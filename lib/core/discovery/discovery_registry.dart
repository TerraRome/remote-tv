import 'discovery_provider.dart';

abstract interface class DiscoveryRegistry {
  List<DiscoveryProvider> get providers;
  void register(DiscoveryProvider provider);
  void unregister(String id);
  DiscoveryProvider? getProvider(String id);
  Future<List<DiscoveryProvider>> supportedProviders();
}
