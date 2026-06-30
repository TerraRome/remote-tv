// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'touch_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TouchEventImpl _$$TouchEventImplFromJson(Map<String, dynamic> json) =>
    _$TouchEventImpl(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      dx: (json['dx'] as num).toDouble(),
      dy: (json['dy'] as num).toDouble(),
      type: $enumDecode(_$TouchEventTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$$TouchEventImplToJson(_$TouchEventImpl instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'dx': instance.dx,
      'dy': instance.dy,
      'type': _$TouchEventTypeEnumMap[instance.type]!,
    };

const _$TouchEventTypeEnumMap = {
  TouchEventType.down: 'down',
  TouchEventType.move: 'move',
  TouchEventType.up: 'up',
  TouchEventType.swipe: 'swipe',
};
