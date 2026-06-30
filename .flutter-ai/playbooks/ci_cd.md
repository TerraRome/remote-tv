# CI/CD Playbook

## Tools

- **Fastlane** — build automation, code signing, deployment.
- **GitHub Actions** — CI pipeline.
- **Firebase App Distribution** — beta distribution (Android).
- **TestFlight** — beta distribution (iOS).

## Pipeline Stages

```
push → analyze → test → build → distribute → deploy
```

### Analyze (all branches)

- `flutter analyze` — lint check.
- `dart format --set-exit-if-changed .` — formatting check.
- Fail pipeline on any warning/error.

### Test (all branches)

- `flutter test --coverage` — unit + widget tests.
- Upload coverage report to Codecov.
- Fail if coverage drops below threshold.

### Build (main + tags)

- `flutter build apk --flavor {flavor}` — Android.
- `flutter build ios --flavor {flavor}` — iOS (macOS runner).
- Build all flavors: dev, staging, prod.

### Distribute (main only)

- **Dev:** Auto-deploy to Firebase App Distribution (Android) + TestFlight (iOS).
- **Staging:** Manual trigger → Firebase App Distribution + TestFlight.
- **Prod:** Tagged release only → Play Store + App Store.

### Deploy (tagged release only)

- Create GitHub Release with changelog.
- Upload APK/AAB to Play Store via Fastlane.
- Upload IPA to App Store via Fastlane.
- Notify team in Slack.

## Fastlane Setup

```ruby
lane :build_and_distribute do
  match(type: "appstore", readonly: true)
  build_app(
    scheme: "Runner",
    export_method: "app-store",
    configuration: "Release"
  )
  upload_to_app_store(skip_metadata: true, skip_screenshots: true)
end
```

## Secrets Management

- **CI secrets:** GitHub Actions secrets (API keys, cert passwords, Firebase config).
- **Fastlane Match:** Git-based code signing repository (private).
- **Dotenv:** `flutter_dotenv` for runtime env vars (not in repo).

## Quality Gates

- All tests pass.
- Coverage ≥ 80%.
- No analyer warnings.
- Changelog updated.
- Version bumped.
- Architect approval (staging/prod only).
