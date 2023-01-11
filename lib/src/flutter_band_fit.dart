part of flutter_band_fit;

class FlutterBandFit {
  late MethodChannel _methodChannel;
  late EventChannel _eventChannel;
  late EventChannel _bpTestChannel;

  // late EventChannel _oxygenTestChannel;
  // late EventChannel _temperatureTestChannel;
  // late EventChannel _connectionChannel;

  static FlutterBandFit? _instance;
  Map? mapOptions;

  late StreamSubscription<dynamic> eventChannelListener;
  late StreamSubscription<dynamic> bpChannelListener;
  // late StreamSubscription<dynamic> oxygenChannelListener;
  // late StreamSubscription<dynamic> temperatureChannelListener;
//  late StreamSubscription<dynamic> connectionChannelListener;

  factory FlutterBandFit([options]) {
    if (_instance == null) {
      MethodChannel methodChannel = const MethodChannel(BandFitConstants.BAND_METHOD_CHANNEL);

      EventChannel eventChannel = const EventChannel(BandFitConstants.BAND_EVENT_CHANNEL); // temporary for stream events

      EventChannel bpTestChannel = const EventChannel(BandFitConstants.BAND_BP_TEST_CHANNEL);

      //EventChannel oxygenTestChannel = const EventChannel(BandFitConstants.SMART_OXYGEN_TEST_CHANNEL);

      // EventChannel temperatureTestChannel = const EventChannel(BandFitConstants.SMART_TEMP_TEST_CHANNEL);

      // EventChannel connectionChannel = EventChannel(BandFitConstants.SMART_CONNECTION_CHANNEL);

      //check if the option variable is AFOptions type or map type
      //assert(options is Map);
      // if (options is Map) {
      //_instance = FlutterBandFit.private(methodChannel, eventChannel, bpTestChannel, oxygenTestChannel, temperatureTestChannel,  mapOptions: options);
      //_instance = FlutterBandFit.private(methodChannel, eventChannel, bpTestChannel, temperatureTestChannel,  mapOptions: options);
      _instance = FlutterBandFit.private(methodChannel, eventChannel, bpTestChannel,  mapOptions: options);
      // }
    }
    return _instance!;
  }

  @visibleForTesting
  FlutterBandFit.private(this._methodChannel, this._eventChannel, this._bpTestChannel, {this.mapOptions});


  Future<String> initializeDeviceConnection() async {
    var result = await _methodChannel.invokeMethod(BandFitConstants.DEVICE_INITIALIZE);
    // result can be status ==
    // SC_CANCELED if permission is not allowed,
    // SC_INIT if permission is allowed,
    // BLE_NOT_SUPPORTED if bluetooth device does not supports for v4.

    debugPrint('result>>$result');
    return result.toString().trim();
    /*if (result != null && result.toString().isNotEmpty) {
      if (result.toString() == BandFitConstants.SC_INIT) {
        return true;
      }else  if (result.toString() == BandFitConstants.BLE_NOT_SUPPORTED){
        return false;
      }else{
        return false;
      }
    }else{
      return false;
    }*/
  }

  Future<String> getLastConnectedDeviceAddress() async {
    var result = await _methodChannel.invokeMethod(BandFitConstants.GET_LAST_DEVICE_ADDRESS);
    debugPrint('result>>$result');
    return result.toString().trim();
  }


  Future<bool> connectLastDeviceAddress() async {
    return await _methodChannel.invokeMethod(BandFitConstants.CONNECT_LAST_DEVICE);
  }

  Future<bool> clearGattDisconnect() async {
    return await _methodChannel.invokeMethod(BandFitConstants.CLEAR_GATT_DISCONNECT);
  }

  Future<bool> checkFindBand() async {
    return await _methodChannel.invokeMethod(BandFitConstants.CHECK_FIND_BAND);
  }

  Future<String> findBandDevice() async{
    return await _methodChannel.invokeMethod(BandFitConstants.FIND_BAND_DEVICE);
  }

  Future<String> resetDevicesAllData() async{
    return await _methodChannel.invokeMethod(BandFitConstants.RESET_DEVICE_DATA);
  }

