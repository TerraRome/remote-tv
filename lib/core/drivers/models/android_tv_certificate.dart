import 'package:freezed_annotation/freezed_annotation.dart';

part 'android_tv_certificate.freezed.dart';
part 'android_tv_certificate.g.dart';

@freezed
class AndroidTvCertificate with _$AndroidTvCertificate {
  const factory AndroidTvCertificate({
    required String deviceId,
    required String certificate,
    required String privateKey,
    required DateTime createdAt,
  }) = _AndroidTvCertificate;

  factory AndroidTvCertificate.fromJson(Map<String, dynamic> json) =>
      _$AndroidTvCertificateFromJson(json);
}
