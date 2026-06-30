// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'android_tv_certificate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AndroidTvCertificateImpl _$$AndroidTvCertificateImplFromJson(
  Map<String, dynamic> json,
) => _$AndroidTvCertificateImpl(
  deviceId: json['device_id'] as String,
  certificate: json['certificate'] as String,
  privateKey: json['private_key'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$$AndroidTvCertificateImplToJson(
  _$AndroidTvCertificateImpl instance,
) => <String, dynamic>{
  'device_id': instance.deviceId,
  'certificate': instance.certificate,
  'private_key': instance.privateKey,
  'created_at': instance.createdAt.toIso8601String(),
};
