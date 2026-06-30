import '../repositories/discovery_repository.dart';
import '../entities/tv_device.dart';

final class GetDevices {
  final DiscoveryRepository _repository;

  GetDevices(this._repository);

  Future<List<TvDevice>> call() => _repository.getDevices();
}
