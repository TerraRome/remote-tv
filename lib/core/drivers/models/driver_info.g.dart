// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DriverInfoImpl _$$DriverInfoImplFromJson(Map<String, dynamic> json) =>
    _$DriverInfoImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      manufacturer: json['manufacturer'] as String,
      version: json['version'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$$DriverInfoImplToJson(_$DriverInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'manufacturer': instance.manufacturer,
      'version': instance.version,
      'description': instance.description,
    };
