import '../repositories/connection_repository.dart';

final class DisconnectDevice {
  final ConnectionRepository _repository;

  DisconnectDevice(this._repository);

  Future<void> call(String deviceId) => _repository.disconnect(deviceId);
}
