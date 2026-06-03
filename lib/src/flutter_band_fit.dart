part of '../flutter_band_fit.dart';

typedef BandDataCallback = void Function(dynamic data);
typedef BandErrorCallback = void Function(Object error);

class FlutterBandFit {
  FlutterBandFit._(
    this._methodChannel,
    this._eventChannel,
    this._bpTestChannel, {
    this.mapOptions,
  });

  final MethodChannel _methodChannel;
  final EventChannel _eventChannel;
  final EventChannel _bpTestChannel;

  static FlutterBandFit? _instance;
  final Map<String, dynamic>? mapOptions;

  StreamSubscription<dynamic>? _eventChannelListener;
  StreamSubscription<dynamic>? _bpChannelListener;

  factory FlutterBandFit([Map<String, dynamic>? options]) {
    _instance ??= FlutterBandFit._(
      const MethodChannel(BandFitConstants.BAND_METHOD_CHANNEL),
      const EventChannel(BandFitConstants.BAND_EVENT_CHANNEL),
      const EventChannel(BandFitConstants.BAND_BP_TEST_CHANNEL),
      mapOptions: options,
    );
    return _instance!;
  }

  @visibleForTesting
  FlutterBandFit.private(
    MethodChannel methodChannel,
    EventChannel eventChannel,
    EventChannel bpTestChannel, {
    Map<String, dynamic>? mapOptions,
  }) : this._(
          methodChannel,
          eventChannel,
          bpTestChannel,
          mapOptions: mapOptions,
        );

  Future<T?> _invoke<T>(String method, [dynamic arguments]) {
    return _methodChannel.invokeMethod<T>(method, arguments);
  }

  Future<String> _invokeString(String method, [dynamic arguments]) async {
    final result = await _invoke<dynamic>(method, arguments);
    return result?.toString().trim() ?? '';
  }

