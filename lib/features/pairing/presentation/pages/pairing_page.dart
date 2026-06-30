import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/pairing_bloc.dart';
import '../bloc/pairing_event.dart';
import '../bloc/pairing_state.dart';
import '../widgets/pairing_loading.dart';
import '../widgets/pairing_pin_dialog.dart';
import '../widgets/pairing_success.dart';
import '../widgets/pairing_error.dart';

final class PairingPage extends StatelessWidget {
  final PairingBloc bloc;

  const PairingPage({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(value: bloc, child: const _PairingView());
  }
}

final class _PairingView extends StatelessWidget {
  const _PairingView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pair TV')),
      body: BlocConsumer<PairingBloc, PairingState>(
        listener: (context, state) {
          if (state is PairingAwaitingPin) {
            showDialog(
              context: context,
              builder: (_) => PairingPinDialog(
                deviceName: state.device.name,
                pin: state.pin.toString(),
              ),
            );
          }
        },
        builder: (context, state) {
          return switch (state) {
            PairingIdle() => const Center(
              child: Text('Select a device to pair'),
            ),
            PairingInProgress() => const PairingLoading(),
            PairingAwaitingPin() => const PairingLoading(),
            PairingSuccess() => const PairingSuccessView(),
            PairingError(message: final message) => PairingErrorView(
              message: message,
              onRetry: () =>
                  context.read<PairingBloc>().add(const CancelPairing()),
            ),
          };
        },
      ),
    );
  }
}
