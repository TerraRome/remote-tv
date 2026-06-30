import 'package:equatable/equatable.dart';

sealed class RemoteState extends Equatable {
  const RemoteState();

  @override
  List<Object?> get props => [];
}

final class RemoteInitial extends RemoteState {
  const RemoteInitial();
}

final class RemoteReady extends RemoteState {
  final String deviceId;
  const RemoteReady(this.deviceId);

  @override
  List<Object?> get props => [deviceId];
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
