import 'models/driver_device.dart';
import 'tv_driver.dart';

abstract interface class DriverRegistry {
  List<TvDriver> get drivers;
  TvDriver? resolve(DriverDevice device);
  TvDriver? resolveById(String id);
  List<TvDriver> supportedDrivers();
}
