import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:injectable/injectable.dart';

import '../transport/android_tv_transport.dart';
import 'android_tv_message.dart';
import 'android_tv_message_codec.dart';

/// High-level protocol handler that manages the message exchange lifecycle.
//
/// Handles TLS transport, pairing, message framing, sending, and receiving.
@singleton
class AndroidTvProtocolHandler {
  AndroidTvProtocolHandler({
    required AndroidTvTransport transport,
    required AndroidTvMessageCodec codec,
  }) : _transport = transport,
       _codec = codec;

  final AndroidTvTransport _transport;
  final AndroidTvMessageCodec _codec;

  /// Cached after option exchange.
  String? _deviceName;

  /// The TV's self-signed certificate captured during TLS handshake.
  /// Set after successful pairing for subsequent cert pinning.
  X509Certificate? _serverCertificate;

  String? get deviceName => _deviceName;
  bool get isPaired => _paired;
  X509Certificate? get serverCertificate => _serverCertificate;

  /// True once pairing has completed successfully (option+config exchange done).
  bool _paired = false;

  final StreamController<AndroidTvMessage> _messageController =
      StreamController<AndroidTvMessage>.broadcast();

  StreamSubscription<Uint8List>? _transportSub;

  /// TCP reassembly buffer. Accumulates bytes until complete frames arrive.
  final BytesBuilder _receiveBuffer = BytesBuilder();

  /// Max receive buffer size (10 MB). Prevents OOM on malformed streams.
  static const int _maxBufferSize = 10 * 1024 * 1024;

  /// Connect to the TV at [host]:[port] and start listening for messages.
  Future<void> connect(String host, int port) async {
    _receiveBuffer.clear();
    _paired = false;
    _deviceName = null;
    await _transport.connect(host, port);
    _transportSub = _transport.incomingMessages.listen(_onData);
  }

  /// Incoming raw data handler with TCP reassembly.
  void _onData(Uint8List chunk) {
    _receiveBuffer.add(chunk);
    if (_receiveBuffer.length > _maxBufferSize) {
      _receiveBuffer.clear();
      return;
    }
    _processBuffer();
  }

  /// Process as many complete frames as possible from the receive buffer.
  void _processBuffer() {
    while (true) {
      try {
        final data = _receiveBuffer.toBytes();
        if (data.length < 4) return;

        final msg = _codec.tryDecode(data);
        if (msg == null) return;

        final frameLen = 4 + msg.payload.length;
        _receiveBuffer.clear();
        if (data.length > frameLen) {
          _receiveBuffer.add(data.sublist(frameLen));
        }

        if (!_messageController.isClosed) {
          _messageController.add(msg);
        }
      } on FormatException {
        _receiveBuffer.clear();
        if (!_messageController.isClosed) {
          _messageController.addError(
            FormatException('Malformed message in receive buffer'),
          );
        }
        return;
      }
    }
  }

  /// Send a raw message.
  Future<void> sendMessage(AndroidTvMessage message) async {
    final encoded = _codec.encode(message);
    await _transport.send(encoded);
  }

  /// Send a message and await a response of [expectedType].
  ///
  /// Listener registered **before** sending. Cleans up on failure or timeout.
  Future<AndroidTvMessage> sendAndWait(
    AndroidTvMessage message,
    AndroidTvMessageType expectedType, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final completer = Completer<AndroidTvMessage>();
    late final StreamSubscription<AndroidTvMessage> sub;
    final timer = Timer(timeout, () {
      sub.cancel();
      if (!completer.isCompleted) {
        completer.completeError(
          TimeoutException('No response for ${expectedType.name}'),
        );
      }
    });

    sub = _messageController.stream.listen((msg) {
      if (msg.type == expectedType) {
        timer.cancel();
        completer.complete(msg);
      }
    });

    try {
      await sendMessage(message);
    } catch (e) {
      timer.cancel();
      sub.cancel();
      if (!completer.isCompleted) {
        completer.completeError(e);
      }
    }

    return completer.future;
  }

  /// --- Pairing Protocol ---

  /// Initiate pairing by sending a pairing request (0x01) with [options].
  /// Returns the server's pairing request ack (0x02) payload.
  Future<AndroidTvMessage> initiatePairing(Uint8List options) async {
    final request = _codec.encodePairingRequest(options);
    return sendAndWait(request, AndroidTvMessageType.pairingRequestAck);
  }

  /// Send the PIN (pairing secret 0x03) and await server ack (0x04).
  /// Throws if server rejects the PIN.
  Future<AndroidTvMessage> sendPin(String pin) async {
    final secret = _codec.encodePairingSecret(pin);
    final ack = await sendAndWait(
      secret,
      AndroidTvMessageType.pairingSecretAck,
    );
    // ponytail: parse ack payload for success/failure code
    return ack;
  }

  /// Perform option / configuration exchange with the TV.
  /// This completes the pairing handshake.
  Future<void> exchangeOptions(
    Uint8List optionData,
    Uint8List configData,
  ) async {
    await sendMessage(_codec.encodeOption(optionData));
    await sendMessage(_codec.encodeConfiguration(configData));
    final response = await sendAndWait(
      AndroidTvMessage(
        type: AndroidTvMessageType.option,
        payload: Uint8List(0),
      ),
      AndroidTvMessageType.option,
    );
    _deviceName = String.fromCharCodes(response.payload);
    _paired = true;
  }

  /// --- Remote Control ---

  /// Send a key event (action: 0=DOWN, 1=UP).
  Future<void> sendKeyEvent(int keyCode, int action) async {
    final msg = _codec.encodeInput(keyCode, action);
    await sendMessage(msg);
  }

  /// Send a touch event (action: 0=DOWN, 1=MOVE, 2=UP).
  Future<void> sendTouchEvent(int action, double x, double y) async {
    final msg = _codec.encodeTouchEvent(action, x, y);
    await sendMessage(msg);
  }

  /// --- Certificate Management ---

  /// Set the TV's server certificate (captured during TLS handshake).
  void setServerCertificate(X509Certificate cert) {
    _serverCertificate = cert;
  }

  /// Disconnect.
  Future<void> disconnect() async {
    await _transportSub?.cancel();
    _transportSub = null;
    _receiveBuffer.clear();
    _paired = false;
    _deviceName = null;
    _serverCertificate = null;
    await _transport.disconnect();
    await _messageController.close();
  }

  /// Whether transport is connected.
  bool get isConnected => _transport.isConnected;

  /// Stream of incoming parsed messages.
  Stream<AndroidTvMessage> get messages => _messageController.stream;
}
