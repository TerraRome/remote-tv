final class StorageKeys {
  StorageKeys._();

  // ── App ──
  static const String hiveBoxName = 'remote_box';

  // ── Discovery ──
  static const String lastDiscoveryTimestamp = 'last_discovery_timestamp';

  // ── Android TV Certificates ──
  static String androidTvCertificate(String deviceId) =>
      'android_tv.device.$deviceId.certificate';
  static String androidTvPrivateKey(String deviceId) =>
      'android_tv.device.$deviceId.private_key';

  // ── Favorites ──
  static const String favoriteTvs = 'favorite_tvs';
  static const String lastConnectedTv = 'last_connected_tv';

  // ── Settings ──
  static const String themeMode = 'theme_mode';
  static const String darkModeOverride = 'dark_mode_override';
}