  Future<bool> checkDialSupport() async {
    return await _methodChannel.invokeMethod(BandFitConstants.CHECK_DIAL_SUPPORT);
  }

  Future<String> readOnlineDialConfig() async{
    return await _methodChannel.invokeMethod(BandFitConstants.READ_ONLINE_DIAL_CONFIG);
  }

  Future<String> prepareSendOnlineDialData() async{
    return await _methodChannel.invokeMethod(BandFitConstants.PREPARE_SEND_ONLINE_DIAL);
  }

  Future<String> listenWatchDialProgress() async{
    return await _methodChannel.invokeMethod(BandFitConstants.LISTEN_WATCH_DIAL_PROGRESS);
  }

  Future<String> sendOnlineDialPath(String filePath) async{
    var params = {
      "path": filePath, //bandData --send downloaded dial file path
    };
    return await _methodChannel.invokeMethod(BandFitConstants.SEND_ONLINE_DIAL_PATH, params);
  }

  Future<String> sendOnlineDialData(dynamic bandData) async{
    var params = {
      "data": bandData, //bandData --send always band data as byte[] array
    };
    return await _methodChannel.invokeMethod(BandFitConstants.SEND_ONLINE_DIAL_DATA, params);
  }

  Future<String> stopOnlineDialData() async{
    return await _methodChannel.invokeMethod(BandFitConstants.STOP_ONLINE_DIAL_DATA);
  }


  /*Future<String> bleReInitialize() async {
    var result = await _methodChannel.invokeMethod(BandFitConstants.BLE_RE_INITIALIZE);
    debugPrint('result>>$result');
    return result.toString().trim();
  }*/
  Future<int> getAndroidDeviceSDKIntVersion() async {
    int result = await _methodChannel.invokeMethod(BandFitConstants.ANDROID_DEVICE_SDK_INT);
    debugPrint('intVersion>>$result');
    return result;
  }

  Future<String> reInitializeBlueConnection() async {
    var result = await _methodChannel.invokeMethod(BandFitConstants.DEVICE_RE_INITIATE);
    debugPrint('result>>$result');
    return result.toString().trim();
  }

  Future<List<BandDeviceModel>> startSearchingDevices() async {
    var resultDevices = await _methodChannel.invokeMethod(BandFitConstants.START_DEVICE_SEARCH);
    debugPrint('resultDevices>> $resultDevices');
    if (resultDevices != null) {
      List<BandDeviceModel> deviceList = [];
      Map<String, dynamic> responseBody = jsonDecode(resultDevices);
      // List<dynamic> responseData = jsonDecode(responseBody["data"]);
      List<dynamic> responseData = responseBody["data"];
      for (var data in responseData) {
        deviceList.add(BandDeviceModel.fromJson(data));
      }
      debugPrint('deviceList>> $deviceList');
      //List<BandDeviceModel> deviceList = new ;
      return deviceList;
    } else {
      return [];
    }
  }

  Future<dynamic> stopSearchingDevices() async {
    return await _methodChannel.invokeMethod(BandFitConstants.STOP_DEVICE_SEARCH);
  }

  Future<bool> connectDevice(BandDeviceModel deviceModel) async{
    var deviceParams = {
      // 'index': deviceModel.index,
      'name': deviceModel.name,
      'address': deviceModel.address,
      // 'rssi': deviceModel.rssi,
      // 'alias': deviceModel.alias,
      // 'deviceType': deviceModel.deviceType,
      // 'bondState': deviceModel.bondState,
    };
    return await _methodChannel.invokeMethod(BandFitConstants.BIND_DEVICE, deviceParams);
  }

  Future<bool> reConnectDevice(BandDeviceModel deviceModel) async{
    var deviceParams = {
      'name': deviceModel.name,
      'address': deviceModel.address,
      'identifier': deviceModel.identifier,
    };
    return await _methodChannel.invokeMethod(BandFitConstants.RE_BIND_DEVICE, deviceParams);
  }

  Future<bool> disconnectDevice() async{
    return await _methodChannel.invokeMethod(BandFitConstants.UNBIND_DEVICE);
  }

