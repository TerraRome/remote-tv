// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'touch_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TouchEvent _$TouchEventFromJson(Map<String, dynamic> json) {
  return _TouchEvent.fromJson(json);
}

/// @nodoc
mixin _$TouchEvent {
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;
  double get dx => throw _privateConstructorUsedError;
  double get dy => throw _privateConstructorUsedError;
  TouchEventType get type => throw _privateConstructorUsedError;

  /// Serializes this TouchEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TouchEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TouchEventCopyWith<TouchEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TouchEventCopyWith<$Res> {
  factory $TouchEventCopyWith(
    TouchEvent value,
    $Res Function(TouchEvent) then,
  ) = _$TouchEventCopyWithImpl<$Res, TouchEvent>;
  @useResult
  $Res call({double x, double y, double dx, double dy, TouchEventType type});
}

/// @nodoc
class _$TouchEventCopyWithImpl<$Res, $Val extends TouchEvent>
    implements $TouchEventCopyWith<$Res> {
  _$TouchEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TouchEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? y = null,
    Object? dx = null,
    Object? dy = null,
    Object? type = null,
  }) {
    return _then(
      _value.copyWith(
            x: null == x
                ? _value.x
                : x // ignore: cast_nullable_to_non_nullable
                      as double,
            y: null == y
                ? _value.y
                : y // ignore: cast_nullable_to_non_nullable
                      as double,
            dx: null == dx
                ? _value.dx
                : dx // ignore: cast_nullable_to_non_nullable
                      as double,
            dy: null == dy
                ? _value.dy
                : dy // ignore: cast_nullable_to_non_nullable
                      as double,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as TouchEventType,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TouchEventImplCopyWith<$Res>
    implements $TouchEventCopyWith<$Res> {
  factory _$$TouchEventImplCopyWith(
    _$TouchEventImpl value,
    $Res Function(_$TouchEventImpl) then,
  ) = __$$TouchEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double x, double y, double dx, double dy, TouchEventType type});
}

/// @nodoc
class __$$TouchEventImplCopyWithImpl<$Res>
    extends _$TouchEventCopyWithImpl<$Res, _$TouchEventImpl>
    implements _$$TouchEventImplCopyWith<$Res> {
  __$$TouchEventImplCopyWithImpl(
    _$TouchEventImpl _value,
    $Res Function(_$TouchEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TouchEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? y = null,
    Object? dx = null,
    Object? dy = null,
    Object? type = null,
  }) {
    return _then(
      _$TouchEventImpl(
        x: null == x
            ? _value.x
            : x // ignore: cast_nullable_to_non_nullable
                  as double,
        y: null == y
            ? _value.y
            : y // ignore: cast_nullable_to_non_nullable
                  as double,
        dx: null == dx
            ? _value.dx
            : dx // ignore: cast_nullable_to_non_nullable
                  as double,
        dy: null == dy
            ? _value.dy
            : dy // ignore: cast_nullable_to_non_nullable
                  as double,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as TouchEventType,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TouchEventImpl implements _TouchEvent {
  const _$TouchEventImpl({
    required this.x,
    required this.y,
    required this.dx,
    required this.dy,
    required this.type,
  });

  factory _$TouchEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$TouchEventImplFromJson(json);

  @override
  final double x;
  @override
  final double y;
  @override
  final double dx;
  @override
  final double dy;
  @override
  final TouchEventType type;

  @override
  String toString() {
    return 'TouchEvent(x: $x, y: $y, dx: $dx, dy: $dy, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TouchEventImpl &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.dx, dx) || other.dx == dx) &&
            (identical(other.dy, dy) || other.dy == dy) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, x, y, dx, dy, type);

  /// Create a copy of TouchEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TouchEventImplCopyWith<_$TouchEventImpl> get copyWith =>
      __$$TouchEventImplCopyWithImpl<_$TouchEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TouchEventImplToJson(this);
  }
}

abstract class _TouchEvent implements TouchEvent {
  const factory _TouchEvent({
    required final double x,
    required final double y,
    required final double dx,
    required final double dy,
    required final TouchEventType type,
  }) = _$TouchEventImpl;

  factory _TouchEvent.fromJson(Map<String, dynamic> json) =
      _$TouchEventImpl.fromJson;

  @override
  double get x;
  @override
  double get y;
  @override
  double get dx;
  @override
  double get dy;
  @override
  TouchEventType get type;

  /// Create a copy of TouchEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TouchEventImplCopyWith<_$TouchEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
