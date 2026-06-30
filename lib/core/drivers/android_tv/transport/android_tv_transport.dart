import 'dart:typed_data';

/// Abstract transport for Android TV remote protocol.
abstract interface class AndroidTvTransport {
  Future<void> connect(String host, int port);
  Future<void> disconnect();
  Future<void> send(Uint8List data);
  Stream<Uint8List> get incomingMessages;
  bool get isConnected;
}
