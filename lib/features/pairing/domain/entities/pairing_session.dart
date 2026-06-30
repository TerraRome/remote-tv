import 'package:freezed_annotation/freezed_annotation.dart';

part 'pairing_session.freezed.dart';
part 'pairing_session.g.dart';

@freezed
class PairingSession with _$PairingSession {
  const factory PairingSession({
    required String deviceId,
    required String sessionId,
    required int pin,
    required bool isPaired,
    required DateTime createdAt,
    DateTime? expiresAt,
  }) = _PairingSession;

  factory PairingSession.fromJson(Map<String, dynamic> json) =>
      _$PairingSessionFromJson(json);
}
