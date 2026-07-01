import 'dart:async';
import 'package:injectable/injectable.dart';
import '../../../../core/drivers/driver_registry.dart';
import '../../domain/entities/tv_device.dart';
import '../../domain/repositories/discovery_repository.dart';
import '../datasources/discovery_datasource.dart';
import '../mappers/driver_device_mapper.dart';

const _discoveryTimeout = Duration(seconds: 30);

@Injectable(as: DiscoveryRepository)
final class DiscoveryRepositoryImpl implements DiscoveryRepository {
  final DiscoveryDatasource _datasource;
  final DriverRegistry _driverRegistry;
  final DriverDeviceMapper _mapper;

  DiscoveryRepositoryImpl(this._datasource, this._driverRegistry, this._mapper);

  @override
  Stream<TvDevice> watchDevices() {
    return _datasource
        .startDiscovery()
        .asyncMap((result) async {
          final driver = await _driverRegistry.resolve(result.device);
          if (driver == null) return null;
          return _mapper.mapToTvDevice(result.device);
        })
        .where((d) => d != null)
        .cast<TvDevice>()
        .timeout(_discoveryTimeout, onTimeout: (sink) => sink.close());
  }

  @override
  Future<List<TvDevice>> getDevices() async {
    final devices = <TvDevice>[];
    final sub = watchDevices().listen((device) {
      devices.add(device);
    });
    await Future<void>.delayed(_discoveryTimeout);
    await sub.cancel();
    return devices;
  }

  @override
  Future<void> stopDiscovery() async {
    await _datasource.stopDiscovery();
  }

  void dispose() {}
}
