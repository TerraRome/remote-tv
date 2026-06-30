import '../../../discovery/domain/entities/tv_device.dart';

sealed class FavoritesEvent {}

final class FavoritesLoad extends FavoritesEvent {}

final class FavoritesAdd extends FavoritesEvent {
  final TvDevice device;

  FavoritesAdd(this.device);
}

final class FavoritesRemove extends FavoritesEvent {
  final String deviceId;

  FavoritesRemove(this.deviceId);
}
