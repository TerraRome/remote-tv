// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovery_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DiscoveryResultImpl _$$DiscoveryResultImplFromJson(
  Map<String, dynamic> json,
) => _$DiscoveryResultImpl(
  device: DriverDevice.fromJson(json['device'] as Map<String, dynamic>),
  protocol: $enumDecode(_$DiscoveryProtocolEnumMap, json['protocol']),
  discoveredAt: DateTime.parse(json['discovered_at'] as String),
);

Map<String, dynamic> _$$DiscoveryResultImplToJson(
  _$DiscoveryResultImpl instance,
) => <String, dynamic>{
  'device': instance.device.toJson(),
  'protocol': _$DiscoveryProtocolEnumMap[instance.protocol]!,
  'discovered_at': instance.discoveredAt.toIso8601String(),
};

const _$DiscoveryProtocolEnumMap = {
  DiscoveryProtocol.mdns: 'mdns',
  DiscoveryProtocol.ssdp: 'ssdp',
  DiscoveryProtocol.manual: 'manual',
  DiscoveryProtocol.dial: 'dial',
  DiscoveryProtocol.bluetooth: 'bluetooth',
  DiscoveryProtocol.unknown: 'unknown',
};
