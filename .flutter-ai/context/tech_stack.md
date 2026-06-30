# Tech Stack

## Core

| Technology         | Version | Purpose                     |
| ------------------ | ------- | --------------------------- |
| Flutter            | ^3.24   | Cross-platform UI framework |
| Dart               | ^3.5    | Programming language        |
| Bloc               | ^8.x    | State management            |
| Clean Architecture | N/A     | Project structure pattern   |

## Data Layer

| Technology         | Purpose                          |
| ------------------ | -------------------------------- |
| Dio                | HTTP client, interceptors, retry |
| Hive               | Local NoSQL storage, caching     |
| Firebase Firestore | Remote real-time database        |
| Firebase Storage   | File/asset storage               |
| Firebase Auth      | Authentication                   |

## DI & Code Generation

| Technology       | Purpose                          |
| ---------------- | -------------------------------- |
| GetIt            | Service locator                  |
| Injectable       | Code-gen DI setup                |
| Freezed          | Immutable models, sealed classes |
| JsonSerializable | JSON serialization               |

## Services

| Technology             | Purpose                          |
| ---------------------- | -------------------------------- |
| Firebase Crashlytics   | Error reporting                  |
| Firebase Analytics     | Event tracking                   |
| Firebase Remote Config | Feature flags                    |
| AdMob                  | Banner/interstitial/rewarded ads |
| Google Play Billing    | In-app purchases (future)        |

## Build & CI/CD

| Tool            | Purpose                        |
| --------------- | ------------------------------ |
| Flutter Flavors | Dev/staging/prod environments  |
| Fastlane        | Build automation, code signing |
| GitHub Actions  | CI/CD pipelines                |
| CodeMagic       | Alternative CI/CD (optional)   |

## Dev Tools

| Tool             | Purpose                                |
| ---------------- | -------------------------------------- |
| Flutter DevTools | Performance, memory, network profiling |
| Dart Analyze     | Static analysis                        |
| melos            | Monorepo management (future)           |
| build_runner     | Code generation runner                 |

## Native Bridge

| Platform | Approach                               |
| -------- | -------------------------------------- |
| Android  | Kotlin, MethodChannel, Pigeon (future) |
| iOS      | Swift, MethodChannel, Pigeon (future)  |

## Testing

| Framework        | Purpose             |
| ---------------- | ------------------- |
| flutter_test     | Widget & unit tests |
| bloc_test        | Bloc unit tests     |
| mocktail         | Mocking             |
| integration_test | Integration tests   |

## Analysis & Linting

| Package       | Purpose                              |
| ------------- | ------------------------------------ |
| flutter_lints | Baseline lint rules                  |
| custom_lint   | Project-specific lint rules (future) |

## Monitoring & Debugging

| Tool    | Purpose                         |
| ------- | ------------------------------- |
| Sentry  | Performance monitoring (future) |
| Datadog | APM (future)                    |
| logger  | Structured logging              |
