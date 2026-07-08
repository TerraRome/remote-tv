import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/drivers/driver_registry.dart';
import '../../../../core/drivers/tv_driver.dart';
import '../../../../core/drivers/models/driver_device.dart' as drv;
import '../../../../core/drivers/models/driver_pairing_session.dart'
    as drv_session;
import '../../../discovery/domain/entities/tv_device.dart';

@injectable
final class PairingDatasource {
  final DriverRegistry _driverRegistry;
  String? _resolvedDriverId;

  PairingDatasource(this._driverRegistry);

  /// Build a DriverDevice from TvDevice.
  drv.DriverDevice _toDriverDevice(TvDevice device) {
    debugPrint(
      '[PairingDatasource] toDriverDevice: id=${device.id} ip=${device.ipAddress} port=${device.port} type=${device.deviceType}',
    );
    return drv.DriverDevice(
      id: device.id,
      name: device.name,
      ipAddress: device.ipAddress,
      port: device.port,
      deviceType: device.deviceType,
    );
  }

  /// Resolve a driver by device type, falling back to any supported driver.
  Future<TvDriver> _resolve(drv.DriverDevice driverDevice) async {
    debugPrint(
      '[PairingDatasource] resolving driver for type=${driverDevice.deviceType}',
    );
    final driver =
        await _driverRegistry.resolve(driverDevice) ??
        _driverRegistry.drivers.firstOrNull;
    debugPrint(
      '[PairingDatasource] resolved driver: ${driver?.runtimeType} id=${driver?.id}',
    );
    if (driver == null) {
      throw Exception(
        'No driver available for device type: ${driverDevice.deviceType}',
      );
    }
    _resolvedDriverId = driver.id;
    return driver;
  }

  /// Get the previously resolved driver.
  TvDriver _getResolved() {
    final driver = _resolvedDriverId != null
        ? _driverRegistry.resolveById(_resolvedDriverId!)
        : null;
    if (driver == null) {
      throw Exception('No driver resolved');
    }
    return driver;
  }

  /// Connect and start the pairing handshake.
  /// Returns a session containing the PIN the TV displayed.
  Future<drv_session.DriverPairingSession> startPairing(TvDevice device) async {
    final driverDevice = _toDriverDevice(device);
    final driver = await _resolve(driverDevice);

    await driver.connect(driverDevice);
    return driver.pair(driverDevice);
  }

  /// Submit the PIN displayed on TV to complete pairing.
  Future<bool> submitPin(String sessionId, String pin) async {
    final driver = _getResolved();

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
    final driverDevice = _toDriverDevice(device);
    final driver = await _resolve(driverDevice);
    return driver.pair(driverDevice);
  }

  Future<void> disconnectDevice(String deviceId) async {
    final driver = _getResolved();
    await driver.disconnect();
  }
}
