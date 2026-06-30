import 'package:flutter/material.dart';

final class RemoteVolumeBar extends StatelessWidget {
  final VoidCallback onVolumeUp;
  final VoidCallback onVolumeDown;
  final VoidCallback onMute;

  const RemoteVolumeBar({
    super.key,
    required this.onVolumeUp,
    required this.onVolumeDown,
    required this.onMute,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.volume_down),
          tooltip: 'Volume Down',
          onPressed: onVolumeDown,
        ),
        IconButton(
          icon: const Icon(Icons.volume_off),
          tooltip: 'Mute',
          onPressed: onMute,
        ),
        IconButton(
          icon: const Icon(Icons.volume_up),
          tooltip: 'Volume Up',
          onPressed: onVolumeUp,
        ),
      ],
    );
  }
}
