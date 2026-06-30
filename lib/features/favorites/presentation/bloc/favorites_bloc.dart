import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';
import '../../domain/repositories/favorite_repository.dart';

@injectable
final class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoriteRepository _repository;

  FavoritesBloc(this._repository) : super(FavoritesInitial()) {
    on<FavoritesLoad>(_onLoad);
    on<FavoritesAdd>(_onAdd);
    on<FavoritesRemove>(_onRemove);
  }

  Future<void> _onLoad(
    FavoritesLoad event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final devices = await _repository.getFavorites();
      emit(FavoritesLoaded(devices));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> _onAdd(FavoritesAdd event, Emitter<FavoritesState> emit) async {
    try {
      await _repository.addFavorite(event.device);
      final devices = await _repository.getFavorites();
      emit(FavoritesLoaded(devices));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> _onRemove(
    FavoritesRemove event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await _repository.removeFavorite(event.deviceId);
      final devices = await _repository.getFavorites();
      emit(FavoritesLoaded(devices));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }
}
