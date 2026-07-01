import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

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
    if (_disposed) throw StateError('Transport disposed');
    await disconnect();
    try {
      _socket = await SecureSocket.connect(
        host,
        port,
        timeout: const Duration(seconds: 5),
        // ponytail: add certificate pinning after pairing
        onBadCertificate: (cert) => true,
      );
      _subscription = _rawStream().listen(
        (data) => _messageController.add(data),
        onError: (e) {
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
          if (!_messageController.isClosed) {
            _messageController.close();
          }
        },
      );
    } on SocketException catch (e) {
      throw DriverConnectionException(
        'Connection to $host:$port failed: ${e.message}',
        cause: e,
      );
    } on HandshakeException catch (e) {
      throw DriverConnectionException(
        'TLS handshake with $host:$port failed: ${e.message}',
        cause: e,
      );
    } on TimeoutException catch (e) {
      throw DriverConnectionException(
        'Connection to $host:$port timed out',
        cause: e,
      );
    }
  }

  @override
  Future<void> disconnect() async {
    await _subscription?.cancel();
    _subscription = null;
    try {
      await _socket?.close();
    } catch (_) {}
    _socket = null;
  }

  @override
  Future<void> send(Uint8List data) async {
    if (_socket == null) {
      throw DriverConnectionException('Not connected');
    }
    _socket!.add(data);
    await _socket!.flush();
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
