import '../../../discovery/domain/entities/tv_device.dart';
import '../repositories/favorite_repository.dart';

final class GetFavorites {
  final FavoriteRepository _repository;

  GetFavorites(this._repository);

  Future<List<TvDevice>> call() => _repository.getFavorites();
}