  Future<String> setUserParameters(var userParams) async{
    //ex. sample paylod
    /* var userParamsSample = {
      "age":"50",  // user age (0-254)
      "height":"50", // always cm
      "weight":"50", // always in kgs
      "gender":"male", //male  or female in lower case
      "steps": "11000", // targetted goals
      "isCelsius": "true", // if celsius then send "true" else "false" for Fahrenheit
      "screenOffTime": "15", //screen off time
      "isChineseLang": "false", //true for chinese lang setup and false for english
      "raiseHandWakeUp": "false", //true or false -- send true to wake up bright light switch
    };*/
    return await _methodChannel.invokeMethod(BandFitConstants.SET_USER_PARAMS, userParams);
  }

  Future<String> set24HeartRate(bool enable) async{
    var params = {
      "enable": enable?"true":"false", //true or false -- send true to enable the 24 hrs sync
    };
    return await _methodChannel.invokeMethod(BandFitConstants.SET_24_HEART_RATE, params);
  }

  Future<String> set24BloodOxygen(bool enable) async{
    var params = {
      "enable": enable?"true":"false", //true or false -- send true to enable the 24 hrs sync
    };
    return await _methodChannel.invokeMethod(BandFitConstants.SET_24_OXYGEN, params);
  }

  Future<String> set24HrTemperatureTest(String interval, bool isEnabled) async{
    //Mandatory:: interval is always in minutes
    // The settable intervals are 1 minute, 5 minutes, 10 minutes, 30 minutes, 1 hour, 2 hours, 3 hours, 4 hours, 6 hours, 8 hours, 12 hours, 24 hours
    // If set to 30 minutes, Interval = 30, set to 3 hours, then Interval = 3
    // calculations are done, inside the plugin, internally
    var params = {
      "interval": interval, //interval is always in minutes
      "enable": isEnabled ? "true":"false",
    };
    return await _methodChannel.invokeMethod(BandFitConstants.SET_24_TEMPERATURE_TEST, params);
  }

  Future<String> setWeatherInfoSevenDays(String data) async{
    var params = {
      "data": data,
    };
    return await _methodChannel.invokeMethod(BandFitConstants.SET_WEATHER_INFO, params);
  }

  Future<String> setDeviceBandLanguage(String lang) async{
    var params = {
      "lang": lang, //either es or en
    };
    return await _methodChannel.invokeMethod(BandFitConstants.SET_BAND_LANGUAGE, params);
  }

  Future<String> setRejectIncomingCall(bool enable) async{
    var params = {
      "enable": enable?"true":"false", //true or false -- send true to enable it
    };
    return await _methodChannel.invokeMethod(BandFitConstants.SET_REJECT_CALL, params);
  }

  Future<String> setDoNotDisturb(bool isMessageOn, bool isMotorOn, bool disturbTimeSwitch, String fromHr, String fromMin, String toHour, String toMin) async{
    var params = {
      "isMessageOn": isMessageOn?"true":"false", //true or false -- send true to enable it
      "isMotorOn": isMotorOn?"true":"false", //true or false -- send true to enable it
      "disturbTimeSwitch": disturbTimeSwitch?"true":"false", //true or false -- send true to enable it
      "from_time_hour": fromHr != null ?fromHr.padLeft(2, "0"):"", // send integer value as string
      "from_time_minute": fromMin != null ? fromMin.padLeft(2, "0"):"",// send integer value as string
      "to_time_hour": toHour != null ? toHour.padLeft(2, "0"):"", // send integer value as string
      "to_time_minute": toMin != null ? toMin.padLeft(2, "0"):"", // send integer value as string
    };
    return await _methodChannel.invokeMethod(BandFitConstants.SET_DO_NOT_DISTURB, params);
  }

  Future<Map<String, dynamic>> fetchDeviceDataInfo() async{
    var _result =  await _methodChannel.invokeMethod(BandFitConstants.GET_DEVICE_DATA_INFO);
    debugPrint("device_data_reaponse>> $_result");
    if (_result != null) {
      Map<String, dynamic> response = jsonDecode(_result);
      return response;
    }else{
      return {};
    }
  }

