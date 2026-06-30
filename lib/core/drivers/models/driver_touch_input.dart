enum DriverTouchType { down, move, up, swipe }

class DriverTouchInput {
  const DriverTouchInput({
    required this.x,
    required this.y,
    required this.dx,
    required this.dy,
    required this.type,
  });

  final double x;
  final double y;
  final double dx;
  final double dy;
  final DriverTouchType type;
}
