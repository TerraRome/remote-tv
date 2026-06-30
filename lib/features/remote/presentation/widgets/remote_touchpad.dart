import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/touch_event.dart';
import '../bloc/remote_bloc.dart';
import '../bloc/remote_event.dart';

final class RemoteTouchpad extends StatefulWidget {
  const RemoteTouchpad({super.key});

  @override
  State<RemoteTouchpad> createState() => _RemoteTouchpadState();
}

final class _RemoteTouchpadState extends State<RemoteTouchpad> {
  double _startX = 0;
  double _startY = 0;

  void _sendTouch(
    TouchEventType type,
    double x,
    double y, {
    double dx = 0,
    double dy = 0,
  }) {
    context.read<RemoteBloc>().add(
      RemoteTouchEventSent(TouchEvent(x: x, y: y, dx: dx, dy: dy, type: type)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: GestureDetector(
        onPanStart: (details) {
          _startX = details.localPosition.dx;
          _startY = details.localPosition.dy;
          _sendTouch(TouchEventType.down, _startX, _startY);
        },
        onPanUpdate: (details) {
          final dx = details.localPosition.dx - _startX;
          final dy = details.localPosition.dy - _startY;
          _sendTouch(
            TouchEventType.move,
            details.localPosition.dx,
            details.localPosition.dy,
            dx: dx,
            dy: dy,
          );
          _startX = details.localPosition.dx;
          _startY = details.localPosition.dy;
        },
        onPanEnd: (details) {
          _sendTouch(TouchEventType.up, _startX, _startY);
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.touch_app,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text('Touchpad', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
