# Bloc Skill

## Structure

```
bloc/
├── {feature}_bloc.dart       # Bloc class
├── {feature}_event.dart      # Events (Freezed sealed class)
├── {feature}_state.dart      # States (Freezed sealed class)
```

## Event Design

- Events represent user actions or system triggers.
- One event class per distinct action.
- Events are Freezed unions with `const` constructors.
- Events may carry payload (IDs, data).

```dart
@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.login(String email, String password) = _Login;
  const factory AuthEvent.logout() = _Logout;
  const factory AuthEvent.checkSession() = _CheckSession;
}
```

## State Design

- States represent a single screen state at a point in time.
- States are Freezed unions with `initial` as default.
- Include loading/error/data variants.

```dart
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.unauthenticated(String? message) = _Unauthenticated;
  const factory AuthState.error(String message) = _Error;
}
```

## Bloc Rules

- Inject use cases, not repositories or data sources.
- Use `on<Event>` inside constructor for event handling.
- Each event handler is a separate method (no inline logic).
- Call `emit()` for state changes.
- Handle errors in event handlers; emit error state.
- No business logic in Bloc—delegate to UseCase.

```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;

  AuthBloc({required LoginUseCase loginUseCase})
      : _loginUseCase = loginUseCase,
        super(const AuthState.initial()) {
    on<AuthEvent.login>(_onLogin);
  }

  Future<void> _onLogin(
    AuthEvent.login event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }
}
```

## Cubit (for simple state)

- Use Cubit when only 1-2 methods and no event complexity.
- Cubit state still uses Freezed sealed class.
- Call methods directly instead of dispatching events.

## Testing

- Test each event handler.
- Test initial state.
- Test error paths.
- Use `blocTest` for declarative assertions.
- Mock use cases with mocktail.

```dart
blocTest<AuthBloc, AuthState>(
  'emits [Loading, Authenticated] when login succeeds',
  build: () => AuthBloc(loginUseCase: mockLoginUseCase),
  act: (bloc) => bloc.add(const AuthEvent.login('test@test.com', 'pass')),
  expect: () => [
    const AuthState.loading(),
    const AuthState.authenticated(User(id: '1', email: 'test@test.com')),
  ],
);
```
