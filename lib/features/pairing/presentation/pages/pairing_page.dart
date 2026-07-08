import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../discovery/domain/entities/tv_device.dart';
import '../bloc/pairing_bloc.dart';
import '../bloc/pairing_event.dart';
import '../bloc/pairing_state.dart';
import '../widgets/pairing_loading.dart';
import '../widgets/pairing_pin_dialog.dart';
import '../widgets/pairing_success.dart';
import '../widgets/pairing_error.dart';

final class PairingPage extends StatelessWidget {
  final TvDevice device;
  const PairingPage({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return _PairingView(device: device);
  }
}

final class _PairingView extends StatefulWidget {
  final TvDevice device;
  const _PairingView({required this.device});

  @override
  State<_PairingView> createState() => _PairingViewState();
}

final class _PairingViewState extends State<_PairingView> {
  @override
  void initState() {
    super.initState();
    // Start pairing immediately with the selected device
    context.read<PairingBloc>().add(InitiatePairing(widget.device));
  }

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
          if (state is PairingSuccess) {
            context.push('/remote/${state.device.id}', extra: state.device);
          }
        },
        builder: (context, state) {
          return switch (state) {
            PairingInProgress() => const PairingLoading(),
            PairingAwaitingPin() => const PairingLoading(),
            PairingSuccess() => const PairingSuccessView(),
            PairingError(message: final message) => PairingErrorView(
              message: message,
              onRetry: () =>
                  context.read<PairingBloc>().add(const CancelPairing()),
            ),
            _ => const PairingLoading(),
          };
        },
      ),
    );
  }
}