  Future<Map<String, dynamic>> fetchOverAllByDate(String dateTime) async{
    var params = {
      "dateTime":dateTime,  // dateTime is mandatory to pass
    };
    //returns result status == SC_INIT or SC_FAILURE
    var result = await _methodChannel.invokeMethod(BandFitConstants.FETCH_OVERALL_BY_DATE, params);
    var returnResponse = <String, dynamic>{};
    if (result != null) {
      if(result.toString().isNotEmpty){
        if (result.toString() == BandFitConstants.SC_FAILURE) {
          returnResponse ={
            "status": BandFitConstants.SC_FAILURE,
            "data":""
          };
        }else if (result.toString() == BandFitConstants.SC_DISCONNECTED) {
          returnResponse ={
            "status": BandFitConstants.SC_DISCONNECTED,
            "data":""
          };
        }else{
          Map<String, dynamic> response = jsonDecode(result);
          returnResponse ={
            "status": BandFitConstants.SC_SUCCESS,
            "data":response
          };
        }
        return returnResponse;
      }else {
        return returnResponse;
      }
    }else{
      return returnResponse;
    }
  }

  Future<Map<String, dynamic>> fetchOverAllDeviceData() async{
    //returns result status == SC_INIT or SC_FAILURE
    var result = await _methodChannel.invokeMethod(BandFitConstants.FETCH_OVERALL_DEVICE_DATA);
    var returnResponse = <String, dynamic>{};
    if (result != null) {
      if(result.toString().isNotEmpty){
        if (result.toString() == BandFitConstants.SC_FAILURE) {
          returnResponse ={
            "status": BandFitConstants.SC_FAILURE,
            "data":""
          };
        }else if (result.toString() == BandFitConstants.SC_DISCONNECTED) {
          returnResponse ={
            "status": BandFitConstants.SC_DISCONNECTED,
            "data":""
          };
        }else{
          Map<String, dynamic> response = jsonDecode(result);
          returnResponse ={
            "status": BandFitConstants.SC_SUCCESS,
            "data":response
          };
        }
        return returnResponse;
      }else {
        return returnResponse;
      }
    }else{
      return returnResponse;
    }
  }


  Future<String> getDeviceVersion() async{
    return  await _methodChannel.invokeMethod(BandFitConstants.GET_DEVICE_VERSION);
  }

  Future<String> getBatteryStatus() async{
    return  await _methodChannel.invokeMethod(BandFitConstants.GET_DEVICE_BATTERY_STATUS);
  }

  Future<bool> checkConectionStatus() async{
    return await _methodChannel.invokeMethod(BandFitConstants.CHECK_CONNECTION_STATUS);
  }

  Future<String> callQuickSwitchSettingStatus() async{
    return  await _methodChannel.invokeMethod(BandFitConstants.CHECK_QUICK_SWITCH_SETTING);
  }


  Future<String> syncStepsData() async{
    //returns result status == SC_INIT or SC_FAILURE or SC_DISCONNECTED (if the device gor disconnected)
    return await _methodChannel.invokeMethod(BandFitConstants.GET_SYNC_STEPS);
  }

  Future<Map<String, dynamic>> fetchAllJudgement() async{
    //returns result status == SC_INIT or SC_FAILURE or SC_DISCONNECTED (if the device gor disconnected)
    var result =  await _methodChannel.invokeMethod(BandFitConstants.SYNC_ALL_JUDGE);
    debugPrint("judgement_reaponse>> $result");
    var returnResponse = <String, dynamic>{};
    if (result != null) {
      if(result.toString().isNotEmpty){
        if (result.toString() == BandFitConstants.SC_FAILURE) {
          returnResponse ={
            "status": BandFitConstants.SC_FAILURE,
            "data":""
          };
        }else if (result.toString() == BandFitConstants.SC_DISCONNECTED) {
          returnResponse ={
            "status": BandFitConstants.SC_DISCONNECTED,
            "data":""
          };
        }else{
          Map<String, dynamic> response = jsonDecode(result);
          returnResponse ={
            "status": BandFitConstants.SC_SUCCESS,
            "data":response
          };
        }
        return returnResponse;
      }else {
        return returnResponse;
      }
    }else{
      return returnResponse;
    }
  }

