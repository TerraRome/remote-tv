import 'package:injectable/injectable.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../datasources/favorites_datasource.dart';
import '../../../discovery/domain/entities/tv_device.dart';

@Injectable(as: FavoriteRepository)
final class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoritesDatasource _datasource;

  FavoriteRepositoryImpl(this._datasource);

  @override
  Future<List<TvDevice>> getFavorites() async => _datasource.getFavorites();

  @override
  Future<void> addFavorite(TvDevice device) async =>
      _datasource.addFavorite(device);

  @override
  Future<void> removeFavorite(String deviceId) async =>
      _datasource.removeFavorite(deviceId);

  @override
  Future<bool> isFavorite(String deviceId) async =>
      _datasource.isFavorite(deviceId);

  @override
  Stream<List<TvDevice>> watchFavorites() async* {
    yield _datasource.getFavorites();
  }
}
