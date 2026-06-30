// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'driver_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DriverInfo _$DriverInfoFromJson(Map<String, dynamic> json) {
  return _DriverInfo.fromJson(json);
}

/// @nodoc
mixin _$DriverInfo {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get manufacturer => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  /// Serializes this DriverInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DriverInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DriverInfoCopyWith<DriverInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DriverInfoCopyWith<$Res> {
  factory $DriverInfoCopyWith(
    DriverInfo value,
    $Res Function(DriverInfo) then,
  ) = _$DriverInfoCopyWithImpl<$Res, DriverInfo>;
  @useResult
  $Res call({
    String id,
    String name,
    String manufacturer,
    String version,
    String description,
  });
}

/// @nodoc
class _$DriverInfoCopyWithImpl<$Res, $Val extends DriverInfo>
    implements $DriverInfoCopyWith<$Res> {
  _$DriverInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DriverInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? manufacturer = null,
    Object? version = null,
    Object? description = null,
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
            manufacturer: null == manufacturer
                ? _value.manufacturer
                : manufacturer // ignore: cast_nullable_to_non_nullable
                      as String,
            version: null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DriverInfoImplCopyWith<$Res>
    implements $DriverInfoCopyWith<$Res> {
  factory _$$DriverInfoImplCopyWith(
    _$DriverInfoImpl value,
    $Res Function(_$DriverInfoImpl) then,
  ) = __$$DriverInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String manufacturer,
    String version,
    String description,
  });
}

/// @nodoc
class __$$DriverInfoImplCopyWithImpl<$Res>
    extends _$DriverInfoCopyWithImpl<$Res, _$DriverInfoImpl>
    implements _$$DriverInfoImplCopyWith<$Res> {
  __$$DriverInfoImplCopyWithImpl(
    _$DriverInfoImpl _value,
    $Res Function(_$DriverInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DriverInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? manufacturer = null,
    Object? version = null,
    Object? description = null,
  }) {
    return _then(
      _$DriverInfoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        manufacturer: null == manufacturer
            ? _value.manufacturer
            : manufacturer // ignore: cast_nullable_to_non_nullable
                  as String,
        version: null == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DriverInfoImpl implements _DriverInfo {
  const _$DriverInfoImpl({
    required this.id,
    required this.name,
    required this.manufacturer,
    required this.version,
    required this.description,
  });

  factory _$DriverInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DriverInfoImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String manufacturer;
  @override
  final String version;
  @override
  final String description;

  @override
  String toString() {
    return 'DriverInfo(id: $id, name: $name, manufacturer: $manufacturer, version: $version, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DriverInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.manufacturer, manufacturer) ||
                other.manufacturer == manufacturer) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, manufacturer, version, description);

  /// Create a copy of DriverInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DriverInfoImplCopyWith<_$DriverInfoImpl> get copyWith =>
      __$$DriverInfoImplCopyWithImpl<_$DriverInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DriverInfoImplToJson(this);
  }
}

abstract class _DriverInfo implements DriverInfo {
  const factory _DriverInfo({
    required final String id,
    required final String name,
    required final String manufacturer,
    required final String version,
    required final String description,
  }) = _$DriverInfoImpl;

  factory _DriverInfo.fromJson(Map<String, dynamic> json) =
      _$DriverInfoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get manufacturer;
  @override
  String get version;
  @override
  String get description;

  /// Create a copy of DriverInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DriverInfoImplCopyWith<_$DriverInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
