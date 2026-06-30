import 'package:flutter/material.dart';

final class DiscoveryLoadingWidget extends StatelessWidget {
  const DiscoveryLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Scanning for TVs...'),
        ],
      ),
    );
  }
}
