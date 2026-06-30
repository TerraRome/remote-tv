import 'package:injectable/injectable.dart';
import '../../../../core/drivers/driver_registry.dart';
import '../../../../core/enums/remote_command.dart';
import '../../domain/entities/touch_event.dart';
import '../../../../core/drivers/models/driver_touch_input.dart' as drv_touch;
import '../../../discovery/domain/entities/tv_device.dart';

@injectable
final class RemoteDatasource {
  final DriverRegistry _driverRegistry;

  RemoteDatasource(this._driverRegistry);

  Future<void> sendCommand(TvDevice device, RemoteCommand command) async {
    final driver = _driverRegistry.resolveById('android_tv');
    if (driver == null) {
      throw Exception('No driver available for remote control');
    }
    await driver.sendCommand(command);
  }

  Future<void> sendText(TvDevice device, String text) async {
    final driver = _driverRegistry.resolveById('android_tv');
    if (driver == null) {
      throw Exception('No driver available for text input');
    }
    await driver.sendText(text);
  }

  Future<void> sendTouch(TvDevice device, TouchEvent event) async {
    final driver = _driverRegistry.resolveById('android_tv');
    if (driver == null) {
      throw Exception('No driver available for touch input');
    }
    final input = drv_touch.DriverTouchInput(
      type: drv_touch.DriverTouchType.values[event.type.index],
      x: event.x,
      y: event.y,
      dx: event.dx,
      dy: event.dy,
    );
    await driver.sendTouch(input);
  }
}
