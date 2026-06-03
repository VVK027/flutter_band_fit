# Full implementation guide

End-to-end reference for integrating `flutter_band_fit` and mirroring the **example app** (`flutter_band_fit_app`). Use this document for overall workflow; use the linked guides for API grouping and step-by-step integration.

## What this plugin is

- **UTE smart band / fitness watch** connectivity via BLE on Android and iOS.
- Native stacks use the **UTE SDK**, which is the same family as the **GloryFit SDK** (vendor naming differs by platform/build, but capabilities align: scan, bind, sync, vitals, dial, firmware, settings).
- **Goal of the plugin:** one Dart API and method/event channels so Flutter apps do not duplicate separate Android and iOS SDK integrations.

## Layered architecture

```text
Your Flutter app
    └── FlutterBandFit (Dart singleton, lib/)
            ├── MethodChannel  → Android: FlutterBandFitPlugin + ute_sdk (AAR)
            │                  → iOS: FlutterBandFitPlugin + UTESmartBandApi.framework
            ├── EventChannel   → connection / sync / SDK callbacks
            └── EventChannel   → blood-pressure test stream
```

The **example app** adds clean-architecture boundaries on top of the plugin:

| Layer | Role | Example location |
| ----- | ---- | ---------------- |
| Plugin API | BLE + sync + settings | `package:flutter_band_fit` |
| Shared service | Wraps plugin, persistence, sync orchestration | `example/lib/core/services/activity_service_provider.dart` |
| Feature repositories | Feature-specific plugin calls | `example/lib/features/*/data/repositories/` |
| Controllers / UI | GetX flows | `example/lib/features/*/presentation/` |

**Reference implementation:** all production-style flows (pair, reconnect, vitals home, detail charts, device settings, dial, firmware, health export) live under `example/lib/`. Start from `example/lib/main.dart` → `app/main.dart`.

## Overall runtime workflow

### Phase 1 — Bootstrap (once per session)

1. Create a single `FlutterBandFit()` instance (factory singleton).
2. Request platform permissions (BLE; on Android 12+ also `BLUETOOTH_SCAN` / `BLUETOOTH_CONNECT` and location as required by your OS version).
3. Call `initializeDeviceConnection()`.
4. Branch on result (`BandFitConstants` / string status):
   - `initiated` — proceed.
   - `bleNotSupported` — device cannot use required BLE; stop or degrade UI.
   - `bleNotEnabled` / `canceled` — prompt user to enable Bluetooth or grant permissions.
5. Register `receiveEventListeners(...)` (and `receiveBPListeners(...)` only during BP test UI).

Example: `AddDeviceController.initialize()` and `VitalMainController` permission + init paths.

### Phase 2 — Discovery

1. `startSearchingDevices()` → `List<BandDeviceModel>`.
2. Show list in UI; call `stopSearchingDevices()` when leaving scan UI.
3. If the list is empty, show a “no devices” state (bands must be advertising and in pairing mode).

Example: `ScanDevicesUseCase` → `DevicePresentationRepositoryImpl` → `ActivityServiceProvider.startSearchingDevices()`.

### Phase 3 — Connection

1. Fresh pair: `connectDevice(device)`.
2. Known MAC/UUID: `reConnectDevice(device)` or `connectLastDeviceAddress()` after `getLastConnectedDeviceAddress()`.
3. Listen on the event stream for `DEVICE_CONNECTED`, `SYNC_TIME_OK`, battery/version payloads.
4. On success: `setUserParameters`, 24h monitoring toggles, language, optional DND/weather/call reject.
5. Verify with `checkConnectionStatus()` before sync or tests.

Example: `AddDeviceController.addDeviceListener()` handles connection events; `updateDeviceConnection()` persists device and fetches version/battery.

### Phase 4 — Sync and local data

Typical order after connect (example vitals home):

1. `syncStepsData()`, `syncSleepData()`, `syncRateData()`, … as needed.
2. `fetchOverAllDeviceData()` or per-date `fetchStepsByDate(date)`, etc.
3. Parse maps in a repository layer; treat empty maps as decode failure or no data.

