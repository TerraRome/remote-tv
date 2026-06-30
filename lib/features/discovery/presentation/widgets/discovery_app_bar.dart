import 'package:flutter/material.dart';

final class DiscoveryAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onScan;

  const DiscoveryAppBar({super.key, required this.onScan});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Discover TVs'),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          tooltip: 'Scan for TVs',
          onPressed: onScan,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
