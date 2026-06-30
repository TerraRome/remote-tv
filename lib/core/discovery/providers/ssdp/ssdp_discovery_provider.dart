import 'dart:async';
import '../../discovery_provider.dart';
import '../../models/discovery_protocol.dart';
import '../../../drivers/models/driver_device.dart';

class SsdpDiscoveryProvider implements DiscoveryProvider {
  @override
  String get id => 'ssdp';

  @override
  String get name => 'SSDP Discovery';

  @override
  Set<DiscoveryProtocol> get protocols => {DiscoveryProtocol.ssdp};

  @override
  Future<bool> isSupported() async => false;

  @override
  Stream<DriverDevice> discover() async* {}

  @override
  Future<void> dispose() async {}
}
