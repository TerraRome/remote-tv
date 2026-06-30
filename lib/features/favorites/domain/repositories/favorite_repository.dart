import '../../../discovery/domain/entities/tv_device.dart';

abstract interface class FavoriteRepository {
  Future<List<TvDevice>> getFavorites();
  Future<void> addFavorite(TvDevice device);
  Future<void> removeFavorite(String deviceId);
  Future<bool> isFavorite(String deviceId);
  Stream<List<TvDevice>> watchFavorites();
}
