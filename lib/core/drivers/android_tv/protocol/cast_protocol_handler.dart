import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../transport/android_tv_transport.dart';
import 'cast_message.dart';

/// Cast v2 protocol handler.
///
/// Manages TLS + CastMessage framing to a Google Cast device on port 8009.
/// Handles heartbeat (PING/PONG) automatically and exposes a simple
/// send-message / receive-message API for higher-level controllers.
@singleton
class CastProtocolHandler {
  CastProtocolHandler({required AndroidTvTransport transport})
      : _transport = transport;

  final AndroidTvTransport _transport;

  StreamSubscription<Uint8List>? _transportSub;
  StreamController<CastMessage> _messageController =
      StreamController<CastMessage>.broadcast();

  /// TCP reassembly buffer for fragmented Cast frames.
  final BytesBuilder _buffer = BytesBuilder();
  bool _connected = false;

  final String _sourceId = 'sender-0';
  final String _destinationId = 'receiver-0';

  static const _nsHeartbeat = 'urn:x-cast:com.google.cast.tp.heartbeat';
  static const _nsConnection = 'urn:x-cast:com.google.cast.tp.connection';
  static const _nsReceiver = 'urn:x-cast:com.google.cast.receiver';

  bool get isConnected => _connected;
  Stream<CastMessage> get messages => _messageController.stream;

  /// Connect to a Cast device via TLS on [host]:[port].
  Future<void> connect(String host, int port) async {
    debugPrint('[CastProtocolHandler] connect() $host:$port');
    _buffer.clear();
    await _transport.connect(host, port);
    _messageController = StreamController<CastMessage>.broadcast();

    _transportSub = _transport.incomingMessages.listen(
      _onData,
      onError: (e) {
        debugPrint('[CastProtocolHandler] transport error: $e');
        _connected = false;
        if (!_messageController.isClosed) {
          _messageController.addError(e);
        }
      },
      onDone: () {
        debugPrint('[CastProtocolHandler] transport done');
        _connected = false;
        if (!_messageController.isClosed) {
          _messageController.close();
        }
      },
    );

    // Listen for heartbeats and connection messages automatically
    _messageController.stream.listen((msg) {
      if (msg.namespace == _nsHeartbeat) {
        _handleHeartbeat(msg);
      } else if (msg.namespace == _nsConnection) {
        _handleConnection(msg);
      } else if (msg.namespace == _nsReceiver) {
        debugPrint(
          '[CastProtocolHandler] receiver: ${msg.payloadUtf8}',
        );
      }
    });

    _connected = true;
    debugPrint('[CastProtocolHandler] connected');
  }

  /// Handle incoming raw bytes from transport.
  void _onData(Uint8List chunk) {
    _buffer.add(chunk);
    _processBuffer();
  }

  /// Extract complete Cast frames from the buffer.
  void _processBuffer() {
    while (true) {
      final data = _buffer.toBytes();
      final msg = CastMessageCodec.tryDecode(data);
      if (msg == null) return;

      final frameLen = 4 + data.buffer.asByteData().getUint32(0);
      _buffer.clear();
      if (data.length > frameLen) {
        _buffer.add(data.sublist(frameLen));
      }

      debugPrint('[CastProtocolHandler] recv: ${msg.namespace} '
          'payload=${msg.payloadUtf8}');

      if (!_messageController.isClosed) {
        _messageController.add(msg);
      }
    }
  }

  /// Handle heartbeat PING → send PONG automatically.
  void _handleHeartbeat(CastMessage msg) {
    if (msg.payloadUtf8?.contains('"PING"') == true) {
      debugPrint('[CastProtocolHandler] heartbeat PING → PONG');
      sendMessage(CastMessage(
        sourceId: msg.destinationId,
        destinationId: msg.sourceId,
        namespace: _nsHeartbeat,
        payloadUtf8: '{"type":"PONG"}',
      ));
    }
  }

  /// Handle connection messages.
  void _handleConnection(CastMessage msg) {
    debugPrint('[CastProtocolHandler] connection: ${msg.payloadUtf8}');
  }

  /// Send a CastMessage over the transport.
  Future<void> sendMessage(CastMessage msg) async {
    final framed = CastMessageCodec.encode(msg);
    debugPrint('[CastProtocolHandler] send: ${msg.namespace} '
        '${msg.payloadUtf8 ?? ''} (${framed.length} bytes)');
    await _transport.send(framed);
  }

  /// Establish a Cast transport virtual connection.
  /// Must be called after connect().
  Future<void> sendConnect() async {
    debugPrint('[CastProtocolHandler] sending CONNECT');
    await sendMessage(CastMessage(
      sourceId: _sourceId,
      destinationId: _destinationId,
      namespace: _nsConnection,
      payloadUtf8: '{"type":"CONNECT"}',
    ));
  }

  /// Send receiver GET_STATUS to learn about running apps.
  Future<void> sendGetStatus() async {
    debugPrint('[CastProtocolHandler] sending GET_STATUS');
    await sendMessage(CastMessage(
      sourceId: _sourceId,
      destinationId: _destinationId,
      namespace: _nsReceiver,
      payloadUtf8: '{"type":"GET_STATUS"}',
    ));
  }

  /// Launch a receiver app by [appId].
  Future<void> sendLaunch(String appId) async {
    debugPrint('[CastProtocolHandler] launching app $appId');
    await sendMessage(CastMessage(
      sourceId: _sourceId,
      destinationId: _destinationId,
      namespace: _nsReceiver,
      payloadUtf8: '{"type":"LAUNCH","appId":"$appId"}',
    ));
  }

  /// Send a key event via Cast input namespace.
  ///
  /// [keyCode]: Android keycode (e.g. 19 = DPAD_UP, 66 = ENTER, 4 = BACK)
  /// [action]: 0 = DOWN, 1 = UP
  Future<void> sendKeyEvent(int keyCode, int action) async {
    debugPrint('[CastProtocolHandler] keyEvent code=$keyCode action=$action');
    final payload = jsonEncode({
      'type': 'KEY_EVENT',
      'keyCode': keyCode,
      'action': action,
    });
    await sendMessage(CastMessage(
      sourceId: _sourceId,
      destinationId: _destinationId,
      namespace: 'urn:x-cast:com.google.cast.input',
      payloadUtf8: payload,
    ));
  }

  /// Disconnect from the Cast device.
  Future<void> disconnect() async {
    debugPrint('[CastProtocolHandler] disconnect()');
    _connected = false;
    await _transportSub?.cancel();
    _transportSub = null;
    _buffer.clear();
    await _transport.disconnect();
    if (!_messageController.isClosed) {
      await _messageController.close();
    }
  }
}
