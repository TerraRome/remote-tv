import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/remote_repository.dart';
import 'remote_event.dart';
import 'remote_state.dart';

@injectable
final class RemoteBloc extends Bloc<RemoteEvent, RemoteState> {
  final RemoteRepository _repository;

  RemoteBloc(this._repository) : super(const RemoteInitial()) {
    on<RemoteDeviceChanged>(_onDeviceChanged);
    on<RemoteCommandIssued>(_onCommandIssued);
    on<RemoteTextSent>(_onTextSent);
    on<RemoteTouchEventSent>(_onTouchSent);
  }

  void _onDeviceChanged(RemoteDeviceChanged event, Emitter<RemoteState> emit) {
    emit(RemoteReady(event.device));
  }

  Future<void> _onCommandIssued(
    RemoteCommandIssued event,
    Emitter<RemoteState> emit,
  ) async {
    try {
      final state = this.state;
      if (state case RemoteReady(:final device)) {
        await _repository.sendCommand(device, event.command);
        final label = event.command.name;
        emit(RemoteCommandSent('$label sent'));
      }
    } catch (e) {
      emit(RemoteError(e.toString()));
    }
  }

  Future<void> _onTouchSent(
    RemoteTouchEventSent event,
    Emitter<RemoteState> emit,
  ) async {
    try {
      final state = this.state;
      if (state case RemoteReady(:final device)) {
        await _repository.sendTouch(device, event.touchEvent);
        emit(const RemoteCommandSent('Touch sent'));
      }
    } catch (e) {
      emit(RemoteError(e.toString()));
    }
  }

  Future<void> _onTextSent(
    RemoteTextSent event,
    Emitter<RemoteState> emit,
  ) async {
    try {
      final state = this.state;
      if (state case RemoteReady(:final device)) {
        await _repository.sendText(device, event.text);
        emit(RemoteCommandSent('Text sent'));
      }
    } catch (e) {
      emit(RemoteError(e.toString()));
    }
  }
}
