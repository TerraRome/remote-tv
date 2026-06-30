import 'package:equatable/equatable.dart';
import '../../domain/entities/tv_device.dart';

sealed class DiscoveryState extends Equatable {
  const DiscoveryState();

  @override
  List<Object?> get props => [];
}

final class DiscoveryInitial extends DiscoveryState {
  const DiscoveryInitial();
}

final class DiscoveryLoading extends DiscoveryState {
  const DiscoveryLoading();
}

final class DiscoveryEmpty extends DiscoveryState {
  const DiscoveryEmpty();
}

final class DiscoveryLoaded extends DiscoveryState {
  final List<TvDevice> devices;
  const DiscoveryLoaded(this.devices);

  @override
  List<Object?> get props => [devices];
}

final class DiscoveryError extends DiscoveryState {
  final String message;
  const DiscoveryError(this.message);

  @override
  List<Object?> get props => [message];
}
