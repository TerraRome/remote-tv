// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_connection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DriverConnectionImpl _$$DriverConnectionImplFromJson(
  Map<String, dynamic> json,
) => _$DriverConnectionImpl(
  deviceId: json['device_id'] as String,
  driverId: json['driver_id'] as String,
  state: json['state'] as String,
  sessionToken: json['session_token'] as String,
  connectedAt: DateTime.parse(json['connected_at'] as String),
  lastActivityAt: json['last_activity_at'] == null
      ? null
      : DateTime.parse(json['last_activity_at'] as String),
  capabilities:
      (json['capabilities'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
);

Map<String, dynamic> _$$DriverConnectionImplToJson(
  _$DriverConnectionImpl instance,
) => <String, dynamic>{
  'device_id': instance.deviceId,
  'driver_id': instance.driverId,
  'state': instance.state,
  'session_token': instance.sessionToken,
  'connected_at': instance.connectedAt.toIso8601String(),
  'last_activity_at': instance.lastActivityAt?.toIso8601String(),
  'capabilities': instance.capabilities,
};
