import 'package:injectable/injectable.dart';
import '../driver_registry.dart';
import '../driver_registry_impl.dart';
import '../tv_driver.dart';

@module
abstract class DriversModule {
  @lazySingleton
  DriverRegistry driverRegistry(
    @Named('android_tv') TvDriver androidTvDriver,
  ) => DriverRegistryImpl([androidTvDriver]);
}
