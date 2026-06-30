import 'package:freezed_annotation/freezed_annotation.dart';

part 'driver_device.freezed.dart';
part 'driver_device.g.dart';

@freezed
class DriverDevice with _$DriverDevice {
  const factory DriverDevice({
    required String id,
    required String name,
    required String ipAddress,
    required int port,
    required String deviceType,
    String? modelName,
    String? manufacturer,
    @Default({}) Map<String, String> metadata,
  }) = _DriverDevice;

  factory DriverDevice.fromJson(Map<String, dynamic> json) =>
      _$DriverDeviceFromJson(json);
}
