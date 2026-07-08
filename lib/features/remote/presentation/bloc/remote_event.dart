import 'package:equatable/equatable.dart';
import '../../../../core/enums/remote_command.dart';
import '../../../discovery/domain/entities/tv_device.dart';
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
  final TvDevice device;
  const RemoteDeviceChanged(this.device);

  @override
  List<Object?> get props => [device];
}
