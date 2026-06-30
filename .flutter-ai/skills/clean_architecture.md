# Clean Architecture Skill

## Layer Definitions

### Domain Layer (innermost)

- **Entities:** Plain Dart objects representing business concepts. No annotations, no serialization.
- **Repository Interfaces:** Abstract classes defining data contracts. No implementation details.
- **Use Cases:** Single-responsibility classes with `call()` method. Dependency-injected repository interfaces.
- **Failures:** Sealed failure classes extending base `Failure`.

### Data Layer

- **Repository Implementations:** Implement domain repository interfaces. Coordinate remote + local data sources.
- **Data Sources:** Remote (Dio), Local (Hive). Return raw DTOs or models.
- **DTOs/Models:** Freezed classes with JSON serialization. Mapped to domain entities before crossing layer boundary.
- **Data Source:** Pure I/O, no business logic.

### Presentation Layer

- **Blocs/Cubits:** State management. Inject use cases. Emit states as sealed classes.
- **Screens:** StatelessWidgets where possible. Constrained rebuilds via BlocSelector.
- **Widgets:** Reusable, testable components. Receive data via constructor params.

## Mapping Rules

- **DTO → Entity:** Repository implementation handles mapping. Entity has no framework dependency.
- **DTO ← API response:** DataSource returns DTO. Repository maps to Entity.
- **Entity → UI state:** Bloc converts Entity to presentation state (may subset fields).

## Dependency Injection Registration

| Component       | Register As | Scope   |
| --------------- | ----------- | ------- |
| DataSources     | Factory     | Request |
| Repository Impl | Singleton   | App     |
| UseCase         | Factory     | Feature |
| Bloc            | Factory     | Feature |

## Testing Strategy

- **Domain:** Pure unit tests. No mocks for entities; mock repository interfaces.
- **Data:** Test repository implementations with mock data sources.
- **Presentation:** Test bloc behavior with mock use cases. Widget tests with mock blocs.

## File Organization

```
lib/
├── core/          # Shared across layers
├── features/
│   └── {feature}/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/  # interfaces
│       │   └── usecases/
│       └── presentation/
│           ├── bloc/
│           ├── screens/
│           └── widgets/
```
