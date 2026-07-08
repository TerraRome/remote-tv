import 'package:injectable/injectable.dart';
import '../../../../core/drivers/driver_registry.dart';
import '../../../../core/drivers/tv_driver.dart';
import '../../../../core/drivers/models/driver_device.dart' as drv;
import '../../../../core/enums/remote_command.dart';
import '../../domain/entities/touch_event.dart';
import '../../../../core/drivers/models/driver_touch_input.dart' as drv_touch;
import '../../../discovery/domain/entities/tv_device.dart';

@injectable
final class RemoteDatasource {
  final DriverRegistry _driverRegistry;

  RemoteDatasource(this._driverRegistry);

  TvDriver _getDriver() {
    final driver = _driverRegistry.resolveById('android_tv');
    if (driver == null) {
      throw Exception('No driver available for remote control');
    }
    return driver;
  }

  drv.DriverDevice _toDriverDevice(TvDevice device) {
    return drv.DriverDevice(
      id: device.id,
      name: device.name,
      ipAddress: device.ipAddress,
      port: device.port,
      deviceType: device.deviceType,
    );
  }

  Future<void> _ensureConnected(TvDriver driver, TvDevice device) async {
    try {
      await driver.connect(_toDriverDevice(device));
    } catch (_) {}
  }

  Future<void> sendCommand(TvDevice device, RemoteCommand command) async {
    final driver = _getDriver();
    try {
      await driver.sendCommand(command);
    } catch (_) {
      await _ensureConnected(driver, device);
      await driver.sendCommand(command);
    }
  }

  Future<void> sendText(TvDevice device, String text) async {
    final driver = _getDriver();
    try {
      await driver.sendText(text);
    } catch (_) {
      await _ensureConnected(driver, device);
      await driver.sendText(text);
    }
  }

  Future<void> sendTouch(TvDevice device, TouchEvent event) async {
    final driver = _getDriver();
    final input = drv_touch.DriverTouchInput(
      type: drv_touch.DriverTouchType.values[event.type.index],
      x: event.x,
      y: event.y,
      dx: event.dx,
      dy: event.dy,
    );
    try {
      await driver.sendTouch(input);
    } catch (_) {
      await _ensureConnected(driver, device);
      await driver.sendTouch(input);
    }
  }
}
