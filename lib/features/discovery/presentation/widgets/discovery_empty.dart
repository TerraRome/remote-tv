import 'package:flutter/material.dart';

final class DiscoveryEmpty extends StatelessWidget {
  const DiscoveryEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.tv_off,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text('No TVs found', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Tap Scan to discover TVs on your network',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
