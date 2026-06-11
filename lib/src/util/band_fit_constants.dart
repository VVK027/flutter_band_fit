part of '../../flutter_band_fit.dart';

// spirometer supported user params enum
/// Spirometer measurement mode passed in user parameters.
enum MeasureMode {
  /// All measurement modes.
  ALL,

  /// Forced vital capacity mode.
  FVC,

  /// Vital capacity mode.
  VC,

  /// Maximum voluntary ventilation mode.
  MVV,

  /// Minute ventilation mode.
  MV,
}

/// Smoking status passed in user parameters.
enum Smoke {
  /// Non-smoker profile.
  NOSMOKE,

  /// Smoker profile.
  SMOKE,
}

/// Biological sex passed in user parameters.
enum Sex {
  /// Male profile.
  MALE,

  /// Female profile.
  FEMALE,
}

/// Lung-function reference standard passed in user parameters.
enum Standard {
  /// ECCS reference standard.
  ECCS,

  /// Knudson reference standard.
  KNUDSON,

  /// USA reference standard.
  USA,
}

// its enum extensions
/// String name helpers for [MeasureMode] values.
extension MeasureModeExtension on MeasureMode {
  /// Returns the SDK string label for this enum value.
  String get name {
    return ["ALL", "FVC", "VC", "MVV", "MV"][index];
  }
}

/// String name helpers for [Smoke] values.
extension SmokeExtension on Smoke {
  /// Returns the SDK string label for this enum value.
  String get name {
    return ["NOSMOKE", "SMOKE"][index];
  }
}

/// String name helpers for [Sex] values.
extension SexExtension on Sex {
  /// Returns the SDK string label for this enum value.
  String get name {
    return ["MALE", "FEMALE"][index];
  }
}

/// String name helpers for [Standard] values.
extension StandardExtension on Standard {
  /// Returns the SDK string label for this enum value.
  String get name {
    return ["ECCS", "KNUDSON", "USA"][index];
  }
}

// use it like
// MeasureMode.ALL.name
/// Method names, channel identifiers, and event keys used by
/// [FlutterBandFit] when communicating with the native SDK.
class BandFitConstants {
  /// Prevents public instantiation; use static members only.
  const BandFitConstants._();

  // result constants
  /// Operation status/event value `"success"`.
  static const String SC_SUCCESS = "success";

  /// Operation status/event value `"failure"`.
  static const String SC_FAILURE = "failure";

  /// Operation status/event value `"complete"`.
  static const String SC_COMPLETE = "complete";

  /// Operation status/event value `"canceled"`.
  static const String SC_CANCELED = "canceled";

  /// Operation status/event value `"disconnected"`.
  static const String SC_DISCONNECTED = "disconnected";

  /// Operation status/event value `"initiated"`.
  static const String SC_INIT = "initiated";

  /// Operation status/event value `"reInitiated"`.
  static const String SC_RE_INIT = "reInitiated";

  /// Operation status/event value `"bleReInitiated"`.
  static const String SC_BLE_RE_INIT = "bleReInitiated";

  /// Operation status/event value `"notSupported"`.
  static const String SC_NOT_SUPPORTED = "notSupported";

  //android related
  /// Plugin constant `"androidDeviceSDKVersion"` used by the native SDK bridge.
  static const String ANDROID_DEVICE_SDK_INT = "androidDeviceSDKVersion";

  //relates to device connections
  //static const String BLE_RE_INITIALIZE = "bleReInitialize";
  /// Plugin constant `"deviceReInitiate"` used by the native SDK bridge.
  static const String DEVICE_RE_INITIATE = "deviceReInitiate";

  /// Plugin constant `"initDeviceConnection"` used by the native SDK bridge.
  static const String DEVICE_INITIALIZE = "initDeviceConnection";

  /// Plugin constant `"startDeviceSearch"` used by the native SDK bridge.
  static const String START_DEVICE_SEARCH = "startDeviceSearch";

  /// Plugin constant `"updateDeviceSearchList"` used by the native SDK bridge.
  static const String UPDATE_DEVICE_LIST = "updateDeviceSearchList";

  /// Plugin constant `"stopDeviceSearch"` used by the native SDK bridge.
  static const String STOP_DEVICE_SEARCH = "stopDeviceSearch";

  /// Plugin constant `"connectDevice"` used by the native SDK bridge.
  static const String BIND_DEVICE = "connectDevice";

