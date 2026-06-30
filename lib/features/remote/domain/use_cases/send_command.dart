import '../../../../core/enums/remote_command.dart';
import '../repositories/remote_repository.dart';

final class SendCommand {
  final RemoteRepository _repository;

  SendCommand(this._repository);

  Future<void> call(String deviceId, RemoteCommand command) =>
      _repository.sendCommand(deviceId, command);
}
