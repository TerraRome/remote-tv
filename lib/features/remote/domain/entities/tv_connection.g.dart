// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_connection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TvConnectionImpl _$$TvConnectionImplFromJson(Map<String, dynamic> json) =>
    _$TvConnectionImpl(
      deviceId: json['device_id'] as String,
      driverId: json['driver_id'] as String,
      state: $enumDecode(_$TvConnectionStateEnumMap, json['state']),
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

Map<String, dynamic> _$$TvConnectionImplToJson(_$TvConnectionImpl instance) =>
    <String, dynamic>{
      'device_id': instance.deviceId,
      'driver_id': instance.driverId,
      'state': _$TvConnectionStateEnumMap[instance.state]!,
      'session_token': instance.sessionToken,
      'connected_at': instance.connectedAt.toIso8601String(),
      'last_activity_at': instance.lastActivityAt?.toIso8601String(),
      'capabilities': instance.capabilities,
    };

const _$TvConnectionStateEnumMap = {
  TvConnectionState.disconnected: 'disconnected',
  TvConnectionState.connecting: 'connecting',
  TvConnectionState.connected: 'connected',
  TvConnectionState.disconnecting: 'disconnecting',
  TvConnectionState.failed: 'failed',
};
