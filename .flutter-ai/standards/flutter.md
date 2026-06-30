# Flutter Development Standards

This document outlines the canonical development standards for Flutter projects within the Flutter AI Workspace (FAW). Adherence to these standards ensures consistency, maintainability, scalability, and high performance across all applications. These guidelines are crucial for both human developers and AI agents, enabling seamless collaboration and automated quality assurance.

## Folder Convention

The `lib/` directory structure adheres to the Clean Architecture principles and a modular, feature-first approach.

```
lib/
├── app/                  # Application bootstrapping, routing, global dependencies
│   ├── app.dart          # Root App Widget (e.g., MaterialApp/CupertinoApp)
│   └── router.dart       # App-wide routing configuration (e.g., GoRouter, Navigator 2.0)
├── core/                 # Cross-cutting concerns, infrastructure, common utilities
│   ├── constants/        # Global constants (strings, dimensions, API keys)
│   ├── di/               # Dependency Injection setup and configuration
│   │   ├── injection.dart    # Main DI setup (GetIt, Injectable config)
│   │   └── modules/          # DI modules for different categories (e.g., firebase_module.dart, package_module.dart)
│   ├── enums/            # Shared enumerations
│   ├── extensions/       # Dart/Flutter extension methods (e.g., ContextExtension)
│   ├── services/         # Global services (e.g., analytics, crashlytics, ads, notification)
│   ├── theme/            # Application theme definitions (colors, text styles, spacing, radius)
│   └── utils/            # Generic utility functions and helpers (e.g., validators, formatters)
├── features/             # Modular features, each a self-contained domain
│   ├── feature_name/     # Example: auth, home, settings, product
│   │   ├── data/             # Data Layer for 'feature_name'
│   │   │   ├── datasources/  # Remote (APIs) and Local (DB, cache) data sources
│   │   │   ├── models/       # Data Transfer Objects (DTOs), usually Freezed
│   │   │   └── repositories/ # Concrete repository implementations
│   │   ├── domain/           # Domain Layer for 'feature_name'
│   │   │   ├── entities/     # Core domain objects, Freezed preferred
│   │   │   ├── repositories/ # Abstract repository interfaces
│   │   │   └── usecases/     # Business logic interactors
│   │   └── presentation/     # Presentation Layer for 'feature_name'
│   │       ├── bloc/         # Bloc/Cubit (events, states, bloc)
│   │       ├── pages/        # Top-level screens/pages
│   │       └── widgets/      # Reusable UI components specific to the feature
│   ├── shared/               # Reusable components, models, and utilities shared across features
│   │   ├── models/           # Shared domain entities or models (e.g., generic User model)
│   │   ├── widgets/          # Generic, highly reusable UI widgets (e.g., AppButton, LoadingIndicator)
│   │   └── validators/       # Reusable input validators
└── main.dart             # Entry point of the Flutter application
```

**Conventions:**

- **Feature First:** New functionality is organized within the `features/` directory. Each sub-directory represents a distinct feature domain.
- **Clean Architecture Layers:** Within each feature, `data/`, `domain/`, and `presentation/` directories explicitly enforce Clean Architecture.
- **Separation of Concerns:** `core/` for cross-cutting, `shared/` for generic reusable components, `app/` for global app setup.
- **Descriptive Naming:** Directory names are clear and reflect their purpose.

## Widget Rules

Flutter widgets are the building blocks of the UI. Adhering to these rules ensures efficient, maintainable, and testable UIs.

1.  **Prefer `StatelessWidget`:** Use `StatelessWidget` by default. Only use `StatefulWidget` when widget's state _truly_ changes over time (e.g., user input, animation state). External state (like Bloc state) should be managed outside the `StatefulWidget` itself, making the widget stateless where possible.
2.  **`const` Widgets:** Use the `const` keyword for widgets and widget properties whenever possible. This optimizes rebuild performance by preventing unnecessary recreation of identical widgets.
3.  **Small, Focused Widgets:** Break down complex UIs into small, single-responsibility widgets. This improves readability, reusability, and testability.
4.  **Widget Trees, Not Helper Methods:** Avoid creating helper methods that return widgets within a `build` method. Instead, extract them into separate `StatelessWidget` or `StatefulWidget` classes. This allows Flutter to optimize rebuilds and provides better debugging information.
    - **Anti-pattern:**
      ```dart
      Widget build(BuildContext context) {
        return Column(
          children: [
            _buildHeader(), // Anti-pattern
            // ...
          ],
        );
      }
      Widget _buildHeader() { /* ... */ }
      ```
    - **Best Practice:**
      ```dart
      Widget build(BuildContext context) {
        return Column(
          children: [
            const HeaderWidget(), // Best practice
            // ...
          ],
        );
      }
      class HeaderWidget extends StatelessWidget { const HeaderWidget({super.key}); /* ... */ }
      ```
