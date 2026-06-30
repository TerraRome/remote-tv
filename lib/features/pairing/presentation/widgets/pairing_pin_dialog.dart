import 'package:flutter/material.dart';

final class PairingPinDialog extends StatelessWidget {
  final String deviceName;
  final String pin;

  const PairingPinDialog({
    super.key,
    required this.deviceName,
    required this.pin,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Pair with $deviceName'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Enter the PIN shown on your TV:'),
          const SizedBox(height: 16),
          Text(
            pin,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 8,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
