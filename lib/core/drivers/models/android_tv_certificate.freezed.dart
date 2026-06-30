// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'android_tv_certificate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AndroidTvCertificate _$AndroidTvCertificateFromJson(Map<String, dynamic> json) {
  return _AndroidTvCertificate.fromJson(json);
}

/// @nodoc
mixin _$AndroidTvCertificate {
  String get deviceId => throw _privateConstructorUsedError;
  String get certificate => throw _privateConstructorUsedError;
  String get privateKey => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this AndroidTvCertificate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AndroidTvCertificate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AndroidTvCertificateCopyWith<AndroidTvCertificate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AndroidTvCertificateCopyWith<$Res> {
  factory $AndroidTvCertificateCopyWith(
    AndroidTvCertificate value,
    $Res Function(AndroidTvCertificate) then,
  ) = _$AndroidTvCertificateCopyWithImpl<$Res, AndroidTvCertificate>;
  @useResult
  $Res call({
    String deviceId,
    String certificate,
    String privateKey,
    DateTime createdAt,
  });
}

/// @nodoc
class _$AndroidTvCertificateCopyWithImpl<
  $Res,
  $Val extends AndroidTvCertificate
>
    implements $AndroidTvCertificateCopyWith<$Res> {
  _$AndroidTvCertificateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AndroidTvCertificate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? certificate = null,
    Object? privateKey = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            deviceId: null == deviceId
                ? _value.deviceId
                : deviceId // ignore: cast_nullable_to_non_nullable
                      as String,
            certificate: null == certificate
                ? _value.certificate
                : certificate // ignore: cast_nullable_to_non_nullable
                      as String,
            privateKey: null == privateKey
                ? _value.privateKey
                : privateKey // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AndroidTvCertificateImplCopyWith<$Res>
    implements $AndroidTvCertificateCopyWith<$Res> {
  factory _$$AndroidTvCertificateImplCopyWith(
    _$AndroidTvCertificateImpl value,
    $Res Function(_$AndroidTvCertificateImpl) then,
  ) = __$$AndroidTvCertificateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String deviceId,
    String certificate,
    String privateKey,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$AndroidTvCertificateImplCopyWithImpl<$Res>
    extends _$AndroidTvCertificateCopyWithImpl<$Res, _$AndroidTvCertificateImpl>
    implements _$$AndroidTvCertificateImplCopyWith<$Res> {
  __$$AndroidTvCertificateImplCopyWithImpl(
    _$AndroidTvCertificateImpl _value,
    $Res Function(_$AndroidTvCertificateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AndroidTvCertificate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? certificate = null,
    Object? privateKey = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$AndroidTvCertificateImpl(
        deviceId: null == deviceId
            ? _value.deviceId
            : deviceId // ignore: cast_nullable_to_non_nullable
                  as String,
        certificate: null == certificate
            ? _value.certificate
            : certificate // ignore: cast_nullable_to_non_nullable
                  as String,
        privateKey: null == privateKey
            ? _value.privateKey
            : privateKey // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AndroidTvCertificateImpl implements _AndroidTvCertificate {
  const _$AndroidTvCertificateImpl({
    required this.deviceId,
    required this.certificate,
    required this.privateKey,
    required this.createdAt,
  });

  factory _$AndroidTvCertificateImpl.fromJson(Map<String, dynamic> json) =>
      _$$AndroidTvCertificateImplFromJson(json);

  @override
  final String deviceId;
  @override
  final String certificate;
  @override
  final String privateKey;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'AndroidTvCertificate(deviceId: $deviceId, certificate: $certificate, privateKey: $privateKey, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AndroidTvCertificateImpl &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.certificate, certificate) ||
                other.certificate == certificate) &&
            (identical(other.privateKey, privateKey) ||
                other.privateKey == privateKey) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, deviceId, certificate, privateKey, createdAt);

  /// Create a copy of AndroidTvCertificate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AndroidTvCertificateImplCopyWith<_$AndroidTvCertificateImpl>
  get copyWith =>
      __$$AndroidTvCertificateImplCopyWithImpl<_$AndroidTvCertificateImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AndroidTvCertificateImplToJson(this);
  }
}

abstract class _AndroidTvCertificate implements AndroidTvCertificate {
  const factory _AndroidTvCertificate({
    required final String deviceId,
    required final String certificate,
    required final String privateKey,
    required final DateTime createdAt,
  }) = _$AndroidTvCertificateImpl;

  factory _AndroidTvCertificate.fromJson(Map<String, dynamic> json) =
      _$AndroidTvCertificateImpl.fromJson;

  @override
  String get deviceId;
  @override
  String get certificate;
  @override
  String get privateKey;
  @override
  DateTime get createdAt;

  /// Create a copy of AndroidTvCertificate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AndroidTvCertificateImplCopyWith<_$AndroidTvCertificateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
