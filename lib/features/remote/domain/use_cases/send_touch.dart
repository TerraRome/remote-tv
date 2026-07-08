import '../../../discovery/domain/entities/tv_device.dart';
import '../entities/touch_event.dart';
import '../repositories/remote_repository.dart';

final class SendTouch {
  final RemoteRepository _repository;

  SendTouch(this._repository);

  Future<void> call(TvDevice device, TouchEvent event) =>
      _repository.sendTouch(device, event);
}