  Future<String> syncSleepData() async{
    //returns result status == SC_INIT or SC_FAILURE or SC_DISCONNECTED (if the device gor disconnected)
    return await _methodChannel.invokeMethod(BandFitConstants.GET_SYNC_SLEEP);
  }

  Future<String> syncRateData() async{
    //returns result status == SC_INIT or SC_FAILURE or SC_DISCONNECTED (if the device gor disconnected)
    return await _methodChannel.invokeMethod(BandFitConstants.GET_SYNC_RATE);
  }

  Future<String> syncBloodPressure() async{
    //returns result status == SC_INIT or SC_FAILURE or SC_DISCONNECTED (if the device gor disconnected)
    return await _methodChannel.invokeMethod(BandFitConstants.GET_SYNC_BP);
  }

  Future<String> syncOxygenSaturation() async{
    //returns result status == SC_INIT or SC_FAILURE or SC_DISCONNECTED (if the device gor disconnected)
    return await _methodChannel.invokeMethod(BandFitConstants.GET_SYNC_OXYGEN);
  }

  Future<String> syncAllSportInfo() async{
    //returns result status == SC_INIT or SC_FAILURE or SC_DISCONNECTED (if the device gor disconnected)
    return await _methodChannel.invokeMethod(BandFitConstants.GET_SYNC_SPORT_INFO);
  }


  Future<String> syncTemperature() async{
    //returns result status == SC_INIT or SC_FAILURE or SC_DISCONNECTED (if the device gor disconnected)
    return await _methodChannel.invokeMethod(BandFitConstants.GET_SYNC_TEMPERATURE);
  }

  Future<String> startBloodPressure() async{
    //returns result status == SC_INIT or SC_FAILURE or SC_DISCONNECTED (if the device gor disconnected)
    return await _methodChannel.invokeMethod(BandFitConstants.START_BP_TEST);
  }
  Future<String> stopBloodPressure() async{
    //returns result status == SC_INIT or SC_FAILURE or SC_DISCONNECTED (if the device gor disconnected)
    return await _methodChannel.invokeMethod(BandFitConstants.STOP_BP_TEST);
  }

  /*Future<String> startHR() async{
    //returns result status == SC_INIT or SC_FAILURE or SC_DISCONNECTED (if the device gor disconnected)
    return await _methodChannel.invokeMethod(BandFitConstants.START_HR_TEST);
  }
  Future<String> stopHR() async{
    //returns result status == SC_INIT or SC_FAILURE or SC_DISCONNECTED (if the device gor disconnected)
    return await _methodChannel.invokeMethod(BandFitConstants.STOP_HR_TEST);
  }*/

  Future<String> startOxygenTest() async{
    //returns result status == SC_INIT or SC_FAILURE or SC_DISCONNECTED (if the device gor disconnected)
    return await _methodChannel.invokeMethod(BandFitConstants.START_OXYGEN_TEST);
  }

  Future<String> stopOxygenTest() async{
    //returns result status == SC_INIT or SC_FAILURE or SC_DISCONNECTED (if the device gor disconnected)
    return await _methodChannel.invokeMethod(BandFitConstants.STOP_OXYGEN_TEST);
  }


  Future<Map<String, dynamic>> fetchStepsByDate(String dateTime) async{
    // dateTime = "yyyyMMdd" // 20220212
    //returns result status == SC_INIT or SC_FAILURE or SC_DISCONNECTED (if the device gor disconnected)
    var params = {
      "dateTime":dateTime,  // dateTime is mandatory to pass
    };
    var _result =  await _methodChannel.invokeMethod(BandFitConstants.FETCH_STEPS_BY_DATE, params);
    debugPrint("result_response>> $_result");
    if (_result != null) {
      Map<String, dynamic> response = jsonDecode(_result);
      return response;
    }else{
      return {};
    }
  }

  Future<Map<String, dynamic>> fetchSleepByDate(String dateTime) async{
    // dateTime = "yyyyMMdd" // 20220103
    //returns result status == SC_INIT or SC_FAILURE or SC_DISCONNECTED (if the device gor disconnected)
    // state // deep sleep: 0, Light sleep: 1,  awake: 2
    var params = {
      "dateTime":dateTime,  // dateTime is mandatory to pass
    };
    var _result =  await _methodChannel.invokeMethod(BandFitConstants.FETCH_SLEEP_BY_DATE, params);
    debugPrint("sleep_reaponse>> $_result");
    if (_result != null) {
      Map<String, dynamic> response = jsonDecode(_result);
      return response;
    }else{
      return {};
    }
  }

