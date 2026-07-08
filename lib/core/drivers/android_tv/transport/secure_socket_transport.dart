import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../driver_exception.dart';
import 'android_tv_transport.dart';

/// TLS SecureSocket transport for Android TV remote protocol (port 6466).
@Singleton(as: AndroidTvTransport)
final class SecureSocketTransport implements AndroidTvTransport {
  SecureSocket? _socket;
  final _messageController = StreamController<Uint8List>.broadcast();
  StreamSubscription<Uint8List>? _subscription;
  bool _disposed = false;

  @override
  X509Certificate? get serverCertificate => _socket?.peerCertificate;

  @override
  bool get isConnected => _socket != null;

  Stream<Uint8List> _rawStream() {
    return _socket!.cast<Uint8List>();
  }

  @override
  Future<void> connect(String host, int port) async {
    debugPrint('[SecureSocketTransport] connect() $host:$port');
    if (_disposed) {
      debugPrint('[SecureSocketTransport] connect FAILED - disposed');
      throw StateError('Transport disposed');
    }
    await disconnect();
    try {
      debugPrint('[SecureSocketTransport] establishing TLS connection...');
      _socket = await SecureSocket.connect(
        host,
        port,
        timeout: const Duration(seconds: 5),
        // ponytail: add certificate pinning after pairing
        onBadCertificate: (cert) => true,
      );
      debugPrint(
        '[SecureSocketTransport] TLS connected, peerCert=${_socket?.peerCertificate?.issuer}',
      );
      _subscription = _rawStream().listen(
        (data) {
          debugPrint('[SecureSocketTransport] received ${data.length} bytes');
          _messageController.add(data);
        },
        onError: (e) {
          debugPrint('[SecureSocketTransport] stream error: $e');
          if (!_messageController.isClosed) {
            _messageController.addError(
              DriverConnectionException(
                'Transport error: $e',
                cause: e is Exception ? e : null,
              ),
            );
          }
        },
        onDone: () {
          debugPrint('[SecureSocketTransport] stream done');
          if (!_messageController.isClosed) {
            _messageController.close();
          }
        },
      );
    } on SocketException catch (e) {
      debugPrint('[SecureSocketTransport] SocketException: ${e.message}');
      throw DriverConnectionException(
        'Connection to $host:$port failed: ${e.message}',
        cause: e,
      );
    } on HandshakeException catch (e) {
      debugPrint('[SecureSocketTransport] HandshakeException: ${e.message}');
      throw DriverConnectionException(
        'TLS handshake with $host:$port failed: ${e.message}',
        cause: e,
      );
    } on TimeoutException catch (e) {
      debugPrint('[SecureSocketTransport] TimeoutException');
      throw DriverConnectionException(
        'Connection to $host:$port timed out',
        cause: e,
      );
    }
  }

  @override
  Future<void> disconnect() async {
    debugPrint('[SecureSocketTransport] disconnect()');
    await _subscription?.cancel();
    _subscription = null;
    try {
      await _socket?.close();
      debugPrint('[SecureSocketTransport] socket closed');
    } catch (e) {
      debugPrint('[SecureSocketTransport] close error: $e');
    }
    _socket = null;
  }

  @override
  Future<void> send(Uint8List data) async {
    debugPrint('[SecureSocketTransport] send ${data.length} bytes');
    if (_socket == null) {
      debugPrint('[SecureSocketTransport] send FAILED - not connected');
      throw DriverConnectionException('Not connected');
    }
    _socket!.add(data);
    await _socket!.flush();
    debugPrint('[SecureSocketTransport] send flushed');
  }

  @override
  Stream<Uint8List> get incomingMessages => _messageController.stream;

  /// Dispose permanently. No reconnection after this.
  Future<void> dispose() async {
    _disposed = true;
    await disconnect();
    await _messageController.close();
  }
}
