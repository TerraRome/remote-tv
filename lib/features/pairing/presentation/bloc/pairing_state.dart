import 'package:equatable/equatable.dart';
import '../../../discovery/domain/entities/tv_device.dart';

sealed class PairingState extends Equatable {
  const PairingState();

  @override
  List<Object?> get props => [];
}

final class PairingIdle extends PairingState {
  const PairingIdle();
}

final class PairingInProgress extends PairingState {
  final TvDevice device;
  const PairingInProgress(this.device);

  @override
  List<Object?> get props => [device];
}

final class PairingAwaitingPin extends PairingState {
  final TvDevice device;
  final String sessionId;
  final int pin;
  const PairingAwaitingPin({
    required this.device,
    required this.sessionId,
    required this.pin,
  });

  @override
  List<Object?> get props => [device, sessionId, pin];
}

final class PairingSuccess extends PairingState {
  final TvDevice device;
  const PairingSuccess(this.device);

  @override
  List<Object?> get props => [device];
}

final class PairingError extends PairingState {
  final String message;
  const PairingError(this.message);

  @override
  List<Object?> get props => [message];
}
