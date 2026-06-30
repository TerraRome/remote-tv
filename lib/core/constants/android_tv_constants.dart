final class AndroidTvConstants {
  AndroidTvConstants._();

  /// Default port for the Android TV remote protocol (not ADB).
  static const int remotePort = 6466;

  /// Default timeout for TV connections.
  static const int connectionTimeoutSeconds = 5;

  /// Default timeout for discovery.
  static const int discoveryTimeoutSeconds = 10;

  /// mDNS service type for Android TV remote protocol.
  static const String mdnsServiceType = '_androidtvremote._tcp';
}
