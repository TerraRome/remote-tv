import 'package:flutter/material.dart';

final class RemoteDpad extends StatelessWidget {
  final VoidCallback onUp;
  final VoidCallback onDown;
  final VoidCallback onLeft;
  final VoidCallback onRight;
  final VoidCallback onOk;
  final VoidCallback onBack;
  final VoidCallback onHome;
  final VoidCallback onMenu;

  const RemoteDpad({
    super.key,
    required this.onUp,
    required this.onDown,
    required this.onLeft,
    required this.onRight,
    required this.onOk,
    required this.onBack,
    required this.onHome,
    required this.onMenu,
  });

  Widget _navButton(IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: 56,
      height: 56,
      child: FilledButton.tonal(onPressed: onPressed, child: Icon(icon)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [_navButton(Icons.keyboard_arrow_up, onUp)],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _navButton(Icons.keyboard_arrow_left, onLeft),
            const SizedBox(width: 8),
            _navButton(Icons.check, onOk),
            const SizedBox(width: 8),
            _navButton(Icons.keyboard_arrow_right, onRight),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [_navButton(Icons.keyboard_arrow_down, onDown)],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _navButton(Icons.arrow_back, onBack),
            const SizedBox(width: 8),
            _navButton(Icons.home, onHome),
            const SizedBox(width: 8),
            _navButton(Icons.menu, onMenu),
          ],
        ),
      ],
    );
  }
}
