import 'package:flutter/material.dart';

final class RemoteChannelButtons extends StatelessWidget {
  final VoidCallback onChannelUp;
  final VoidCallback onChannelDown;

  const RemoteChannelButtons({
    super.key,
    required this.onChannelUp,
    required this.onChannelDown,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.add),
          tooltip: 'Channel Up',
          onPressed: onChannelUp,
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.remove),
          tooltip: 'Channel Down',
          onPressed: onChannelDown,
        ),
      ],
    );
  }
}
