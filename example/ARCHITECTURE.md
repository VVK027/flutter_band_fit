# Example app architecture

The example app uses a **feature-first layout** with **Clean Architecture boundaries**.

```
lib/
├── app/                    # Global app shell
│   ├── main.dart
│   ├── bindings/
│   ├── routes/
│   └── theme/
├── core/                   # Shared infrastructure
│   ├── constants/
│   ├── exports/
│   ├── services/
│   ├── utils/
│   └── widgets/            # Barrel: widgets.dart (vital cards, tabs, scaffolds, …)
└── features/
    ├── splash/
    ├── vitals/             # Home + health detail screens
    ├── device/             # Pairing & settings
    ├── profile/
    └── health/             # Apple Health / Google Fit
```

Each feature follows this shape:

- `data/` — repository implementations, models, datasource adapters
- `domain/` — repository interfaces, entities, use cases
- `presentation/` — GetX controllers, bindings, views/widgets

## Dependency direction

Allowed direction only:

- `presentation -> domain`
- `data -> domain`
- `app -> features` and `app -> core`

Not allowed:

- `domain -> data`
- `domain -> presentation`
- `core -> features`
- direct cross-feature access to concrete implementations

See full rules in [docs/architecture/dependency-rules.md](docs/architecture/dependency-rules.md).

## Theming

- `AppTheme.light` / `AppTheme.dark` on `GetMaterialApp`
- `ThemeController` persists mode via GetStorage
- `ThemeToggleButton` on main vitals app bar
- Prefer `Theme.of(context)` and `context.appTheme` over hard-coded colors

## Detail screens (GetX controllers)

Vitals chart/detail pages use a controller + thin view:

| Screen | Controller | Body widget |
|--------|------------|-------------|
| Heart rate | `HeartRateDetailController` | `heart_rate_detail_body.dart` |
| SpO₂ | `OxygenDetailController` | `oxygen_detail_body.dart` |
| Blood pressure | `BloodPressureDetailController` | `blood_pressure_detail_body.dart` |
| Temperature | `TemperatureDetailController` | `temperature_detail_body.dart` |
| Sleep (day/week/month) | `SleepDetailsController` | `sleep_details_body.dart` |
| Activities (steps/cal/distance) | `ActivitiesDetailsController` | `activities_details_body.dart` |
| Activity monitor | `ActivityMonitorController` | `activity_monitor_body.dart` |
| Band reminders | `BandRemindersController` | `band_reminders_body.dart` |
| Do not disturb | `DoNotDisturbController` | `do_not_disturb_body.dart` |
| Weather on band | `WeatherInDetailsController` | `weather_in_details_body.dart` |
| Firmware upgrade | `FirmwareUpgradeController` | `firmware_upgrade_body.dart` |
| Apple/Google bind | `AppleGoogleBindController` | `apple_google_bind_body.dart` |
| Profile update | `ProfileUpdateController` | `profile_update_body.dart` |

Shared mixins: `VitalDetailDateMixin` (day navigation), `BleTestListenerMixin` (BP/SpO₂/temp BLE callbacks).

Charts and stat rows use `Obx` so only the chart/stats rebuild when data changes—not the full scaffold.

## Composition and DI

- App-level shared services are registered in `app/bindings/initial_binding.dart`.
- Feature-level repositories and use cases are registered in feature bindings (for example `vitals_binding.dart`, `device_binding.dart`).
- Controllers should depend on use cases/repositories, not directly on shared service internals when a feature abstraction exists.

## Performance

- `VitalMainController` keeps BLE/sync orchestration out of the widget tree.
- `VitalMainStepsCard`, `VitalMainStatusBanners`, `VitalMainVitalList` reduce rebuild scope.
- `GetBuilder`/`Obx` are used for targeted updates.
- Syncfusion charts are wrapped with `RepaintBoundary` in detail screens.

## Shared widgets (`core/widgets/`)

- `vital_data_widget.dart`, `icon_text_widget.dart`, `dwm_tabs.dart` — vitals home & tabbed details
- `cupertino_button_widget.dart`, `custom_assets_bar.dart` — forms and sleep charts
- `vital_detail_scaffold.dart` — detail page scaffolds (below)

## Shared detail UI (`core/widgets/vital_detail_scaffold.dart`)

- `VitalColoredAppBar` — accent header + theme toggle (HR, BP, SpO2, …)
- `SettingsPageScaffold` — settings/reminders/DND screens
- `DetailDateNavigator` / `DetailActivityHeader` — reused on chart detail pages
- `VitalTabDetailScaffold` — tabbed vitals (activities, sleep, temperature)

## Imports

Use focused barrels and direct imports instead of one mega-export:

| Barrel | Use when |
|--------|----------|
| `core/exports/core_exports.dart` | Flutter + GetX only |
| `common/common_imports.dart` | Band SDK + constants + `GlobalMethods` |
| `core/exports/vitals_imports.dart` | Detail screens with charts + shared widgets |
| Direct imports | Theme, a single widget, or one model |

Avoid importing `widgets.dart` in controllers or services.

## Further documentation

- Docs index: [docs/README.md](docs/README.md)
- Plugin full workflow: [docs/plugin/full-implementation-guide.md](docs/plugin/full-implementation-guide.md)
- Feature template: [docs/architecture/feature-template.md](docs/architecture/feature-template.md)
