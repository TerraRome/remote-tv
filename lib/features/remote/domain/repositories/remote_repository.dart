import '../../../../core/enums/remote_command.dart';
import '../entities/touch_event.dart';

abstract interface class RemoteRepository {
  Future<void> sendCommand(String deviceId, RemoteCommand command);
  Future<void> sendText(String deviceId, String text);
  Future<void> sendTouch(String deviceId, TouchEvent event);
}
