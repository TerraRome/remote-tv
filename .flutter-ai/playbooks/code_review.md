# Code Review Playbook

## When to Use

Before merging any PR into main.

## Review Checklist

### Structure

- [ ] Feature follows Clean Architecture layers (data → domain → presentation).
- [ ] No presentation imports in data/domain layer.
- [ ] No data layer imports in domain layer.
- [ ] No circular dependencies.

### Dart & Style

- [ ] Code formatted with `dart format .`.
- [ ] No analyzer warnings.
- [ ] Imports ordered correctly.
- [ ] `final` over `var` for unchanged locals.
- [ ] No `dynamic` or bare `Object` types.
- [ ] Prefer expressions over statements where appropriate.

### Bloc

- [ ] Events are Freezed sealed unions.
- [ ] States are Freezed sealed unions with initial/loading/error/data.
- [ ] Bloc delegates to UseCase, not repository directly.
- [ ] Each event has a separate handler method.
- [ ] Errors are caught and emitted as error state.

### Testing

- [ ] UseCase has unit tests covering success + failure.
- [ ] Bloc has tests covering each event → state transition.
- [ ] Repository tests mock both data sources.
- [ ] No test uses real network or database.
- [ ] Coverage meets threshold (≥ 80%).

### DI

- [ ] New classes registered via Injectable annotations.
- [ ] No manual `GetIt.I.register...()` outside injection modules.
- [ ] Scopes correct (singleton vs factory).

### Security

- [ ] No secrets, keys, or tokens in code.
- [ ] Input validation on all user-facing fields.
- [ ] No PII in log statements.

### Performance

- [ ] No unnecessary widget rebuilds (BlocSelector or const constructors).
- [ ] Images cached (cached_network_image).
- [ ] Lists use builders (ListView.builder, GridView.builder).
- [ ] No heavy computation in build methods.
