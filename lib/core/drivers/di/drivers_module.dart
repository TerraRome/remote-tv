import 'package:injectable/injectable.dart';
import '../driver_registry.dart';
import '../driver_registry_impl.dart';
import '../android_tv/android_tv_driver.dart';

@module
abstract class DriversModule {
  @lazySingleton
  DriverRegistry driverRegistry(
    @Named('android_tv') AndroidTvDriver androidTvDriver,
  ) => DriverRegistryImpl([androidTvDriver]);
}
