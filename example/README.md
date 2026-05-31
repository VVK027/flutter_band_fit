# flutter_band_fit_example

Reference app for the [flutter_band_fit](../README.md) plugin — pair a UTE smart band, sync vitals, and manage device settings.

## Run

```bash
flutter pub get
flutter run
```

Requires Bluetooth and (on Android 12+) runtime BLE/location permissions.

## Architecture and docs

This example app follows a **feature-first clean architecture** layout.

- High-level overview: [ARCHITECTURE.md](ARCHITECTURE.md)
- Full docs index: [docs/README.md](docs/README.md)
- Dependency boundaries: [docs/architecture/dependency-rules.md](docs/architecture/dependency-rules.md)
- New feature template: [docs/architecture/feature-template.md](docs/architecture/feature-template.md)
- Migration checklist: [docs/migration/clean-architecture-checklist.md](docs/migration/clean-architecture-checklist.md)

## Code layout (quick)

Main flows:

- **Vitals home** — `features/vitals/presentation/views/vital_main.dart` + `VitalMainController`
- **Add device** — `AddDeviceController` + scan list widgets
- **Settings** — `DeviceSettingsController` + large settings view

Top-level folders:

- `lib/app` — app bootstrap, root bindings, routes, theme
- `lib/core` — shared framework-level utilities/widgets/services
- `lib/features` — feature modules (`device`, `vitals`, `health`, `profile`, `splash`)
