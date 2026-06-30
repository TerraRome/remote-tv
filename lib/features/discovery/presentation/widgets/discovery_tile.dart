import 'package:flutter/material.dart';
import '../../domain/entities/tv_device.dart';

final class DiscoveryTile extends StatelessWidget {
  final TvDevice device;
  final VoidCallback? onTap;

  const DiscoveryTile({super.key, required this.device, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.tv, size: 40),
        title: Text(device.name, style: theme.textTheme.titleMedium),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (device.manufacturer != null)
              Text(device.manufacturer!, style: theme.textTheme.bodySmall),
            Text(
              '${device.ipAddress}:${device.port}',
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
              ),
            ),
            Text(
              device.deviceType,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
