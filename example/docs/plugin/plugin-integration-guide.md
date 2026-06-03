# Plugin integration guide

This guide explains how to integrate `flutter_band_fit` in a Flutter app and structure the runtime flow safely.

For SDK background, native↔Dart mapping, and how the **example app** wires each phase, see [full implementation guide](full-implementation-guide.md).

**UTE SDK = GloryFit SDK:** this plugin wraps the native **UTE SDK**, which **is the GloryFit SDK** (same stack; UTE branding in code, GloryFit branding in many consumer apps). Android (`ute_sdk`) and iOS (`UTESmartBandApi`) are platform builds of that SDK; Dart methods are the shared contract.

**Reference app:** complete flows live under `example/lib/` — use them as the canonical implementation alongside this guide.

## 1) Initialize once

- Create a singleton instance with `final bandFit = FlutterBandFit();`
- Call `initializeDeviceConnection()` before scan/connect operations.
- Handle initialization statuses:
  - `initiated`: plugin ready.
  - `canceled`: permission denied or interrupted.
  - `bleNotSupported`: device does not support required BLE features.

## 2) Device discovery and connection

- Start scanning with `startSearchingDevices()`.
- Present the returned `List<BandDeviceModel>` in UI.
- Connect using:
  - `connectDevice(device)` for a freshly discovered device.
  - `reConnectDevice(device)` when identifier is already persisted.
  - `connectLastDeviceAddress()` for quick reconnect attempts.
- Use `checkConectionStatus()` before triggering sync/testing workflows.
- Prefer `checkConnectionStatus()` (spelling-safe alias); `checkConectionStatus()` remains available for backward compatibility.

## 3) Configure user and device settings

Typical setup sequence after connect:

1. `setUserParameters({...})`
2. `set24HeartRate(true/false)`
3. `set24BloodOxygen(true/false)`
4. `set24HrTemperatureTest(interval, enabled)`
5. Optional UI features:
   - `setDoNotDisturb(...)`
   - `setRejectIncomingCall(...)`
   - `setDeviceBandLanguage(...)`

## 4) Sync and fetch data

- Trigger sync:
  - `syncStepsData()`, `syncSleepData()`, `syncRateData()`, `syncBloodPressure()`, `syncOxygenSaturation()`, `syncTemperature()`
- Pull data snapshots:
  - Per day: `fetchStepsByDate()`, `fetchSleepByDate()`, `fetchHeartRateByDate()`, etc.
  - Full local device data: `fetchOverAllDeviceData()`, `fetchAllStepsData()`, etc.
- Some methods return status-only strings, while others return maps containing payloads.

## 5) Real-time listeners

- Register streams:
  - `receiveEventListeners(...)` for general updates.
  - `receiveBPListeners(...)` for blood pressure test updates.
- Lifecycle:
  - `pauseEventListeners()` / `resumeEventListeners()`
  - `pauseBPListeners()` / `resumeBPListeners()`
  - Always call `cancelEventListeners()` and `cancelBPListeners()` in `dispose`, or simply call plugin `dispose()`.

## 6) Error handling recommendations

- Treat all platform responses as runtime values; always branch by status constants.
- Guard reconnect/sync actions when `checkConectionStatus()` is false.
- If a method returns an empty map, handle it as "no data / failed decode" and retry if appropriate.
- Keep plugin invocation in a dedicated repository/service layer to isolate platform-specific behavior from UI.
