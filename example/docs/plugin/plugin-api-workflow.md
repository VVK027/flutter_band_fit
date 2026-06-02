# Plugin API workflow reference

Reference for the current `FlutterBandFit` API grouped by operational flow.

## Connection and lifecycle

- `initializeDeviceConnection() -> Future<String>`
- `reInitializeBlueConnection() -> Future<String>`
- `getAndroidDeviceSDKIntVersion() -> Future<int>`
- `disconnectDevice() -> Future<bool>`
- `checkConectionStatus() -> Future<bool>`
- `checkConnectionStatus() -> Future<bool>` (preferred alias)
- `dispose() -> void`

## Scan and connect

- `startSearchingDevices() -> Future<List<BandDeviceModel>>`
- `stopSearchingDevices() -> Future<dynamic>`
- `connectDevice(BandDeviceModel) -> Future<bool>`
- `reConnectDevice(BandDeviceModel) -> Future<bool>`
- `getLastConnectedDeviceAddress() -> Future<String>`
- `connectLastDeviceAddress() -> Future<bool>`
- `clearGattDisconnect() -> Future<bool>`

## Device controls

- `checkFindBand()`, `findBandDevice()`
- `resetDevicesAllData()`
- `setUserParameters(dynamic userParams)`
- `set24HeartRate(bool)`
- `set24BloodOxygen(bool)`
- `set24HrTemperatureTest(String interval, bool enabled)`
- `setDoNotDisturb(...)`
- `setRejectIncomingCall(bool)`
- `setWeatherInfoSevenDays(String)`
- `setDeviceBandLanguage(String)`

## Dial operations

- `checkDialSupport()`
- `readOnlineDialConfig()`
- `prepareSendOnlineDialData()`
- `listenWatchDialProgress()`
- `sendOnlineDialPath(String path)`
- `sendOnlineDialData(dynamic bytes)`
- `stopOnlineDialData()`

## Sync operations

- `syncStepsData()`
- `syncSleepData()`
- `syncRateData()`
- `syncBloodPressure()`
- `syncOxygenSaturation()`
- `syncTemperature()`
- `syncAllSportInfo()`
- `fetchAllJudgement() -> Future<Map<String, dynamic>>`

## Fetch operations

- `fetchDeviceDataInfo()`
- `fetchOverAllByDate(String date)`
- `fetchOverAllDeviceData()`
- By date:
  - `fetchStepsByDate(String date)`
  - `fetchSleepByDate(String date)`
  - `fetchBPByDate(String date)`
  - `fetchHeartRateByDate(String date)`
  - `fetch24HourHRByDate(String date)`
  - `fetchOxygenByDate(String date)`
  - `fetchTemperatureByDate(String date)`
- Bulk:
  - `fetchAllStepsData()`
  - `fetchAllSleepData()`
  - `fetchAllBPData()`
  - `fetchAllTemperatureData()`
  - `fetchAllHr24Data()`

## Test operations

- `startBloodPressure()`, `stopBloodPressure()`
- `startOxygenTest()`, `stopOxygenTest()`
- `testTempData()`

## Listener operations

- `receiveEventListeners({onData, onError, onDone})`
- `pauseEventListeners()`, `resumeEventListeners()`, `cancelEventListeners()`
- `receiveBPListeners({onData, onError, onDone})`
- `pauseBPListeners()`, `resumeBPListeners()`, `cancelBPListeners()`
- Callback typedefs:
  - `BandDataCallback = void Function(dynamic data)`
  - `BandErrorCallback = void Function(Object error)`

## Response conventions

- String responses commonly contain plugin statuses from `BandFitConstants`:
  - `success`, `failure`, `initiated`, `disconnected`, `canceled`
- Map responses are JSON-decoded platform payloads.
- Status-wrapped map responses use:
  - `{"status": "...", "data": ...}`
