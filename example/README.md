# flutter_band_fit_example

Reference application for the [flutter_band_fit](../README.md) plugin — pair a UTE smart band (native **UTE SDK = GloryFit SDK**), sync vitals, and manage device settings.

This package is the **full implementation** of plugin usage (not a minimal stub). Copy patterns from `lib/features/` and `lib/core/services/activity_service_provider.dart` into your own app.

## Run

```bash
flutter pub get
flutter run
```

Requires Bluetooth and (on Android 12+) runtime BLE/location permissions.

## Documentation

| Topic | Link |
| ----- | ---- |
| Docs index | [docs/README.md](docs/README.md) |
| Full workflow + example map | [docs/plugin/full-implementation-guide.md](docs/plugin/full-implementation-guide.md) |
| Integration steps | [docs/plugin/plugin-integration-guide.md](docs/plugin/plugin-integration-guide.md) |
| API reference | [docs/plugin/plugin-api-workflow.md](docs/plugin/plugin-api-workflow.md) |
| App architecture | [ARCHITECTURE.md](ARCHITECTURE.md) |

## Code layout (quick)

Main flows:

- **Vitals home** — `features/vitals/presentation/views/vital_main.dart` + `VitalMainController`
- **Add device** — `AddDeviceController` + scan list widgets
- **Settings** — `DeviceSettingsController` + device settings views

Top-level folders:

- `lib/app` — bootstrap, bindings, routes, theme
- `lib/core` — shared services (including `activity_service_provider.dart`)
- `lib/features` — `device`, `vitals`, `health`, `profile`, `splash`