5.  **Explicit Keys for Stateful Widgets/Lists:** Provide `Key`s for `StatefulWidget`s and items in dynamic lists (e.g., `ListView.builder`) to preserve state correctly during widget tree changes.
6.  **Avoid Excessive `BuildContext` Capturing:** Do not store `BuildContext` in a `State` object for later use beyond the current `build` cycle, as it can become invalid and lead to errors.
7.  **Separation of UI and Logic:** Widgets should primarily focus on presenting UI. Business logic, data fetching, and state management belong in `Bloc`s, `Use Case`s, or `Repository`s. Widgets should receive data and callbacks, not directly manage complex logic.
8.  **Responsive Design:** Design widgets to be adaptable across different screen sizes and orientations using `MediaQuery`, `LayoutBuilder`, `Flexible`, `Expanded`, and `AspectRatio`.

## State Management (Bloc)

Bloc is the standard state management solution for FAW projects due to its predictability, testability, and clear separation of concerns.

1.  **One Bloc, One Feature/Domain:** Each Bloc should manage the state for a single, well-defined feature or a specific slice of a larger domain. Avoid god-Blocs.
2.  **Explicit Events and States:** Define distinct `Bloc Events` (inputs/actions) and `Bloc States` (outputs/UI conditions). Use `Freezed` for Bloc states to ensure immutability and enable easy equality checks.
3.  **`mapEventToState` (or `on<Event>`) Purity:** Logic within a Bloc's `mapEventToState` (or the new `on<Event>` handlers) should be pure functions of the incoming event and current state, producing a new state. Side effects (e.g., API calls, database operations) must be delegated to `Use Case`s.
4.  **`Cubit` for Simple State:** For very simple state management without complex event handling (e.g., a simple counter, toggle), a `Cubit` can be used instead of a `Bloc`. However, generally prefer Bloc for consistency and scalability.
5.  **`BlocProvider` and `BlocBuilder`:**
    - Use `BlocProvider.value` or `BlocProvider` to provide Blocs to the widget tree.
    - Use `BlocBuilder` to rebuild widgets based on state changes. Utilize `buildWhen` to optimize rebuilds further.
    - Use `BlocListener` for side effects like showing `Snackbars`, navigating, or displaying dialogs, which should not trigger UI rebuilds.
    - Use `BlocConsumer` for widgets that need both `BlocBuilder` and `BlocListener` functionality.
    - Use `BlocSelector` to rebuild widgets only when a specific part of the state changes, for granular control.
6.  **No `BuildContext` in Blocs:** Blocs must never depend on `BuildContext`. This ensures they are testable and UI-agnostic.
7.  **Dependency Injection:** Blocs should receive their dependencies (e.g., `Use Case`s) via constructor injection, managed by `GetIt`/`Injectable`.

## Bloc Convention

### File Structure (`feature_name/presentation/bloc/`)

```
bloc/
├── feature_name_bloc.dart          # Main Bloc class
├── feature_name_event.dart         # All events for the Bloc
└── feature_name_state.dart         # All states for the Bloc (Freezed recommended)
```

### Naming Conventions

- **Bloc Class:** `FeatureNameBloc` (e.g., `AuthBloc`, `ProductBloc`).
- **Event Class:** `FeatureNameEvent` (abstract class), specific events `LoadFeatureName`, `AddFeatureName`, `FeatureNameUpdated` (e.g., `LoadAuth`, `AuthSignedIn`).
- **State Class:** `FeatureNameState` (abstract class), specific states `FeatureNameInitial`, `FeatureNameLoading`, `FeatureNameLoaded`, `FeatureNameError` (e.g., `AuthInitial`, `AuthLoading`, `AuthAuthenticated`, `AuthError`). Use `Freezed` for `FeatureNameState`.

### Example (Auth Bloc)

