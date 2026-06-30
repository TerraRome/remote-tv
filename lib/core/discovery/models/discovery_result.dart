import 'package:freezed_annotation/freezed_annotation.dart';
import '../../drivers/models/driver_device.dart';
import 'discovery_protocol.dart';

part 'discovery_result.freezed.dart';
part 'discovery_result.g.dart';

@freezed
class DiscoveryResult with _$DiscoveryResult {
  const factory DiscoveryResult({
    required DriverDevice device,
    required DiscoveryProtocol protocol,
    required DateTime discoveredAt,
  }) = _DiscoveryResult;

  factory DiscoveryResult.fromJson(Map<String, dynamic> json) =>
      _$DiscoveryResultFromJson(json);
}
