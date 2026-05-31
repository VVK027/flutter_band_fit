# flutter_band_fit

Flutter plugin for **UTE smart band / fitness watch** connectivity on Android and iOS. It wraps the native UTE SDK (BLE pairing, sync, vitals, dial faces, firmware, weather, and device settings) and exposes a Dart API for host apps.

## Features

- Scan, pair, connect, and disconnect BLE band devices
- Sync steps, sleep, heart rate, blood pressure, SpO₂, temperature, and related history
- Device settings: goals, DND, reminders, 24h monitoring toggles, find band, reset
- Optional Apple Health / Google Fit path in the example app
- Event stream for connection state, sync progress, and SDK callbacks

## Requirements

- Flutter **≥ 3.24**, Dart **≥ 3.5**
- **Android**: `minSdk 26`, Bluetooth permissions (runtime on API 31+)
- **iOS**: Xcode project with `UTESmartBandApi` framework (included under `ios/`)

## Installation

Add to your app `pubspec.yaml`:

```yaml
dependencies:
  flutter_band_fit:
    path: ../flutter_band_fit   # or your published source
```

### Android

The plugin uses `com.vvk.flutter_band_fit` and bundles `ute_sdk` (AAR). Ensure your app manifest merges BLE/location permissions as required by your target SDK.

### iOS

Register the plugin in your `Podfile` / Flutter iOS project like any federated plugin; the native `FlutterBandFitPlugin` bridges to `UTESmartBandApi`.

## Usage

```dart
import 'package:flutter_band_fit/flutter_band_fit.dart';

final band = FlutterBandFit();

// 1) Initialize BLE stack
await band.initializeDeviceConnection();

// 2) Register listeners while the feature is active
band.receiveEventListeners(
  onData: (data) {},
  onError: (error) {},
);

// 3) Connect and run operations
final connected = await band.checkConnectionStatus();
if (connected) {
  await band.syncStepsData();
}

// 4) Cleanup listeners when done
band.dispose();
```

Constants and method names align with the native SDK (`BandFitConstants`, device events, sync operations). See `lib/src/util/band_fit_constants.dart` and the **example** app for full flows.

## API lifecycle best practices

- Keep a single `FlutterBandFit` instance for the app/session.
- Register listeners only while the related UI flow is active:
  - `receiveEventListeners(...)`
  - `receiveBPListeners(...)`
- On screen/service teardown, release listeners with either:
  - `cancelEventListeners()` and `cancelBPListeners()`, or
  - `dispose()` to cancel both subscriptions.
- Prefer `checkConnectionStatus()` before sync/fetch/test calls.
  - `checkConectionStatus()` is still supported for backward compatibility.
- Treat platform results as runtime values:
  - String methods usually return status constants (`success`, `failure`, `disconnected`, `canceled`, `initiated`)
  - Map methods return parsed payloads and may return empty maps on invalid/empty data.

## API workflow reference

- Full plugin method grouping and operation flow:
  - `example/docs/plugin/plugin-api-workflow.md`
- Integration and lifecycle guide:
  - `example/docs/plugin/plugin-integration-guide.md`
- Optimization and maintenance checklist:
  - `example/docs/plugin/plugin-optimization-maintenance.md`

## Example app

The `example/` package (`flutter_band_fit_app`) is a reference UI built with **GetX**:

| Area | Path |
| ---- | ---- |
| Entry | `example/lib/main.dart` → `app/main.dart` |
| Routes | `example/lib/app/routes/` |
| BLE / sync state | `example/lib/core/services/activity_service_provider.dart` |
| Features | `example/lib/features/` (splash, vitals, device, profile, health) |

Run:

```bash
cd example
flutter pub get
flutter run
```

Architecture and import conventions: [example/ARCHITECTURE.md](example/ARCHITECTURE.md).

## Project layout

```text
lib/                    # Plugin Dart API (public)
android/                # Android library + ute_sdk
ios/                    # iOS plugin + UTESmartBandApi.framework
example/                # Demo application
```

## License

See repository license terms. UTE SDK binaries (`ute_sdk.aar`, iOS framework) are third-party artifacts—confirm redistribution rights for your product.
