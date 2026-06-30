import 'package:injectable/injectable.dart';
import '../entities/tv_device.dart';
import '../repositories/discovery_repository.dart';

@injectable
final class DiscoverTvs {
  final DiscoveryRepository _repository;

  DiscoverTvs(this._repository);

  Future<List<TvDevice>> call() => _repository.getDevices();
}
