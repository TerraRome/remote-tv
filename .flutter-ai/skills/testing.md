# Testing Skill

## Test Types

| Type            | Scope                                    | Tools                                   | Location               |
| --------------- | ---------------------------------------- | --------------------------------------- | ---------------------- |
| **Unit**        | Single class (UseCase, Bloc, Repository) | `flutter_test`, `mocktail`, `bloc_test` | `test/` mirrors `lib/` |
| **Widget**      | Single widget + interaction              | `flutter_test`, `WidgetTester`          | `test/` mirrors `lib/` |
| **Integration** | Feature flow (UI → API → DB)             | `integration_test`                      | `integration_test/`    |

## File Organization

```
test/
├── core/
├── features/
│   └── {feature}/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   └── usecases/
│       └── presentation/
│           └── bloc/
```

## Naming

- File: `{test_target}_test.dart`
- Group: `{Class name}` — describes scenario
- Test: `'emits [State] when [action]'`

```dart
group('AuthBloc', () {
  blocTest<AuthBloc, AuthState>(
    'emits [Loading, Authenticated] when login succeeds',
    ...
  );
});
```

## Coverage Requirements

- **Domain (entities, use cases):** 100% line coverage.
- **Blocs:** Cover every event + every state transition.
- **Repositories:** Cover cache hit, cache miss, network error, offline.
- **DataSources:** Cover success, error, timeout.
- **Screens:** Cover happy path + error display.

## Mocking Rules

- Mock repository interfaces, not implementations.
- Mock data sources in repository tests.
- Use `mocktail` over `mockito` (no codegen).
- Register fallback values for non-nullable params.

```dart
class MockUserRepository extends Mock implements IUserRepository {}
```

## Golden Tests (Widget)

- Use `matchesGoldenFile` for visual regression.
- Keep golden images in `test/goldens/`.
- Goldens committed to repo.
- Update with `--update-goldens` flag.
