// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_pairing_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DriverPairingSessionImpl _$$DriverPairingSessionImplFromJson(
  Map<String, dynamic> json,
) => _$DriverPairingSessionImpl(
  deviceId: json['device_id'] as String,
  sessionId: json['session_id'] as String,
  pin: (json['pin'] as num).toInt(),
  isPaired: json['is_paired'] as bool,
  createdAt: DateTime.parse(json['created_at'] as String),
  expiresAt: json['expires_at'] == null
      ? null
      : DateTime.parse(json['expires_at'] as String),
);

Map<String, dynamic> _$$DriverPairingSessionImplToJson(
  _$DriverPairingSessionImpl instance,
) => <String, dynamic>{
  'device_id': instance.deviceId,
  'session_id': instance.sessionId,
  'pin': instance.pin,
  'is_paired': instance.isPaired,
  'created_at': instance.createdAt.toIso8601String(),
  'expires_at': instance.expiresAt?.toIso8601String(),
};
