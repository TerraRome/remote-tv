import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../driver_exception.dart';
import 'android_tv_transport.dart';

/// Combined transport: tries TLS first, falls back to raw TCP if TV
/// doesn't support TLS on the remote protocol port.
@Singleton(as: AndroidTvTransport)
final class CombinedTransport implements AndroidTvTransport {
  Socket? _socket;
  final _messageController = StreamController<Uint8List>.broadcast();
  StreamSubscription<Uint8List>? _subscription;
  bool _disposed = false;

  @override
  X509Certificate? get serverCertificate =>
      _socket is SecureSocket ? (_socket as SecureSocket).peerCertificate : null;

  @override
  bool get isConnected => _socket != null;

  Stream<Uint8List> _rawStream() {
    return _socket!.cast<Uint8List>();
  }

  @override
  Future<void> connect(String host, int port) async {
    debugPrint('[CombinedTransport] connect() $host:$port');
    if (_disposed) {
      debugPrint('[CombinedTransport] connect FAILED - disposed');
      throw StateError('Transport disposed');
    }
    await disconnect();

    // Try TLS first
    try {
      debugPrint('[CombinedTransport] trying TLS...');
      _socket = await SecureSocket.connect(
        host,
        port,
        timeout: const Duration(seconds: 5),
        onBadCertificate: (cert) => true,
      );
      debugPrint(
        '[CombinedTransport] TLS connected, peerCert=${(_socket as SecureSocket).peerCertificate?.issuer}',
      );
    } on SocketException catch (e) {
      // If TCP connected but TLS failed ("Read failed"), try raw socket
      if (e.message == 'Read failed' || (e.osError?.message ?? '').contains('Read failed')) {
        debugPrint('[CombinedTransport] TLS failed ($e), trying raw TCP...');
        try {
          _socket = await Socket.connect(
            host,
            port,
            timeout: const Duration(seconds: 5),
          );
          debugPrint('[CombinedTransport] raw TCP connected');
        } catch (rawError) {
          debugPrint('[CombinedTransport] raw TCP also failed: $rawError');
          _socket = null;
          throw DriverConnectionException(
            'Connection to $host:$port failed (TLS + raw): ${rawError is SocketException ? rawError.message : rawError}',
            cause: rawError is Exception ? rawError : null,
          );
        }
      } else {
        debugPrint('[CombinedTransport] SocketException: ${e.message}');
        _socket = null;
        throw DriverConnectionException(
          'Connection to $host:$port failed: ${e.message}',
          cause: e,
        );
      }
    } on HandshakeException catch (e) {
      debugPrint('[CombinedTransport] HandshakeException: ${e.message}, trying raw TCP...');
      try {
        _socket = await Socket.connect(
          host,
          port,
          timeout: const Duration(seconds: 5),
        );
        debugPrint('[CombinedTransport] raw TCP connected after TLS handshake failure');
      } catch (rawError) {
        debugPrint('[CombinedTransport] raw TCP also failed: $rawError');
        _socket = null;
        throw DriverConnectionException(
          'Connection to $host:$port failed (TLS handshake + raw): ${rawError is SocketException ? rawError.message : rawError}',
          cause: rawError is Exception ? rawError : null,
        );
      }
    } on TimeoutException catch (e) {
      debugPrint('[CombinedTransport] TimeoutException');
      _socket = null;
      throw DriverConnectionException(
        'Connection to $host:$port timed out',
        cause: e,
      );
    }

    // Set up stream listener
    _subscription = _rawStream().listen(
      (data) {
        debugPrint('[CombinedTransport] received ${data.length} bytes hex: '
            '${data.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}');
        _messageController.add(data);
      },
      onError: (e) {
        debugPrint('[CombinedTransport] stream error: $e');
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
        debugPrint('[CombinedTransport] stream done');
        if (!_messageController.isClosed) {
          _messageController.close();
        }
      },
    );
  }

  @override
  Future<void> disconnect() async {
    debugPrint('[CombinedTransport] disconnect()');
    await _subscription?.cancel();
    _subscription = null;
    try {
      await _socket?.close();
      debugPrint('[CombinedTransport] socket closed');
    } catch (e) {
      debugPrint('[CombinedTransport] close error: $e');
    }
    _socket = null;
  }

  @override
  Future<void> send(Uint8List data) async {
    debugPrint('[CombinedTransport] send ${data.length} bytes');
    if (_socket == null) {
      debugPrint('[CombinedTransport] send FAILED - not connected');
      throw DriverConnectionException('Not connected');
    }
    _socket!.add(data);
    await _socket!.flush();
    debugPrint('[CombinedTransport] send flushed');
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
