# Freezed Skill

## Purpose

Immutable data classes with generated equality, copyWith, serialization, and union types.

## Model Pattern

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    String? displayName,
    @Default(false) bool isVerified,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

## Union Pattern (State)

```dart
@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.error(String message) = _Error;
}
```

## Union Pattern (Event)

```dart
@freezed
sealed class AuthEvent with _$AuthEvent {
  const factory AuthEvent.login(String email, String password) = _Login;
  const factory AuthEvent.logout() = _Logout;
}
```

## Rules

- `@freezed` on class, `_$ClassName` mixin.
- Factory constructors define fields.
- Use `@Default(value)` for defaults.
- Use `@Assert(...)` for validation (via built_value).
- `fromJson` requires `json_serializable` part file.
- Unions use `sealed` modifier (Dart 3) for exhaustiveness.
- Pattern match with `switch`:

```dart
switch (state) {
  case AuthStateInitial(): // ...
  case AuthStateAuthenticated(:final user): // ...
  case AuthStateError(:final message): // ...
}
```

## Generated Methods

| Method            | Purpose          |
| ----------------- | ---------------- |
| `copyWith(...)`   | Immutable update |
| `==` / `hashCode` | Value equality   |
| `toString()`      | Debug string     |
| `toJson()`        | Serialization    |
| `fromJson()`      | Deserialization  |
