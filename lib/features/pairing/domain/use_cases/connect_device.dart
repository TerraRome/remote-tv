import '../../../discovery/domain/entities/tv_device.dart';
import '../../../remote/domain/entities/tv_connection.dart';
import '../repositories/connection_repository.dart';

final class ConnectDevice {
  final ConnectionRepository _repository;

  ConnectDevice(this._repository);

  Future<TvConnection> call(TvDevice device) => _repository.connect(device);
}
