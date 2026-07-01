import 'dart:io';
import 'dart:typed_data';

/// Abstract transport for Android TV remote protocol.
abstract interface class AndroidTvTransport {
  Future<void> connect(String host, int port);
  Future<void> disconnect();
  Future<void> send(Uint8List data);
  Stream<Uint8List> get incomingMessages;
  bool get isConnected;

  /// The server's X.509 certificate from the TLS handshake.
  /// null before connection or if transport is not TLS-based.
  X509Certificate? get serverCertificate;
}
