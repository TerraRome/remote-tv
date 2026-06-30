import '../repositories/discovery_repository.dart';
import '../entities/tv_device.dart';

final class WatchDevices {
  final DiscoveryRepository _repository;

  WatchDevices(this._repository);

  Stream<TvDevice> call() => _repository.watchDevices();
}
