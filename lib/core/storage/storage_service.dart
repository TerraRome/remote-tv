import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import '../constants/storage_keys.dart';

@singleton
final class StorageService {
  late Box _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(StorageKeys.hiveBoxName);
  }

  T? get<T>(String key) => _box.get(key) as T?;

  Future<void> put<T>(String key, T value) => _box.put(key, value);

  Future<void> delete(String key) => _box.delete(key);

  Future<void> clear() => _box.clear();
}