```dart
// auth_event.dart
part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthUserChanged extends AuthEvent {
  final User? user;
  const AuthUserChanged(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthLogoutRequested extends AuthEvent {}

// auth_state.dart
part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error(String message) = _Error;
}

// auth_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart'; // Example for Freezed
import 'package:injectable/injectable.dart'; // Example for DI

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart'; // Freezed generated file

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase _signInUseCase; // UseCase dependency
  final GetUserUseCase _getUserUseCase; // UseCase dependency

  AuthBloc(this._signInUseCase, this._getUserUseCase) : super(const AuthState.initial()) {
    on<AuthUserChanged>(_onUserChanged);
    on<AuthLogoutRequested>(_onLogoutRequested);
    // ... other event handlers
  }

  void _onUserChanged(AuthUserChanged event, Emitter<AuthState> emit) async {
    if (event.user != null) {
      emit(AuthState.authenticated(event.user!));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  void _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      await _signInUseCase.signOut(); // Delegate to UseCase
      emit(const AuthState.unauthenticated());
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }
}
```

## Naming Convention

Consistent naming improves code readability and discoverability for humans and AI.

- **Files:** `snake_case` (e.g., `user_repository.dart`, `my_widget.dart`).
- **Folders:** `snake_case` (e.g., `auth`, `core`, `utils`).
- **Classes:** `PascalCase` (e.g., `UserRepository`, `MyWidget`, `AuthBloc`, `SignInUseCase`).
- **Enums:** `PascalCase` for type, `camelCase` for values (e.g., `enum ThemeMode { light, dark }`).
- **Variables, Parameters, Functions, Methods:** `camelCase` (e.g., `userName`, `_privateMethod`, `fetchUser`).
- **Constants (compile-time):** `SCREAMING_SNAKE_CASE` for global, top-level constants (`const API_KEY = '...'`). `camelCase` or `PascalCase` for class/local constants.
- **Private Members:** Prefix with `_` (e.g., `_myPrivateField`, `_privateMethod`).
- **Abstract Classes/Interfaces:** Prefix with `I` (e.g., `IAuthRepository`).
- **Freezed Generated Files:** `*.freezed.dart` and `*.g.dart`.

## Error Handling

Robust error handling is critical for production-ready applications.

1.  **Custom Exceptions for Domain Errors:** Define custom exception classes for specific domain errors (e.g., `AuthException`, `NetworkException`). This allows for granular error handling and translation into user-friendly messages.
2.  **`Either` Type for Functional Error Handling:** In the Domain Layer (Use Cases), prefer returning `Either<Failure, Success>` (e.g., from `fpdart` or similar package) to explicitly model potential failure states without relying on `try-catch`. `Failure` classes represent domain-specific error types.
    - **Anti-pattern (Use Case):** `Future<User> signIn(...)` (throws on error)
    - **Best Practice (Use Case):** `Future<Either<AuthFailure, User>> signIn(...)`
3.  **Catching in Data Layer:** Data Sources and Repository Implementations are the primary places to catch infrastructure-level exceptions (e.g., `DioError`, `FirebaseException`, `HiveError`) and map them to domain-specific `Failure` types or custom exceptions.
4.  **Bloc Error State:** Blocs should emit an `Error` state (e.g., `AuthState.error(message)`) when an error occurs, providing a user-friendly message or an error identifier.
5.  **UI Feedback:** Use `BlocListener` to react to error states and display appropriate UI feedback (e.g., `SnackBar`, `AlertDialog`, error messages on input fields).
6.  **Centralized Error Reporting:** Integrate with a crash reporting service (e.g., Firebase Crashlytics) through `core/services/crashlytics_service.dart` to log all unhandled exceptions and significant errors.
7.  **Graceful Degradation:** Design features to degrade gracefully in case of errors (e.g., show cached data, display placeholder UI).

## Logging

Effective logging is crucial for debugging, monitoring, and understanding application behavior in production.

1.  **Use a Dedicated Logging Package:** Employ a structured logging package like `logger` or `flogs`. Do not use `print()` for production code.
2.  **Log Levels:** Utilize appropriate log levels (e.g., `debug`, `info`, `warning`, `error`, `wtf`) to control verbosity and severity.
3.  **Contextual Logging:** Include relevant context in log messages (e.g., user ID, feature name, method name, error details, stack trace).
4.  **Centralized Logging Service:** Abstract logging through a `core/services/logging_service.dart`. This service can then integrate with different log outputs (console, Crashlytics, remote logging solutions) based on the environment (dev/prod).
5.  **Sensitive Data:** NEVER log sensitive user data (passwords, PII, API keys) to prevent security breaches.
6.  **Production Logging:** In production, limit logging to `info`, `warning`, `error` levels, and send them to a remote aggregation service (e.g., Crashlytics, Sentry, ELK stack). Debug logs should be disabled.
7.  **HTTP Request/Response Logging:** For network requests, enable logging of requests and responses (excluding sensitive headers/bodies) in debug builds through Dio interceptors. Disable in production.

