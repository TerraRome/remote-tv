# Business Rules

## Identity & Auth

- User identity managed via Firebase Auth.
- Auth state drives app navigation (authenticated vs unauthenticated).
- Session persistence handled by Firebase Auth SDK.
- Anonymous auth allowed for guest users.

## Data Ownership

- User data stored in Firestore under `/users/{userId}`.
- Shared/team data stored under `/teams/{teamId}` with security rules.
- Local cache (Hive) is ephemeral—regenerated from remote on logout.
- Firebase Storage for user-generated content (images, files).

## Monetization

- Ads served via AdMob (banner, interstitial, rewarded).
- Ad visibility controlled by Remote Config flags.
- Premium features gated by entitlement checks (future IAP).
- No ads for authenticated premium users.

## Feature Flags

- Remote Config drives feature rollout.
- Default values baked into app for offline resilience.
- Kill-switch for any feature via Remote Config boolean.

## Offline Behavior

- Read from cache first, sync with remote.
- Writes queue locally if offline, sync on reconnect.
- Conflict resolution: last-write-wins for simple fields, manual merge for complex.

## Analytics & Tracking

- All screen views tracked via Firebase Analytics.
- Custom events for key user actions (sign in, purchase, feature use).
- No PII in events.
- Crashlytics enabled for all non-debug builds.
