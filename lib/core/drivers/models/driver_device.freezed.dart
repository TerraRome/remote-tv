// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'driver_device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DriverDevice _$DriverDeviceFromJson(Map<String, dynamic> json) {
  return _DriverDevice.fromJson(json);
}

/// @nodoc
mixin _$DriverDevice {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get ipAddress => throw _privateConstructorUsedError;
  int get port => throw _privateConstructorUsedError;
  String get deviceType => throw _privateConstructorUsedError;
  String? get modelName => throw _privateConstructorUsedError;
  String? get manufacturer => throw _privateConstructorUsedError;
  Map<String, String> get metadata => throw _privateConstructorUsedError;

  /// Serializes this DriverDevice to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DriverDevice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DriverDeviceCopyWith<DriverDevice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DriverDeviceCopyWith<$Res> {
  factory $DriverDeviceCopyWith(
    DriverDevice value,
    $Res Function(DriverDevice) then,
  ) = _$DriverDeviceCopyWithImpl<$Res, DriverDevice>;
  @useResult
  $Res call({
    String id,
    String name,
    String ipAddress,
    int port,
    String deviceType,
    String? modelName,
    String? manufacturer,
    Map<String, String> metadata,
  });
}

/// @nodoc
class _$DriverDeviceCopyWithImpl<$Res, $Val extends DriverDevice>
    implements $DriverDeviceCopyWith<$Res> {
  _$DriverDeviceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DriverDevice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? ipAddress = null,
    Object? port = null,
    Object? deviceType = null,
    Object? modelName = freezed,
    Object? manufacturer = freezed,
    Object? metadata = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            ipAddress: null == ipAddress
                ? _value.ipAddress
                : ipAddress // ignore: cast_nullable_to_non_nullable
                      as String,
            port: null == port
                ? _value.port
                : port // ignore: cast_nullable_to_non_nullable
                      as int,
            deviceType: null == deviceType
                ? _value.deviceType
                : deviceType // ignore: cast_nullable_to_non_nullable
                      as String,
            modelName: freezed == modelName
                ? _value.modelName
                : modelName // ignore: cast_nullable_to_non_nullable
                      as String?,
            manufacturer: freezed == manufacturer
                ? _value.manufacturer
                : manufacturer // ignore: cast_nullable_to_non_nullable
                      as String?,
            metadata: null == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DriverDeviceImplCopyWith<$Res>
    implements $DriverDeviceCopyWith<$Res> {
  factory _$$DriverDeviceImplCopyWith(
    _$DriverDeviceImpl value,
    $Res Function(_$DriverDeviceImpl) then,
  ) = __$$DriverDeviceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String ipAddress,
    int port,
    String deviceType,
    String? modelName,
    String? manufacturer,
    Map<String, String> metadata,
  });
}

/// @nodoc
class __$$DriverDeviceImplCopyWithImpl<$Res>
    extends _$DriverDeviceCopyWithImpl<$Res, _$DriverDeviceImpl>
    implements _$$DriverDeviceImplCopyWith<$Res> {
  __$$DriverDeviceImplCopyWithImpl(
    _$DriverDeviceImpl _value,
    $Res Function(_$DriverDeviceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DriverDevice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? ipAddress = null,
    Object? port = null,
    Object? deviceType = null,
    Object? modelName = freezed,
    Object? manufacturer = freezed,
    Object? metadata = null,
  }) {
    return _then(
      _$DriverDeviceImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        ipAddress: null == ipAddress
            ? _value.ipAddress
            : ipAddress // ignore: cast_nullable_to_non_nullable
                  as String,
        port: null == port
            ? _value.port
            : port // ignore: cast_nullable_to_non_nullable
                  as int,
        deviceType: null == deviceType
            ? _value.deviceType
            : deviceType // ignore: cast_nullable_to_non_nullable
                  as String,
        modelName: freezed == modelName
            ? _value.modelName
            : modelName // ignore: cast_nullable_to_non_nullable
                  as String?,
        manufacturer: freezed == manufacturer
            ? _value.manufacturer
            : manufacturer // ignore: cast_nullable_to_non_nullable
                  as String?,
        metadata: null == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DriverDeviceImpl implements _DriverDevice {
  const _$DriverDeviceImpl({
    required this.id,
    required this.name,
    required this.ipAddress,
    required this.port,
    required this.deviceType,
    this.modelName,
    this.manufacturer,
    final Map<String, String> metadata = const {},
  }) : _metadata = metadata;

  factory _$DriverDeviceImpl.fromJson(Map<String, dynamic> json) =>
      _$$DriverDeviceImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String ipAddress;
  @override
  final int port;
  @override
  final String deviceType;
  @override
  final String? modelName;
  @override
  final String? manufacturer;
  final Map<String, String> _metadata;
  @override
  @JsonKey()
  Map<String, String> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'DriverDevice(id: $id, name: $name, ipAddress: $ipAddress, port: $port, deviceType: $deviceType, modelName: $modelName, manufacturer: $manufacturer, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DriverDeviceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.port, port) || other.port == port) &&
            (identical(other.deviceType, deviceType) ||
                other.deviceType == deviceType) &&
            (identical(other.modelName, modelName) ||
                other.modelName == modelName) &&
            (identical(other.manufacturer, manufacturer) ||
                other.manufacturer == manufacturer) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    ipAddress,
    port,
    deviceType,
    modelName,
    manufacturer,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of DriverDevice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DriverDeviceImplCopyWith<_$DriverDeviceImpl> get copyWith =>
      __$$DriverDeviceImplCopyWithImpl<_$DriverDeviceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DriverDeviceImplToJson(this);
  }
}

abstract class _DriverDevice implements DriverDevice {
  const factory _DriverDevice({
    required final String id,
    required final String name,
    required final String ipAddress,
    required final int port,
    required final String deviceType,
    final String? modelName,
    final String? manufacturer,
    final Map<String, String> metadata,
  }) = _$DriverDeviceImpl;

  factory _DriverDevice.fromJson(Map<String, dynamic> json) =
      _$DriverDeviceImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get ipAddress;
  @override
  int get port;
  @override
  String get deviceType;
  @override
  String? get modelName;
  @override
  String? get manufacturer;
  @override
  Map<String, String> get metadata;

  /// Create a copy of DriverDevice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DriverDeviceImplCopyWith<_$DriverDeviceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