  Future<Map<String, dynamic>> fetchBPByDate(String dateTime) async{
    // dateTime = "yyyyMMdd" // 20220103
    //returns result status == SC_INIT or SC_FAILURE or SC_DISCONNECTED (if the device gor disconnected)
    // state // deep sleep: 0, Light sleep: 1,  awake: 2
    var params = {
      "dateTime":dateTime,  // dateTime is mandatory to pass
    };
    var _result =  await _methodChannel.invokeMethod(BandFitConstants.FETCH_BP_BY_DATE, params);
    debugPrint("sleep_reaponse>> $_result");
    if (_result != null) {
      Map<String, dynamic> response = jsonDecode(_result);
      return response;
    }else{
      return {};
    }
  }

  Future<Map<String, dynamic>> fetchHeartRateByDate(String dateTime) async{
    // dateTime = "yyyyMMdd" // 20220103
    //returns result status == SC_INIT or SC_FAILURE or SC_DISCONNECTED (if the device gor disconnected)
    // state // deep sleep: 0, Light sleep: 1,  awake: 2
    var params = {
      "dateTime":dateTime,  // dateTime is mandatory to pass
    };
    var _result =  await _methodChannel.invokeMethod(BandFitConstants.FETCH_HR_BY_DATE, params);
    debugPrint("hr_reaponse>> $_result");
    if (_result != null) {
      Map<String, dynamic> response = jsonDecode(_result);
      return response;
    }else{
      return {};
    }
  }

  Future<Map<String, dynamic>> fetch24HourHRByDate(String dateTime) async{
    // dateTime = "yyyyMMdd" // 20220103
    //returns result status == SC_INIT or SC_FAILURE or SC_DISCONNECTED (if the device gor disconnected)
    // state // deep sleep: 0, Light sleep: 1,  awake: 2
    var params = {
      "dateTime":dateTime,  // dateTime is mandatory to pass
    };
    var _result =  await _methodChannel.invokeMethod(BandFitConstants.FETCH_24_HOUR_HR_BY_DATE, params);
    debugPrint("hr_reaponse>> $_result");
    if (_result != null) {
      Map<String, dynamic> response = jsonDecode(_result);
      return response;
    }else{
      return {};
    }
  }

  Future<Map<String, dynamic>> fetchOxygenByDate(String dateTime) async{
    // dateTime = "yyyyMMdd" // 20220103
    //returns result status == SC_INIT or SC_FAILURE or SC_DISCONNECTED (if the device gor disconnected)
    // state // deep sleep: 0, Light sleep: 1,  awake: 2
    var params = {
      "dateTime":dateTime,  // dateTime is mandatory to pass
    };
    var _result =  await _methodChannel.invokeMethod(BandFitConstants.FETCH_OXYGEN_BY_DATE, params);
    debugPrint("oxy_reaponse>> $_result");
    if (_result != null) {
      Map<String, dynamic> response = jsonDecode(_result);
      return response;
    }else{
      return {};
    }
  }

  Future<Map<String, dynamic>> fetchTemperatureByDate(String dateTime) async{
    // dateTime = "yyyyMMdd" // 20220103
    //returns result status == SC_INIT or SC_FAILURE or SC_DISCONNECTED (if the device gor disconnected)
    // state // deep sleep: 0, Light sleep: 1,  awake: 2
    var params = {
      "dateTime":dateTime,  // dateTime is mandatory to pass
    };
    var _result =  await _methodChannel.invokeMethod(BandFitConstants.FETCH_TEMP_BY_DATE, params);
    debugPrint("temp_reaponse>> $_result");
    if (_result != null) {
      Map<String, dynamic> response = jsonDecode(_result);
      return response;
    }else{
      return {};
    }
  }