  Map<String, dynamic> _decodeMap(dynamic raw) {
    if (raw == null) return <String, dynamic>{};
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) {
      return raw.map(
        (key, value) => MapEntry(key.toString(), value),
      );
    }
    if (raw is String && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) return decoded;
        if (decoded is Map) {
          return decoded.map(
            (key, value) => MapEntry(key.toString(), value),
          );
        }
      } on FormatException {
        return <String, dynamic>{};
      }
    }
    return <String, dynamic>{};
  }

  Map<String, dynamic> _decodeStatusResponse(dynamic raw) {
    final value = raw?.toString() ?? '';
    if (value.isEmpty) return <String, dynamic>{};
    if (value == BandFitConstants.SC_FAILURE ||
        value == BandFitConstants.SC_DISCONNECTED) {
      return <String, dynamic>{
        'status': value,
        'data': '',
      };
    }
    return <String, dynamic>{
      'status': BandFitConstants.SC_SUCCESS,
      'data': _decodeMap(raw),
    };
  }

  Map<String, String> _boolParam(bool value) => <String, String>{
        'enable': value ? 'true' : 'false',
      };

  Map<String, String> _dateParam(String dateTime) => <String, String>{
        'dateTime': dateTime,
      };

  Future<String> initializeDeviceConnection() async {
    return _invokeString(BandFitConstants.DEVICE_INITIALIZE);
  }

  Future<String> getLastConnectedDeviceAddress() async {
    return _invokeString(BandFitConstants.GET_LAST_DEVICE_ADDRESS);
  }

  Future<bool> connectLastDeviceAddress() async {
    return (await _invoke<bool>(BandFitConstants.CONNECT_LAST_DEVICE)) ?? false;
  }

  Future<bool> clearGattDisconnect() async {
    return (await _invoke<bool>(BandFitConstants.CLEAR_GATT_DISCONNECT)) ??
        false;
  }

  Future<bool> checkFindBand() async {
    return (await _invoke<bool>(BandFitConstants.CHECK_FIND_BAND)) ?? false;
  }

  Future<String> findBandDevice() async {
    return _invokeString(BandFitConstants.FIND_BAND_DEVICE);
  }

  Future<String> resetDevicesAllData() async {
    return _invokeString(BandFitConstants.RESET_DEVICE_DATA);
  }

  Future<bool> checkDialSupport() async {
    return (await _invoke<bool>(BandFitConstants.CHECK_DIAL_SUPPORT)) ?? false;
  }

  Future<String> readOnlineDialConfig() async {
    return _invokeString(BandFitConstants.READ_ONLINE_DIAL_CONFIG);
  }

  Future<String> prepareSendOnlineDialData() async {
    return _invokeString(BandFitConstants.PREPARE_SEND_ONLINE_DIAL);
  }

  Future<String> listenWatchDialProgress() async {
    return _invokeString(BandFitConstants.LISTEN_WATCH_DIAL_PROGRESS);
  }

  Future<String> sendOnlineDialPath(String filePath) async {
    return _invokeString(
      BandFitConstants.SEND_ONLINE_DIAL_PATH,
      <String, String>{'path': filePath},
    );
  }

  Future<String> sendOnlineDialData(dynamic bandData) async {
    return _invokeString(
      BandFitConstants.SEND_ONLINE_DIAL_DATA,
      <String, dynamic>{'data': bandData},
    );
  }

  Future<String> stopOnlineDialData() async {
    return _invokeString(BandFitConstants.STOP_ONLINE_DIAL_DATA);
  }

  Future<int> getAndroidDeviceSDKIntVersion() async {
    return (await _invoke<int>(BandFitConstants.ANDROID_DEVICE_SDK_INT)) ?? 0;
  }

  Future<String> reInitializeBlueConnection() async {
    return _invokeString(BandFitConstants.DEVICE_RE_INITIATE);
  }

  Future<List<BandDeviceModel>> startSearchingDevices() async {
    final raw = await _invoke<dynamic>(BandFitConstants.START_DEVICE_SEARCH);
    final responseBody = _decodeMap(raw);
    final dynamic devicesRaw = responseBody['data'];
    if (devicesRaw is! List) return <BandDeviceModel>[];
    return devicesRaw
        .whereType<Map<dynamic, dynamic>>()
        .map(
          (device) => BandDeviceModel.fromJson(
            device.map(
              (key, value) => MapEntry(key.toString(), value),
            ),
          ),
        )
        .toList();
  }

  Future<dynamic> stopSearchingDevices() async {
    return _invoke<dynamic>(BandFitConstants.STOP_DEVICE_SEARCH);
  }

  Future<bool> connectDevice(BandDeviceModel deviceModel) async {
    return (await _invoke<bool>(BandFitConstants.BIND_DEVICE, <String, dynamic>{
          'name': deviceModel.name,
          'address': deviceModel.address,
        })) ??
        false;
  }

  Future<bool> reConnectDevice(BandDeviceModel deviceModel) async {
    return (await _invoke<bool>(
            BandFitConstants.RE_BIND_DEVICE, <String, dynamic>{
          'name': deviceModel.name,
          'address': deviceModel.address,
          'identifier': deviceModel.identifier,
        })) ??
        false;
  }

  Future<bool> disconnectDevice() async {
    return (await _invoke<bool>(BandFitConstants.UNBIND_DEVICE)) ?? false;
  }

  Future<String> setUserParameters(dynamic userParams) async {
    return _invokeString(BandFitConstants.SET_USER_PARAMS, userParams);
  }

  Future<String> set24HeartRate(bool enable) async {
    return _invokeString(
        BandFitConstants.SET_24_HEART_RATE, _boolParam(enable));
  }

  Future<String> set24BloodOxygen(bool enable) async {
    return _invokeString(BandFitConstants.SET_24_OXYGEN, _boolParam(enable));
  }

  Future<String> set24HrTemperatureTest(String interval, bool isEnabled) async {
    return _invokeString(
      BandFitConstants.SET_24_TEMPERATURE_TEST,
      <String, String>{
        'interval': interval,
        'enable': isEnabled ? 'true' : 'false',
      },
    );
  }

  Future<String> setWeatherInfoSevenDays(String data) async {
    return _invokeString(
      BandFitConstants.SET_WEATHER_INFO,
      <String, String>{'data': data},
    );
  }

  Future<String> setDeviceBandLanguage(String lang) async {
    return _invokeString(
      BandFitConstants.SET_BAND_LANGUAGE,
      <String, String>{'lang': lang},
    );
  }

  Future<String> setRejectIncomingCall(bool enable) async {
    return _invokeString(BandFitConstants.SET_REJECT_CALL, _boolParam(enable));
  }

  Future<String> setDoNotDisturb(
    bool isMessageOn,
    bool isMotorOn,
    bool disturbTimeSwitch,
    String fromHr,
    String fromMin,
    String toHour,
    String toMin,
  ) async {
    return _invokeString(
      BandFitConstants.SET_DO_NOT_DISTURB,
      <String, String>{
        'isMessageOn': isMessageOn ? 'true' : 'false',
        'isMotorOn': isMotorOn ? 'true' : 'false',
        'disturbTimeSwitch': disturbTimeSwitch ? 'true' : 'false',
        'from_time_hour': fromHr.padLeft(2, '0'),
        'from_time_minute': fromMin.padLeft(2, '0'),
        'to_time_hour': toHour.padLeft(2, '0'),
        'to_time_minute': toMin.padLeft(2, '0'),
      },
    );
  }

  Future<Map<String, dynamic>> fetchDeviceDataInfo() async {
    final result =
        await _invoke<dynamic>(BandFitConstants.GET_DEVICE_DATA_INFO);
    return _decodeMap(result);
  }

  Future<Map<String, dynamic>> fetchOverAllByDate(String dateTime) async {
    final result = await _invoke<dynamic>(
      BandFitConstants.FETCH_OVERALL_BY_DATE,
      _dateParam(dateTime),
    );
    return _decodeStatusResponse(result);
  }

  Future<Map<String, dynamic>> fetchOverAllDeviceData() async {
    final result =
        await _invoke<dynamic>(BandFitConstants.FETCH_OVERALL_DEVICE_DATA);
    return _decodeStatusResponse(result);
  }

  Future<String> getDeviceVersion() async {
    return _invokeString(BandFitConstants.GET_DEVICE_VERSION);
  }

  Future<String> getBatteryStatus() async {
    return _invokeString(BandFitConstants.GET_DEVICE_BATTERY_STATUS);
  }

  Future<bool> checkConectionStatus() async {
    return (await _invoke<bool>(BandFitConstants.CHECK_CONNECTION_STATUS)) ??
        false;
  }

  /// Correctly-spelled alias for [checkConectionStatus].
  Future<bool> checkConnectionStatus() => checkConectionStatus();

  Future<String> callQuickSwitchSettingStatus() async {
    return _invokeString(BandFitConstants.CHECK_QUICK_SWITCH_SETTING);
  }

  Future<String> syncStepsData() async {
    return _invokeString(BandFitConstants.GET_SYNC_STEPS);
  }

  Future<Map<String, dynamic>> fetchAllJudgement() async {
    final result = await _invoke<dynamic>(BandFitConstants.SYNC_ALL_JUDGE);
    return _decodeStatusResponse(result);
  }

  Future<String> syncSleepData() async {
    return _invokeString(BandFitConstants.GET_SYNC_SLEEP);
  }

  Future<String> syncRateData() async {
    return _invokeString(BandFitConstants.GET_SYNC_RATE);
  }

  Future<String> syncBloodPressure() async {
    return _invokeString(BandFitConstants.GET_SYNC_BP);
  }

  Future<String> syncOxygenSaturation() async {
    return _invokeString(BandFitConstants.GET_SYNC_OXYGEN);
  }

  Future<String> syncAllSportInfo() async {
    return _invokeString(BandFitConstants.GET_SYNC_SPORT_INFO);
  }

  Future<String> syncTemperature() async {
    return _invokeString(BandFitConstants.GET_SYNC_TEMPERATURE);
  }

  Future<String> startBloodPressure() async {
    return _invokeString(BandFitConstants.START_BP_TEST);
  }

  Future<String> stopBloodPressure() async {
    return _invokeString(BandFitConstants.STOP_BP_TEST);
  }

  Future<String> startOxygenTest() async {
    return _invokeString(BandFitConstants.START_OXYGEN_TEST);
  }

  Future<String> stopOxygenTest() async {
    return _invokeString(BandFitConstants.STOP_OXYGEN_TEST);
  }

  Future<Map<String, dynamic>> fetchStepsByDate(String dateTime) async {
    final result = await _invoke<dynamic>(
      BandFitConstants.FETCH_STEPS_BY_DATE,
      _dateParam(dateTime),
    );
    return _decodeMap(result);
  }

  Future<Map<String, dynamic>> fetchSleepByDate(String dateTime) async {
    final result = await _invoke<dynamic>(
      BandFitConstants.FETCH_SLEEP_BY_DATE,
      _dateParam(dateTime),
    );
    return _decodeMap(result);
  }

  Future<Map<String, dynamic>> fetchBPByDate(String dateTime) async {
    final result = await _invoke<dynamic>(
      BandFitConstants.FETCH_BP_BY_DATE,
      _dateParam(dateTime),
    );
    return _decodeMap(result);
  }

  Future<Map<String, dynamic>> fetchHeartRateByDate(String dateTime) async {
    final result = await _invoke<dynamic>(
      BandFitConstants.FETCH_HR_BY_DATE,
      _dateParam(dateTime),
    );
    return _decodeMap(result);
  }

  Future<Map<String, dynamic>> fetch24HourHRByDate(String dateTime) async {
    final result = await _invoke<dynamic>(
      BandFitConstants.FETCH_24_HOUR_HR_BY_DATE,
      _dateParam(dateTime),
    );
    return _decodeMap(result);
  }

  Future<Map<String, dynamic>> fetchOxygenByDate(String dateTime) async {
    final result = await _invoke<dynamic>(
      BandFitConstants.FETCH_OXYGEN_BY_DATE,
      _dateParam(dateTime),
    );
    return _decodeMap(result);
  }

  Future<Map<String, dynamic>> fetchTemperatureByDate(String dateTime) async {
    final result = await _invoke<dynamic>(
      BandFitConstants.FETCH_TEMP_BY_DATE,
      _dateParam(dateTime),
    );
    return _decodeMap(result);
  }

  Future<Map<String, dynamic>> fetchAllStepsData() async {
    final result =
        await _invoke<dynamic>(BandFitConstants.FETCH_ALL_STEPS_DATA);
    return _decodeMap(result);
  }

  Future<Map<String, dynamic>> fetchAllSleepData() async {
    final result =
        await _invoke<dynamic>(BandFitConstants.FETCH_ALL_SLEEP_DATA);
    return _decodeMap(result);
  }

  Future<Map<String, dynamic>> fetchAllBPData() async {
    final result = await _invoke<dynamic>(BandFitConstants.FETCH_ALL_BP_DATA);
    return _decodeMap(result);
  }

  Future<Map<String, dynamic>> fetchAllTemperatureData() async {
    final result = await _invoke<dynamic>(BandFitConstants.FETCH_ALL_TEMP_DATA);
    return _decodeMap(result);
  }

  Future<Map<String, dynamic>> fetchAllHr24Data() async {
    final result =
        await _invoke<dynamic>(BandFitConstants.FETCH_ALL_HR_24_DATA);
    return _decodeMap(result);
  }

  Future<String> testTempData() async {
    return _invokeString(BandFitConstants.START_TEST_TEMP);
  }

  void receiveEventListeners({
    BandDataCallback? onData,
    BandErrorCallback? onError,
    void Function()? onDone,
  }) {
    _eventChannelListener = _eventChannel
        .receiveBroadcastStream(BandFitConstants.BAND_EVENT_CHANNEL)
        .listen(
          onData,
          onError: onError,
          onDone: onDone,
          cancelOnError: false,
        );
  }

  void pauseEventListeners() {
    _eventChannelListener?.pause();
  }

  bool resumeEventListeners() {
    final listener = _eventChannelListener;
    if (listener == null || !listener.isPaused) return false;
    listener.resume();
    return true;
  }

  void cancelEventListeners() {
    _eventChannelListener?.cancel();
    _eventChannelListener = null;
  }

  void receiveBPListeners({
    BandDataCallback? onData,
    BandErrorCallback? onError,
    void Function()? onDone,
  }) {
    _bpChannelListener = _bpTestChannel
        .receiveBroadcastStream(BandFitConstants.BAND_BP_TEST_CHANNEL)
        .listen(
          onData,
          onError: onError,
          onDone: onDone,
          cancelOnError: false,
        );
  }

  void pauseBPListeners() {
    _bpChannelListener?.pause();
  }

  bool resumeBPListeners() {
    final listener = _bpChannelListener;
    if (listener == null || !listener.isPaused) return false;
    listener.resume();
    return true;
  }

  void cancelBPListeners() {
    _bpChannelListener?.cancel();
    _bpChannelListener = null;
  }

  /// Releases local stream subscriptions held by this singleton.
  void dispose() {
    cancelEventListeners();
    cancelBPListeners();
  }
}
