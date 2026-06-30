# Dependency Injection Skill

## Stack

- **GetIt** — service locator (runtime).
- **Injectable** — code-gen for registration (build time).

## Registration Rules

| Component       | Register As | Scope   | Injectable Annotations            |
| --------------- | ----------- | ------- | --------------------------------- |
| DataSource      | Factory     | Request | `@singleton` or `@factoryParam`   |
| Repository Impl | Singleton   | App     | `@Singleton(as: IUserRepository)` |
| UseCase         | Factory     | Feature | `@singleton`                      |
| Bloc            | Factory     | Feature | `@factoryParam`                   |
| Dio             | Singleton   | App     | `@module`                         |
| Hive            | Singleton   | App     | `@module`                         |

## Module Example

```dart
@module
abstract class NetworkModule {
  @singleton
  Dio get dio => Dio(BaseOptions(baseUrl: 'https://api.example.com'));
}

@module
abstract class StorageModule {
  @preResolve
  @singleton
  Future<HiveInterface> get hive async => Hive;
}
```

## Feature Registration

```dart
@singleton
class UserRepository implements IUserRepository {
  // ...
}

@singleton
class GetUsersUseCase {
  final IUserRepository _repository;
  GetUsersUseCase(this._repository);
}
```

## Init

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureInjection(Environment.prod);
  runApp(const App());
}
```

## Testing with GetIt

- Reset GetIt between tests: `GetIt.I.reset()`.
- Register mocks in test `setUp`:

```dart
setUp(() {
  GetIt.I.registerSingleton<IUserRepository>(MockUserRepository());
});
tearDown(() {
  GetIt.I.reset();
});
```

## Lazy vs Eager

- **Eager:** Firebase, Dio — register as `@singleton` (eager by default).
- **Lazy:** UseCases — register as `@singleton` will be lazy (resolved on first injection).
- **Factory:** Blocs — always factory to get fresh instance per navigation.
