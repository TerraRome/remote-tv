import '../../../../core/enums/remote_command.dart';
import '../../../discovery/domain/entities/tv_device.dart';
import '../repositories/remote_repository.dart';

final class SendCommand {
  final RemoteRepository _repository;

  SendCommand(this._repository);

  Future<void> call(TvDevice device, RemoteCommand command) =>
      _repository.sendCommand(device, command);
}
