import 'discovery_provider.dart';
import 'discovery_registry.dart';

class DiscoveryRegistryImpl implements DiscoveryRegistry {
  final List<DiscoveryProvider> _providers;

  DiscoveryRegistryImpl([List<DiscoveryProvider>? initialProviders])
    : _providers = List.from(initialProviders ?? []);

  @override
  List<DiscoveryProvider> get providers => List.unmodifiable(_providers);

  @override
  void register(DiscoveryProvider provider) {
    _providers.removeWhere((p) => p.id == provider.id);
    _providers.add(provider);
  }

  @override
  void unregister(String id) {
    _providers.removeWhere((p) => p.id == id);
  }

  @override
  DiscoveryProvider? getProvider(String id) {
    try {
      return _providers.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<DiscoveryProvider>> supportedProviders() async {
    final supported = <DiscoveryProvider>[];
    for (final provider in _providers) {
      if (await provider.isSupported()) {
        supported.add(provider);
      }
    }
    return supported;
  }
}
