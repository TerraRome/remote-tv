import 'package:equatable/equatable.dart';
import '../../domain/entities/tv_device.dart';

sealed class DiscoveryEvent extends Equatable {
  const DiscoveryEvent();

  @override
  List<Object?> get props => [];
}

final class StartDiscovery extends DiscoveryEvent {
  const StartDiscovery();
}

final class StopDiscovery extends DiscoveryEvent {
  const StopDiscovery();
}

final class RetryDiscovery extends DiscoveryEvent {
  const RetryDiscovery();
}

final class DeviceSelected extends DiscoveryEvent {
  final TvDevice device;
  const DeviceSelected(this.device);

  @override
  List<Object?> get props => [device];
}
