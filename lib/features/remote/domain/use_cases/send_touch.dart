import '../entities/touch_event.dart';
import '../repositories/remote_repository.dart';

final class SendTouch {
  final RemoteRepository _repository;

  SendTouch(this._repository);

  Future<void> call(String deviceId, TouchEvent event) =>
      _repository.sendTouch(deviceId, event);
}