  /// Plugin constant `"reconnectDevice"` used by the native SDK bridge.
  static const String RE_BIND_DEVICE = "reconnectDevice";

  /// Plugin constant `"disconnectDevice"` used by the native SDK bridge.
  static const String UNBIND_DEVICE = "disconnectDevice";

  /// Plugin constant `"bleNotSupported"` used by the native SDK bridge.
  static const String BLE_NOT_SUPPORTED = "bleNotSupported";

  /// Plugin constant `"bleNotEnabled"` used by the native SDK bridge.
  static const String BLE_NOT_ENABLED = "bleNotEnabled";

  //device data
  /// Native method or event identifier `"getLastDeviceAddress"`.
  static const String GET_LAST_DEVICE_ADDRESS = "getLastDeviceAddress";

  /// Plugin constant `"connectLastDevice"` used by the native SDK bridge.
  static const String CONNECT_LAST_DEVICE = "connectLastDevice";

  /// Plugin constant `"clearGattDisconnect"` used by the native SDK bridge.
  static const String CLEAR_GATT_DISCONNECT = "clearGattDisconnect";

  /// Plugin constant `"checkConnectionStatus"` used by the native SDK bridge.
  static const String CHECK_CONNECTION_STATUS = "checkConnectionStatus";

  /// Native method or event identifier `"fetchDeviceVersion"`.
  static const String GET_DEVICE_VERSION = "fetchDeviceVersion";

  /// Native method or event identifier `"fetchBatteryStatus"`.
  static const String GET_DEVICE_BATTERY_STATUS = "fetchBatteryStatus";

  /// Native method or event identifier `"setUserDetails"`.
  static const String SET_USER_PARAMS = "setUserDetails";

  /// Native method or event identifier `"set24HeartRate"`.
  static const String SET_24_HEART_RATE = "set24HeartRate";

  /// Native method or event identifier `"set24Oxygen"`.
  static const String SET_24_OXYGEN = "set24Oxygen";

  /// Native method or event identifier `"set24TempTest"`.
  static const String SET_24_TEMPERATURE_TEST = "set24TempTest";

  /// Native method or event identifier `"setWeatherInfo"`.
  static const String SET_WEATHER_INFO = "setWeatherInfo";

  /// Native method or event identifier `"setBandLanguage"`.
  static const String SET_BAND_LANGUAGE = "setBandLanguage";

  /// Plugin constant `"checkFindBand"` used by the native SDK bridge.
  static const String CHECK_FIND_BAND = "checkFindBand";

  /// Plugin constant `"findBandDevice"` used by the native SDK bridge.
  static const String FIND_BAND_DEVICE = "findBandDevice";

  /// Plugin constant `"deleteDeviceData"` used by the native SDK bridge.
  static const String RESET_DEVICE_DATA = "deleteDeviceData";

  /// Native method or event identifier `"fetchDeviceDataInfo"`.
  static const String GET_DEVICE_DATA_INFO = "fetchDeviceDataInfo";

  /// Plugin constant `"checkDialSupport"` used by the native SDK bridge.
  static const String CHECK_DIAL_SUPPORT = "checkDialSupport";

  /// Plugin constant `"readOnlineDialConfig"` used by the native SDK bridge.
  static const String READ_ONLINE_DIAL_CONFIG = "readOnlineDialConfig";

  /// Plugin constant `"prepareSendOnlineDial"` used by the native SDK bridge.
  static const String PREPARE_SEND_ONLINE_DIAL = "prepareSendOnlineDial";

  /// Plugin constant `"sendOnlineDialSuccess"` used by the native SDK bridge.
  static const String SEND_ONLINE_DIAL_SUCCESS = "sendOnlineDialSuccess";

  /// Plugin constant `"sendOnlineDialFailure"` used by the native SDK bridge.
  static const String SEND_ONLINE_DIAL_FAIL = "sendOnlineDialFailure";

  /// Plugin constant `"sendOnlineDialLarge"` used by the native SDK bridge.
  static const String SEND_ONLINE_DIAL_LARGE = "sendOnlineDialLarge";

  /// Plugin constant `"listenWatchDialProgress"` used by the native SDK bridge.
  static const String LISTEN_WATCH_DIAL_PROGRESS = "listenWatchDialProgress";

  /// Plugin constant `"sendOnlineDialData"` used by the native SDK bridge.
  static const String SEND_ONLINE_DIAL_DATA = "sendOnlineDialData";

