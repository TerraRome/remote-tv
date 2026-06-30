import 'models/driver_device.dart';
import 'driver_registry.dart';
import 'tv_driver.dart';

class DriverRegistryImpl implements DriverRegistry {
  DriverRegistryImpl(this._drivers);

  final List<TvDriver> _drivers;

  @override
  List<TvDriver> get drivers => List.unmodifiable(_drivers);

  @override
  TvDriver? resolve(DriverDevice device) {
    for (final driver in _drivers) {
      if (driver.supports(device) as bool? ?? false) {
        return driver;
      }
    }
    return null;
  }

  @override
  List<TvDriver> supportedDrivers() =>
      _drivers.where((d) => d.capabilities.isNotEmpty).toList();
}
