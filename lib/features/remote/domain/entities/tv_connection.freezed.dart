// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tv_connection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TvConnection _$TvConnectionFromJson(Map<String, dynamic> json) {
  return _TvConnection.fromJson(json);
}

/// @nodoc
mixin _$TvConnection {
  String get deviceId => throw _privateConstructorUsedError;
  String get driverId => throw _privateConstructorUsedError;
  TvConnectionState get state => throw _privateConstructorUsedError;
  String get sessionToken => throw _privateConstructorUsedError;
  DateTime get connectedAt => throw _privateConstructorUsedError;
  DateTime? get lastActivityAt => throw _privateConstructorUsedError;
  Map<String, String> get capabilities => throw _privateConstructorUsedError;

  /// Serializes this TvConnection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TvConnection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TvConnectionCopyWith<TvConnection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TvConnectionCopyWith<$Res> {
  factory $TvConnectionCopyWith(
    TvConnection value,
    $Res Function(TvConnection) then,
  ) = _$TvConnectionCopyWithImpl<$Res, TvConnection>;
  @useResult
  $Res call({
    String deviceId,
    String driverId,
    TvConnectionState state,
    String sessionToken,
    DateTime connectedAt,
    DateTime? lastActivityAt,
    Map<String, String> capabilities,
  });
}

/// @nodoc
class _$TvConnectionCopyWithImpl<$Res, $Val extends TvConnection>
    implements $TvConnectionCopyWith<$Res> {
  _$TvConnectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TvConnection
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
                      as TvConnectionState,
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
abstract class _$$TvConnectionImplCopyWith<$Res>
    implements $TvConnectionCopyWith<$Res> {
  factory _$$TvConnectionImplCopyWith(
    _$TvConnectionImpl value,
    $Res Function(_$TvConnectionImpl) then,
  ) = __$$TvConnectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String deviceId,
    String driverId,
    TvConnectionState state,
    String sessionToken,
    DateTime connectedAt,
    DateTime? lastActivityAt,
    Map<String, String> capabilities,
  });
}

/// @nodoc
class __$$TvConnectionImplCopyWithImpl<$Res>
    extends _$TvConnectionCopyWithImpl<$Res, _$TvConnectionImpl>
    implements _$$TvConnectionImplCopyWith<$Res> {
  __$$TvConnectionImplCopyWithImpl(
    _$TvConnectionImpl _value,
    $Res Function(_$TvConnectionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TvConnection
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
      _$TvConnectionImpl(
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
                  as TvConnectionState,
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
class _$TvConnectionImpl implements _TvConnection {
  const _$TvConnectionImpl({
    required this.deviceId,
    required this.driverId,
    required this.state,
    required this.sessionToken,
    required this.connectedAt,
    this.lastActivityAt,
    final Map<String, String> capabilities = const {},
  }) : _capabilities = capabilities;

  factory _$TvConnectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TvConnectionImplFromJson(json);

  @override
  final String deviceId;
  @override
  final String driverId;
  @override
  final TvConnectionState state;
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
    return 'TvConnection(deviceId: $deviceId, driverId: $driverId, state: $state, sessionToken: $sessionToken, connectedAt: $connectedAt, lastActivityAt: $lastActivityAt, capabilities: $capabilities)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TvConnectionImpl &&
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

  /// Create a copy of TvConnection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TvConnectionImplCopyWith<_$TvConnectionImpl> get copyWith =>
      __$$TvConnectionImplCopyWithImpl<_$TvConnectionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TvConnectionImplToJson(this);
  }
}

abstract class _TvConnection implements TvConnection {
  const factory _TvConnection({
    required final String deviceId,
    required final String driverId,
    required final TvConnectionState state,
    required final String sessionToken,
    required final DateTime connectedAt,
    final DateTime? lastActivityAt,
    final Map<String, String> capabilities,
  }) = _$TvConnectionImpl;

  factory _TvConnection.fromJson(Map<String, dynamic> json) =
      _$TvConnectionImpl.fromJson;

  @override
  String get deviceId;
  @override
  String get driverId;
  @override
  TvConnectionState get state;
  @override
  String get sessionToken;
  @override
  DateTime get connectedAt;
  @override
  DateTime? get lastActivityAt;
  @override
  Map<String, String> get capabilities;

  /// Create a copy of TvConnection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TvConnectionImplCopyWith<_$TvConnectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
