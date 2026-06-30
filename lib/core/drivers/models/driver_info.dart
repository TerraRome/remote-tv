import 'package:freezed_annotation/freezed_annotation.dart';

part 'driver_info.freezed.dart';
part 'driver_info.g.dart';

@freezed
class DriverInfo with _$DriverInfo {
  const factory DriverInfo({
    required String id,
    required String name,
    required String manufacturer,
    required String version,
    required String description,
  }) = _DriverInfo;

  factory DriverInfo.fromJson(Map<String, dynamic> json) =>
      _$DriverInfoFromJson(json);
}
