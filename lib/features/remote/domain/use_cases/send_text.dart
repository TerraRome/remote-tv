import '../repositories/remote_repository.dart';

final class SendText {
  final RemoteRepository _repository;

  SendText(this._repository);

  Future<void> call(String deviceId, String text) =>
      _repository.sendText(deviceId, text);
}
