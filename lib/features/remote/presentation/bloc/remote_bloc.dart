import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../discovery/domain/entities/tv_device.dart';
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
    emit(RemoteReady(event.deviceId));
  }

  Future<void> _onCommandIssued(
    RemoteCommandIssued event,
    Emitter<RemoteState> emit,
  ) async {
    try {
      final state = this.state;
      if (state case RemoteReady(:final deviceId)) {
        await _repository.sendCommand(deviceId, event.command);
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
      if (state case RemoteReady(:final deviceId)) {
        await _repository.sendTouch(deviceId, event.touchEvent);
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
      if (state case RemoteReady(:final deviceId)) {
        await _repository.sendText(deviceId, event.text);
        emit(RemoteCommandSent('Text sent'));
      }
    } catch (e) {
      emit(RemoteError(e.toString()));
    }
  }
}

/// Helper to create RemoteDevice from a discovery device
TvDevice tvDeviceFromId(String deviceId) {
  return TvDevice(
    id: deviceId,
    name: '',
    ipAddress: '',
    port: 0,
    deviceType: 'android_tv',
  );
}