  /// Plugin constant `"sendOnlineDialPath"` used by the native SDK bridge.
  static const String SEND_ONLINE_DIAL_PATH = "sendOnlineDialPath";

  /// Plugin constant `"stopOnlineDialData"` used by the native SDK bridge.
  static const String STOP_ONLINE_DIAL_DATA = "stopOnlineDialData";

  /// Plugin constant `"watchDialProgressStatus"` used by the native SDK bridge.
  static const String WATCH_DIAL_PROGRESS_STATUS = "watchDialProgressStatus";

  /// Native method or event identifier `"setDoNotDisturb"`.
  static const String SET_DO_NOT_DISTURB = "setDoNotDisturb";

  /// Native method or event identifier `"setRejectCall"`.
  static const String SET_REJECT_CALL = "setRejectCall";

  // daily activities & operations
  /// Native method or event identifier `"fetchAllJudgement"`.
  static const String SYNC_ALL_JUDGE = "fetchAllJudgement";

  /// Native method or event identifier `"syncAllStepsData"`.
  static const String GET_SYNC_STEPS = "syncAllStepsData";

  /// Native method or event identifier `"syncRateData"`.
  static const String GET_SYNC_RATE = "syncRateData";

  /// Native method or event identifier `"syncSleepData"`.
  static const String GET_SYNC_SLEEP = "syncSleepData";

  /// Native method or event identifier `"syncBP"`.
  static const String GET_SYNC_BP = "syncBP";

  /// Native method or event identifier `"syncOxygen"`.
  static const String GET_SYNC_OXYGEN = "syncOxygen";

  /// Native method or event identifier `"syncTemperature"`.
  static const String GET_SYNC_TEMPERATURE = "syncTemperature";

  /// Native method or event identifier `"syncAllSportInfo"`.
  static const String GET_SYNC_SPORT_INFO = "syncAllSportInfo";

  // test starts
  /// Native method or event identifier `"startTestTemp"`.
  static const String START_TEST_TEMP = "startTestTemp";

  /// Native method or event identifier `"startBPTest"`.
  static const String START_BP_TEST = "startBPTest";

  /// Native method or event identifier `"stopBPTest"`.
  static const String STOP_BP_TEST = "stopBPTest";

  // static const String START_HR_TEST = "startHRTest";
  // static const String STOP_HR_TEST = "stopHRTest";

  /// Native method or event identifier `"startOxygenTest"`.
  static const String START_OXYGEN_TEST = "startOxygenTest";

  /// Native method or event identifier `"stopOxygenTest"`.
  static const String STOP_OXYGEN_TEST = "stopOxygenTest";

  /// Native method or event identifier `"fetchOverAllByDate"`.
  static const String FETCH_OVERALL_BY_DATE = "fetchOverAllByDate";

  /// Native method or event identifier `"fetchStepsByDate"`.
  static const String FETCH_STEPS_BY_DATE = "fetchStepsByDate";

  /// Native method or event identifier `"fetchSleepByDate"`.
  static const String FETCH_SLEEP_BY_DATE = "fetchSleepByDate";

  /// Native method or event identifier `"fetchBPByDate"`.
  static const String FETCH_BP_BY_DATE = "fetchBPByDate";

  /// Native method or event identifier `"fetchHRByDate"`.
  static const String FETCH_HR_BY_DATE = "fetchHRByDate";

  /// Native method or event identifier `"fetchOxygenByDate"`.
  static const String FETCH_OXYGEN_BY_DATE = "fetchOxygenByDate";

  /// Native method or event identifier `"fetch24HourHRDateByDate"`.
  static const String FETCH_24_HOUR_HR_BY_DATE = "fetch24HourHRDateByDate";

  /// Native method or event identifier `"fetchTemperatureByDate"`.
  static const String FETCH_TEMP_BY_DATE = "fetchTemperatureByDate";

  /// Native method or event identifier `"fetchOverAllDeviceData"`.
  static const String FETCH_OVERALL_DEVICE_DATA = "fetchOverAllDeviceData";

  /// Native method or event identifier `"fetchAllStepsData"`.
  static const String FETCH_ALL_STEPS_DATA = "fetchAllStepsData";

  /// Native method or event identifier `"fetchAllSleepData"`.
  static const String FETCH_ALL_SLEEP_DATA = "fetchAllSleepData";

  /// Native method or event identifier `"fetchAllBPData"`.
  static const String FETCH_ALL_BP_DATA = "fetchAllBPData";

