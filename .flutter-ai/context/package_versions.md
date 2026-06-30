# Package Versions

## Pin Strategy

- Major.minor pinned. Patch free (`^`).
- `pubspec.lock` committed for reproducible builds.
- Dependencies reviewed quarterly for upgrades.

## Core

| Package      | Pinned Version | Notes             |
| ------------ | -------------- | ----------------- |
| flutter      | ^3.24.x        | SDK constraint    |
| dart         | ^3.5.x         | SDK constraint    |
| flutter_bloc | ^8.1.x         | State management  |
| bloc         | ^8.1.x         | Core bloc package |
| equatable    | ^2.0.x         | Value equality    |

## Data Layer

| Package          | Pinned Version | Notes           |
| ---------------- | -------------- | --------------- |
| dio              | ^5.4.x         | HTTP client     |
| hive             | ^2.2.x         | Local storage   |
| hive_flutter     | ^1.1.x         | Flutter adapter |
| cloud_firestore  | ^5.x.x         | Firestore SDK   |
| firebase_storage | ^12.x.x        | Storage SDK     |
| firebase_auth    | ^5.x.x         | Auth SDK        |

## DI & Code Gen

| Package              | Pinned Version | Notes              |
| -------------------- | -------------- | ------------------ |
| get_it               | ^7.7.x         | Service locator    |
| injectable           | ^2.4.x         | DI code gen        |
| injectable_generator | ^2.6.x         | dev_dependency     |
| freezed_annotation   | ^2.4.x         | Immutable models   |
| freezed              | ^2.5.x         | dev_dependency     |
| json_annotation      | ^4.9.x         | JSON serialization |
| json_serializable    | ^6.8.x         | dev_dependency     |
| build_runner         | ^2.4.x         | dev_dependency     |

## Services

| Package                | Pinned Version | Notes           |
| ---------------------- | -------------- | --------------- |
| firebase_core          | ^3.x.x         | Core Firebase   |
| firebase_crashlytics   | ^4.x.x         | Error reporting |
| firebase_analytics     | ^11.x.x        | Analytics       |
| firebase_remote_config | ^5.x.x         | Feature flags   |
| google_mobile_ads      | ^5.x.x         | AdMob           |

## Utilities

| Package              | Pinned Version | Notes             |
| -------------------- | -------------- | ----------------- |
| go_router            | ^14.x.x        | Navigation        |
| flutter_dotenv       | ^5.1.x         | Env vars          |
| logger               | ^2.4.x         | Logging           |
| intl                 | ^0.19.x        | i18n, formatting  |
| shimmer              | ^3.0.x         | Loading skeletons |
| cached_network_image | ^3.4.x         | Image caching     |

## Testing

| Package          | Pinned Version | Notes          |
| ---------------- | -------------- | -------------- |
| flutter_test     | SDK constraint | dev_dependency |
| bloc_test        | ^9.1.x         | dev_dependency |
| mocktail         | ^1.0.x         | dev_dependency |
| integration_test | SDK constraint | dev_dependency |
