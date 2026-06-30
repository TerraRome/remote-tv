import 'dart:async';
import '../../discovery_provider.dart';
import '../../models/discovery_protocol.dart';
import '../../../drivers/models/driver_device.dart';

class ManualDiscoveryProvider implements DiscoveryProvider {
  @override
  String get id => 'manual';

  @override
  String get name => 'Manual Discovery';

  @override
  Set<DiscoveryProtocol> get protocols => {DiscoveryProtocol.manual};

  @override
  Future<bool> isSupported() async => true;

  @override
  Stream<DriverDevice> discover() async* {}

  @override
  Future<void> dispose() async {}
}
