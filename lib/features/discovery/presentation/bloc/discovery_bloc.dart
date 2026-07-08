import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/tv_device.dart';
import '../../domain/use_cases/watch_discovered_tvs.dart';
import 'discovery_event.dart';
import 'discovery_state.dart';

@injectable
final class DiscoveryBloc extends Bloc<DiscoveryEvent, DiscoveryState> {
  final WatchDiscoveredTvs _watchDiscoveredTvs;
  List<TvDevice> _devices = [];

  DiscoveryBloc(this._watchDiscoveredTvs) : super(const DiscoveryInitial()) {
    on<StartDiscovery>(_onStartDiscovery);
    on<StopDiscovery>(_onStopDiscovery);
    on<RetryDiscovery>(_onRetryDiscovery);
    on<DeviceSelected>(_onDeviceSelected);
  }

  Future<void> _onStartDiscovery(
    StartDiscovery event,
    Emitter<DiscoveryState> emit,
  ) async {
    debugPrint('[DiscoveryBloc] StartDiscovery triggered');
    _watchDiscoveredTvs.stop();
    _devices = [];
    emit(const DiscoveryLoading());

    try {
      await emit.forEach<TvDevice>(
        _watchDiscoveredTvs().timeout(
          const Duration(seconds: 12),
          onTimeout: (sink) => sink.close(),
        ),
        onData: (device) {
          debugPrint(
            '[DiscoveryBloc] Device received: '
            '${device.id} ${device.name} ${device.ipAddress}',
          );
          _devices.add(device);
          return DiscoveryLoaded(List.unmodifiable(_devices));
        },
        onError: (error, _) {
          debugPrint('[DiscoveryBloc] Error: $error');
          return DiscoveryError(error.toString());
        },
      );
    } catch (e) {
      debugPrint('[DiscoveryBloc] emit.forEach error: $e');
    }

    if (_devices.isEmpty && !isClosed) {
      emit(const DiscoveryEmpty());
    }
  }

  Future<void> _onStopDiscovery(
    StopDiscovery event,
    Emitter<DiscoveryState> emit,
  ) async {
    _watchDiscoveredTvs.stop();
    if (_devices.isEmpty) {
      emit(const DiscoveryEmpty());
    } else {
      emit(DiscoveryLoaded(List.unmodifiable(_devices)));
    }
  }

  Future<void> _onRetryDiscovery(
    RetryDiscovery event,
    Emitter<DiscoveryState> emit,
  ) async {
    _watchDiscoveredTvs.stop();
    _devices = [];
    add(const StartDiscovery());
  }

  void _onDeviceSelected(DeviceSelected event, Emitter<DiscoveryState> emit) {}

  @override
  Future<void> close() {
    _watchDiscoveredTvs.stop();
    return super.close();
  }
}