  /// Native method or event identifier `"fetchAllTempData"`.
  static const String FETCH_ALL_TEMP_DATA = "fetchAllTempData";

  /// Native method or event identifier `"fetchAllHr24Data"`.
  static const String FETCH_ALL_HR_24_DATA = "fetchAllHr24Data";

  /// Native method or event identifier `"syncStepsFinish"`.
  static const String SYNC_STEPS_FINISH = "syncStepsFinish";

  /// Native method or event identifier `"syncSleepFinish"`.
  static const String SYNC_SLEEP_FINISH = "syncSleepFinish";

  /// Native method or event identifier `"syncBpFinish"`.
  static const String SYNC_BP_FINISH = "syncBpFinish";
  //static const String SYNC_RATE_FINISH = "syncRateFinish";
  /// Native method or event identifier `"syncTempFinish"`.
  static const String SYNC_TEMPERATURE_FINISH = "syncTempFinish";

  /// Native method or event identifier `"sync24hrRateFinish"`.
  static const String SYNC_24_HOUR_RATE_FINISH = "sync24hrRateFinish";

  /// Native method or event identifier `"syncEcgDataFinish"`.
  static const String SYNC_ECG_DATA_FINISH = "syncEcgDataFinish";

  /// Native method or event identifier `"syncOxygenFinish"`.
  static const String SYNC_OXYGEN_FINISH = "syncOxygenFinish";

  /// Native method or event identifier `"syncStatus24hrOpen"`.
  static const String SYNC_STATUS_24_HOUR_RATE_OPEN = "syncStatus24hrOpen";

  /// Native method or event identifier `"syncStatus24OxyOpen"`.
  static const String SYNC_STATUS_24_HOUR_OXYGEN_OPEN = "syncStatus24OxyOpen";

  /// Native method or event identifier `"syncTemp24hrAutomatic"`.
  static const String SYNC_TEMPERATURE_24_HOUR_AUTOMATIC =
      "syncTemp24hrAutomatic";

  /// Native method or event identifier `"syncWeatherSuccess"`.
  static const String SYNC_WEATHER_SUCCESS = "syncWeatherSuccess";

  /// Native method or event identifier `"syncStatusCurrentOxyCmd"`.
  static const String SYNC_STATUS_CURRENT_OXYGEN_CMD =
      "syncStatusCurrentOxyCmd";

  /// Plugin constant `"dndOpened"` used by the native SDK bridge.
  static const String DND_OPENED = "dndOpened";

  /// Plugin constant `"dndClosed"` used by the native SDK bridge.
  static const String DND_CLOSED = "dndClosed";

  /// Plugin constant `"callQuickSwitchSettingStatus"` used by the native SDK bridge.
  static const String CHECK_QUICK_SWITCH_SETTING =
      "callQuickSwitchSettingStatus";

  /// Plugin constant `"quickSwitchStatus"` used by the native SDK bridge.
  static const String QUICK_SWITCH_STATUS = "quickSwitchStatus";

  /// Plugin constant `"quickSwitchSupport"` used by the native SDK bridge.
  static const String QUICK_SWITCH_SUPPORT = "quickSwitchSupport";

  //any sync failed
  /// Native method or event identifier `"syncBleWriteSuccess"`.
  static const String SYNC_BLE_WRITE_SUCCESS = "syncBleWriteSuccess";

  /// Native method or event identifier `"syncBleWriteFail"`.
  static const String SYNC_BLE_WRITE_FAIL = "syncBleWriteFail";

  /// Native method or event identifier `"SYNC_TIME_OK"`.
  static const String SYNC_TIME_OK = "SYNC_TIME_OK";

  /// Native method or event identifier `"syncSleepTimeOut"`.
  static const String SYNC_SLEEP_TIME_OUT = "syncSleepTimeOut";

  /// Native method or event identifier `"syncStepsTimeOut"`.
  static const String SYNC_STEPS_TIME_OUT = "syncStepsTimeOut";

  /// Native method or event identifier `"syncTempTimeOut"`.
  static const String SYNC_TEMPERATURE_TIME_OUT = "syncTempTimeOut";

  /// Native method or event identifier `"bpTestStarted"`.
  static const String BP_TEST_STARTED = "bpTestStarted";

  /// Native method or event identifier `"bpTestFinished"`.
  static const String BP_TEST_FINISHED = "bpTestFinished";

  /// Native method or event identifier `"bpTestTimeOut"`.
  static const String BP_TEST_TIME_OUT = "bpTestTimeOut";

