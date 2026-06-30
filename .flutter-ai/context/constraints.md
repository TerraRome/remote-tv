# Constraints

## Platform Constraints

- **Minimum Android SDK:** 24 (Android 7.0)
- **Minimum iOS:** 15.0
- **Target Android SDK:** 34 (Android 14)
- **Architectures (Android):** arm64-v8a, armeabi-v7a, x86_64
- **Architectures (iOS):** arm64
- **File size limit:** APK < 150 MB, IPA < 400 MB

## Performance Constraints

- **Frame budget:** 16ms per frame (60fps) on target devices
- **APK size overhead:** < 5 MB for FAW-generated code over baseline Flutter app
- **Cold start:** < 2 seconds on mid-range device (2020+)
- **Network response:** Timeout at 30s, retry 3x with exponential backoff
- **Cache eviction:** LRU for images (max 200 items), Hive stores capped at 50 MB

## Security Constraints

- **No plaintext secrets in code.** Firebase config, API keys via Remote Config or flutter_dotenv.
- **All API calls** over HTTPS with certificate pinning (future).
- **Firestore security rules** enforced on backend. Never trust client data.
- **User auth tokens** stored via Firebase Auth SDK. Never in Hive.
- **Input validation** required on all user-facing text fields.
- **Logging** cannot include PII, tokens, or passwords.

## Architectural Constraints

- **No circular dependencies** between features. Cross-feature communication via domain layer only.
- **No presentation layer** classes in data or domain layers.
- **No data layer** classes in domain layer (DTOs stay in data).
- **Use Cases** must be single-method classes (`call()` or `execute()`).
- **Bloc events** must be immutable (Freezed).
- **Repository interfaces** defined in domain, implementations in data.

## Build Constraints

- **3 flavors:** dev, staging, prod.
- **Versioning:** `{major}.{minor}.{patch}+{buildNumber}` incremented per flavor.
- **CI/CD required** for all deployments. No manual builds for production.
- **Code signing** automated via Fastlane (match/cert).

## Dependency Constraints

- **No `dart:io`** in shared code (platform-independent code).
- **No `package:http`** — use Dio for all HTTP.
- **No random-pinned packages** from pub.dev without security review.
- **Licenses:** Must be MIT, BSD, Apache 2.0, or similar. No GPL/Affero.

## Process Constraints

- **Every feature** must have a plan before coding.
- **Every PR** requires passing code review checklist.
- **Every release** requires passing release checklist.
- **Every dependency update** requires passing dependency_update checklist.
- **Architecture changes** require architect approval.
