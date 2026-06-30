import 'package:freezed_annotation/freezed_annotation.dart';

part 'touch_event.freezed.dart';
part 'touch_event.g.dart';

@freezed
class TouchEvent with _$TouchEvent {
  const factory TouchEvent({
    required double x,
    required double y,
    required double dx,
    required double dy,
    required TouchEventType type,
  }) = _TouchEvent;

  factory TouchEvent.fromJson(Map<String, dynamic> json) =>
      _$TouchEventFromJson(json);
}

enum TouchEventType { down, move, up, swipe }
