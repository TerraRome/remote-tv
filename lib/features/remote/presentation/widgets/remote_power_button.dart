import 'package:flutter/material.dart';

final class RemotePowerButton extends StatelessWidget {
  final VoidCallback onPressed;

  const RemotePowerButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 64,
      height: 64,
      child: FloatingActionButton(
        heroTag: 'power',
        backgroundColor: theme.colorScheme.error,
        foregroundColor: theme.colorScheme.onError,
        onPressed: onPressed,
        child: const Icon(Icons.power_settings_new, size: 32),
      ),
    );
  }
}
