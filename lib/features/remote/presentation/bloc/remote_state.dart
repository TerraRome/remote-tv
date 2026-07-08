import 'package:equatable/equatable.dart';
import '../../../discovery/domain/entities/tv_device.dart';

sealed class RemoteState extends Equatable {
  const RemoteState();

  @override
  List<Object?> get props => [];
}

final class RemoteInitial extends RemoteState {
  const RemoteInitial();
}

final class RemoteReady extends RemoteState {
  final TvDevice device;
  const RemoteReady(this.device);

  @override
  List<Object?> get props => [device];
}

final class RemoteCommandSent extends RemoteState {
  final String message;
  const RemoteCommandSent(this.message);

  @override
  List<Object?> get props => [message];
}

final class RemoteError extends RemoteState {
  final String message;
  const RemoteError(this.message);

  @override
  List<Object?> get props => [message];
}
