import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/tv_device.dart';
import '../../domain/use_cases/discover_tvs.dart';
import '../../domain/use_cases/watch_discovered_tvs.dart';
import 'discovery_event.dart';
import 'discovery_state.dart';

@injectable
final class DiscoveryBloc extends Bloc<DiscoveryEvent, DiscoveryState> {
  final DiscoverTvs _discoverTvs;
  final WatchDiscoveredTvs _watchDiscoveredTvs;
  StreamSubscription<TvDevice>? _subscription;
  List<TvDevice> _devices = [];

  DiscoveryBloc(this._discoverTvs, this._watchDiscoveredTvs)
    : super(const DiscoveryInitial()) {
    on<StartDiscovery>(_onStartDiscovery);
    on<StopDiscovery>(_onStopDiscovery);
    on<RetryDiscovery>(_onRetryDiscovery);
    on<DeviceSelected>(_onDeviceSelected);
  }

  Future<void> _onStartDiscovery(
    StartDiscovery event,
    Emitter<DiscoveryState> emit,
  ) async {
    emit(const DiscoveryLoading());
    _devices = [];
    try {
      final initialDevices = await _discoverTvs();
      _devices.addAll(initialDevices);
    } catch (error) {
      emit(DiscoveryError(error.toString()));
      return;
    }
    await _subscription?.cancel();
    _subscription = _watchDiscoveredTvs().listen(
      (device) {
        _devices.add(device);
        if (!isClosed) {
          emit(DiscoveryLoaded(List.unmodifiable(_devices)));
        }
      },
      onError: (error) {
        if (!isClosed) {
          emit(DiscoveryError(error.toString()));
        }
      },
    );
    emit(DiscoveryLoaded(List.unmodifiable(_devices)));
  }

  Future<void> _onStopDiscovery(
    StopDiscovery event,
    Emitter<DiscoveryState> emit,
  ) async {
    await _subscription?.cancel();
    _subscription = null;
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
    await _subscription?.cancel();
    _subscription = null;
    _devices = [];
    add(const StartDiscovery());
  }

  void _onDeviceSelected(DeviceSelected event, Emitter<DiscoveryState> emit) {
    // Device selected — routing handled by page
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    _subscription = null;
    await super.close();
  }
}