Example: `ActivityServiceProvider` sync helpers and `VitalMainController` / detail controllers.

### Phase 5 — Real-time tests and teardown

- BP / SpO₂ / temperature tests: `startBloodPressure()` / `stopBloodPressure()`, etc., plus `receiveBPListeners`.
- On route dispose or app background: `pauseEventListeners()` / `resumeEventListeners()` as needed.
- On feature exit: `cancelEventListeners()`, `cancelBPListeners()`, or `dispose()` on the plugin instance.

## Native SDK ↔ Flutter API map

The vendor BLE flow (initialize → BLE support → listener → BT on → scan → connect) maps to Dart as follows:

| Native concept (UTE / GloryFit) | Flutter plugin |
| ------------------------------- | -------------- |
| Service instance / bind | `FlutterBandFit()` singleton |
| `isSupportBle4_0()` | `initializeDeviceConnection()` → `bleNotSupported` |
| Set scan listener | `receiveEventListeners(...)` |
| `isBleEnabled()` | init result `bleNotEnabled` / OS permission flow in app |
| `startLeScan` / `stopLeScan` | `startSearchingDevices()` / `stopSearchingDevices()` |
| Scan callback list | `List<BandDeviceModel>` |
| `connect(address)` | `connectDevice` / `reConnectDevice` / `connectLastDeviceAddress` |
| Connection state | Event stream + `checkConnectionStatus()` |

## Example app flow index

| User flow | Entry | Key plugin touchpoints |
| --------- | ----- | ---------------------- |
| First launch / splash | `features/splash` | Routing only |
| Add device / scan | `AddDeviceController` | `initializeDeviceConnection`, `startSearchingDevices`, `connectDevice`, events |
| Vitals dashboard | `VitalMainController` | Reconnect, sync all, `receiveEventListeners` |
| HR / sleep / steps details | `features/vitals/presentation/controllers/*` | `fetch*ByDate`, charts from stored sync data |
| Device settings | `DeviceSettingsController` | Version, battery, reconnect use cases |
| Dial face | `DialFaceDetailsController` | `checkDialSupport`, `sendOnlineDialPath`, progress events |
| Profile / BMI | `features/profile` | `setUserParameters` via provider |
| Apple Health / Google Fit | `features/health` | Platform health APIs (not plugin) |

## Response handling

- **Strings:** `success`, `failure`, `initiated`, `disconnected`, `canceled`, `bleNotSupported`, `bleNotEnabled`, etc. — see `BandFitConstants`.
- **Maps:** JSON from native code; plugin decodes to `Map<String, dynamic>` (empty map on failure).
- **Status-wrapped maps:** `{ "status": "...", "data": ... }` for some operations.

Keep parsing in one place per app (example: `JsonUtils`, repository `_decodeMap` patterns).

## Platform notes

### Android

- Plugin package: `com.vvk.flutter_band_fit`, bundled `ute_sdk` AAR.
- `minSdk 26`; runtime BLE permissions on API 31+.
- `getAndroidDeviceSDKIntVersion()` helps branch permission sets.

### iOS

- `UTESmartBandApi.framework` under `ios/`.
- Request Bluetooth usage descriptions in `Info.plist` (example app already documents patterns).

### macOS

- Plugin registers for macOS; example target may be used for development — confirm BLE support before shipping a macOS product.

## Related documents

- [Plugin integration guide](plugin-integration-guide.md) — safe integration sequence for new apps.
- [Plugin API workflow reference](plugin-api-workflow.md) — methods grouped by operation.
- [Example app architecture](../architecture/clean-architecture.md) — feature-first layout.
- [Example docs index](../README.md)

## Suggested manual test plan

1. Launch example app → vitals home.
2. Add device: scan, connect, confirm dashboard updates.
3. Trigger sync; open HR, sleep, activity detail screens.
4. Device settings: reconnect, find band, language, 24h toggles.
5. Optional: dial upload, firmware screen, health bind.

These steps match flows exercised in `example/lib/features/`.
