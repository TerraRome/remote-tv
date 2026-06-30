import 'dart:convert';
import 'package:injectable/injectable.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../discovery/domain/entities/tv_device.dart';

@injectable
final class FavoritesDatasource {
  static const _favoritesKey = 'favorites';
  static const _lastConnectedKey = 'last_connected';
  final StorageService _storage;

  FavoritesDatasource(this._storage);

  List<TvDevice> getFavorites() {
    final raw = _storage.get<String>(_favoritesKey);
    if (raw == null) return [];
    final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => TvDevice.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveFavorites(List<TvDevice> devices) async {
    final raw = jsonEncode(devices.map((e) => e.toJson()).toList());
    await _storage.put(_favoritesKey, raw);
  }

  Future<void> addFavorite(TvDevice device) async {
    final devices = getFavorites();
    if (devices.any((d) => d.id == device.id)) return;
    devices.add(device);
    await saveFavorites(devices);
  }

  Future<void> removeFavorite(String deviceId) async {
    final devices = getFavorites();
    devices.removeWhere((d) => d.id == deviceId);
    await saveFavorites(devices);
  }

  bool isFavorite(String deviceId) {
    return getFavorites().any((d) => d.id == deviceId);
  }

  TvDevice? getLastConnected() {
    final raw = _storage.get<String>(_lastConnectedKey);
    if (raw == null) return null;
    return TvDevice.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> setLastConnected(TvDevice device) async {
    await _storage.put(_lastConnectedKey, jsonEncode(device.toJson()));
  }
}
