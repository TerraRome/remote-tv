// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pairing_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PairingSession _$PairingSessionFromJson(Map<String, dynamic> json) {
  return _PairingSession.fromJson(json);
}

/// @nodoc
mixin _$PairingSession {
  String get deviceId => throw _privateConstructorUsedError;
  String get sessionId => throw _privateConstructorUsedError;
  int get pin => throw _privateConstructorUsedError;
  bool get isPaired => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;

  /// Serializes this PairingSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PairingSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PairingSessionCopyWith<PairingSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PairingSessionCopyWith<$Res> {
  factory $PairingSessionCopyWith(
    PairingSession value,
    $Res Function(PairingSession) then,
  ) = _$PairingSessionCopyWithImpl<$Res, PairingSession>;
  @useResult
  $Res call({
    String deviceId,
    String sessionId,
    int pin,
    bool isPaired,
    DateTime createdAt,
    DateTime? expiresAt,
  });
}

/// @nodoc
class _$PairingSessionCopyWithImpl<$Res, $Val extends PairingSession>
    implements $PairingSessionCopyWith<$Res> {
  _$PairingSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PairingSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? sessionId = null,
    Object? pin = null,
    Object? isPaired = null,
    Object? createdAt = null,
    Object? expiresAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            deviceId: null == deviceId
                ? _value.deviceId
                : deviceId // ignore: cast_nullable_to_non_nullable
                      as String,
            sessionId: null == sessionId
                ? _value.sessionId
                : sessionId // ignore: cast_nullable_to_non_nullable
                      as String,
            pin: null == pin
                ? _value.pin
                : pin // ignore: cast_nullable_to_non_nullable
                      as int,
            isPaired: null == isPaired
                ? _value.isPaired
                : isPaired // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            expiresAt: freezed == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PairingSessionImplCopyWith<$Res>
    implements $PairingSessionCopyWith<$Res> {
  factory _$$PairingSessionImplCopyWith(
    _$PairingSessionImpl value,
    $Res Function(_$PairingSessionImpl) then,
  ) = __$$PairingSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String deviceId,
    String sessionId,
    int pin,
    bool isPaired,
    DateTime createdAt,
    DateTime? expiresAt,
  });
}

/// @nodoc
class __$$PairingSessionImplCopyWithImpl<$Res>
    extends _$PairingSessionCopyWithImpl<$Res, _$PairingSessionImpl>
    implements _$$PairingSessionImplCopyWith<$Res> {
  __$$PairingSessionImplCopyWithImpl(
    _$PairingSessionImpl _value,
    $Res Function(_$PairingSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PairingSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? sessionId = null,
    Object? pin = null,
    Object? isPaired = null,
    Object? createdAt = null,
    Object? expiresAt = freezed,
  }) {
    return _then(
      _$PairingSessionImpl(
        deviceId: null == deviceId
            ? _value.deviceId
            : deviceId // ignore: cast_nullable_to_non_nullable
                  as String,
        sessionId: null == sessionId
            ? _value.sessionId
            : sessionId // ignore: cast_nullable_to_non_nullable
                  as String,
        pin: null == pin
            ? _value.pin
            : pin // ignore: cast_nullable_to_non_nullable
                  as int,
        isPaired: null == isPaired
            ? _value.isPaired
            : isPaired // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        expiresAt: freezed == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PairingSessionImpl implements _PairingSession {
  const _$PairingSessionImpl({
    required this.deviceId,
    required this.sessionId,
    required this.pin,
    required this.isPaired,
    required this.createdAt,
    this.expiresAt,
  });

  factory _$PairingSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PairingSessionImplFromJson(json);

  @override
  final String deviceId;
  @override
  final String sessionId;
  @override
  final int pin;
  @override
  final bool isPaired;
  @override
  final DateTime createdAt;
  @override
  final DateTime? expiresAt;

  @override
  String toString() {
    return 'PairingSession(deviceId: $deviceId, sessionId: $sessionId, pin: $pin, isPaired: $isPaired, createdAt: $createdAt, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PairingSessionImpl &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.pin, pin) || other.pin == pin) &&
            (identical(other.isPaired, isPaired) ||
                other.isPaired == isPaired) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    deviceId,
    sessionId,
    pin,
    isPaired,
    createdAt,
    expiresAt,
  );

  /// Create a copy of PairingSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PairingSessionImplCopyWith<_$PairingSessionImpl> get copyWith =>
      __$$PairingSessionImplCopyWithImpl<_$PairingSessionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PairingSessionImplToJson(this);
  }
}

abstract class _PairingSession implements PairingSession {
  const factory _PairingSession({
    required final String deviceId,
    required final String sessionId,
    required final int pin,
    required final bool isPaired,
    required final DateTime createdAt,
    final DateTime? expiresAt,
  }) = _$PairingSessionImpl;

  factory _PairingSession.fromJson(Map<String, dynamic> json) =
      _$PairingSessionImpl.fromJson;

  @override
  String get deviceId;
  @override
  String get sessionId;
  @override
  int get pin;
  @override
  bool get isPaired;
  @override
  DateTime get createdAt;
  @override
  DateTime? get expiresAt;

  /// Create a copy of PairingSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PairingSessionImplCopyWith<_$PairingSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
