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
  StreamSubscription<TvDevice>? _discoverySub;
  Timer? _discoveryTimer;
  List<TvDevice> _devices = [];

  DiscoveryBloc(this._watchDiscoveredTvs) : super(const DiscoveryInitial()) {
    on<StartDiscovery>(_onStartDiscovery);
    on<StopDiscovery>(_onStopDiscovery);
    on<RetryDiscovery>(_onRetryDiscovery);
    on<DeviceSelected>(_onDeviceSelected);
  }

  void _cancelDiscovery() {
    _discoveryTimer?.cancel();
    _discoveryTimer = null;
    _discoverySub?.cancel();
    _discoverySub = null;
    _watchDiscoveredTvs.stop();
  }

  Future<void> _onStartDiscovery(
    StartDiscovery event,
    Emitter<DiscoveryState> emit,
  ) async {
    debugPrint('[DiscoveryBloc] StartDiscovery triggered');
    _cancelDiscovery();
    _devices = [];
    emit(const DiscoveryLoading());

    // Overall timeout: emit empty if nothing found within 10s
    _discoveryTimer = Timer(const Duration(seconds: 10), () {
      debugPrint('[DiscoveryBloc] Discovery timeout (10s)');
      if (!isClosed) {
        _cancelDiscovery();
        emit(const DiscoveryEmpty());
      }
    });

    try {
      final stream = _watchDiscoveredTvs();
      _discoverySub = stream.listen(
        (device) {
          debugPrint(
            '[DiscoveryBloc] Device received: '
            '${device.id} ${device.name} ${device.ipAddress}',
          );
          _devices.add(device);
          // Cancel timeout since we found at least one device
          _discoveryTimer?.cancel();
          emit(DiscoveryLoaded(List.unmodifiable(_devices)));
        },
        onError: (error) {
          debugPrint('[DiscoveryBloc] Error: $error');
          _discoveryTimer?.cancel();
          emit(DiscoveryError(error.toString()));
        },
        onDone: () {
          debugPrint('[DiscoveryBloc] Stream done');
          _discoveryTimer?.cancel();
          if (_devices.isEmpty && !isClosed) {
            emit(const DiscoveryEmpty());
          }
        },
      );
    } catch (e) {
      _discoveryTimer?.cancel();
      debugPrint('[DiscoveryBloc] Failed to start discovery: $e');
      emit(DiscoveryError(e.toString()));
    }
  }

  Future<void> _onStopDiscovery(
    StopDiscovery event,
    Emitter<DiscoveryState> emit,
  ) async {
    _cancelDiscovery();
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
    _cancelDiscovery();
    _devices = [];
    add(const StartDiscovery());
  }

  void _onDeviceSelected(DeviceSelected event, Emitter<DiscoveryState> emit) {}

  @override
  Future<void> close() {
    _cancelDiscovery();
    return super.close();
  }
}
