# New Feature Playbook

## When to Use

Adding a new feature (screen, API integration, business capability) to the app.

## Steps

### Phase 1: Plan

- [ ] Open `planning/planner.md` and follow its process.
- [ ] File a new planning document in `planning/{feature_name}.md` with:
  - Feature scope and acceptance criteria.
  - Data model changes (entities, DTOs, Firestore docs).
  - API endpoints needed (method, path, request/response).
  - Screen wireframes (text description or links to Figma).
  - Bloc event/state definitions.
- [ ] Architect reviews plan.

### Phase 2: Scaffold

- [ ] Run `flutter create` feature structure under `lib/features/{feature_name}/`.
  ```
  data/datasources/
  data/models/
  data/repositories/
  domain/entities/
  domain/repositories/  (interface only)
  domain/usecases/
  presentation/bloc/
  presentation/screens/
  presentation/widgets/
  ```
- [ ] Register DI: add Injectable annotations to new classes.
- [ ] Run `dart run build_runner build --delete-conflicting-outputs`.
- [ ] Verify no compile errors.

### Phase 3: Data Layer

- [ ] Define DTOs (Freezed models with `fromJson`/`toJson`).
- [ ] Implement remote data source (Dio calls or Firestore queries).
- [ ] Implement local data source (Hive boxes).
- [ ] Implement repository (implements domain interface).
- [ ] Write repository tests (mock both data sources).
- [ ] Verify all tests pass.

### Phase 4: Domain Layer

- [ ] Define entities (plain Dart objects, no serialization).
- [ ] Define repository interface in domain.
- [ ] Implement use case(s).
- [ ] Write use case unit tests (mock repository interface).
- [ ] Verify all tests pass.

### Phase 5: Presentation Layer

- [ ] Define Bloc events (Freezed sealed union).
- [ ] Define Bloc states (Freezed sealed union).
- [ ] Implement Bloc (inject use case, handle events).
- [ ] Write Bloc tests (mock use case, cover all event→state transitions).
- [ ] Build screen widget (StatelessWidget, no business logic).
- [ ] Build sub-widgets (reusable, constructor-injected data).
- [ ] Add screen to GoRouter.
- [ ] Verify screen renders in app.

### Phase 6: Integration

- [ ] Connect screen to real data sources (not mocks).
- [ ] Test full flow: launch app → navigate → interact → see data.
- [ ] Test error states: no network, empty data, server error.
- [ ] Test offline: cached data displays without network.
- [ ] Run `dart format .` and fix any formatting issues.
- [ ] Run `flutter analyze` and fix all warnings/errors.

### Phase 7: Review & Submit

- [ ] Open PR with description referencing planning doc.
- [ ] Run code review checklist (see `checklists/code_review.md`).
- [ ] Address all review comments.
- [ ] Merge to main branch.

### Phase 8: Verify

- [ ] Deploy to staging via CI/CD.
- [ ] Run integration tests on staging.
- [ ] Verify analytics events fire correctly.
- [ ] Verify Crashlytics shows no new errors.
- [ ] Mark feature as complete.
