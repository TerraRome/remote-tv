import '../../../../core/enums/remote_command.dart';
import '../../../discovery/domain/entities/tv_device.dart';
import '../entities/touch_event.dart';

abstract interface class RemoteRepository {
  Future<void> sendCommand(TvDevice device, RemoteCommand command);
  Future<void> sendText(TvDevice device, String text);
  Future<void> sendTouch(TvDevice device, TouchEvent event);
}
