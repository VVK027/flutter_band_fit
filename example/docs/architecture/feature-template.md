# Feature template

Use this template when creating or refactoring a feature.

## Recommended structure

```text
features/<feature>/
  data/
    repositories/
    models/
    datasources/        # optional
  domain/
    entities/
    repositories/
    usecases/
  presentation/
    bindings/
    controllers/
    views/
    widgets/
```

## Setup steps

1. Define `domain/repositories/*.dart` contracts.
2. Implement `domain/usecases/*.dart` for business actions.
3. Add `data/repositories/*_impl.dart` using plugin/service APIs.
4. Register dependencies in feature binding.
5. Update controllers to call usecases/repositories.
6. Keep views focused on rendering and user interaction.

## Controller guidelines

- Keep controllers orchestration-focused.
- Move reusable decision logic into use cases.
- Keep repetitive UI event handling in private helper methods.
- Preserve backward-compatible behavior while refactoring.

## Data guidelines

- Repository implementation is the adapter boundary.
- Do not expose shared provider internals to presentation.
- Convert raw payloads/models close to the data layer.
