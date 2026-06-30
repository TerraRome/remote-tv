import 'package:equatable/equatable.dart';
import '../../../../core/enums/remote_command.dart';
import '../../domain/entities/touch_event.dart';

sealed class RemoteEvent extends Equatable {
  const RemoteEvent();

  @override
  List<Object?> get props => [];
}

final class RemoteCommandIssued extends RemoteEvent {
  final RemoteCommand command;
  const RemoteCommandIssued(this.command);

  @override
  List<Object?> get props => [command];
}

final class RemoteTextSent extends RemoteEvent {
  final String text;
  const RemoteTextSent(this.text);

  @override
  List<Object?> get props => [text];
}

final class RemoteTouchEventSent extends RemoteEvent {
  final TouchEvent touchEvent;
  const RemoteTouchEventSent(this.touchEvent);

  @override
  List<Object?> get props => [touchEvent];
}

final class RemoteDeviceChanged extends RemoteEvent {
  final String deviceId;
  const RemoteDeviceChanged(this.deviceId);

  @override
  List<Object?> get props => [deviceId];
}
