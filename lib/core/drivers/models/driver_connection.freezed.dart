// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'driver_connection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DriverConnection _$DriverConnectionFromJson(Map<String, dynamic> json) {
  return _DriverConnection.fromJson(json);
}

/// @nodoc
mixin _$DriverConnection {
  String get deviceId => throw _privateConstructorUsedError;
  String get driverId => throw _privateConstructorUsedError;
  String get state => throw _privateConstructorUsedError;
  String get sessionToken => throw _privateConstructorUsedError;
  DateTime get connectedAt => throw _privateConstructorUsedError;
  DateTime? get lastActivityAt => throw _privateConstructorUsedError;
  Map<String, String> get capabilities => throw _privateConstructorUsedError;

  /// Serializes this DriverConnection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DriverConnection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DriverConnectionCopyWith<DriverConnection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DriverConnectionCopyWith<$Res> {
  factory $DriverConnectionCopyWith(
    DriverConnection value,
    $Res Function(DriverConnection) then,
  ) = _$DriverConnectionCopyWithImpl<$Res, DriverConnection>;
  @useResult
  $Res call({
    String deviceId,
    String driverId,
    String state,
    String sessionToken,
    DateTime connectedAt,
    DateTime? lastActivityAt,
    Map<String, String> capabilities,
  });
}

/// @nodoc
class _$DriverConnectionCopyWithImpl<$Res, $Val extends DriverConnection>
    implements $DriverConnectionCopyWith<$Res> {
  _$DriverConnectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DriverConnection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? driverId = null,
    Object? state = null,
    Object? sessionToken = null,
    Object? connectedAt = null,
    Object? lastActivityAt = freezed,
    Object? capabilities = null,
  }) {
    return _then(
      _value.copyWith(
            deviceId: null == deviceId
                ? _value.deviceId
                : deviceId // ignore: cast_nullable_to_non_nullable
                      as String,
            driverId: null == driverId
                ? _value.driverId
                : driverId // ignore: cast_nullable_to_non_nullable
                      as String,
            state: null == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                      as String,
            sessionToken: null == sessionToken
                ? _value.sessionToken
                : sessionToken // ignore: cast_nullable_to_non_nullable
                      as String,
            connectedAt: null == connectedAt
                ? _value.connectedAt
                : connectedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            lastActivityAt: freezed == lastActivityAt
                ? _value.lastActivityAt
                : lastActivityAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            capabilities: null == capabilities
                ? _value.capabilities
                : capabilities // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DriverConnectionImplCopyWith<$Res>
    implements $DriverConnectionCopyWith<$Res> {
  factory _$$DriverConnectionImplCopyWith(
    _$DriverConnectionImpl value,
    $Res Function(_$DriverConnectionImpl) then,
  ) = __$$DriverConnectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String deviceId,
    String driverId,
    String state,
    String sessionToken,
    DateTime connectedAt,
    DateTime? lastActivityAt,
    Map<String, String> capabilities,
  });
}

/// @nodoc
class __$$DriverConnectionImplCopyWithImpl<$Res>
    extends _$DriverConnectionCopyWithImpl<$Res, _$DriverConnectionImpl>
    implements _$$DriverConnectionImplCopyWith<$Res> {
  __$$DriverConnectionImplCopyWithImpl(
    _$DriverConnectionImpl _value,
    $Res Function(_$DriverConnectionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DriverConnection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? driverId = null,
    Object? state = null,
    Object? sessionToken = null,
    Object? connectedAt = null,
    Object? lastActivityAt = freezed,
    Object? capabilities = null,
  }) {
    return _then(
      _$DriverConnectionImpl(
        deviceId: null == deviceId
            ? _value.deviceId
            : deviceId // ignore: cast_nullable_to_non_nullable
                  as String,
        driverId: null == driverId
            ? _value.driverId
            : driverId // ignore: cast_nullable_to_non_nullable
                  as String,
        state: null == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as String,
        sessionToken: null == sessionToken
            ? _value.sessionToken
            : sessionToken // ignore: cast_nullable_to_non_nullable
                  as String,
        connectedAt: null == connectedAt
            ? _value.connectedAt
            : connectedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        lastActivityAt: freezed == lastActivityAt
            ? _value.lastActivityAt
            : lastActivityAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        capabilities: null == capabilities
            ? _value._capabilities
            : capabilities // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DriverConnectionImpl implements _DriverConnection {
  const _$DriverConnectionImpl({
    required this.deviceId,
    required this.driverId,
    required this.state,
    required this.sessionToken,
    required this.connectedAt,
    this.lastActivityAt,
    final Map<String, String> capabilities = const {},
  }) : _capabilities = capabilities;

  factory _$DriverConnectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$DriverConnectionImplFromJson(json);

  @override
  final String deviceId;
  @override
  final String driverId;
  @override
  final String state;
  @override
  final String sessionToken;
  @override
  final DateTime connectedAt;
  @override
  final DateTime? lastActivityAt;
  final Map<String, String> _capabilities;
  @override
  @JsonKey()
  Map<String, String> get capabilities {
    if (_capabilities is EqualUnmodifiableMapView) return _capabilities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_capabilities);
  }

  @override
  String toString() {
    return 'DriverConnection(deviceId: $deviceId, driverId: $driverId, state: $state, sessionToken: $sessionToken, connectedAt: $connectedAt, lastActivityAt: $lastActivityAt, capabilities: $capabilities)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DriverConnectionImpl &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.driverId, driverId) ||
                other.driverId == driverId) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.sessionToken, sessionToken) ||
                other.sessionToken == sessionToken) &&
            (identical(other.connectedAt, connectedAt) ||
                other.connectedAt == connectedAt) &&
            (identical(other.lastActivityAt, lastActivityAt) ||
                other.lastActivityAt == lastActivityAt) &&
            const DeepCollectionEquality().equals(
              other._capabilities,
              _capabilities,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    deviceId,
    driverId,
    state,
    sessionToken,
    connectedAt,
    lastActivityAt,
    const DeepCollectionEquality().hash(_capabilities),
  );

  /// Create a copy of DriverConnection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DriverConnectionImplCopyWith<_$DriverConnectionImpl> get copyWith =>
      __$$DriverConnectionImplCopyWithImpl<_$DriverConnectionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DriverConnectionImplToJson(this);
  }
}

abstract class _DriverConnection implements DriverConnection {
  const factory _DriverConnection({
    required final String deviceId,
    required final String driverId,
    required final String state,
    required final String sessionToken,
    required final DateTime connectedAt,
    final DateTime? lastActivityAt,
    final Map<String, String> capabilities,
  }) = _$DriverConnectionImpl;

  factory _DriverConnection.fromJson(Map<String, dynamic> json) =
      _$DriverConnectionImpl.fromJson;

  @override
  String get deviceId;
  @override
  String get driverId;
  @override
  String get state;
  @override
  String get sessionToken;
  @override
  DateTime get connectedAt;
  @override
  DateTime? get lastActivityAt;
  @override
  Map<String, String> get capabilities;

  /// Create a copy of DriverConnection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DriverConnectionImplCopyWith<_$DriverConnectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
