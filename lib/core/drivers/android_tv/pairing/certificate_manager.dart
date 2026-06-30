import 'package:injectable/injectable.dart';

import '../../../constants/storage_keys.dart';
import '../../../storage/storage_service.dart';

/// Manages per-device X.509 certificates via Hive (StorageService).
///
/// Each device gets its own certificate+key pair stored under
/// `StorageKeys.androidTvCertificate(deviceId)` and
/// `StorageKeys.androidTvPrivateKey(deviceId)`.
@singleton
class CertificateManager {
  final StorageService _storage;

  CertificateManager({required StorageService storage}) : _storage = storage;

  /// Check if a certificate exists for [deviceId].
  Future<bool> hasCertificate(String deviceId) async {
    final cert = _storage.get<String>(
      StorageKeys.androidTvCertificate(deviceId),
    );
    final key = _storage.get<String>(StorageKeys.androidTvPrivateKey(deviceId));
    return cert != null && key != null;
  }

  /// Load the certificate PEM for [deviceId].
  String loadCertificate(String deviceId) {
    final value = _storage.get<String>(
      StorageKeys.androidTvCertificate(deviceId),
    );
    if (value == null) {
      throw StateError('No certificate found for device $deviceId');
    }
    return value;
  }

  /// Load the private key PEM for [deviceId].
  String loadPrivateKey(String deviceId) {
    final value = _storage.get<String>(
      StorageKeys.androidTvPrivateKey(deviceId),
    );
    if (value == null) {
      throw StateError('No private key found for device $deviceId');
    }
    return value;
  }

  /// Save certificate and private key for [deviceId].
  Future<void> saveCertificate({
    required String deviceId,
    required String cert,
    required String key,
  }) async {
    await _storage.put(StorageKeys.androidTvCertificate(deviceId), cert);
    await _storage.put(StorageKeys.androidTvPrivateKey(deviceId), key);
  }

  /// Delete stored certificate for [deviceId].
  Future<void> delete(String deviceId) async {
    await _storage.delete(StorageKeys.androidTvCertificate(deviceId));
    await _storage.delete(StorageKeys.androidTvPrivateKey(deviceId));
  }

  /// Remove all certificates (legacy compat).
  Future<void> clear() async {
    // ponytail: iterate known device IDs to clear each. For now no-op.
    // Device-specific `delete(deviceId)` is the primary API.
  }
}
