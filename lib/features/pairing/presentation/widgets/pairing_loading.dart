import 'package:flutter/material.dart';

final class PairingLoading extends StatelessWidget {
  const PairingLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Pairing in progress...'),
        ],
      ),
    );
  }
}
