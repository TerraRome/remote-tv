import 'dart:async';
import 'package:multicast_dns/multicast_dns.dart';
import '../../discovery_provider.dart';
import '../../models/discovery_protocol.dart';
import '../../../drivers/models/driver_device.dart';

class MdnsDiscoveryProvider implements DiscoveryProvider {
  MDnsClient? _client;

  // Android TV remote protocol service type
  static const String _serviceType = '_androidtvremote._tcp.local';

  @override
  String get id => 'mdns';

  @override
  String get name => 'mDNS Discovery';

  @override
  Set<DiscoveryProtocol> get protocols => {DiscoveryProtocol.mdns};

  @override
  Future<bool> isSupported() async => true;

  @override
  Stream<DriverDevice> discover() async* {
    _client = MDnsClient();
    await _client!.start();

    final controller = StreamController<DriverDevice>();
    unawaited(_doDiscovery(controller));

    await for (final device in controller.stream) {
      yield device;
    }

    _client?.stop();
    _client = null;
  }

  Future<void> _doDiscovery(StreamController<DriverDevice> controller) async {
    try {
      final ptrRecords = <PtrResourceRecord>[];
      await for (final ptr in _client!.lookup<PtrResourceRecord>(
        ResourceRecordQuery.serverPointer(_serviceType),
      )) {
        ptrRecords.add(ptr);
      }

      for (final ptr in ptrRecords) {
        final device = await _resolveDevice(ptr);
        if (device != null) {
          controller.add(device);
        }
      }
    } catch (e) {
      controller.addError(e);
    } finally {
      await controller.close();
    }
  }

  Future<DriverDevice?> _resolveDevice(PtrResourceRecord ptr) async {
    final serviceName = ptr.domainName;
    if (serviceName.isEmpty) return null;

    String? target;
    int? port;
    final txtData = <String, String>{};

    // Resolve SRV record
    await for (final srv in _client!.lookup<SrvResourceRecord>(
      ResourceRecordQuery.service(serviceName),
    )) {
      target = srv.target;
      port = srv.port;
    }

    if (target == null || port == null) return null;

    // Resolve TXT record
    await for (final txt in _client!.lookup<TxtResourceRecord>(
      ResourceRecordQuery.text(serviceName),
    )) {
      final raw = txt.text;
      if (raw.isNotEmpty) {
        for (final line in raw.split('\n')) {
          final trimmed = line.trim();
          if (trimmed.isEmpty) continue;
          final eqIndex = trimmed.indexOf('=');
          if (eqIndex > 0) {
            final key = trimmed.substring(0, eqIndex).trim().toLowerCase();
            final value = trimmed.substring(eqIndex + 1).trim();
            txtData[key] = value;
          }
        }
      }
    }

    // Resolve IPv4 address
    String? ipAddress;
    await for (final ip in _client!.lookup<IPAddressResourceRecord>(
      ResourceRecordQuery.addressIPv4(target),
    )) {
      ipAddress = ip.address.address;
    }

    // Fall back to IPv6 if no IPv4
    if (ipAddress == null) {
      await for (final ip in _client!.lookup<IPAddressResourceRecord>(
        ResourceRecordQuery.addressIPv6(target),
      )) {
        ipAddress = ip.address.address;
      }
    }

    if (ipAddress == null) return null;

    final name = serviceName.replaceFirst('.$_serviceType', '');
    final id = 'android-tv-${ipAddress.replaceAll('.', '-')}-$port';
    final modelName = txtData['model'] ?? name;
    final manufacturer = txtData['manufacturer'] ?? 'Google';

    return DriverDevice(
      id: id,
      name: name,
      ipAddress: ipAddress,
      port: port,
      deviceType: 'android_tv',
      modelName: modelName,
      manufacturer: manufacturer,
      metadata: {'service_name': serviceName, ...txtData},
    );
  }

  @override
  Future<void> dispose() async {
    _client?.stop();
    _client = null;
  }
}
