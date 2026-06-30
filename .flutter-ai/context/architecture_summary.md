# Architecture Summary

## Clean Architecture Layers

```
data/   → Data Sources, DTOs, Repository Impls
domain/ → Entities, Use Cases, Repository Interfaces
presentation/ → Blocs, Screens, Widgets
core/   → Shared utilities, DI, Theme, Constants
```

## Dependency Rule

- Dependencies point inward: `data` → `domain` → nothing.
- `presentation` depends on `domain` only.
- `data` depends on `domain` only.
- `core` is shared across all layers (no circular deps).

## Data Flow

```
UI → Bloc → UseCase → Repository ← DataSource (remote)
                                        ← DataSource (local)
```

- UI dispatches events to Bloc.
- Bloc calls UseCase.
- UseCase orchestrates business logic via Repository interface.
- Repository delegates to DataSources (Dio remote, Hive local).
- Repository returns domain entities.

## State Management

- Bloc for feature state.
- Cubit for simple state (single screen).
- BlocSelector for granular rebuilds.
- No setState outside widget-local state.

## DI

- GetIt as service locator.
- Injectable for code generation.
- Scoped DI via child GetIt scopes (future).
- Singleton for stateless services, factory for use cases.

## Error Handling

- Sealed union `Result<T>` for success/failure propagation.
- `Either<Failure, T>` for complex flows where caller needs specific type.
- Failure hierarchy: `NetworkFailure`, `CacheFailure`, `AuthFailure`, `UnknownFailure`.
- UI layer maps failures to user-facing messages.

## Feature Structure

```
features/{feature_name}/
  data/
    datasources/
    models/
    repositories/
  domain/
    entities/
    repositories/
    usecases/
  presentation/
    bloc/
    screens/
    widgets/
```

## Navigation

- GoRouter for declarative routing.
- ShellRoute for persistent bottom nav.
- Redirect guards based on auth state.
- Deep link support.

## Configuration

- Firebase Remote Config for runtime config.
- .env (via flutter_dotenv) for build-time secrets.
- Build flavors for environment separation.
