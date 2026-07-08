import '../../../discovery/domain/entities/tv_device.dart';
import '../repositories/remote_repository.dart';

final class SendText {
  final RemoteRepository _repository;

  SendText(this._repository);

  Future<void> call(TvDevice device, String text) =>
      _repository.sendText(device, text);
}
