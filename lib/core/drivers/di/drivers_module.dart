import 'package:injectable/injectable.dart';
import '../android_tv/android_tv_driver.dart';
import '../driver_registry.dart';
import '../driver_registry_impl.dart';
import '../tv_driver.dart';

@module
abstract class DriversModule {
  @singleton
  AndroidTvDriver get androidTvDriver => AndroidTvDriver();

  @singleton
  List<TvDriver> get driverList => [androidTvDriver];

  @singleton
  DriverRegistry get driverRegistry => DriverRegistryImpl(driverList);
}