  /// Native method or event identifier `"bpTestError"`.
  static const String BP_TEST_ERROR = "bpTestError";

  /// Native method or event identifier `"oxyTestStarted"`.
  static const String OXYGEN_TEST_STARTED = "oxyTestStarted";

  /// Native method or event identifier `"oxyTestFinished"`.
  static const String OXYGEN_TEST_FINISHED = "oxyTestFinished";

  /// Native method or event identifier `"oxyTestTimeOut"`.
  static const String OXYGEN_TEST_TIME_OUT = "oxyTestTimeOut";

  /// Native method or event identifier `"oxyTestError"`.
  static const String OXYGEN_TEST_ERROR = "oxyTestError";

  /// Native method or event identifier `"tempTestOK"`.
  static const String TEMP_TEST_OK = "tempTestOK";

  /// Native method or event identifier `"tempTestTimeOut"`.
  static const String TEMP_TEST_TIME_OUT = "tempTestTimeOut";

  /// Native method or event identifier `"hrTestStarted"`.
  static const String HR_TEST_STARTED = "hrTestStarted";

  /// Native method or event identifier `"hrTestFinished"`.
  static const String HR_TEST_FINISHED = "hrTestFinished";

  //method channel
  /// Flutter platform channel name `"smartMethodChannel"`.
  static const String BAND_METHOD_CHANNEL = "smartMethodChannel";

  /// Flutter platform channel name `"smartEventChannel"`.
  static const String BAND_EVENT_CHANNEL = "smartEventChannel";

  /// Flutter platform channel name `"smartBPTestChannel"`.
  static const String BAND_BP_TEST_CHANNEL = "smartBPTestChannel";

  //for continuous call backs from the hardware device search
  // static const String SMART_CALLBACK = "smartCallbacks";
  // static const String START_LISTENING = "startListening";
  // static const String SERVICE_LISTENING = "serviceListener";
  // static const String CALL_LISTENER = "callListener";
  // static const String STOP_LISTENING = "cancelListening";

  //listeners result callback list
  /// Event payload key `"batteryStatus"` emitted on the main event channel.
  static const String BATTERY_STATUS = "batteryStatus";

  /// Event payload key `"deviceVersion"` emitted on the main event channel.
  static const String DEVICE_VERSION = "deviceVersion";
  // static const String DEVICE_NOT_VALID = "deviceNotValid";
  /// Event payload key `"deviceDisConnected"` emitted on the main event channel.
  static const String DEVICE_DISCONNECTED = "deviceDisConnected";

  /// Event payload key `"deviceConnected"` emitted on the main event channel.
  static const String DEVICE_CONNECTED = "deviceConnected";

  /// Event payload key `"updateDeviceParams"` emitted on the main event channel.
  static const String UPDATE_DEVICE_PARAMS = "updateDeviceParams";

  /// Plugin constant `"queryBandLanguage"` used by the native SDK bridge.
  static const String QUERY_BAND_LANGUAGE = "queryBandLanguage";

  /// Native method or event identifier `"syncBandLanguage"`.
  static const String SYNC_BAND_LANGUAGE = "syncBandLanguage";

  //real time sync data constants
  /// Real-time event payload key `"stepsRealTime"`.
  static const String STEPS_REAL_TIME = "stepsRealTime";

  /// Real-time event payload key `"heartRateRT"`.
  static const String HR_REAL_TIME = "heartRateRT";

  /// Real-time event payload key `"bpResult"`.
  static const String BP_RESULT = "bpResult";

  /// Android live BP callback status when the measurement is complete.
  static const String BP_RESULT_STATUS_COMPLETE = "4";

  /// Real-time event payload key `"tempResult"`.
  static const String TEMP_RESULT = "tempResult";

  /// Real-time event payload key `"oxygenResult"`.
  static const String OXYGEN_RESULT = "oxygenResult";

  /// Real-time event payload key `"hr24RealResult"`.
  static const String HR_24_REAL_RESULT = "hr24RealResult";

  /// Plugin constant `"callbackException"` used by the native SDK bridge.
  static const String CALLBACK_EXCEPTION = "callbackException";

  // static const String SMART_EVENTS = "smartEvents";

  /// Plugin constant `"com.vvk.band_fit"` used by the native SDK bridge.
  static const String BROADCAST_ACTION_NAME = "com.vvk.band_fit";

  //requires only for IOS
//  static const String DC_APP_Id = "dcAppId";
}
