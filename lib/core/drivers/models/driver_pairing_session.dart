import 'package:freezed_annotation/freezed_annotation.dart';

part 'driver_pairing_session.freezed.dart';
part 'driver_pairing_session.g.dart';

@freezed
class DriverPairingSession with _$DriverPairingSession {
  const factory DriverPairingSession({
    required String deviceId,
    required String sessionId,
    required int pin,
    required bool isPaired,
    required DateTime createdAt,
    DateTime? expiresAt,
  }) = _DriverPairingSession;

  factory DriverPairingSession.fromJson(Map<String, dynamic> json) =>
      _$DriverPairingSessionFromJson(json);
}
