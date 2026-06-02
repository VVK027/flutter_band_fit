# Feature-first clean architecture

This app is organized by feature and layered by responsibility.

## Folder model

```text
lib/
  app/
  core/
  features/
    <feature>/
      data/
      domain/
      presentation/
```

## Layer responsibilities

- `presentation`
  - GetX controllers, route bindings, widgets/views
  - orchestrates UI state and calls use cases
- `domain`
  - entities/value objects
  - repository contracts
  - use case classes
- `data`
  - repository implementations
  - data models + adapters
  - delegates to shared services/plugin APIs

## Current feature coverage

- `vitals`: sync rules/usecases, data repositories, detail controllers split by concern
- `device`: presentation repositories + connection/usecases
- `health`: bind/unbind repository + usecases
- `profile`: BMI usecase and profile settings usecase
- `splash`: simple controller-driven route bootstrap

## Shared layers

- `app/`: app shell, routes, global bindings, theme bootstrap
- `core/`: framework-level shared code (constants, widgets, service wrappers, utility helpers)

`core/` should remain generic and feature-agnostic.
