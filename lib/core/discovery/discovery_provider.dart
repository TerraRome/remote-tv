import 'models/discovery_protocol.dart';
import '../drivers/models/driver_device.dart';

abstract interface class DiscoveryProvider {
  String get id;
  String get name;
  Set<DiscoveryProtocol> get protocols;
  Future<bool> isSupported();
  Stream<DriverDevice> discover();
  Future<void> dispose();
}