  Future<Map<String, dynamic>> fetchAllStepsData() async{
    var result =  await _methodChannel.invokeMethod(BandFitConstants.FETCH_ALL_STEPS_DATA);
    debugPrint("all_reaponse>> $result");
    if (result != null) {
      Map<String, dynamic> response = jsonDecode(result);
      return response;
    }else{
      return {};
    }
  }

  Future<Map<String, dynamic>> fetchAllSleepData() async{
    var result =  await _methodChannel.invokeMethod(BandFitConstants.FETCH_ALL_SLEEP_DATA);
    debugPrint("sleep_reaponse>> $result");
    if (result != null) {
      Map<String, dynamic> response = jsonDecode(result);
      return response;
    }else{
      return {};
    }
  }

  Future<Map<String, dynamic>> fetchAllBPData() async{
    var result =  await _methodChannel.invokeMethod(BandFitConstants.FETCH_ALL_BP_DATA);
    debugPrint("bp_reaponse>> $result");
    if (result != null) {
      Map<String, dynamic> response = jsonDecode(result);
      return response;
    }else{
      return {};
    }
  }

  Future< Map<String, dynamic>> fetchAllTemperatureData() async{
    var result =  await _methodChannel.invokeMethod(BandFitConstants.FETCH_ALL_TEMP_DATA);
    debugPrint("temp_reaponse>> $result");
    if (result != null) {
      Map<String, dynamic> response = jsonDecode(result);
      return response;
    }else{
      return {};
    }
  }

  Future< Map<String, dynamic>> fetchAllHr24Data() async{
    var result =  await _methodChannel.invokeMethod(BandFitConstants.FETCH_ALL_HR_24_DATA);
    debugPrint("hr_reaponse>> $result");
    if (result != null) {
      Map<String, dynamic> response = jsonDecode(result);
      return response;
    }else{
      return {};
    }
  }

  Future<String> testTempData() async{
    //returns result status == SC_INIT or SC_FAILURE or SC_DISCONNECTED (if the device gor disconnected)
    return await _methodChannel.invokeMethod(BandFitConstants.START_TEST_TEMP);
  }

  /*void onDeviceCallbackData(Function callback) async {
    await startListening(callback as void Function(dynamic), BandFitConstants.SMART_CALLBACK);
  }

  void onCancelCallbackData() async {
   // stopListening(callback as void Function(), BandFitConstants.SMART_CALLBACK);
  }*/

  /* Stream<dynamic> registerEventCallBackListeners(){
    return _eventChannel.receiveBroadcastStream();
  }*/

  void receiveEventListeners({Function(dynamic)? onData, Function(dynamic)? onError, Function()? onDone}) {
    eventChannelListener = _eventChannel.receiveBroadcastStream(BandFitConstants.BAND_EVENT_CHANNEL).listen(onData,onError:onError, onDone: onDone, cancelOnError: false);
  }

  void pauseEventListeners(){
    eventChannelListener.pause();
  }

  bool resumeEventListeners(){
    if (eventChannelListener.isPaused) {
      eventChannelListener.resume();
      return true;
    }else{
      return false;
    }
  }

  void cancelEventListeners(){
    eventChannelListener.cancel();
  }

  void receiveBPListeners({Function(dynamic)? onData, Function(dynamic)? onError, Function()? onDone}) {
    bpChannelListener = _bpTestChannel.receiveBroadcastStream(BandFitConstants.BAND_BP_TEST_CHANNEL).listen(onData,onError:onError, onDone: onDone, cancelOnError: false);
  }

  void pauseBPListeners(){
    bpChannelListener.pause();
  }

  bool resumeBPListeners(){
    if (bpChannelListener.isPaused) {
      bpChannelListener.resume();
      return true;
    }else{
      return false;
    }
  }

  void cancelBPListeners(){
    bpChannelListener.cancel();
  }

  /* void receiveConnectionListeners({Function(dynamic)? onData, Function(dynamic)? onError, Function()? onDone}) {
    connectionChannelListener = _eventChannel.receiveBroadcastStream().listen(onData,onError:onError, onDone: onDone, cancelOnError: false);
  }

  void pauseConnectionListeners(){
    connectionChannelListener.pause();
  }

  bool resumeConnectionListeners(){
    if (connectionChannelListener.isPaused) {
      connectionChannelListener.resume();
      return true;
    }else{
      return false;
    }
  }

  void cancelConnectionListeners(){
    connectionChannelListener.cancel();
  }*/

