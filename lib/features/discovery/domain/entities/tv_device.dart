import 'package:freezed_annotation/freezed_annotation.dart';

part 'tv_device.freezed.dart';
part 'tv_device.g.dart';

@freezed
class TvDevice with _$TvDevice {
  const factory TvDevice({
    required String id,
    required String name,
    required String ipAddress,
    required int port,
    required String deviceType,
    String? modelName,
    String? manufacturer,
    @Default({}) Map<String, String> metadata,
  }) = _TvDevice;

  factory TvDevice.fromJson(Map<String, dynamic> json) =>
      _$TvDeviceFromJson(json);
}
