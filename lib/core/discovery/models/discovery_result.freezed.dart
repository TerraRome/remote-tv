// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discovery_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DiscoveryResult _$DiscoveryResultFromJson(Map<String, dynamic> json) {
  return _DiscoveryResult.fromJson(json);
}

/// @nodoc
mixin _$DiscoveryResult {
  DriverDevice get device => throw _privateConstructorUsedError;
  DiscoveryProtocol get protocol => throw _privateConstructorUsedError;
  DateTime get discoveredAt => throw _privateConstructorUsedError;

  /// Serializes this DiscoveryResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DiscoveryResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiscoveryResultCopyWith<DiscoveryResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiscoveryResultCopyWith<$Res> {
  factory $DiscoveryResultCopyWith(
    DiscoveryResult value,
    $Res Function(DiscoveryResult) then,
  ) = _$DiscoveryResultCopyWithImpl<$Res, DiscoveryResult>;
  @useResult
  $Res call({
    DriverDevice device,
    DiscoveryProtocol protocol,
    DateTime discoveredAt,
  });

  $DriverDeviceCopyWith<$Res> get device;
}

/// @nodoc
class _$DiscoveryResultCopyWithImpl<$Res, $Val extends DiscoveryResult>
    implements $DiscoveryResultCopyWith<$Res> {
  _$DiscoveryResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DiscoveryResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? device = null,
    Object? protocol = null,
    Object? discoveredAt = null,
  }) {
    return _then(
      _value.copyWith(
            device: null == device
                ? _value.device
                : device // ignore: cast_nullable_to_non_nullable
                      as DriverDevice,
            protocol: null == protocol
                ? _value.protocol
                : protocol // ignore: cast_nullable_to_non_nullable
                      as DiscoveryProtocol,
            discoveredAt: null == discoveredAt
                ? _value.discoveredAt
                : discoveredAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }

  /// Create a copy of DiscoveryResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DriverDeviceCopyWith<$Res> get device {
    return $DriverDeviceCopyWith<$Res>(_value.device, (value) {
      return _then(_value.copyWith(device: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DiscoveryResultImplCopyWith<$Res>
    implements $DiscoveryResultCopyWith<$Res> {
  factory _$$DiscoveryResultImplCopyWith(
    _$DiscoveryResultImpl value,
    $Res Function(_$DiscoveryResultImpl) then,
  ) = __$$DiscoveryResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DriverDevice device,
    DiscoveryProtocol protocol,
    DateTime discoveredAt,
  });

  @override
  $DriverDeviceCopyWith<$Res> get device;
}

/// @nodoc
class __$$DiscoveryResultImplCopyWithImpl<$Res>
    extends _$DiscoveryResultCopyWithImpl<$Res, _$DiscoveryResultImpl>
    implements _$$DiscoveryResultImplCopyWith<$Res> {
  __$$DiscoveryResultImplCopyWithImpl(
    _$DiscoveryResultImpl _value,
    $Res Function(_$DiscoveryResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DiscoveryResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? device = null,
    Object? protocol = null,
    Object? discoveredAt = null,
  }) {
    return _then(
      _$DiscoveryResultImpl(
        device: null == device
            ? _value.device
            : device // ignore: cast_nullable_to_non_nullable
                  as DriverDevice,
        protocol: null == protocol
            ? _value.protocol
            : protocol // ignore: cast_nullable_to_non_nullable
                  as DiscoveryProtocol,
        discoveredAt: null == discoveredAt
            ? _value.discoveredAt
            : discoveredAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DiscoveryResultImpl implements _DiscoveryResult {
  const _$DiscoveryResultImpl({
    required this.device,
    required this.protocol,
    required this.discoveredAt,
  });

  factory _$DiscoveryResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$DiscoveryResultImplFromJson(json);

  @override
  final DriverDevice device;
  @override
  final DiscoveryProtocol protocol;
  @override
  final DateTime discoveredAt;

  @override
  String toString() {
    return 'DiscoveryResult(device: $device, protocol: $protocol, discoveredAt: $discoveredAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiscoveryResultImpl &&
            (identical(other.device, device) || other.device == device) &&
            (identical(other.protocol, protocol) ||
                other.protocol == protocol) &&
            (identical(other.discoveredAt, discoveredAt) ||
                other.discoveredAt == discoveredAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, device, protocol, discoveredAt);

  /// Create a copy of DiscoveryResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiscoveryResultImplCopyWith<_$DiscoveryResultImpl> get copyWith =>
      __$$DiscoveryResultImplCopyWithImpl<_$DiscoveryResultImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DiscoveryResultImplToJson(this);
  }
}

abstract class _DiscoveryResult implements DiscoveryResult {
  const factory _DiscoveryResult({
    required final DriverDevice device,
    required final DiscoveryProtocol protocol,
    required final DateTime discoveredAt,
  }) = _$DiscoveryResultImpl;

  factory _DiscoveryResult.fromJson(Map<String, dynamic> json) =
      _$DiscoveryResultImpl.fromJson;

  @override
  DriverDevice get device;
  @override
  DiscoveryProtocol get protocol;
  @override
  DateTime get discoveredAt;

  /// Create a copy of DiscoveryResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiscoveryResultImplCopyWith<_$DiscoveryResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