## Performance

Performance is a key principle. Implement these guidelines to ensure a fast and fluid application.

1.  **`const` Everywhere Possible:** As mentioned in Widget Rules, using `const` keyword is the simplest and most effective performance optimization. Apply it to widgets, `Text` styles, `EdgeInsets`, `Colors`, etc.
2.  **Minimize Widget Rebuilds:**
    - Use `BlocBuilder` with `buildWhen` to rebuild only when necessary.
    - Use `BlocSelector` to listen to specific parts of the state.
    - Separate large `build` methods into smaller, `const`-capable widgets.
    - Avoid complex calculations directly in `build` methods; move them to `Bloc`s or `Use Case`s.
3.  **Lazy Loading:**
    - Use `ListView.builder`, `GridView.builder`, `PageView.builder` for lists with many items.
    - Implement deferred loading for large feature modules (Flutter's built-in feature).
4.  **Image Optimization:**
    - Use `CachedNetworkImage` for network images.
    - Specify `width` and `height` for `Image` widgets to prevent extra layout passes.
    - Use appropriate image formats (e.g., WebP over PNG for web).
    - Compress images where possible.
5.  **Asynchronous Operations & Isolates:**
    - Use `async`/`await` for I/O-bound operations (network, disk).
    - For CPU-bound operations (heavy computations, JSON parsing of large data), use `compute` to run them in a separate isolate, preventing UI freezes.
6.  **Pre-computation/Caching:**
    - Cache expensive results or frequently accessed data in memory or local storage (Hive).
    - Pre-compute values during app startup if they are needed immediately and are static.
7.  **Profile Regularly:** Use Flutter DevTools to profile application performance (widget rebuilds, GPU/CPU usage, memory) and identify bottlenecks.
8.  **Avoid Unnecessary `setState`:** In `StatefulWidget`s, ensure `setState` is only called when UI needs to update based on internal widget state.
9.  **Efficient Animations:** Limit expensive animations, optimize curves, and use `AnimatedBuilder` to separate animation logic from widget structure.

## Const Usage

The `const` keyword is paramount for Flutter performance and should be used judiciously.

1.  **`const` Constructors:** If a widget or class is immutable (all its fields are `final` and it doesn't depend on mutable state), give it a `const` constructor.
2.  **`const` Widget Instances:** Always use `const` before widget constructors (e.g., `const Text('Hello')`, `const SizedBox(height: 16)`) if the widget and its properties are immutable. This tells Flutter not to rebuild these widgets if their parent rebuilds.
3.  **`const` Collections:** Use `const` for lists, maps, and sets if their contents are known at compile time and will not change.
4.  **`const` Variables:** Declare variables as `const` if their value is a compile-time constant. If a variable's value is known at runtime but will not change after initialization, use `final`.
5.  **Linting:** Enable and adhere to linter rules (e.g., `prefer_const_constructors`, `prefer_const_literals_to_create_immutables`) in `analysis_options.yaml` to enforce `const` usage.

## BuildContext Rules

`BuildContext` is a critical part of Flutter's widget tree but must be used carefully.

1.  **Do Not Store `BuildContext`:** Never store `BuildContext` as a field in a `State` object or any other class. It can become invalid if the widget moves in the tree, leading to crashes.
2.  **`BuildContext` for Direct Access:** Use `BuildContext` to access inherited widgets like `Theme.of(context)`, `MediaQuery.of(context)`, `BlocProvider.of(context)`, or for navigation (`Navigator.of(context)`).
3.  **`mounted` Check:** When performing asynchronous operations that might complete after the widget has been disposed, always check `if (mounted)` before calling `setState` or updating the UI to prevent errors.
4.  **Pass Data, Not Context:** When passing information down the widget tree, prefer passing direct data (e.g., `String name`, `Function onTap`) rather than the `BuildContext` itself.
5.  **Blocs are `BuildContext`-Agnostic:** Blocs (and Cubits) must never take `BuildContext` as a dependency or use it internally. Their logic should be purely business-focused and testable outside the UI.

## Responsive Design

Applications must adapt gracefully to various screen sizes, orientations, and form factors.

1.  **`MediaQuery.of(context)`:** Use `MediaQuery.of(context).size` and `MediaQuery.of(context).orientation` to get screen dimensions and orientation.
    - **Anti-pattern:** Hardcoding pixel values without considering screen size.
    - **Best Practice:** Calculating dimensions relative to screen size: `MediaQuery.of(context).size.width * 0.8`.
2.  **`LayoutBuilder`:** Use `LayoutBuilder` to build different UIs based on the available width/height of a _parent widget_, not the whole screen. Useful for breaking down complex layouts into adaptive components.
3.  **`Flexible` and `Expanded`:** Use these widgets within `Row` and `Column` to distribute space adaptively.
    - `Flexible`: Child can take available space, but not forced to fill it.
    - `Expanded`: Child is forced to fill the available space.
4.  **`AspectRatio`:** Maintain aspect ratios for images or video players.
5.  **`FittedBox`:** Scale and position its child within itself according to its `fit` property. Useful for ensuring text or icons fit without overflowing.
6.  **`SizedBox.expand()`:** Make a widget fill all available space.
7.  **Grid/List Adapters:** Use `GridView.count` or `GridView.extent` with adaptive `crossAxisCount` or `maxCrossAxisExtent` values.
8.  **Adaptive Platforms:** Consider using `Theme.of(context).platform` or `defaultTargetPlatform` to apply platform-specific UI adjustments (e.g., iOS vs. Android dialogs).
9.  **Breakpoints:** Define a set of standard breakpoints (e.g., small, medium, large screens) and create distinct UI layouts for each.

## Code Style

Adherence to a consistent code style is non-negotiable for maintainability and collaboration.

1.  **Dart Effective Style:** Follow the official [Dart Effective Style Guide](https://dart.dev/guides/language/effective-dart) strictly.
2.  **Linting:** Enforce style rules using `analysis_options.yaml`. Include a comprehensive set of lint rules (e.g., `package:flutter_lints/flutter.yaml`) and customize as needed.
    - **Example `analysis_options.yaml` (minimal):**

      ```yaml
      include: package:flutter_lints/flutter.yaml

      linter:
        rules:
          # Prefer to use leading underscores for private members.
          prefer_final_fields: true
          prefer_const_constructors: true
          prefer_const_literals_to_create_immutables: true
          sized_box_for_whitespace: true
          avoid_redundant_argument_values: true
          # Add more specific rules as needed
      ```

3.  **`dart format`:** All code must be formatted using `dart format .` before committing. Integrate this into pre-commit hooks.
4.  **No Trailing Commas in Single-Line Lists:** For single-line lists, maps, or parameter lists, avoid trailing commas. For multi-line, always use trailing commas.
5.  **Blank Lines:** Use blank lines to separate logical blocks of code (e.g., between methods, between properties and methods, within long methods for clarity).
6.  **Comments:**
    - **Doc Comments (`///`):** Use for public APIs (classes, methods, fields) to explain their purpose, parameters, and return values.
    - **Block Comments (`/* ... */`):** For explaining complex algorithms or sections of code.
    - **Line Comments (`//`):** For quick inline explanations.
    - **TODO/FIXME:** Use `// TODO: [description]` and `// FIXME: [description]` for outstanding work or known bugs.
7.  **Import Ordering:** Imports should be ordered automatically by the IDE (or `dart format`), typically:
    - `dart:` imports
    - `package:` imports
    - Relative imports
    - Separated by blank lines.

## Best Practices

General best practices for robust Flutter development.

1.  **Dependency Injection (GetIt/Injectable):** Use a DI framework to manage dependencies. This improves testability, modularity, and reduces boilerplate for constructor injection.
2.  **Immutability (Freezed):** Prefer immutable data models and state objects. Use `Freezed` for data classes to automatically generate boilerplate for equality, hashing, copying, and `toString()`.
3.  **Testing:**
    - **Unit Tests:** For business logic (Use Cases, Blocs, Repositories).
    - **Widget Tests:** For UI components.
    - **Integration Tests:** For testing entire features or application flows.
    - Aim for high code coverage, especially in the Domain layer.
4.  **Error Boundaries:** Use `ErrorWidget.builder` and custom `ErrorBoundary` widgets (if needed) to gracefully handle UI errors and prevent entire app crashes.
5.  **Asynchronous Programming (`async`/`await`, `Future`/`Stream`):** Understand and correctly apply asynchronous patterns. Handle `Futures` and `Streams` carefully to avoid memory leaks or unhandled errors.
6.  **Platform Channels:** When using platform channels for native code integration, minimize calls, batch data, and ensure error handling on both Dart and native sides.
7.  **Theme Management:** Centralize all styling (colors, fonts, spacing, radius) within `core/theme/` and use `Theme.of(context)` to access it. This ensures a consistent look and feel and makes theming easier.
8.  **Firebase Integration:** Follow best practices for Firebase SDK usage: initialize once, use `Stream` for real-time data, handle `null` states.
9.  **Flavor Configuration:** Use Flutter Flavors for environment-specific configurations (API endpoints, keys, app names) to ensure robust deployments to dev, staging, and production.
10. **Accessibility:** Design with accessibility in mind. Use semantic widgets, provide `semanticsLabel` for images, and ensure proper contrast ratios.
11. **Localization:** Plan for internationalization from the start. Use `Intl` package or Flutter's built-in localization features.

## Anti-Patterns

Avoid these common pitfalls in Flutter development.

1.  **God Widgets/God Blocs:** Large, monolithic widgets or blocs that manage too many responsibilities. Break them down into smaller, focused units.
2.  **`BuildContext` in Business Logic:** Passing `BuildContext` into Blocs, Use Cases, or Repositories. Business logic should be independent of the UI tree.
3.  **`setState` in `build` Method:** Calling `setState` directly or indirectly within a `build` method will cause an infinite rebuild loop.
4.  **Hardcoded Values:** Magic strings, numbers, or colors scattered throughout the codebase. Use `core/constants/` and `core/theme/`.
5.  **Ignoring Lint Warnings/Errors:** Lint rules exist for a reason. Ignoring them leads to inconsistent code quality and potential bugs.
6.  **Prop Drilling:** Passing data down through many layers of widgets that don't directly use it. Use `BlocProvider`/`Provider` or `InheritedWidget` for efficient state sharing.
7.  **Unnecessary `StatefulWidget`s:** Creating a `StatefulWidget` when a `StatelessWidget` would suffice (e.g., for data received from a Bloc that the widget just displays).
8.  **Synchronous Expensive Operations on Main Thread:** Performing heavy computations or blocking I/O on the main thread, leading to UI freezes (jank). Use `async`/`await` and `compute`.
9.  **Lack of Error Handling:** Failing to anticipate and gracefully handle errors, leading to crashes or poor user experience.
10. **Directly Using `package:http`:** Prefer `Dio` for network requests due to its interceptors, error handling, and cancellation capabilities.
11. **Deeply Nested Widget Trees without Refactoring:** Extremely deep and complex widget trees become hard to read and maintain. Refactor into smaller, reusable widgets.
12. **Circular Dependencies:** Modules or layers depending on each other directly or indirectly, violating Clean Architecture and making testing difficult.
13. **Ignoring `dispose()`:** For `StatefulWidget`s, `AnimationController`s, `StreamController`s, etc., failing to `dispose()` resources can lead to memory leaks.
14. **Lack of Comments/Documentation:** Undocumented complex logic or APIs make onboarding and maintenance challenging.
15. **Unused Code/Dependencies:** Keep the codebase clean. Remove unused imports, variables, functions, and packages.

## Rules

All future markdown documents generated for the Flutter AI Workspace must adhere to the following rules:

- **Production quality:** Content must be accurate, reliable, and suitable for enterprise-level development.
- **No filler text:** Avoid extraneous language; be concise and direct.
- **No generic AI prompts:** Content should be specific to Flutter development and FAW's context.
- **Actionable:** Provide clear guidance that can be directly implemented or followed.
- **Engineering focused:** Prioritize technical accuracy and practical application.
- **Suitable for enterprise Flutter development:** Align with the needs and expectations of professional Flutter teams.
- **Suitable for AI consumption:** Structured and formatted for easy parsing and understanding by AI agents.
- **Consistent terminology:** Use standardized terms throughout the workspace.
- **Modular:** Design content in independent, reusable units.
- **Easy to maintain:** Ensure documents can be updated efficiently as standards and practices evolve.

Every document must contain the following sections:

- Overview
- Responsibilities
- Rules
- Examples
- Checklist
- Best Practices
- Anti Patterns
- References

## Examples

_(This section will be populated with concrete examples illustrating the application of these Flutter development standards.)_

## Checklist

_(This section will contain checklists for code reviews, architectural validations, and adherence to these Flutter standards.)_

## References

_(This section will link to relevant external resources, Flutter documentation, and related FAW standards documents.)_
