import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/discovery_bloc.dart';
import '../bloc/discovery_event.dart';
import '../bloc/discovery_state.dart';
import '../widgets/discovery_app_bar.dart';
import '../widgets/discovery_list.dart';
import '../widgets/discovery_empty.dart' as empty_widget;
import '../widgets/discovery_loading.dart';
import '../widgets/discovery_error.dart';

final class DiscoveryPage extends StatelessWidget {
  const DiscoveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DiscoveryBloc>();
    return Scaffold(
      appBar: DiscoveryAppBar(onScan: () => bloc.add(const StartDiscovery())),
      body: BlocConsumer<DiscoveryBloc, DiscoveryState>(
        listener: (context, state) {
          if (state is DiscoveryLoaded) {
            // Listening for device selection via bloc event
          }
        },
        builder: (context, state) {
          return switch (state) {
            DiscoveryInitial() => const empty_widget.DiscoveryEmpty(),
            DiscoveryLoading() => const DiscoveryLoadingWidget(),
            DiscoveryEmpty() => const empty_widget.DiscoveryEmpty(),
            DiscoveryLoaded(:final devices) => DiscoveryList(
              devices: devices,
              onDeviceTap: (device) {
                context.push('/pair/${device.id}');
              },
            ),
            DiscoveryError(:final message) => DiscoveryErrorWidget(
              message: message,
              onRetry: () => bloc.add(const RetryDiscovery()),
            ),
          };
        },
      ),
    );
  }
}
