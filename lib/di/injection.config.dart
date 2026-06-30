// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../core/drivers/android_tv/android_tv_driver.dart' as _i842;
import '../core/drivers/di/drivers_module.dart' as _i562;
import '../core/drivers/driver_registry.dart' as _i605;
import '../core/drivers/tv_driver.dart' as _i735;
import '../core/network/dio_client.dart' as _i393;
import '../core/storage/storage_service.dart' as _i468;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final driversModule = _$DriversModule();
    gh.singleton<_i842.AndroidTvDriver>(() => driversModule.androidTvDriver);
    gh.singleton<List<_i735.TvDriver>>(() => driversModule.driverList);
    gh.singleton<_i605.DriverRegistry>(() => driversModule.driverRegistry);
    gh.singleton<_i393.DioClient>(() => _i393.DioClient());
    gh.singleton<_i468.StorageService>(() => _i468.StorageService());
    return this;
  }
}

class _$DriversModule extends _i562.DriversModule {}
