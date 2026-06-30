import 'package:equatable/equatable.dart';
import '../../../discovery/domain/entities/tv_device.dart';

sealed class PairingEvent extends Equatable {
  const PairingEvent();

  @override
  List<Object?> get props => [];
}

final class InitiatePairing extends PairingEvent {
  final TvDevice device;
  const InitiatePairing(this.device);

  @override
  List<Object?> get props => [device];
}

final class EnterPin extends PairingEvent {
  final String pin;
  const EnterPin(this.pin);

  @override
  List<Object?> get props => [pin];
}

final class ConfirmPin extends PairingEvent {
  final String pin;
  const ConfirmPin(this.pin);

  @override
  List<Object?> get props => [pin];
}

final class CancelPairing extends PairingEvent {
  const CancelPairing();
}

final class DisconnectDevice extends PairingEvent {
  final String deviceId;
  const DisconnectDevice(this.deviceId);

  @override
  List<Object?> get props => [deviceId];
}
