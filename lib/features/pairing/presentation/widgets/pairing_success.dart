import 'package:flutter/material.dart';

final class PairingSuccessView extends StatelessWidget {
  const PairingSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 64),
          SizedBox(height: 16),
          Text('Pairing successful!'),
        ],
      ),
    );
  }
}
