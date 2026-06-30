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
