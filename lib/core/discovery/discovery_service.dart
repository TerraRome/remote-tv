import 'dart:async';
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
  final StreamController<DiscoveryResult> _controller =
      StreamController<DiscoveryResult>.broadcast();
  bool _isRunning = false;

  DiscoveryServiceImpl(this._registry);

  @override
  Stream<DiscoveryResult> startDiscovery() {
    if (_isRunning) return _controller.stream;
    _isRunning = true;
    _seenDeviceKeys.clear();

    unawaited(_startAllProviders());

    return _controller.stream;
  }

  Future<void> _startAllProviders() async {
    final providers = await _registry.supportedProviders();
    for (final provider in providers) {
      final sub = provider.discover().listen(
        (device) {
          final key = _deviceKey(device);
          if (key != null && _seenDeviceKeys.contains(key)) return;
          if (key != null) _seenDeviceKeys.add(key);
          _controller.add(
            DiscoveryResult(
              device: device,
              protocol: provider.protocols.first,
              discoveredAt: DateTime.now(),
            ),
          );
        },
        onError: (error, stackTrace) {
          _controller.addError(error, stackTrace);
        },
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
    for (final sub in _subscriptions.values) {
      await sub.cancel();
    }
    _subscriptions.clear();
    _seenDeviceKeys.clear();
    _isRunning = false;
  }

  void dispose() {
    unawaited(stopDiscovery());
    _controller.close();
  }
}
