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

import '../core/discovery/di/discovery_module.dart' as _i561;
import '../core/discovery/discovery_provider.dart' as _i221;
import '../core/discovery/discovery_registry.dart' as _i498;
import '../core/discovery/discovery_service.dart' as _i418;
import '../core/drivers/android_tv/android_tv_connection_manager.dart' as _i145;
import '../core/drivers/android_tv/android_tv_driver.dart' as _i842;
import '../core/drivers/android_tv/pairing/android_tv_pairing_manager.dart'
    as _i488;
import '../core/drivers/android_tv/pairing/certificate_manager.dart' as _i881;
import '../core/drivers/android_tv/protocol/android_tv_message_codec.dart'
    as _i12;
import '../core/drivers/android_tv/protocol/android_tv_protocol_handler.dart'
    as _i1061;
import '../core/drivers/android_tv/transport/android_tv_transport.dart'
    as _i260;
import '../core/drivers/android_tv/transport/secure_socket_transport.dart'
    as _i678;
import '../core/drivers/di/drivers_module.dart' as _i562;
import '../core/drivers/driver_registry.dart' as _i605;
import '../core/network/dio_client.dart' as _i393;
import '../core/storage/storage_service.dart' as _i468;
import '../features/discovery/data/datasources/discovery_datasource.dart'
    as _i567;
import '../features/discovery/data/mappers/driver_device_mapper.dart' as _i920;
import '../features/discovery/data/repositories/discovery_repository_impl.dart'
    as _i1056;
import '../features/discovery/domain/repositories/discovery_repository.dart'
    as _i742;
import '../features/discovery/domain/use_cases/discover_tvs.dart' as _i331;
import '../features/discovery/domain/use_cases/watch_discovered_tvs.dart'
    as _i637;
import '../features/discovery/presentation/bloc/discovery_bloc.dart' as _i819;
import '../features/favorites/data/datasources/favorites_datasource.dart'
    as _i758;
import '../features/favorites/data/repositories/favorite_repository_impl.dart'
    as _i478;
import '../features/favorites/domain/repositories/favorite_repository.dart'
    as _i761;
import '../features/favorites/presentation/bloc/favorites_bloc.dart' as _i318;
import '../features/pairing/data/datasources/pairing_datasource.dart' as _i635;
import '../features/pairing/data/repositories/connection_repository_impl.dart'
    as _i726;
import '../features/pairing/domain/repositories/connection_repository.dart'
    as _i194;
import '../features/pairing/presentation/bloc/pairing_bloc.dart' as _i679;
import '../features/remote/data/datasources/remote_datasource.dart' as _i223;
import '../features/remote/data/repositories/remote_repository_impl.dart'
    as _i386;
