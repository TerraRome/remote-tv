import '../../../discovery/domain/entities/tv_device.dart';

sealed class FavoritesState {}

final class FavoritesInitial extends FavoritesState {}

final class FavoritesLoaded extends FavoritesState {
  final List<TvDevice> devices;

  FavoritesLoaded(this.devices);
}

final class FavoritesError extends FavoritesState {
  final String message;

  FavoritesError(this.message);
}
