# Dependency rules

These rules keep architecture boundaries clean.

## Allowed dependencies

- `presentation -> domain`
- `data -> domain`
- `app -> core`
- `app -> features`

## Forbidden dependencies

- `domain -> data`
- `domain -> presentation`
- `core -> features`
- `presentation -> data` (direct concrete dependency) when a domain contract exists

## DI placement

- App-global services in `app/bindings/initial_binding.dart`
- Feature repositories/usecases in feature bindings under `features/*/presentation/bindings`
- Controllers consume usecases/repositories registered in binding

## Import guidance

- Prefer direct imports for concrete types.
- Use focused barrel files (`core_exports`, `vitals_imports`) only when they reduce repetition without hiding boundaries.
- Avoid adding broad catch-all barrel imports in controllers.

## Review checklist

- Does this controller import only presentation/domain concerns?
- Is business decision logic implemented in a use case?
- Is plugin/provider integration behind a repository implementation?
- Is `core` staying independent from feature modules?