import '../features/remote/domain/repositories/remote_repository.dart' as _i718;
import '../features/remote/presentation/bloc/remote_bloc.dart' as _i976;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final discoveryModule = _$DiscoveryModule();
    final driversModule = _$DriversModule();
    gh.factory<_i920.DriverDeviceMapper>(() => _i920.DriverDeviceMapper());
    gh.singleton<_i12.AndroidTvMessageCodec>(
      () => _i12.AndroidTvMessageCodec(),
    );
    gh.singleton<_i393.DioClient>(() => _i393.DioClient());
    gh.singleton<List<_i221.DiscoveryProvider>>(
      () => discoveryModule.providerList,
    );
    gh.singleton<_i498.DiscoveryRegistry>(
      () => discoveryModule.discoveryRegistry,
    );
    gh.singleton<_i418.DiscoveryService>(
      () => discoveryModule.discoveryService,
    );
    gh.singleton<_i468.StorageService>(() => _i468.StorageService());
    gh.singleton<_i260.AndroidTvTransport>(() => _i678.SecureSocketTransport());
    gh.singleton<_i221.DiscoveryProvider>(
      () => discoveryModule.ssdpProvider,
      instanceName: 'ssdp',
    );
    gh.factory<_i758.FavoritesDatasource>(
      () => _i758.FavoritesDatasource(gh<_i468.StorageService>()),
    );
    gh.singleton<_i221.DiscoveryProvider>(
      () => discoveryModule.mdnsProvider,
      instanceName: 'mdns',
    );
    gh.singleton<_i221.DiscoveryProvider>(
      () => discoveryModule.manualProvider,
      instanceName: 'manual',
    );
    gh.factory<_i567.DiscoveryDatasource>(
      () => _i567.DiscoveryDatasourceImpl(gh<_i418.DiscoveryService>()),
    );
    gh.factory<_i976.RemoteBloc>(
      () => _i976.RemoteBloc(gh<_i718.RemoteRepository>()),
    );
    gh.singleton<_i881.CertificateManager>(
      () => _i881.CertificateManager(storage: gh<_i468.StorageService>()),
    );
    gh.singleton<_i1061.AndroidTvProtocolHandler>(
      () => _i1061.AndroidTvProtocolHandler(
        transport: gh<_i260.AndroidTvTransport>(),
        codec: gh<_i12.AndroidTvMessageCodec>(),
      ),
    );
    gh.factory<_i761.FavoriteRepository>(
      () => _i478.FavoriteRepositoryImpl(gh<_i758.FavoritesDatasource>()),
    );
    gh.singleton<_i488.AndroidTvPairingManager>(
      () => _i488.AndroidTvPairingManager(
        protocol: gh<_i1061.AndroidTvProtocolHandler>(),
        certificateManager: gh<_i881.CertificateManager>(),
      ),
    );
    gh.factory<_i318.FavoritesBloc>(
      () => _i318.FavoritesBloc(gh<_i761.FavoriteRepository>()),
    );
    gh.singleton<_i145.AndroidTvConnectionManager>(
      () => _i145.AndroidTvConnectionManager(
        protocol: gh<_i1061.AndroidTvProtocolHandler>(),
        transport: gh<_i260.AndroidTvTransport>(),
      ),
    );
    gh.singleton<_i842.AndroidTvDriver>(
      () => _i842.AndroidTvDriver(gh<_i145.AndroidTvConnectionManager>()),
      instanceName: 'android_tv',
    );
    gh.lazySingleton<_i605.DriverRegistry>(
      () => driversModule.driverRegistry(
        gh<_i842.AndroidTvDriver>(instanceName: 'android_tv'),
      ),
    );
    gh.factory<_i742.DiscoveryRepository>(
      () => _i1056.DiscoveryRepositoryImpl(
        gh<_i567.DiscoveryDatasource>(),
        gh<_i605.DriverRegistry>(),
        gh<_i920.DriverDeviceMapper>(),
      ),
    );
    gh.factory<_i635.PairingDatasource>(
      () => _i635.PairingDatasource(gh<_i605.DriverRegistry>()),
    );
    gh.factory<_i223.RemoteDatasource>(
      () => _i223.RemoteDatasource(gh<_i605.DriverRegistry>()),
    );
    gh.factory<_i194.ConnectionRepository>(
      () => _i726.ConnectionRepositoryImpl(gh<_i635.PairingDatasource>()),
    );
    gh.factory<_i386.RemoteRepositoryImpl>(
      () => _i386.RemoteRepositoryImpl(gh<_i223.RemoteDatasource>()),
    );
    gh.factory<_i637.WatchDiscoveredTvs>(
      () => _i637.WatchDiscoveredTvs(gh<_i742.DiscoveryRepository>()),
    );
    gh.factory<_i331.DiscoverTvs>(
      () => _i331.DiscoverTvs(gh<_i742.DiscoveryRepository>()),
    );
    gh.factory<_i679.PairingBloc>(
      () => _i679.PairingBloc(gh<_i194.ConnectionRepository>()),
    );
    gh.factory<_i819.DiscoveryBloc>(
      () => _i819.DiscoveryBloc(gh<_i637.WatchDiscoveredTvs>()),
    );
    return this;
  }
}

class _$DiscoveryModule extends _i561.DiscoveryModule {}

class _$DriversModule extends _i562.DriversModule {}
