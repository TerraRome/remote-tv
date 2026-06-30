import 'package:injectable/injectable.dart';
import '../discovery_provider.dart';
import '../discovery_registry.dart';
import '../discovery_registry_impl.dart';
import '../discovery_service.dart';
import '../providers/mdns/mdns_discovery_provider.dart';
import '../providers/ssdp/ssdp_discovery_provider.dart';
import '../providers/manual/manual_discovery_provider.dart';

@module
abstract class DiscoveryModule {
  @singleton
  @Named('mdns')
  DiscoveryProvider get mdnsProvider => MdnsDiscoveryProvider();

  @singleton
  @Named('ssdp')
  DiscoveryProvider get ssdpProvider => SsdpDiscoveryProvider();

  @singleton
  @Named('manual')
  DiscoveryProvider get manualProvider => ManualDiscoveryProvider();

  @singleton
  List<DiscoveryProvider> get providerList => [
    mdnsProvider,
    ssdpProvider,
    manualProvider,
  ];

  @singleton
  DiscoveryRegistry get discoveryRegistry =>
      DiscoveryRegistryImpl(providerList);

  @singleton
  DiscoveryService get discoveryService =>
      DiscoveryServiceImpl(discoveryRegistry);
}
