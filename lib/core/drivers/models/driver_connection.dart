import 'package:freezed_annotation/freezed_annotation.dart';

part 'driver_connection.freezed.dart';
part 'driver_connection.g.dart';

@freezed
class DriverConnection with _$DriverConnection {
  const factory DriverConnection({
    required String deviceId,
    required String driverId,
    required String state,
    required String sessionToken,
    required DateTime connectedAt,
    DateTime? lastActivityAt,
    @Default({}) Map<String, String> capabilities,
  }) = _DriverConnection;

  factory DriverConnection.fromJson(Map<String, dynamic> json) =>
      _$DriverConnectionFromJson(json);
}
