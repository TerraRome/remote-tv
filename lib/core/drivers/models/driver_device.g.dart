// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DriverDeviceImpl _$$DriverDeviceImplFromJson(Map<String, dynamic> json) =>
    _$DriverDeviceImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      ipAddress: json['ip_address'] as String,
      port: (json['port'] as num).toInt(),
      deviceType: json['device_type'] as String,
      modelName: json['model_name'] as String?,
      manufacturer: json['manufacturer'] as String?,
      metadata:
          (json['metadata'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
    );

Map<String, dynamic> _$$DriverDeviceImplToJson(_$DriverDeviceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'ip_address': instance.ipAddress,
      'port': instance.port,
      'device_type': instance.deviceType,
      'model_name': instance.modelName,
      'manufacturer': instance.manufacturer,
      'metadata': instance.metadata,
    };
