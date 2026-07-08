import 'dart:async';
import 'package:flutter/foundation.dart';
import '../drivers/models/driver_device.dart';
import 'discovery_registry.dart';
import 'models/discovery_result.dart';

abstract interface class DiscoveryService {
  Stream<DiscoveryResult> startDiscovery();
  Future<void> stopDiscovery();
}

class DiscoveryServiceImpl implements DiscoveryService {
  final DiscoveryRegistry _registry;
  final Map<String, StreamSubscription<DriverDevice>> _subscriptions = {};
  final Set<String> _seenDeviceKeys = {};
  StreamController<DiscoveryResult> _controller =
      StreamController<DiscoveryResult>.broadcast();
  bool _isRunning = false;
  int _activeProviders = 0;

  DiscoveryServiceImpl(this._registry);

  @override
  Stream<DiscoveryResult> startDiscovery() {
    debugPrint(
      '[DiscoveryService] startDiscovery() called, isRunning=$_isRunning',
    );
    if (_isRunning) return _controller.stream;
    _isRunning = true;
    _seenDeviceKeys.clear();

    // Recreate controller if it was closed
    if (_controller.isClosed) {
      _controller = StreamController<DiscoveryResult>.broadcast();
    }

    unawaited(_startAllProviders());

    return _controller.stream;
  }

  void _onProviderDone() {
    _activeProviders--;
    if (_activeProviders <= 0 && _isRunning) {
      _isRunning = false;
      if (!_controller.isClosed) {
        _controller.close();
      }
    }
  }

  Future<void> _startAllProviders() async {
    final providers = await _registry.supportedProviders();
    debugPrint('[DiscoveryService] providers registered: ${providers.length}');
    _activeProviders = providers.length;
    for (final provider in providers) {
      debugPrint('[DiscoveryService] starting provider: ${provider.id}');
      final sub = provider.discover().listen(
        (device) {
          final key = _deviceKey(device);
          debugPrint(
            '[DiscoveryService] device from ${provider.id}: ${device.id} $key',
          );
          if (key != null && _seenDeviceKeys.contains(key)) {
            debugPrint('[DiscoveryService] duplicate skipped: $key');
            return;
          }
          if (key != null) _seenDeviceKeys.add(key);
          if (!_controller.isClosed) {
            _controller.add(
              DiscoveryResult(
                device: device,
                protocol: provider.protocols.first,
                discoveredAt: DateTime.now(),
              ),
            );
          }
        },
        onError: (error, stackTrace) {
          debugPrint(
            '[DiscoveryService] provider ${provider.id} error: $error',
          );
          if (!_controller.isClosed) {
            _controller.addError(error, stackTrace);
          }
        },
        onDone: _onProviderDone,
        cancelOnError: false,
      );
      _subscriptions[provider.id] = sub;
    }
  }

  /// Deduplication: MAC > UUID > IP. Returns null if none available.
  String? _deviceKey(DriverDevice device) {
    final mac = device.metadata['mac'];
    if (mac is String && mac.isNotEmpty) {
      return 'mac:$mac';
    }
    final uuid = device.metadata['uuid'];
    if (uuid is String && uuid.isNotEmpty) {
      return 'uuid:$uuid';
    }
    final ip = device.ipAddress;
    if (ip.isNotEmpty) {
      return 'ip:$ip:${device.port}';
    }
    return null;
  }

  @override
  Future<void> stopDiscovery() async {
    _activeProviders = 0;
    for (final sub in _subscriptions.values) {
      await sub.cancel();
    }
    _subscriptions.clear();
    _seenDeviceKeys.clear();
    _isRunning = false;
    if (!_controller.isClosed) {
      _controller.close();
    }
  }

  void dispose() {
    unawaited(stopDiscovery());
    if (!_controller.isClosed) {
      _controller.close();
    }
  }
}
