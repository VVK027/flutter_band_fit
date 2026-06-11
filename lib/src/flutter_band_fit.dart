part of '../flutter_band_fit.dart';

/// Called when the main event channel emits band data.
typedef BandDataCallback = void Function(dynamic data);

/// Called when an event-channel subscription reports an error.
typedef BandErrorCallback = void Function(Object error);

/// Entry point for communicating with a UTE smart band via platform channels.
///
/// Obtain the shared instance with [FlutterBandFit.new] and subscribe to
/// device events through [receiveEventListeners].
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

  /// Optional configuration map passed when the singleton is first created.
  final Map<String, dynamic>? mapOptions;

  StreamSubscription<dynamic>? _eventChannelListener;
  StreamSubscription<dynamic>? _bpChannelListener;

  /// Returns the shared [FlutterBandFit] instance, creating it on first access.
  factory FlutterBandFit([Map<String, dynamic>? options]) {
    _instance ??= FlutterBandFit._(
      const MethodChannel(BandFitConstants.BAND_METHOD_CHANNEL),
      const EventChannel(BandFitConstants.BAND_EVENT_CHANNEL),
      const EventChannel(BandFitConstants.BAND_BP_TEST_CHANNEL),
      mapOptions: options,
    );
    return _instance!;
  }

  /// Test-only constructor that injects custom platform channels.
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

  /// Initializes the native BLE stack and prepares the plugin for device use.
  Future<String> initializeDeviceConnection() async {
    return _invokeString(BandFitConstants.DEVICE_INITIALIZE);
  }

  /// Returns the MAC or identifier of the last successfully connected device.
  Future<String> getLastConnectedDeviceAddress() async {
    return _invokeString(BandFitConstants.GET_LAST_DEVICE_ADDRESS);
  }

  /// Attempts to reconnect to the last known device address.
  Future<bool> connectLastDeviceAddress() async {
    return (await _invoke<bool>(BandFitConstants.CONNECT_LAST_DEVICE)) ?? false;
  }

  /// Clears a pending GATT disconnect state on the native side.
  Future<bool> clearGattDisconnect() async {
    return (await _invoke<bool>(BandFitConstants.CLEAR_GATT_DISCONNECT)) ??
        false;
  }

  /// Reports whether the connected band supports the find-band feature.
  Future<bool> checkFindBand() async {
    return (await _invoke<bool>(BandFitConstants.CHECK_FIND_BAND)) ?? false;
  }

  /// Triggers the band to vibrate or ring so it can be located nearby.
  Future<String> findBandDevice() async {
    return _invokeString(BandFitConstants.FIND_BAND_DEVICE);
  }

  /// Erases all data stored on the connected band.
  Future<String> resetDevicesAllData() async {
    return _invokeString(BandFitConstants.RESET_DEVICE_DATA);
  }

  /// Reports whether the connected band supports custom watch faces.
  Future<bool> checkDialSupport() async {
    return (await _invoke<bool>(BandFitConstants.CHECK_DIAL_SUPPORT)) ?? false;
  }

  /// Reads the current online watch-face configuration from the band.
  Future<String> readOnlineDialConfig() async {
    return _invokeString(BandFitConstants.READ_ONLINE_DIAL_CONFIG);
  }

  /// Prepares the band to receive a new online watch-face transfer.
  Future<String> prepareSendOnlineDialData() async {
    return _invokeString(BandFitConstants.PREPARE_SEND_ONLINE_DIAL);
  }

  /// Starts listening for watch-face upload progress events on the native side.
  Future<String> listenWatchDialProgress() async {
    return _invokeString(BandFitConstants.LISTEN_WATCH_DIAL_PROGRESS);
  }

  /// Sends a watch-face file from [filePath] to the connected band.
  Future<String> sendOnlineDialPath(String filePath) async {
    return _invokeString(
      BandFitConstants.SEND_ONLINE_DIAL_PATH,
      <String, String>{'path': filePath},
    );
  }

  /// Sends raw watch-face payload [bandData] to the connected band.
  Future<String> sendOnlineDialData(dynamic bandData) async {
    return _invokeString(
      BandFitConstants.SEND_ONLINE_DIAL_DATA,
      <String, dynamic>{'data': bandData},
    );
  }

  /// Cancels an in-progress online watch-face transfer.
  Future<String> stopOnlineDialData() async {
    return _invokeString(BandFitConstants.STOP_ONLINE_DIAL_DATA);
  }

  /// Returns the Android SDK API level of the host device.
  Future<int> getAndroidDeviceSDKIntVersion() async {
    return (await _invoke<int>(BandFitConstants.ANDROID_DEVICE_SDK_INT)) ?? 0;
  }

  /// Re-initializes the native Bluetooth connection after a failure.
  Future<String> reInitializeBlueConnection() async {
    return _invokeString(BandFitConstants.DEVICE_RE_INITIATE);
  }

  /// Starts scanning for nearby bands and returns any devices found so far.
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

  /// Stops the active device scan.
  Future<dynamic> stopSearchingDevices() async {
    return _invoke<dynamic>(BandFitConstants.STOP_DEVICE_SEARCH);
  }

  /// Binds to [deviceModel] and establishes a BLE connection.
  Future<bool> connectDevice(BandDeviceModel deviceModel) async {
    return (await _invoke<bool>(BandFitConstants.BIND_DEVICE, <String, dynamic>{
          'name': deviceModel.name,
          'address': deviceModel.address,
        })) ??
        false;
  }

  /// Reconnects to a previously paired [deviceModel].
  Future<bool> reConnectDevice(BandDeviceModel deviceModel) async {
    return (await _invoke<bool>(
            BandFitConstants.RE_BIND_DEVICE, <String, dynamic>{
          'name': deviceModel.name,
          'address': deviceModel.address,
          'identifier': deviceModel.identifier,
        })) ??
        false;
  }

  /// Unbinds and disconnects from the currently connected band.
  Future<bool> disconnectDevice() async {
    return (await _invoke<bool>(BandFitConstants.UNBIND_DEVICE)) ?? false;
  }

  /// Sends user profile details (height, weight, age, etc.) to the band.
  Future<String> setUserParameters(dynamic userParams) async {
    return _invokeString(BandFitConstants.SET_USER_PARAMS, userParams);
  }

  /// Enables or disables continuous 24-hour heart-rate monitoring.
  Future<String> set24HeartRate(bool enable) async {
    return _invokeString(
        BandFitConstants.SET_24_HEART_RATE, _boolParam(enable));
  }

  /// Enables or disables continuous 24-hour blood-oxygen monitoring.
  Future<String> set24BloodOxygen(bool enable) async {
    return _invokeString(BandFitConstants.SET_24_OXYGEN, _boolParam(enable));
  }

  /// Configures automatic temperature testing with [interval] and [isEnabled].
  Future<String> set24HrTemperatureTest(String interval, bool isEnabled) async {
    return _invokeString(
      BandFitConstants.SET_24_TEMPERATURE_TEST,
      <String, String>{
        'interval': interval,
        'enable': isEnabled ? 'true' : 'false',
      },
    );
  }

  /// Pushes a seven-day weather payload [data] to the band display.
  Future<String> setWeatherInfoSevenDays(String data) async {
    return _invokeString(
      BandFitConstants.SET_WEATHER_INFO,
      <String, String>{'data': data},
    );
  }

  /// Sets the on-band UI language to [lang].
  Future<String> setDeviceBandLanguage(String lang) async {
    return _invokeString(
      BandFitConstants.SET_BAND_LANGUAGE,
      <String, String>{'lang': lang},
    );
  }

  /// Enables or disables automatic rejection of incoming phone calls.
  Future<String> setRejectIncomingCall(bool enable) async {
    return _invokeString(BandFitConstants.SET_REJECT_CALL, _boolParam(enable));
  }

  /// Configures do-not-disturb mode, vibration, and quiet hours on the band.
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

  /// Fetches firmware and capability metadata for the connected band.
  Future<Map<String, dynamic>> fetchDeviceDataInfo() async {
    final result =
        await _invoke<dynamic>(BandFitConstants.GET_DEVICE_DATA_INFO);
    return _decodeMap(result);
  }

  /// Fetches aggregated vitals for the calendar day given by [dateTime].
  Future<Map<String, dynamic>> fetchOverAllByDate(String dateTime) async {
    final result = await _invoke<dynamic>(
      BandFitConstants.FETCH_OVERALL_BY_DATE,
      _dateParam(dateTime),
    );
    return _decodeStatusResponse(result);
  }

  /// Fetches all stored vitals from the connected band.
  Future<Map<String, dynamic>> fetchOverAllDeviceData() async {
    final result =
        await _invoke<dynamic>(BandFitConstants.FETCH_OVERALL_DEVICE_DATA);
    return _decodeStatusResponse(result);
  }

  /// Returns the firmware version string of the connected band.
  Future<String> getDeviceVersion() async {
    return _invokeString(BandFitConstants.GET_DEVICE_VERSION);
  }

  /// Returns the current battery level reported by the band.
  Future<String> getBatteryStatus() async {
    return _invokeString(BandFitConstants.GET_DEVICE_BATTERY_STATUS);
  }

  /// Reports whether the band is currently connected.
  Future<bool> checkConectionStatus() async {
    return (await _invoke<bool>(BandFitConstants.CHECK_CONNECTION_STATUS)) ??
        false;
  }

  /// Correctly-spelled alias for [checkConectionStatus].
  Future<bool> checkConnectionStatus() => checkConectionStatus();

  /// Queries quick-switch feature support and status on the band.
  Future<String> callQuickSwitchSettingStatus() async {
    return _invokeString(BandFitConstants.CHECK_QUICK_SWITCH_SETTING);
  }

  /// Triggers a full step-count sync from the band.
  Future<String> syncStepsData() async {
    return _invokeString(BandFitConstants.GET_SYNC_STEPS);
  }

  /// Fetches sync capability flags and judgement data from the band.
  Future<Map<String, dynamic>> fetchAllJudgement() async {
    final result = await _invoke<dynamic>(BandFitConstants.SYNC_ALL_JUDGE);
    return _decodeStatusResponse(result);
  }

  /// Triggers a full sleep-data sync from the band.
  Future<String> syncSleepData() async {
    return _invokeString(BandFitConstants.GET_SYNC_SLEEP);
  }

  /// Triggers a heart-rate data sync from the band.
  Future<String> syncRateData() async {
    return _invokeString(BandFitConstants.GET_SYNC_RATE);
  }

  /// Triggers a blood-pressure data sync from the band.
  Future<String> syncBloodPressure() async {
    return _invokeString(BandFitConstants.GET_SYNC_BP);
  }

  /// Triggers a blood-oxygen data sync from the band.
  Future<String> syncOxygenSaturation() async {
    return _invokeString(BandFitConstants.GET_SYNC_OXYGEN);
  }

  /// Triggers a sport and workout history sync from the band.
  Future<String> syncAllSportInfo() async {
    return _invokeString(BandFitConstants.GET_SYNC_SPORT_INFO);
  }

  /// Triggers a temperature data sync from the band.
  Future<String> syncTemperature() async {
    return _invokeString(BandFitConstants.GET_SYNC_TEMPERATURE);
  }

  /// Starts an on-demand blood-pressure measurement on the band.
  Future<String> startBloodPressure() async {
    return _invokeString(BandFitConstants.START_BP_TEST);
  }

  /// Stops an active on-demand blood-pressure measurement.
  Future<String> stopBloodPressure() async {
    return _invokeString(BandFitConstants.STOP_BP_TEST);
  }

  /// Starts an on-demand blood-oxygen (SpO2) measurement on the band.
  Future<String> startOxygenTest() async {
    return _invokeString(BandFitConstants.START_OXYGEN_TEST);
  }

  /// Stops an active on-demand blood-oxygen measurement.
  Future<String> stopOxygenTest() async {
    return _invokeString(BandFitConstants.STOP_OXYGEN_TEST);
  }

  /// Returns step records stored on the band for [dateTime].
  Future<Map<String, dynamic>> fetchStepsByDate(String dateTime) async {
    final result = await _invoke<dynamic>(
      BandFitConstants.FETCH_STEPS_BY_DATE,
      _dateParam(dateTime),
    );
    return _decodeMap(result);
  }

  /// Returns sleep records stored on the band for [dateTime].
  Future<Map<String, dynamic>> fetchSleepByDate(String dateTime) async {
    final result = await _invoke<dynamic>(
      BandFitConstants.FETCH_SLEEP_BY_DATE,
      _dateParam(dateTime),
    );
    return _decodeMap(result);
  }

  /// Returns blood-pressure records stored on the band for [dateTime].
  Future<Map<String, dynamic>> fetchBPByDate(String dateTime) async {
    final result = await _invoke<dynamic>(
      BandFitConstants.FETCH_BP_BY_DATE,
      _dateParam(dateTime),
    );
    return _decodeMap(result);
  }

  /// Returns heart-rate records stored on the band for [dateTime].
  Future<Map<String, dynamic>> fetchHeartRateByDate(String dateTime) async {
    final result = await _invoke<dynamic>(
      BandFitConstants.FETCH_HR_BY_DATE,
      _dateParam(dateTime),
    );
    return _decodeMap(result);
  }

  /// Returns 24-hour heart-rate records for [dateTime].
  Future<Map<String, dynamic>> fetch24HourHRByDate(String dateTime) async {
    final result = await _invoke<dynamic>(
      BandFitConstants.FETCH_24_HOUR_HR_BY_DATE,
      _dateParam(dateTime),
    );
    return _decodeMap(result);
  }

  /// Returns blood-oxygen records stored on the band for [dateTime].
  Future<Map<String, dynamic>> fetchOxygenByDate(String dateTime) async {
    final result = await _invoke<dynamic>(
      BandFitConstants.FETCH_OXYGEN_BY_DATE,
      _dateParam(dateTime),
    );
    return _decodeMap(result);
  }

  /// Returns temperature records stored on the band for [dateTime].
  Future<Map<String, dynamic>> fetchTemperatureByDate(String dateTime) async {
    final result = await _invoke<dynamic>(
      BandFitConstants.FETCH_TEMP_BY_DATE,
      _dateParam(dateTime),
    );
    return _decodeMap(result);
  }

  /// Returns all step records currently stored on the band.
  Future<Map<String, dynamic>> fetchAllStepsData() async {
    final result =
        await _invoke<dynamic>(BandFitConstants.FETCH_ALL_STEPS_DATA);
    return _decodeMap(result);
  }

  /// Returns all sleep records currently stored on the band.
  Future<Map<String, dynamic>> fetchAllSleepData() async {
    final result =
        await _invoke<dynamic>(BandFitConstants.FETCH_ALL_SLEEP_DATA);
    return _decodeMap(result);
  }

  /// Returns all blood-pressure records currently stored on the band.
  Future<Map<String, dynamic>> fetchAllBPData() async {
    final result = await _invoke<dynamic>(BandFitConstants.FETCH_ALL_BP_DATA);
    return _decodeMap(result);
  }

  /// Returns all temperature records currently stored on the band.
  Future<Map<String, dynamic>> fetchAllTemperatureData() async {
    final result = await _invoke<dynamic>(BandFitConstants.FETCH_ALL_TEMP_DATA);
    return _decodeMap(result);
  }

  /// Returns all 24-hour heart-rate records currently stored on the band.
  Future<Map<String, dynamic>> fetchAllHr24Data() async {
    final result =
        await _invoke<dynamic>(BandFitConstants.FETCH_ALL_HR_24_DATA);
    return _decodeMap(result);
  }

  /// Starts a one-off temperature test on the band.
  Future<String> testTempData() async {
    return _invokeString(BandFitConstants.START_TEST_TEMP);
  }

  /// Subscribes to the main device [EventChannel] for real-time band events.
  void receiveEventListeners({
    BandDataCallback? onData,
    BandErrorCallback? onError,
    void Function()? onDone,
  }) {
    _eventChannelListener?.cancel();
    _eventChannelListener = _eventChannel
        .receiveBroadcastStream(BandFitConstants.BAND_EVENT_CHANNEL)
        .listen(
          onData,
          onError: onError,
          onDone: onDone,
          cancelOnError: false,
        );
  }

  /// Pauses delivery of main event-channel callbacks without cancelling.
  void pauseEventListeners() {
    _eventChannelListener?.pause();
  }

  /// Resumes a paused main event-channel subscription.
  ///
  /// Returns `true` if a paused listener was resumed.
  bool resumeEventListeners() {
    final listener = _eventChannelListener;
    if (listener == null || !listener.isPaused) return false;
    listener.resume();
    return true;
  }

  /// Cancels the main event-channel subscription.
  void cancelEventListeners() {
    _eventChannelListener?.cancel();
    _eventChannelListener = null;
  }

  /// Subscribes to blood-pressure test progress on a dedicated event channel.
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

  /// Pauses delivery of blood-pressure test callbacks without cancelling.
  void pauseBPListeners() {
    _bpChannelListener?.pause();
  }

  /// Resumes a paused blood-pressure test subscription.
  ///
  /// Returns `true` if a paused listener was resumed.
  bool resumeBPListeners() {
    final listener = _bpChannelListener;
    if (listener == null || !listener.isPaused) return false;
    listener.resume();
    return true;
  }

  /// Cancels the blood-pressure test event-channel subscription.
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
