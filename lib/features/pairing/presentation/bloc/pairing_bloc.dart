import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/connection_repository.dart';
import 'pairing_event.dart';
import 'pairing_state.dart';

@injectable
final class PairingBloc extends Bloc<PairingEvent, PairingState> {
  final ConnectionRepository _connectionRepository;

  PairingBloc(this._connectionRepository) : super(const PairingIdle()) {
    on<InitiatePairing>(_onInitiatePairing);
    on<EnterPin>(_onEnterPin);
    on<ConfirmPin>(_onConfirmPin);
    on<CancelPairing>(_onCancelPairing);
    on<DisconnectDevice>(_onDisconnect);
  }

  Future<void> _onInitiatePairing(
    InitiatePairing event,
    Emitter<PairingState> emit,
  ) async {
    emit(PairingInProgress(event.device));
    try {
      final session = await _connectionRepository.startPairing(event.device);
      emit(
        PairingAwaitingPin(
          device: event.device,
          sessionId: session.sessionId,
          pin: session.pin,
        ),
      );
    } catch (error) {
      emit(PairingError(error.toString()));
    }
  }

  void _onEnterPin(EnterPin event, Emitter<PairingState> emit) {
    // Pin entry tracked in state if needed
  }

  Future<void> _onConfirmPin(
    ConfirmPin event,
    Emitter<PairingState> emit,
  ) async {
    final currentState = state;
    if (currentState is PairingAwaitingPin) {
      try {
        await _connectionRepository.submitPin(
          currentState.sessionId,
          event.pin,
        );
        emit(PairingSuccess(currentState.device));
      } catch (error) {
        emit(PairingError(error.toString()));
      }
    }
  }

  void _onCancelPairing(CancelPairing event, Emitter<PairingState> emit) {
    emit(const PairingIdle());
  }

  Future<void> _onDisconnect(
    DisconnectDevice event,
    Emitter<PairingState> emit,
  ) async {
    try {
      await _connectionRepository.disconnect(event.deviceId);
      emit(const PairingIdle());
    } catch (error) {
      emit(PairingError(error.toString()));
    }
  }
}
