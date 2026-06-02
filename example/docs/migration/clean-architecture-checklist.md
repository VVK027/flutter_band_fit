# Clean architecture checklist

Use this checklist for incremental migrations.

## Per feature

- [ ] `domain/repositories` contract exists for external dependencies
- [ ] business logic extracted into `domain/usecases`
- [ ] `data/repositories/*_impl.dart` created
- [ ] feature binding registers repository + usecases
- [ ] controllers consume usecases/repositories (not shared provider directly)
- [ ] views are thin and avoid service-level dependencies
- [ ] lints pass for touched files

## Global

- [ ] `core` remains feature-agnostic
- [ ] app-level DI only contains global/shared primitives
- [ ] docs updated (`ARCHITECTURE.md`, `docs/*`, and relevant READMEs)
- [ ] behavior parity verified for key flows (connect, sync, settings, profile)

## Suggested regression smoke tests

1. Launch app and open vitals dashboard.
2. Scan/connect device from add device flow.
3. Trigger sync and verify state updates.
4. Open detail screens (HR, sleep, activity, DND).
5. Update profile inputs and verify BMI/status behavior.
