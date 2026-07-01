import 'package:injectable/injectable.dart';

import '../../../../core/drivers/driver_registry.dart';
import '../../../../core/drivers/models/driver_device.dart' as drv;
import '../../../../core/drivers/models/driver_pairing_session.dart'
    as drv_session;
import '../../../discovery/domain/entities/tv_device.dart';

@injectable
final class PairingDatasource {
  final DriverRegistry _driverRegistry;

  PairingDatasource(this._driverRegistry);

  /// Connect and start the pairing handshake.
  /// Returns a session containing the PIN the TV displayed.
  Future<drv_session.DriverPairingSession> startPairing(TvDevice device) async {
    final driver = _driverRegistry.resolveById('android_tv');
    if (driver == null) {
      throw Exception('No driver available for pairing');
    }

    final driverDevice = drv.DriverDevice(
      id: device.id,
      name: device.name,
      ipAddress: device.ipAddress,
      port: device.port,
      deviceType: device.deviceType,
    );

    // First connect, then pair
    await driver.connect(driverDevice);
    return driver.pair(driverDevice);
  }

  /// Submit the PIN displayed on TV to complete pairing.
  Future<bool> submitPin(String sessionId, String pin) async {
    final driver = _driverRegistry.resolveById('android_tv');
    if (driver == null) {
      throw Exception('No driver available to submit PIN');
    }

    // Build a minimal session with the ID and PIN
    final session = drv_session.DriverPairingSession(
      deviceId: '',
      sessionId: sessionId,
      pin: int.parse(pin),
      isPaired: false,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(seconds: 30)),
    );

    return driver.submitPin(session, pin);
  }

  Future<drv_session.DriverPairingSession> pairDevice(TvDevice device) async {
    final driver = _driverRegistry.resolveById('android_tv');
    if (driver == null) {
      throw Exception('No driver available for pairing');
    }

    final driverDevice = drv.DriverDevice(
      id: device.id,
      name: device.name,
      ipAddress: device.ipAddress,
      port: device.port,
      deviceType: device.deviceType,
    );

    return driver.pair(driverDevice);
  }

  Future<void> disconnectDevice(String deviceId) async {
    final driver = _driverRegistry.resolveById('android_tv');
    if (driver != null) {
      await driver.disconnect();
    }
  }
}
