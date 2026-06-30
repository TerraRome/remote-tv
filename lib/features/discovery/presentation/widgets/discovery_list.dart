import 'package:flutter/material.dart';
import '../../domain/entities/tv_device.dart';
import 'discovery_tile.dart';

final class DiscoveryList extends StatelessWidget {
  final List<TvDevice> devices;
  final void Function(TvDevice device)? onDeviceTap;

  const DiscoveryList({super.key, required this.devices, this.onDeviceTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: devices.length,
      itemBuilder: (context, index) {
        final device = devices[index];
        return DiscoveryTile(
          device: device,
          onTap: onDeviceTap != null ? () => onDeviceTap!(device) : null,
        );
      },
    );
  }
}
