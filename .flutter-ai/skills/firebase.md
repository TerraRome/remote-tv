# Firebase Skill

## Project Setup

- Single Firebase project per app. Environments via separate GCP projects.
- `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) in `.gitignore`.
- Download configs via Firebase Console per flavor.
- Initialize in `main()` before `runApp()`.

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}
```

## Services

| Service       | Use                           | Package                  |
| ------------- | ----------------------------- | ------------------------ |
| Firestore     | Primary database              | `cloud_firestore`        |
| Auth          | User authentication           | `firebase_auth`          |
| Storage       | File uploads                  | `firebase_storage`       |
| Crashlytics   | Error reporting               | `firebase_crashlytics`   |
| Analytics     | Usage tracking                | `firebase_analytics`     |
| Remote Config | Feature flags, runtime config | `firebase_remote_config` |

## Firestore Rules

- Validate data structure on write.
- Enforce auth checks.
- No client-side security logic—rules are source of truth.

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /public/{doc} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

## Firestore Queries

- Use `FieldPath` for nested field queries.
- Limit results client-side (`limit()`, `orderBy()`).
- Paginate with `startAfterDocument`.
- Listen with `.snapshots()` for real-time.
- Batch writes for atomic operations.

```dart
Future<List<UserDTO>> getUsers() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .orderBy('createdAt', descending: true)
      .limit(20)
      .get();
  return snapshot.docs.map((doc) => UserDTO.fromFirestore(doc)).toList();
}
```

## Auth

- Listen to `authStateChanges()` for session.
- Store minimal user data in Firestore; auth profile in Firebase Auth.
- Handle token refresh automatically (Firebase SDK).
- Map `User` (firebase_auth) to domain entity in repository.

## Crashlytics

- Enable in production only (or all flavors except debug).
- Log custom keys for debugging.
- Catch and report errors in Bloc error handlers.

```dart
await FirebaseCrashlytics.instance.recordError(error, stackTrace);
```
