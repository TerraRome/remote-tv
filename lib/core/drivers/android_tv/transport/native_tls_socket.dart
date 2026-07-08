import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../../driver_exception.dart';
import 'android_tv_transport.dart';

/// TLS transport using Android native SSLSocket via MethodChannel.
///
/// This bypasses Dart's SecureSocket to support legacy TLS protocols
/// and cipher suites that some Xiaomi/Mi TV devices require.
@Singleton(as: AndroidTvTransport)
final class NativeTlsSocket implements AndroidTvTransport {
  final _channel = const MethodChannel('com.example.remote/tls');
  final _eventChannel = const EventChannel('com.example.remote/tls_events');

  StreamSubscription? _eventSub;
  StreamController<Uint8List> _messageController = StreamController<Uint8List>.broadcast();
  bool _connected = false;
  bool _disposed = false;

  @override
  X509Certificate? get serverCertificate => null;

  @override
  bool get isConnected => _connected;

  @override
  Future<void> connect(String host, int port) async {
    debugPrint('[NativeTlsSocket] connect() $host:$port');
    if (_disposed) throw StateError('Transport disposed');

    await disconnect();
    _messageController = StreamController<Uint8List>.broadcast();

    // Subscribe to EventChannel BEFORE connect so eventSink is ready
    _eventSub = _eventChannel.receiveBroadcastStream().listen(
      (data) {
        if (data is Uint8List) {
          debugPrint('[NativeTlsSocket] received ${data.length} bytes hex: '
              '${data.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}');
          if (!_messageController.isClosed) {
            _messageController.add(data);
          }
        }
      },
      onError: (e) {
        debugPrint('[NativeTlsSocket] stream error: $e');
        _connected = false;
        if (!_messageController.isClosed) {
          _messageController.addError(
            DriverConnectionException('TLS stream error: $e', cause: e is Exception ? e : null),
          );
        }
      },
      onDone: () {
        debugPrint('[NativeTlsSocket] stream done');
        _connected = false;
      },
    );

    try {
      await _channel.invokeMethod('connect', {'host': host, 'port': port});
      _connected = true;
      debugPrint('[NativeTlsSocket] connected to $host:$port');
    } on MissingPluginException catch (e) {
      debugPrint('[NativeTlsSocket] plugin not available: $e');
      _connected = false;
      await _eventSub?.cancel();
      _eventSub = null;
      rethrow;
    } catch (e) {
      debugPrint('[NativeTlsSocket] connect failed: $e');
      _connected = false;
      await _eventSub?.cancel();
      _eventSub = null;
      rethrow;
    }
  }

  @override
  Future<void> send(Uint8List data) async {
    debugPrint('[NativeTlsSocket] send ${data.length} bytes');
    if (!_connected) throw DriverConnectionException('Not connected');

    try {
      await _channel.invokeMethod('send', {'data': data.buffer.asUint8List()});
      debugPrint('[NativeTlsSocket] send OK');
    } catch (e) {
      debugPrint('[NativeTlsSocket] send failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> disconnect() async {
    debugPrint('[NativeTlsSocket] disconnect()');
    _connected = false;
    await _eventSub?.cancel();
    _eventSub = null;
    try {
      await _channel.invokeMethod('disconnect');
    } catch (e) {
      debugPrint('[NativeTlsSocket] disconnect error: $e');
    }
    if (!_messageController.isClosed) {
      await _messageController.close();
    }
  }

  @override
  Stream<Uint8List> get incomingMessages => _messageController.stream;

  Future<void> dispose() async {
    _disposed = true;
    await disconnect();
  }
}
