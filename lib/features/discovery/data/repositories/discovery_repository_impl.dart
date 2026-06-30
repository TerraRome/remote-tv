import 'dart:async';
import 'package:injectable/injectable.dart';
import '../../../../core/drivers/driver_registry.dart';
import '../../domain/entities/tv_device.dart';
import '../../domain/repositories/discovery_repository.dart';
import '../datasources/discovery_datasource.dart';
import '../mappers/driver_device_mapper.dart';

@Injectable(as: DiscoveryRepository)
final class DiscoveryRepositoryImpl implements DiscoveryRepository {
  final DiscoveryDatasource _datasource;
  final DriverRegistry _driverRegistry;
  final DriverDeviceMapper _mapper;
  StreamSubscription<dynamic>? _subscription;
  final StreamController<TvDevice> _controller =
      StreamController<TvDevice>.broadcast();

  DiscoveryRepositoryImpl(this._datasource, this._driverRegistry, this._mapper);

  @override
  Stream<TvDevice> watchDevices() {
    _subscription?.cancel();
    _subscription = _datasource.startDiscovery().listen(
      (result) {
        final driver = _driverRegistry.resolve(result.device);
        if (driver == null) return; // No driver — ignore device
        final tvDevice = _mapper.mapToTvDevice(result.device);
        _controller.add(tvDevice);
      },
      onError: (error, stackTrace) {
        _controller.addError(error, stackTrace);
      },
    );
    return _controller.stream;
  }

  @override
  Future<List<TvDevice>> getDevices() async {
    final devices = <TvDevice>[];
    final sub = watchDevices().listen((device) {
      devices.add(device);
    });
    // Listen briefly to collect initial batch
    await Future<void>.delayed(const Duration(seconds: 3));
    await sub.cancel();
    return devices;
  }

  @override
  Future<void> stopDiscovery() async {
    await _subscription?.cancel();
    _subscription = null;
    await _datasource.stopDiscovery();
  }

  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