  /*void receiveOxygenListeners({Function(dynamic)? onData, Function(dynamic)? onError, Function()? onDone}) {
    oxygenChannelListener = _oxygenTestChannel.receiveBroadcastStream(BandFitConstants.SMART_OXYGEN_TEST_CHANNEL).listen(onData,onError:onError, onDone: onDone, cancelOnError: false);
  }

  void pauseOxygenListeners(){
    oxygenChannelListener.pause();
  }

  bool resumeOxygenListeners(){
    if (oxygenChannelListener.isPaused) {
      oxygenChannelListener.resume();
      return true;
    }else{
      return false;
    }
  }

  void cancelOxygenListeners(){
    oxygenChannelListener.cancel();
  }*/



/*  void receiveTemperatureListeners({Function(dynamic)? onData, Function(dynamic)? onError, Function()? onDone}) {
    temperatureChannelListener = _temperatureTestChannel.receiveBroadcastStream(BandFitConstants.SMART_TEMP_TEST_CHANNEL).listen(onData,onError:onError, onDone: onDone, cancelOnError: false);
  }

  void pauseTemperatureListeners(){
    temperatureChannelListener.pause();
  }

  bool resumeTemperatureListeners(){
    if (temperatureChannelListener.isPaused) {
      temperatureChannelListener.resume();
      return true;
    }else{
      return false;
    }
  }

  void cancelTemperatureListeners(){
    temperatureChannelListener.cancel();
  }*/



/*Future<Map<String, dynamic>> getDeviceVersion() async{
    //returns result status == SC_INIT or SC_FAILURE
    var result = await _methodChannel.invokeMethod(BandFitConstants.GET_DEVICE_VERSION);
    var returnResponse;
    if (result != null) {
      if(result.toString().isNotEmpty){
        if (result.toString() == BandFitConstants.SC_FAILURE) {
          returnResponse ={
            "status": BandFitConstants.SC_FAILURE,
            "data":""
          };
        }else if (result.toString() == BandFitConstants.SC_DISCONNECTED) {
          returnResponse ={
            "status": BandFitConstants.SC_DISCONNECTED,
            "data":""
          };
        }else{
          Map<String, dynamic> response = jsonDecode(result);
          returnResponse ={
            "status": BandFitConstants.SC_SUCCESS,
            "data":response
          };
        }
        return returnResponse;
      }else {
        return returnResponse;
      }
    }else{
      return returnResponse;
    }
  }*/

/*Future<Map<String, dynamic>> getBatteryStatus() async{
    //returns result status == SC_INIT or SC_FAILURE or SC_DISCONNECTED (if the device gor disconnected)
    var result = await _methodChannel.invokeMethod(BandFitConstants.GET_DEVICE_BATTERY_STATUS);
    var returnResponse;
    if (result != null) {
      if(result.toString().isNotEmpty){
        if (result.toString() == BandFitConstants.SC_FAILURE) {
          returnResponse ={
            "status": BandFitConstants.SC_FAILURE,
            "data":""
          };
        }else if (result.toString() == BandFitConstants.SC_DISCONNECTED) {
          returnResponse ={
            "status": BandFitConstants.SC_DISCONNECTED,
            "data":""
          };
        }else{
          Map<String, dynamic> response = jsonDecode(result);
          returnResponse ={
            "status": BandFitConstants.SC_SUCCESS,
            "data":response
          };
        }
        return returnResponse;
      }else {
        return returnResponse;
      }
    }else{
      return returnResponse;
    }
  }*/


/*void registerCallBackListeners(Function callback) async{
    _eventChannel.receiveBroadcastStream().listen((data) {
      var decodedJSON = jsonDecode(data);

      debugPrint('register_call_back: $decodedJSON');
      return decodedJSON;
     // String? status = decodedJSON['status'];
    });
  }*/

/*static const MethodChannel _channel = const MethodChannel('mobile_smart_watch');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }*/
  
  Future<String?> getPlatformVersion() {
    return FlutterBandFitPlatform.instance.getPlatformVersion();
  }
}
