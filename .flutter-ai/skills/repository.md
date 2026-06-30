# Repository Skill

## Purpose

Abstraction layer between data sources and domain. Repository coordinates remote and local data, implements caching strategy, and maps DTOs to entities.

## Interface (Domain)

```dart
abstract class IUserRepository {
  AsyncResult<User> getUser(String id);
  AsyncResult<List<User>> getUsers();
  AsyncResult<void> updateUser(User user);
}
```

- Defined in `domain/repositories/`.
- Methods return `AsyncResult<T>` (typedef for `Future<Result<T>>`).
- Parameters are domain primitives (String, int, domain entities).
- No framework types (no `http.Response`, no `QuerySnapshot`).

## Implementation (Data)

```dart
class UserRepository implements IUserRepository {
  final UserRemoteDataSource _remoteDataSource;
  final UserLocalDataSource _localDataSource;

  UserRepository(this._remoteDataSource, this._localDataSource);

  @override
  AsyncResult<User> getUser(String id) async {
    try {
      final cached = await _localDataSource.getUser(id);
      if (cached != null) return Result.success(cached.toEntity());
      final remote = await _remoteDataSource.getUser(id);
      await _localDataSource.cacheUser(remote);
      return Result.success(remote.toEntity());
    } on DioException catch (e) {
      return Result.failure(NetworkFailure(e.message ?? 'Network error'));
    }
  }
}
```

- Implements domain interface.
- Maps DTO → Entity via `.toEntity()` method.
- Coordinates: check cache → fetch remote → update cache.
- Wraps all errors in `Failure` types.

## Caching Strategy

| Pattern       | Implementation                        |
| ------------- | ------------------------------------- |
| Cache-first   | Read local, sync remote in background |
| Network-first | Fetch remote, fallback to cache       |
| Cache-only    | Read local, never fetch               |
| Remote-only   | Always fetch, never cache             |

Default: **Cache-first** for reads, **Network-first** for writes.

## Testing

- Mock both data sources.
- Test cache hit path (returns cached data).
- Test cache miss path (fetches remote, caches, returns).
- Test error path (network fails → returns Failure).
- Test offline scenario (network fails, cache has data → returns cached).
