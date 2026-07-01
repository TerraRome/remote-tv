import 'package:injectable/injectable.dart';
import '../entities/tv_device.dart';
import '../repositories/discovery_repository.dart';

@injectable
final class WatchDiscoveredTvs {
  final DiscoveryRepository _repository;

  WatchDiscoveredTvs(this._repository);

  Stream<TvDevice> call() => _repository.watchDevices();

  Future<void> stop() => _repository.stopDiscovery();
}
