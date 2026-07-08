import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:multicast_dns/multicast_dns.dart';

import '../../../drivers/models/driver_device.dart';
import '../../discovery_provider.dart';
import '../../models/discovery_protocol.dart';

class MdnsDiscoveryProvider implements DiscoveryProvider {
  MDnsClient? _client;

  static const List<String> _serviceTypes = [
    '_androidtvremote._tcp.local',
    '_googlecast._tcp.local',
  ];

  static const Duration _ptrTimeout = Duration(seconds: 3);
  static const Duration _resolveTimeout = Duration(seconds: 2);

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
    debugPrint('[mDNS] discover() called');
    try {
      _client = MDnsClient();
      await _client!.start();
    } catch (e) {
      debugPrint(
        '[mDNS] start failed: $e (reusePort unsupported on this device)',
      );
      _client = null;
      return; // yield nothing, discovery falls back to SSDP
    }
    debugPrint('[mDNS] client started');

    final controller = StreamController<DriverDevice>();
    unawaited(_doDiscovery(controller));

    await for (final device in controller.stream) {
      debugPrint('[mDNS] yielding device: ${device.id} ${device.ipAddress}');
      yield device;
    }

    _client?.stop();
    _client = null;
    debugPrint('[mDNS] discover() done');
  }

  Future<void> _doDiscovery(StreamController<DriverDevice> controller) async {
    try {
      final seen = <String>{};
      for (final serviceType in _serviceTypes) {
        debugPrint('[mDNS] querying PTR for $serviceType');
        final ptrs = <PtrResourceRecord>[];
        await for (final ptr
            in _client!
                .lookup<PtrResourceRecord>(
                  ResourceRecordQuery.serverPointer(serviceType),
                )
                .timeout(_ptrTimeout, onTimeout: (sink) => sink.close())) {
          ptrs.add(ptr);
          debugPrint('[mDNS] PTR found: ${ptr.domainName}');
        }
        debugPrint('[mDNS] PTR results for $serviceType: ${ptrs.length}');

        for (final ptr in ptrs) {
          final device = await _resolveDevice(ptr, serviceType, seen);
          if (device != null) {
            debugPrint(
              '[mDNS] resolved device: ${device.name} @ ${device.ipAddress}:${device.port}',
            );
            controller.add(device);
          } else {
            debugPrint(
              '[mDNS] failed to resolve device for PTR: ${ptr.domainName}',
            );
          }
        }
      }
    } on TimeoutException catch (e) {
      debugPrint('[mDNS] TimeoutException: $e');
    } catch (e, s) {
      debugPrint('[mDNS] error: $e\n$s');
      controller.addError(e);
    } finally {
      await controller.close();
    }
  }

  Future<DriverDevice?> _resolveDevice(
    PtrResourceRecord ptr,
    String serviceType,
    Set<String> seen,
  ) async {
    final serviceName = ptr.domainName;
    if (serviceName.isEmpty) return null;

    String? target;
    int? port;
    final txtData = <String, String>{};

    try {
      await for (final srv
          in _client!
              .lookup<SrvResourceRecord>(
                ResourceRecordQuery.service(serviceName),
              )
              .timeout(_resolveTimeout, onTimeout: (sink) => sink.close())) {
        target = srv.target;
        port = srv.port;
        debugPrint('[mDNS] SRV: ${srv.target}:${srv.port}');
      }

      if (target == null || port == null) {
        debugPrint('[mDNS] no SRV record for $serviceName');
        return null;
      }

      await for (final txt
          in _client!
              .lookup<TxtResourceRecord>(ResourceRecordQuery.text(serviceName))
              .timeout(_resolveTimeout, onTimeout: (sink) => sink.close())) {
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

      String? ipAddress;
      await for (final ip
          in _client!
              .lookup<IPAddressResourceRecord>(
                ResourceRecordQuery.addressIPv4(target),
              )
              .timeout(_resolveTimeout, onTimeout: (sink) => sink.close())) {
        ipAddress = ip.address.address;
      }

      if (ipAddress == null) {
        debugPrint('[mDNS] no IPv4 for $target, trying IPv6');
        await for (final ip
            in _client!
                .lookup<IPAddressResourceRecord>(
                  ResourceRecordQuery.addressIPv6(target),
                )
                .timeout(_resolveTimeout, onTimeout: (sink) => sink.close())) {
          ipAddress = ip.address.address;
        }
      }

      if (ipAddress == null) {
        debugPrint('[mDNS] no IP address resolved for $target');
        return null;
      }

      final key = '$ipAddress:$port';
      if (seen.contains(key)) {
        debugPrint('[mDNS] duplicate: $key');
        return null;
      }
      seen.add(key);

      final name = serviceName.replaceFirst('.$serviceType', '');
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
        metadata: <String, String>{'service_name': serviceName, ...txtData},
      );
    } on TimeoutException catch (e) {
      debugPrint('[mDNS] resolve timeout for $serviceName: $e');
      return null;
    } catch (e) {
      debugPrint('[mDNS] resolve error for $serviceName: $e');
      return null;
    }
  }

  @override
  Future<void> dispose() async {
    _client?.stop();
    _client = null;
  }
}
