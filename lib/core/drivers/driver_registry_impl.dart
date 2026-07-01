import 'models/driver_device.dart';
import 'driver_registry.dart';
import 'tv_driver.dart';

class DriverRegistryImpl implements DriverRegistry {
  DriverRegistryImpl(this._drivers);

  final List<TvDriver> _drivers;

  @override
  List<TvDriver> get drivers => List.unmodifiable(_drivers);

  @override
  Future<TvDriver?> resolve(DriverDevice device) async {
    for (final driver in _drivers) {
      if (await driver.supports(device)) {
        return driver;
      }
    }
    return null;
  }

  @override
  TvDriver? resolveById(String id) {
    for (final driver in _drivers) {
      if (driver.id == id) return driver;
    }
    return null;
  }

  @override
  List<TvDriver> supportedDrivers() =>
      _drivers.where((d) => d.capabilities.isNotEmpty).toList();
}
