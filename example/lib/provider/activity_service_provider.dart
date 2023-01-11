import 'package:flutter_band_fit_app/common/common_imports.dart';
//import 'package:flutter_band_fit_app/model/weather_model.dart';
import 'package:flutter_band_fit_app/utils/shared_service.dart';
import 'package:get/get.dart';
//import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

class ActivityServiceProvider extends GetxController {

  String targetedSteps = defaultTargetedSteps;
  String get getTargetedSteps => targetedSteps.obs.string;

  final FlutterBandFit flutterBandFit = FlutterBandFit();
  // user profile related variables

  late  String userHeight;
  String get getUserHeight => userHeight;
  late  String userWeight;
  String get getUserWeight => userWeight;
  late  String userGender;
  String get getUserGender => userGender;
  late  String userAge;
  String get getUserAge => userAge;
  late  String userDOB;
  String get getUserDOB => userDOB;
  late  String userBMI;
  String get getUserBMI => userBMI;
  late String userBMIStatus;
  String get getUserBMIStatus => userBMIStatus;
  String screenOffTime = screenOffTimeMin.toString();
  String get getScreenOffTime => screenOffTime;


  //device related variables
  bool deviceConnected = false;
  bool get getDeviceConnected => deviceConnected;

  bool healthConnected = false; // for g-fit and apple fit
  bool get getHealthConnected => healthConnected;

  late double deviceLatitude;
  double get getDeviceLatitude => deviceLatitude;

  late double deviceLongitude;
  double get getDeviceLongitude => deviceLongitude;

  String deviceCityName = '';
  String get getDeviceCityName => deviceCityName;

  bool oxygenAvailable = false;
  bool get getOxygenAvailable => oxygenAvailable;

  bool hr24Enabled = false;
  bool get getHR24Enabled => hr24Enabled;

  bool temperature24Enabled = false;
  bool get getTemperature24Enabled => temperature24Enabled;

  bool oxygen24Enabled = false;
  bool get getOxygen24Enabled => oxygen24Enabled;

  bool dndEnabled = false;
  bool get getDndEnabled => dndEnabled;

  String dndEnabledTime = '';
  String get getDNDEnabledTime => dndEnabledTime;

  bool messagesOnEnabled = false;
  bool get getMessagesOnEnabled => messagesOnEnabled;

  bool motorVibrateEnabled = false;
  bool get getMotorVibrateEnabled => motorVibrateEnabled;

  String deviceMacAddress = '';
  String get getDeviceMacAddress => deviceMacAddress;

  String deviceSWName = '';
  String get getDeviceSWName => deviceSWName;

  String deviceVersion = '';
  String get getDeviceVersion => deviceVersion;

  String currentTemperature = '';
  String get getCurrentTemperature => currentTemperature;

  String currentWeatherUrl = '';
  String get getCurrentWeatherUrl => currentWeatherUrl;

  // late  WeatherMainModel weatherModelData;
  // WeatherMainModel get getWeatherModelData => weatherModelData;

  bool tempCelsius = false;
  bool get getIsCelsius => tempCelsius;

  bool raiseHandWakeUp = false;
  bool get getRaiseHandWakeUp => raiseHandWakeUp;

  int batteryPercentage = 0;
  int get getDeviceBatteryPercentage => batteryPercentage;

  int stepsValue = 0;
  int get getSteps => stepsValue;

  String caloriesValue = '-';
  String get getCalories => caloriesValue;

  String distanceValue = '-';
  String get getDistance => distanceValue;

  String heartRateValue = '-';
  String get getHRValue => heartRateValue;

  String hrDateTime = '';
  String get getHRDateTime => hrDateTime;

  String maxHrValue = '';
  String get getMaxHrValue => maxHrValue;

  String minHrValue = '';
  String get getMinHrValue => minHrValue;

  String avgHrValue = '';
  String get getAvgHrValue => avgHrValue;

  String bloodPressureValue = '-';
  String get getBloodPressure => bloodPressureValue;

  String bpDateTime = '';
  String get getBpDateTime => bpDateTime;

  String temperatureValue = '-';
  String get getTemperature => temperatureValue;

  String temperatureDateTime = '';
  String get getTemperatureDateTime => temperatureDateTime;

  String oxygenValue = '-';
  String get getOxygenValue => oxygenValue;

  String oxygenDateTime = '';
  String get getOxygenDateTime => oxygenDateTime;

  String sleepHrsValue = '-';
  String get getSleepHrs => sleepHrsValue;

  String sleepMinutesValue = '';
  String get getSleepMinutes => sleepMinutesValue;

  String sleepHrsDateTime = '';
  String get getSleepHrsDateTime => sleepHrsDateTime;

  double progressPercentage = 0;
  double get getProgressPercentage => progressPercentage;

  bool showSyncProgress = false;
  bool get isSyncProgress => showSyncProgress;

  String lastSyncDated = '';
  String get getLastSyncDated => lastSyncDated;

  String lastSyncDateTime = '';
  String get getLastSyncDateTime => lastSyncDateTime;

  String lastMacAddressId = '';
  String get getLastMacAddressId => lastMacAddressId;

  bool currentDataTime = true;
  bool get isCurrentDataTime => currentDataTime;

  List<String> calenderDateTimeList = [];
  List<String> get getCalenderDateTimeList => calenderDateTimeList;

  String weatherSyncDateTime = '';
  String get getWeatherSyncDateTime => weatherSyncDateTime;

  //dial related flags
  int _syncDialProgress = 0;
  int get getSyncDialProgress => _syncDialProgress;

   int _dialDownloadProgress = 0;
   int get getDialDownloadProgress => _dialDownloadProgress;

  bool dialDownloading = false;
  bool get isDialDownloading => dialDownloading;

  bool dialSyncing = false;
  bool get isDialSyncing => dialSyncing;

  bool dialSyncDone = false;
  bool get isDialSyncDone => dialSyncDone;

  //recent sync data from watch
  String overAllStepsData = '';
  String get getOverAllStepsData => overAllStepsData;

  String overAllSleepData = '';
  String get getOverAllSleepData => overAllSleepData;

  String overAllHrData = '';
  String get getOverAllHrData => overAllHrData;

  String overAllBPData = '';
  String get getOverAllBPData => overAllBPData;

  String overAllTempData = '';
  String get getOverAllTempData => overAllTempData;

  String overAllOxygenData = '';
  String get getOverAllOxygenData => overAllOxygenData;

  String jsonWeatherData = '';
  String get getJsonWeatherData => jsonWeatherData;

  // initializeMethods
  Future<void> initializeProvider() async {
    await fetchLocalDataAssign();
    // this.userSharedPref = await SharedPreferences.getInstance();
    //  fetch old data and assign based on device is connected.
    debugPrint("inside initializeProvider");
    update();
  }

  Future<void> fetchLocalDataAssign() async {
    targetedSteps = sharedService.getTargetedSteps();
    userGender = sharedService.getUserGender().toUpperCase();
    String? tempDob = sharedService.getUserDOB();
    if (tempDob != null) {
      userDOB = sharedService.getUserDOB()!;
      userAge = sharedService.getUserAge()!;
    }
    userHeight = sharedService.getUserHeight(); // always cm
    userWeight = sharedService.getUserWeight();
    userGender = sharedService.getUserGender();
    screenOffTime = sharedService.getScreenOffTime();
    userBMI = sharedService.getBMIValue();
    userBMIStatus = sharedService.getBMIStatus();

    //device related
    deviceConnected = sharedService.isSmartMConnected();
    healthConnected = sharedService.isHealthConnected();
    oxygenAvailable = sharedService.isOxygenAvailable();

    hr24Enabled = sharedService.isHeartRate24HrEnabled();
    oxygen24Enabled = sharedService.isOxygen24HrEnabled();
    temperature24Enabled = sharedService.isTemperatureEnabled();

    dndEnabled = sharedService.isDNDEnabled();
    dndEnabledTime = sharedService.getDNDEnabledTime();
    messagesOnEnabled = sharedService.isMessagesOnEnabled();
    motorVibrateEnabled = sharedService.isMotorVibrateEnabled();

    deviceMacAddress = sharedService.getDeviceMacAddress();
    deviceSWName = sharedService.getDeviceName();
    deviceVersion = sharedService.getDeviceVersionId();
    batteryPercentage = int.parse(sharedService.getBatteryStatus());

    //get temperature unit.
    tempCelsius = sharedService.getIsTempCelsius();
    debugPrint('123>>tempCelsius>> $tempCelsius');
    raiseHandWakeUp = sharedService.getRaiseWakeUp();

    //overall device data
    overAllStepsData = sharedService.getOverAllSteps();
    overAllSleepData = sharedService.getOverAllSleep();
    overAllHrData = sharedService.getOverAllHeartRate();
    overAllBPData = sharedService.getOverAllBP();
    overAllTempData = sharedService.getOverAllTemperature();
    overAllOxygenData = sharedService.getOverAllOxygenData();

    // lastSyncDated = sharedService.getLastSyncDate();
    // lastSyncDateTime = sharedService.getLastSyncDateTime();
    weatherSyncDateTime = sharedService.getWeatherSyncDateTime();


    lastMacAddressId = sharedService.getLastMacAddressId();
    lastSyncDated = sharedService.getLastSyncDate();
    lastSyncDateTime = sharedService.getLastSyncDateTime();

    update();
    debugPrint('deviceSWNameLast>>$deviceSWName');
    debugPrint('deviceMacAddressLast>>$deviceMacAddress');
    //check for last sync data_time
    await verifyToSendCurrentData(lastSyncDated, lastSyncDateTime);

    // device city Name & lat & long
    String weatherResponse = '';
    if (sharedService.getDeviceCityName() != null && sharedService.getLatitude() != null) {
      deviceCityName = sharedService.getDeviceCityName()!;
      deviceLatitude = double.tryParse(sharedService.getLatitude()!)!;
      deviceLongitude = double.tryParse(sharedService.getLongitude()!)!;
      jsonWeatherData = sharedService.getJsonWeatherData()!;
      weatherResponse = sharedService.getWeatherResponseData()!;
    }

    debugPrint("isSmartMConnected>> $deviceConnected");
    update();
    await addRecentDataUI(weatherResponse);
    updateBMIWithHeightWeight(getUserHeight, getUserWeight, false);
  }



  Future<void> verifyToSendCurrentData(String lastSyncDated, String lastSyncDateTime, [DateTime? lastTime]) async {
    // will decide whether to send current data or list of date daa to the backend api
    DateTime currentTime = DateTime.now();
    bool currentData = true; // true always
    List<String> calenderDateList = [];

    debugPrint('getLastSyncDatedTime >> $lastSyncDated');
    if (lastSyncDated.isNotEmpty && lastSyncDateTime.isNotEmpty) {
      currentTime = DateTime.tryParse(lastSyncDateTime)!;
      //lastTime = DateTime.parse('20220401'); //static
      debugPrint('lastTime>> $currentTime');
      debugPrint('lastTimeDay>> ${currentTime.day}');

      int timeDifference = currentTimeDayDifference(currentTime);

      debugPrint('timeDifference>>$timeDifference');

      if (timeDifference >= 1) {
        currentData = false;
        calenderDateList = await GlobalMethods.getDatesListByLastDateTime(currentTime);
      } else {
        currentData = true;
      }
    }

    currentDataTime = currentData;
    calenderDateTimeList = calenderDateList;
    update();
    debugPrint('isCurrentDataTime>> $isCurrentDataTime');
    debugPrint('calenderDateTimeList>> $getCalenderDateTimeList');
  }

  Future<void> addRecentDataUI(String weatherResponse) async {
    try {
      //String calenderDateTime = GlobalMethods.convertBandReadableCalender(DateTime.now());
      //steps data
      if (overAllStepsData.isNotEmpty) {
        List<dynamic> recentStepsData = jsonDecode(overAllStepsData);
        //List<StepsMainModel> stepsTodayList = await getCurrentDaySteps(recentStepsData);
        List<StepsMainModel> stepsTodayList = [];
        if (Platform.isIOS) {
          stepsTodayList = await getSelectedDayStepsData(recentStepsData);
        } else {
          stepsTodayList = await getCurrentDaySteps(recentStepsData);
        }
        if (stepsTodayList.isNotEmpty) {
          StepsMainModel stepsMainModel = stepsTodayList[stepsTodayList.length - 1];
          updateDeviceStats(stepsMainModel.steps, stepsMainModel.distance, stepsMainModel.calories);
        }
      }

      if (overAllSleepData.isNotEmpty) {
        List recentSleepData = jsonDecode(overAllSleepData);
        List<SleepMainModel> sleepTodayList = [];
        if (Platform.isIOS) {
          sleepTodayList = await getSelectedDaySleepData(recentSleepData);
        } else {
          sleepTodayList = await getCurrentDaySleepData(recentSleepData);
        }

        if (sleepTodayList.isNotEmpty) {
          SleepMainModel sleepMainModel = sleepTodayList[sleepTodayList.length - 1];
          updateDeviceSleep(sleepMainModel.total, sleepMainModel.calender);
        }
      }
      if (overAllHrData.isNotEmpty) {
        List recentHrData = jsonDecode(overAllHrData);
        List<BandHRModel> smartHr24List = await getCurrentDayHRData(recentHrData);
        if (smartHr24List.isNotEmpty) {
          String hr24Value = smartHr24List[smartHr24List.length - 1].rate;
          String calender = smartHr24List[smartHr24List.length - 1].calender ?? '';
          String time = smartHr24List[smartHr24List.length - 1].time ?? '';
          String dateTime = getTimeByCalenderTime(calender, time);
          updateHearRate(hr24Value, dateTime);
        }
      }
      if (overAllBPData.isNotEmpty) {
        List recentBPData = jsonDecode(overAllBPData);
        List<BandBPModel> smartBpDataList = await getCurrentDayBPData(recentBPData);
        if (smartBpDataList.isNotEmpty) {
          String high = smartBpDataList[smartBpDataList.length - 1].high ?? '-';
          String low = smartBpDataList[smartBpDataList.length - 1].low ?? '-';
          String calender = smartBpDataList[smartBpDataList.length - 1].calender ?? '';
          String time = smartBpDataList[smartBpDataList.length - 1].time ?? '';
          String dateTime = getTimeByCalenderTime(calender, time);
          debugPrint('bp value $high /$low - $dateTime');
          updateBloodPressure('$high /$low', dateTime);
        }
      }
      if (overAllTempData.isNotEmpty) {
        List recentTempData = jsonDecode(overAllTempData);
        List<BandTempModel> smartTempData = await getCurrentDayTemperatureData(recentTempData);
        if (smartTempData.isNotEmpty) {
          String inFahrenheit = smartTempData[smartTempData.length - 1].inFahrenheit;
          String inCelsius = smartTempData[smartTempData.length - 1].inCelsius;
          String calender = smartTempData[smartTempData.length - 1].calender ?? '';
          String time = smartTempData[smartTempData.length - 1].time ?? '';
          //String startDate = smartTempData[smartTempData.length-1].startDate??'';
          String dateTime = getTimeByCalenderTime(calender, time);
          // debugPrint('inFahrenheit>> $inFahrenheit - $dateTime');
          updateTemperature(inCelsius, inFahrenheit, dateTime);
        }
      }
      //for oxygen
      if (overAllOxygenData.isNotEmpty) {
        List recentOxyData = jsonDecode(overAllOxygenData);
        List<BandOxygenModel> smartOxygenData = await getCurrentDayOxygenData(recentOxyData);
        if (smartOxygenData.isNotEmpty) {
          String oxygenValue = smartOxygenData[smartOxygenData.length - 1].value;
          String calender = smartOxygenData[smartOxygenData.length - 1].calender ?? '';
          String time = smartOxygenData[smartOxygenData.length - 1].time ?? '';
          String dateTime = getTimeByCalenderTime(calender, time);
          updateOxygenSaturation(oxygenValue, dateTime);
        }
      }

      if (weatherResponse.isNotEmpty) {
        var response = jsonDecode(weatherResponse);
        if (response != null) {
          debugPrint('weatherStoreResponse: $response');
          var currentData = response['current'];
          List<dynamic> dailyList = response['daily'];
          // WeatherMainModel weatherMainModel = WeatherMainModel(currentData, dailyList);
          // weatherModelData = weatherMainModel;
          // currentTemperature = double.tryParse(weatherMainModel.temperature.toString()).toStringAsFixed(2);
          // currentWeatherUrl = weatherMainModel.currentIconUrl;
          update();
        }
      }
    } catch (e) {
      debugPrint('addRecentDataUIException: $e');
    }
  }

  Future<void> updateBMIWithHeightWeight(String height, String weight, bool requiredUpdate) async {
    int hFinalCM = int.parse(height);
    double cWeight = double.parse(weight);
    double bmiValueNum = 10000 * cWeight / ((hFinalCM) * (hFinalCM));
    userBMI = bmiValueNum.roundToDouble().toString();
    if (bmiValueNum < 18.5) {
      userBMIStatus = 'bmi_under_weight';
    } else if (bmiValueNum > 18.5 && bmiValueNum < 24.9) {
      userBMIStatus = 'bmi_fit';
    } else if (bmiValueNum > 25.0 && bmiValueNum < 29.0) {
      userBMIStatus = 'bmi_over_weight';
    } else if (bmiValueNum > 30.0) {
      userBMIStatus = 'bmi_obese';
    }
    update();
    if (requiredUpdate) {
      userHeight = height.toString();
      userWeight = weight.toString();
      update();
      sharedService.setInitialHeightWeight(getUserHeight, getUserWeight);
      sharedService.updateBMIStatus(getUserBMI, getUserBMIStatus);
    }
  }

  Future<void> setDefaultUserProfile(String uId, String gender, String dob) async {
    debugPrint("inside setWatchProfile");

    userGender = gender;
    userDOB = dob;
    userAge = GlobalMethods.getAgeFromDOB(dob).toString();
    update();
    // await fetchLocalDataAssign(uId);
    await sharedService.setInitialParams(userGender, userAge, userDOB);
    // update();
    debugPrint("updated setWatchProfile");
  }

  Future<void> setDefaultHeightWeight(int height, int weight) async {
    //debugPrint("inside setWatchProfile");
    userHeight = height.toString();
    userWeight = weight.toString();
    update();
    //sharedService.setInitialHeightWeight(userHeight,userWeight);
    sharedService.setInitialHeightWeight(getUserHeight, getUserWeight);
    // update();
    //debugPrint("updated setWatchProfile");
  }

  Future<void> updateWatchProfile(String height, String weight, String gender, String dob) async {
    userHeight = height;
    userWeight = weight;
    userGender = gender;
    userDOB = dob;
    userAge = GlobalMethods.getAgeFromDOB(dob).toString();
    update();
    await sharedService.setInitialParams(userGender, userAge, userDOB);
    // sharedService.setInitialHeightWeight(userHeight,userWeight);
    sharedService.setInitialHeightWeight(getUserHeight, getUserWeight);
    // update();
    debugPrint("updated updateWatchProfile");
  }


  Future<void> updateBMIStatus(String bmiValue, String bmiStatus) async {
    userBMI = bmiValue;
    userBMIStatus = bmiStatus;
    update();
    //sharedService.updateBMIStatus(userBMI,userBMIStatus);
    sharedService.updateBMIStatus(getUserBMI, getUserBMIStatus);
    // update();
    debugPrint("updated updateBMIStatus");
  }

  Future<void> updateTargetedSteps(String updatedSteps) async {
    targetedSteps = updatedSteps;
    update();
    await sharedService.setTargetedSteps(targetedSteps);
    //update();
    debugPrint("updated updateTargetedSteps2");
  }

  Future<void> setScreenOffTime(String time) async {
    if (time.isNotEmpty) {
      screenOffTime = time;
      update();
      await sharedService.setScreenOffTime(time);
    } else {
      String screenOffTime = sharedService.getScreenOffTime();
      this.screenOffTime = screenOffTime;
      update();
    }
    //update();
  }

  Future<void> setTemperatureUnits(String units) async {
    if (units.isNotEmpty) {
      if (units == tempInCelsius) {
        tempCelsius = true;
      } else {
        tempCelsius = false;
      }
      update();
      await sharedService.setTempCelsius(getIsCelsius);
    } else {
      bool tempUnits = sharedService.getIsTempCelsius();
      tempCelsius = tempUnits;
      update();
    }
  }

  Future<void> setRaiseHandWakeUp(bool isWakeUp) async {
    raiseHandWakeUp = isWakeUp;
    update();
    await sharedService.setRaiseWakeUp(getRaiseHandWakeUp);
  }

  void updateDialDownloadProgress(int progress) {
    _dialDownloadProgress = progress;
    debugPrint('_dialDownloadProgress>> $_dialDownloadProgress');
    update();
  }

  void updateDialSyncingProgress(int progress) {
    _syncDialProgress = progress;
    debugPrint('_syncDialProgress>> $_syncDialProgress');
    update();
  }

  void updateDialSyncUI(bool dialDownloading, bool dialSyncing, bool dialSyncDone) {
    if (dialDownloading) {
      _dialDownloadProgress = 0;
      _syncDialProgress = 0;
    }
    this.dialDownloading = dialDownloading;
    this.dialSyncing = dialSyncing;
    this.dialSyncDone = dialSyncDone;
    update();
  }

  Future<void> setDeviceVersion(String version) async {
    if (version.isNotEmpty) {
      deviceVersion = version;
      update();
      await sharedService.setDeviceVersionId(version);
    } else {
      String oldVersion = sharedService.getDeviceVersionId();
      //String oldVersion = await this.userSharedPref.getString(DEVICE_VERSION_ID) ?? '';
      deviceVersion = oldVersion;
      update();
    }
  }

  Future<void> setBatteryPercentage(String batteryStat, bool callAPISync) async {
    if (batteryStat.isNotEmpty) {
      //this.userSharedPref.setString(BATTERY_STATUS, batteryStat);
      batteryPercentage = int.parse(batteryStat);
      update();
      await sharedService.setBatteryStatus(batteryStat);
    } else {
      String oldPercentage = sharedService.getBatteryStatus();
      // String oldPercentage = this.userSharedPref.getString(BATTERY_STATUS) ?? '0';
      batteryPercentage = int.parse(oldPercentage);
      update();
    }
    //update();
  }

  Future<void> updateHeartRate24Enabled(String isEnabled) async {
    if (isEnabled == "true") {
      hr24Enabled = true;
    } else {
      hr24Enabled = false;
    }
    update();
    await sharedService.setHeartRate24HrEnabled(getHR24Enabled);
  }

  Future<void> updateOxygen24Enabled(String isEnabled) async {
    if (isEnabled == "true") {
      oxygen24Enabled = true;
    } else {
      oxygen24Enabled = false;
    }
    update();
    await sharedService.setOxygen24HrEnabled(getOxygen24Enabled);
  }

  Future<void> updateTemperature24Enabled(bool isEnabled) async {
    //if (isEnabled == "true") {
    temperature24Enabled = isEnabled;
    // }else{
    //  this.temperature24Enabled = false;
    //}
    update();
    await sharedService.setTemperature24HrEnabled(getTemperature24Enabled);
    debugPrint('updateTemperature24Enabled>> $isEnabled');
  }

  void updateDeviceStats(String steps, String distance, String calories) {
    stepsValue = int.parse(steps);
    caloriesValue = calories ?? '-';
    distanceValue = distance ?? '-';

    progressPercentage = (stepsValue * 100) / int.parse(targetedSteps);
    update();
  }

  void updateHearRate(String hr, String dateTime) {
    heartRateValue = hr ?? '-';

    if (dateTime.isNotEmpty) {
      var outputFormat = DateFormat(defaultDateTimeParseFormat);
      String outputDate = outputFormat.format(DateTime.parse(dateTime));
      hrDateTime = outputDate;
    }else{
      hrDateTime = dateTime;
    }
    debugPrint('after_update>> $heartRateValue');
    debugPrint('after_update>> $hrDateTime');
    update();
  }

  void update24HrHearRate(String maxHr, String minHr, String avgHr) {
    maxHrValue = maxHr;
    minHrValue = minHr;
    avgHrValue = avgHr;
    update();
  }

  void updateBloodPressure(String bp, String dateTime) {
    bloodPressureValue = bp;
    if (dateTime.isNotEmpty) {
      var outputFormat = DateFormat(defaultDateTimeParseFormat);
      String outputDate = outputFormat.format(DateTime.parse(dateTime));
      bpDateTime = outputDate;
    }else{
      bpDateTime = dateTime;
    }
   // bpDateTime = dateTime;
    update();
  }

  Future<void> updateBPressureData(String high, String low, String calender, String time, var bpData) async {
    debugPrint('calender12>>$calender');
    debugPrint('time12>>$time');
    String dateTime = getTimeByCalenderTime(calender, time);
    debugPrint('dateTime>>$dateTime');

    String bpValue = '$high /$low';
    bloodPressureValue = bpValue;

    if (dateTime.isNotEmpty) {
      var outputFormat = DateFormat(defaultDateTimeParseFormat);
      String outputDate = outputFormat.format(DateTime.parse(dateTime));
      bpDateTime = outputDate;
    }else{
      bpDateTime = dateTime;
    }
   // bpDateTime = dateTime;
    overAllBPData = jsonEncode(bpData);
    update();
    await sharedService.setOverAllBP(getOverAllBPData);
  }

  void updateDeviceSleep(String totalHours, String calenderDate) {
    // this.stepsValue = int.parse(steps);
    List<String> list = totalHours.split(':');
    //this.sleepHrsValue = totalHours;
    sleepHrsValue = list[0];
    sleepMinutesValue = list[1];
    //String dateTime = getTimeByCalenderTime(calenderDate, '').trim();

    DateTime parseDate = DateTime.parse(calenderDate);
    var outputFormat = DateFormat(defaultDateFormat);
    String outputDate = outputFormat.format(parseDate);

    sleepHrsDateTime = outputDate;
    // this.distanceValue = distance;
    update();
  }

  void updateTemperature(String inCelsius, String inFahrenheit, String dateTime) {
    // check is it in fahrenheit or celsius from SP, and assign it
    if (getIsCelsius) {
      temperatureValue = inCelsius;
    } else {
      temperatureValue = inFahrenheit;
    }
   // temperatureDateTime = dateTime;
    if (dateTime.isNotEmpty) {
      var outputFormat = DateFormat(defaultDateTimeParseFormat);
      String outputDate = outputFormat.format(DateTime.parse(dateTime));
      temperatureDateTime = outputDate;
    }else{
      temperatureDateTime = dateTime;
    }
    update();
  }

  void updateOxygenSaturation(String oxyValue, String dateTime) {
    oxygenValue = oxyValue;
    //oxygenDateTime = dateTime;
    if (dateTime.isNotEmpty) {
      var outputFormat = DateFormat(defaultDateTimeParseFormat);
      String outputDate = outputFormat.format(DateTime.parse(dateTime));
      oxygenDateTime = outputDate;
    }else{
      oxygenDateTime = dateTime;
    }
    update();
  }

  Future<void> updateTemperatureWithData(var jsonData, var temperatureData, DateTime dateTimeSend) async {
    String inCelsius = jsonData['inCelsius'].toString() ?? '-';
    String inFahrenheit = jsonData['inFahrenheit'].toString();
    // String startDate = jsonData['startDate'].toString();
    String time = jsonData['time'].toString();
    String calender = jsonData['calender'].toString();
    String dateTime = getTimeByCalenderTime(calender, time);
    if (getIsCelsius) {
      temperatureValue = inCelsius;
    } else {
      temperatureValue = inFahrenheit;
    }
    //temperatureDateTime = dateTime;
    if (dateTime.isNotEmpty) {
      var outputFormat = DateFormat(defaultDateTimeParseFormat);
      String outputDate = outputFormat.format(DateTime.parse(dateTime));
      temperatureDateTime = outputDate;
    }else{
      temperatureDateTime = dateTime;
    }
    overAllTempData = jsonEncode(temperatureData);
    update();
    await sharedService.setOverAllTemperature(overAllTempData);
  }

  Future<void> updateEventResult(var eventData, BuildContext buildContext) async {
    String result = eventData['result'].toString();
    String status = eventData['status'].toString();
    var jsonData = eventData['data'];
    switch (result) {
      case BandFitConstants.DEVICE_VERSION:
        // data contains only "deviceVersion" returns as String
        String deviceID = jsonData['deviceVersion'].toString() ?? '';
        debugPrint('deviceVersion>>$deviceID');
        setDeviceVersion(deviceID);
        break;

      case BandFitConstants.BATTERY_STATUS:
        // data contains only "deviceVersion"," batteryStatus" returns as String
        String batteryStat = jsonData['batteryStatus'].toString() ?? '';
        debugPrint('batteryStatus>>$batteryStat');
        setBatteryPercentage(batteryStat, true);
        break;

      case BandFitConstants.QUICK_SWITCH_STATUS:
        if (status == BandFitConstants.SC_SUCCESS) {
          String resultStatus = jsonData['result'].toString() ?? '';
          if (resultStatus.isNotEmpty) {
            if (resultStatus == "119") {
              String resultValue = jsonData['value'].toString() ?? '';
              debugPrint('resultValue>> $resultValue');
              if (Platform.isIOS) {
                if (resultValue.isNotEmpty) {
                 if(resultValue == "70"){
                   // DND OFF
                   await updateDoNotDisturbEnable(false, getMotorVibrateEnabled, getMessagesOnEnabled);
                 }else if(resultValue == "78"){
                   // DND ON
                   await updateDoNotDisturbEnable(true, getMotorVibrateEnabled, getMessagesOnEnabled);
                 }else{

                 }
                }
              }else{
                if (jsonData['decimal'] != null &&
                    jsonData['decimal'].length > 0) {
                  List<dynamic> decimalData = jsonData['decimal'] as List<dynamic>;
                  debugPrint('decimalData>> $decimalData');
                  String result = decimalData[0].toString();
                  debugPrint('result>> $result');
                  if (result == "66" || result == "2") {
                    // dnd is not enabled (turned off) -- false
                    await updateDoNotDisturbEnable(false, getMotorVibrateEnabled, getMessagesOnEnabled);
                  } else if (result == "74" || result == "10") {
                    // dnd is enabled (turned on) -- true
                    await updateDoNotDisturbEnable(true, getMotorVibrateEnabled, getMessagesOnEnabled);
                  } else {
                    debugPrint('resultNothingToDo>> $result');
                  }
                }
              }
            }
          }
        }
        break;

      case BandFitConstants.DND_CLOSED:
        debugPrint('DND_CLOSED');
        if (status == BandFitConstants.SC_SUCCESS) {
          String resultStatus = jsonData['result'].toString() ?? '';
          if (resultStatus.isNotEmpty) {
            if (resultStatus == "85") {
              // dnd closed
              String resultValue = jsonData['value'].toString() ?? '';
              debugPrint('resultValue>> $resultValue');
              List<dynamic> hexList = jsonData['hex'] as List<dynamic>;
              List<dynamic> decimalList = jsonData['decimal'] as List<dynamic>;
              debugPrint('hexList>> $hexList');
              debugPrint('decimalList>> $decimalList');

              String dndResult = hexList[0].toString();
              debugPrint('dndResult>> $dndResult');
              if (dndResult.isNotEmpty) {
                if (dndResult == "D7") {
                  String dndValue = hexList[1].toString();
                  debugPrint('dndValue>> $dndValue');
                  if (dndValue == "0A") {
                    // only vibration off = true
                    await updateDoNotDisturbEnable(getDndEnabled, true, getMessagesOnEnabled);
                  } else if (dndValue == "08") {
                    // only vibration off = false
                    await updateDoNotDisturbEnable(getDndEnabled, false, getMessagesOnEnabled);
                  } else if (dndValue == "0C") {
                    // only message reminder off == true
                    await updateDoNotDisturbEnable(getDndEnabled, getMotorVibrateEnabled, true);
                  } else {

                  }
                }
              }
            }
          }
        }
        break;

      case BandFitConstants.DND_OPENED:
        debugPrint('DND_OPENED');
        if (status == BandFitConstants.SC_SUCCESS) {
          String resultStatus = jsonData['result'].toString() ?? '';
          if (resultStatus.isNotEmpty) {
            if (resultStatus == "84") {
              // dnd opened
              String resultValue = jsonData['value'].toString() ?? '';
              debugPrint('resultValue>> $resultValue');
              List<dynamic> hexList = jsonData['hex'] as List<dynamic>;
              List<dynamic> decimalList = jsonData['decimal'] as List<dynamic>;
              debugPrint('hexList>> $hexList');
              debugPrint('decimalList>> $decimalList');

              String dndResult = hexList[0].toString();
              debugPrint('dndResult>> $dndResult');
              if (dndResult.isNotEmpty) {
                if (dndResult == "D7") {
                  String dndValue = hexList[1].toString();
                  debugPrint('dndValue>> $dndValue');
                  if (dndValue == "08") {
                    // only dnd turned on = true
                    await updateDoNotDisturbEnable(true, getMotorVibrateEnabled, getMessagesOnEnabled);
                  } else if (dndValue == "0C") {
                    // dnd && message reminder off == true
                    await updateDoNotDisturbEnable(true, getMotorVibrateEnabled, true);
                  } else if (dndValue == "0A") {
                    // dnd && vibration off == true
                    await updateDoNotDisturbEnable(true, true, getMessagesOnEnabled);
                  } else if (dndValue == "0E") {
                    // dnd, msg && vibration off == true
                    await updateDoNotDisturbEnable(true, true, true);
                  } else {
                    debugPrint('dndNothingValue>> $dndValue');
                  }
                }
              }
              /* if(jsonData['decimal'] !=null && jsonData['decimal'].length >0){
                List<dynamic> decimalData = jsonData['decimal'] as List<dynamic>;
                debugPrint('decimalData>> $decimalData');
                String result = decimalData[0].toString();
                debugPrint('result>> $result');
                if(result =="66"){
                  await updateDoNotDisturbEnable(false, false, false);
                }else if(result =="74"){
                  // dnd is turned on from band - vibration off, msg off
                  await updateDoNotDisturbEnable(true, getMotorVibrateEnabled, getMessagesOnEnabled);
                }else {

                }
              }*/
            }
          }
        }
        break;

     /* case BandFitConstants.WATCH_DIAL_PROGRESS_STATUS:
        if (status == BandFitConstants.SC_SUCCESS) {
          int syncProcess = jsonData['progress'] ?? 0;
          debugPrint('syncProcess>> $syncProcess');
          if (_syncDialProgress != syncProcess) {
            _syncDialProgress = syncProcess;
            update();
            if (syncProcess > 0 && syncProcess == 100) {
              await updateDialSyncUI(false, false, true);
            }
          }
        }
        break;*/
      /* case BandFitConstants.DEVICE_DISCONNECTED:
      // data object will be empty always
        if (status == BandFitConstants.SC_SUCCESS) {
          //Global.showAlertDialog(context, "Invalid Device", "The device trying to connect is not a valid device or unsupported to connect the data or fetch the data");
          if (getDeviceConnected) {
            */ /* GlobalMethods.showAlertDialogWithFunction(buildContext, "Device Disconnected", "Your device has been disconnected", "Retry", (){
              debugPrint("pressed_ok: inside_callback");
              Navigator.of(buildContext).pop();
              retryConnection(buildContext);
            });*/ /*
          }
        }
        break;*/

      case BandFitConstants.SYNC_STEPS_FINISH:
        if (status == BandFitConstants.SC_SUCCESS) {
          //await syncHeartRate();
          await syncSleepData();
          if (jsonData != null) {
            List<dynamic> stepsData = jsonData;
            if (stepsData.isNotEmpty) {
              await updateStepsSyncSDKData(stepsData);
            }
          }
        }
        break;
      case BandFitConstants.SYNC_SLEEP_FINISH:
        if (status == BandFitConstants.SC_SUCCESS) {
          //await syncTemperature();
          // await syncBloodPressure();
          await syncHeartRate();
          if (jsonData != null) {
            //jsonData.toString().isNotEmpty != "{}";
            List<dynamic> sleepData = jsonData;
            if (sleepData.isNotEmpty) {
              await updateSleepSyncSDKData(sleepData);
            }
          }
          /* debugPrint("all sync is done");
         await fetchOverAllDataByDate();
         updateSyncIsDone();*/
        }
        break;
      case BandFitConstants.SYNC_24_HOUR_RATE_FINISH:
        if (status == BandFitConstants.SC_SUCCESS) {
          await syncBloodPressure();
          //await syncSleepData();
          //await syncTemperature();
          if (jsonData != null) {
            List<dynamic> hrData = jsonData;
            if (hrData.isNotEmpty) {
              await updateHR24SyncSDKData(hrData);
            }
          }
        }
        break;
      case BandFitConstants.SYNC_BP_FINISH:
        if (status == BandFitConstants.SC_SUCCESS) {
          await syncTemperature();
          //await syncSleepData();
          // Data Sync With UI
          if (jsonData != null) {
            List<dynamic> bpData = jsonData;
            if (bpData.isNotEmpty) {
              await updateBloodPressureSyncSDKData(bpData);
            }
          }
        }
        break;

      case BandFitConstants.SYNC_TEMPERATURE_FINISH:
        if (status == BandFitConstants.SC_SUCCESS) {
          if (getDeviceSWName.isNotEmpty && getDeviceSWName.contains("KMO4")) {
            if (Platform.isIOS) {
              if (jsonData != null) {
                List<dynamic> tempData = jsonData;
                if (tempData.isNotEmpty) {
                  await updateTemperatureSyncSDKData(tempData);
                }
              }
              updateSyncIsDone(true);
            }else{
              await fetchOverAllDeviceDataSync();
              updateSyncIsDone(false);
            }

          } else {
            await syncOxygen();
            if (jsonData != null) {
              List<dynamic> tempData = jsonData;
              if (tempData.isNotEmpty) {
                await updateTemperatureSyncSDKData(tempData);
              }
            }
          }
        }
        break;

      case BandFitConstants.SYNC_OXYGEN_FINISH:
        if (status == BandFitConstants.SC_SUCCESS) {
          debugPrint("all_data_sync_is_done");
          debugPrint("all_data_sync_is_done>>> $jsonData");
          //await fetchOverAllDeviceData();
          if (Platform.isIOS) {
            if (jsonData != null) {
              List<dynamic> oxyData = jsonData;
              debugPrint("oxyData>>> $oxyData");
              if (oxyData.isNotEmpty) {
                await updateOxygenSyncSDKData(oxyData);
                updateSyncIsDone(true);
              }else{
                updateSyncIsDone(false);
              }
            }
          } else {
            await fetchOverAllDeviceDataSync();
            updateSyncIsDone(false);
          }
        }
        break;


      case BandFitConstants.STEPS_REAL_TIME:
        // real time sync as well as the daily sync
        if (status == BandFitConstants.SC_SUCCESS) {
          String steps = jsonData['steps'].toString() ?? '0';
          String distance = jsonData['distance'].toString() ?? '-';
          String calories = jsonData['calories'].toString() ?? '-';
          debugPrint('real_steps: $steps, distance: $distance, calories: $calories');
          //String formattedSteps = GlobalMethods.formatNumber(int.parse(steps));
          updateDeviceStats(steps, distance, calories);
        }
        break;

      case BandFitConstants.HR_REAL_TIME:
        // real time sync as well as the daily sync
        if (status == BandFitConstants.SC_SUCCESS) {
          String hr = jsonData['hr'].toString();
          debugPrint('inside hr $hr');
          updateHearRate(hr, getHRDateTime);
        }
        break;

      case BandFitConstants.HR_24_REAL_RESULT:
        // real time sync as well as the daily sync
        if (status == BandFitConstants.SC_SUCCESS) {
          String maxHr = jsonData['maxHr'].toString();
          String minHr = jsonData['minHr'].toString();
          String avgHr = jsonData['avgHr'].toString();
          String rtValue = jsonData['rtValue'].toString();
          debugPrint('inside maxHr $maxHr -- $rtValue');
          //if (rtValue =='true') {
          update24HrHearRate(maxHr, minHr, avgHr);
          //}
        }
        break;

      case BandFitConstants.SYNC_STATUS_24_HOUR_RATE_OPEN:
        debugPrint('SYNC_STATUS_24_HOUR_RATE_OPEN');
        String status = jsonData['status'].toString() ?? '';
        if (status.isNotEmpty) {
          await updateHeartRate24Enabled(status);
        }
        //await set24HrTemperatureTest(true);
        break;

      case BandFitConstants.SYNC_STATUS_24_HOUR_OXYGEN_OPEN:
        debugPrint('SYNC_STATUS_24_HOUR_OXYGEN_OPEN');
        String status = jsonData['status'].toString() ?? '';
        debugPrint('SYNC_STATUS>> $status');
        if (status.isNotEmpty) {
          await updateOxygen24Enabled(status);
        }
        break;

      case BandFitConstants.SYNC_TEMPERATURE_24_HOUR_AUTOMATIC:
        debugPrint('SYNC_TEMPERATURE_24_HOUR_AUTOMATIC');
        String status = jsonData['status'].toString() ?? '';
        if (status.isNotEmpty) {
          //if (getTemperature24Enabled) {
          await updateTemperature24Enabled(getTemperature24Enabled);
          // }
        }
        break;
      case BandFitConstants.CALLBACK_EXCEPTION:
        // something went wrong, which falls in the exception
        debugPrint('event_exception_occurred');
        break;
      default:
        debugPrint('no_event_exception');
        break;
    }
  }

  void receiveEventsFrom({required Function(dynamic) onDataUpdate, required Function(dynamic) onError, required Function() onDone}) {
    flutterBandFit.receiveEventListeners(onData: onDataUpdate, onError: onError, onDone: onDone);
  }

  void pauseEventListeners() {
    flutterBandFit.pauseEventListeners();
  }

  bool resumeEventListeners() {
    return flutterBandFit.resumeEventListeners();
  }

  void cancelEventListeners() {
    flutterBandFit.cancelEventListeners();
  }

  /*void receiveOxygenListeners({Function(dynamic) onDataUpdate, Function(dynamic) onError, Function() onDone}) {
    _mobileSmartWatch.receiveOxygenListeners(onData: onDataUpdate, onError: onError, onDone: onDone);
  }

  void pauseOxygenListeners() {
    _mobileSmartWatch.pauseOxygenListeners();
  }

  bool resumeOxygenListeners() {
    return _mobileSmartWatch.resumeOxygenListeners();
  }

  void cancelOxygenEvents() {
    _mobileSmartWatch.cancelOxygenListeners();
  }*/

  void receiveBPListeners({required Function(dynamic) onDataUpdate,required Function(dynamic) onError,required Function() onDone}) {
    flutterBandFit.receiveBPListeners(onData: onDataUpdate, onError: onError, onDone: onDone);
  }

  void pauseBPListeners() {
    flutterBandFit.pauseBPListeners();
  }

  bool resumeBPListeners() {
    return flutterBandFit.resumeBPListeners();
  }

  void cancelBPEvents() {
    flutterBandFit.cancelBPListeners();
  }

  /*void receiveTemperatureListeners({Function(dynamic) onDataUpdate, Function(dynamic) onError, Function() onDone}) {
    _mobileSmartWatch.receiveTemperatureListeners(onData: onDataUpdate, onError: onError, onDone: onDone);
  }

  void pauseTemperatureListeners() {
    _mobileSmartWatch.pauseTemperatureListeners();
  }

  bool resumeTemperatureListeners() {
    return _mobileSmartWatch.resumeTemperatureListeners();
  }

  void cancelTemperatureListeners() {
    _mobileSmartWatch.cancelTemperatureListeners();
  }*/

  Future<int> getAndroidSDKInt() async {
    return await flutterBandFit.getAndroidDeviceSDKIntVersion();
  }

  Future<String> initializeDeviceConnection() async {
    return await flutterBandFit.initializeDeviceConnection();
  }

  Future<String> reInitBluConnection() async {
    return await flutterBandFit.reInitializeBlueConnection();
  }

  Future<String> getConnectedLastDeviceAddress() async {
    return await flutterBandFit.getLastConnectedDeviceAddress();
  }

  Future<bool> connectWithLastDeviceAddress() async {
    return await flutterBandFit.connectLastDeviceAddress();
  }

  Future<bool> checkFindBand() async {
    return await flutterBandFit.checkFindBand();
  }

  Future<String> findDeviceBand() async {
    return await flutterBandFit.findBandDevice();
  }

  Future<String> resetDevicesAllData() async {
    return await flutterBandFit.resetDevicesAllData();
  }

  /*Future<bool> checkDialSupport() async {
    return await _mobileSmartWatch.checkDialSupport();
  }*/

  Future<String> readOnlineDialConfig() async {
    return await flutterBandFit.readOnlineDialConfig();
  }

  Future<String> prepareSendOnlineDialData() async {
    return await flutterBandFit.prepareSendOnlineDialData();
  }

 /* Future<String> listenWatchDialProgress() async {
    return await _mobileSmartWatch.listenWatchDialProgress();
  }*/

  Future<String> stopOnlineDialData() async {
    return await flutterBandFit.stopOnlineDialData();
  }

  Future<String> sendOnlineDialPath(String filePath) async {
    return await flutterBandFit.sendOnlineDialPath(filePath);
  }

  Future<String> sendOnlineDialData(dynamic byteData) async {
    return await flutterBandFit.sendOnlineDialData(byteData);
  }

  Future<List<BandDeviceModel>> startSearchingDevices() async {
    return await flutterBandFit.startSearchingDevices();
  }

  Future<bool> connectDeviceWithMacAddress(BuildContext context) async {

    deviceSWName = sharedService.getDeviceName();
    deviceMacAddress = sharedService.getDeviceMacAddress();
    debugPrint('reconnecting_with_name>>$deviceSWName');
    debugPrint('reconnecting_with_mac>>$deviceMacAddress');
    debugPrint('getDeviceMacAddress>>$getDeviceMacAddress');
    debugPrint('getDeviceSWName>>$getDeviceSWName');
    update();
    String result = await initializeDeviceConnection();
    if (result != null) {
      if (result.toString() == BandFitConstants.BLE_NOT_SUPPORTED) {
        GlobalMethods.showAlertDialog(context, "$textBluetooth 4.0", "$bleNotSupported v4.0");
        return false;
      } else if (result.toString() == BandFitConstants.SC_CANCELED) {
        GlobalMethods.showAlertDialog(context, textBluetooth, bleNotConnected);
        return false;
      } else if (result.toString() == BandFitConstants.SC_INIT) {
        BandDeviceModel deviceModel = BandDeviceModel(address: getDeviceMacAddress, name: getDeviceSWName, identifier: '');
        bool resultConnected = await flutterBandFit.connectDevice(deviceModel);
        debugPrint("connect_with_mac_status $resultConnected");
        if (resultConnected) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  /* Future<bool> connectDeviceWithMacAddress(BuildContext context) async {
    deviceSWName = sharedService.getDeviceName();
    deviceMacAddress = sharedService.getDeviceMacAddress();
    this.update();
    BandDeviceModel deviceModel = BandDeviceModel(
      address: deviceMacAddress,
      name: deviceSWName,
      alias: "",
      bondState: "",
      deviceType: "",
      rssi: ""
    );
    debugPrint("name: ${deviceModel.name}  deviceMacAddress: ${deviceModel.address} ");

    String result = await initializeDeviceConnection();
    if (result != null) {
      if (result.toString() ==  BandFitConstants.SC_INIT) {
        debugPrint("connectDeviceWithMacAddress inside initiations ");
        bool resultConnected = await _mobileSmartWatch.connectDevice(deviceModel);
        debugPrint("connect_status $resultConnected");
        if(resultConnected){
          deviceConnected = true;
          healthConnected = false;
          deviceSWName = sharedService.getDeviceName();
          deviceMacAddress = sharedService.getDeviceMacAddress();
        }else{
          //device is not connected
          debugPrint("else connectDeviceWithMacAddress inside disconnected ");
        }
      } else if (result.toString() == BandFitConstants.SC_DISCONNECTED) {
        debugPrint("connectDeviceWithMacAddress inside SC_DISCONNECTED ");

      } else if (result.toString() == BandFitConstants.SC_CANCELED) {
        debugPrint("connectDeviceWithMacAddress inside SC_CANCELED ");
      } else  {
        debugPrint("connectDeviceWithMacAddress inside else ");
      }
    }
    return false;
  }*/


  Future<bool> reConnectSmartDevice(BandDeviceModel deviceModel) async {
    debugPrint('BandDeviceModel>> $deviceModel');
    bool resultReconnected = await flutterBandFit.reConnectDevice(deviceModel);
    debugPrint("resultReconnected: $resultReconnected");
    return resultReconnected;
  }

  Future<bool> connectSmartDevice(BandDeviceModel deviceModel) async {
    bool resultConnected = await flutterBandFit.connectDevice(deviceModel);
    debugPrint("resultConnected: $resultConnected");

    /*if(resultConnected){
      deviceConnected = true;
      healthConnected = false;
      deviceSWName = deviceModel.name;
      deviceMacAddress = deviceModel.address;
      this.update();
      sharedService.setSmartMConnected(deviceConnected);
      sharedService.setDeviceName(deviceSWName);
      sharedService.setDeviceMacAddress(deviceMacAddress);
      sharedService.setHealthConnected(healthConnected);
    //  await updateUserParamsWatch();
      //await fetchBatteryStatus();
     // await fetchAllJudgement();
    }*/
    // update();
    return resultConnected;
  }

  Future<bool> disconnectDevice() async {
    bool disconnectStatus = await flutterBandFit.disconnectDevice();
    debugPrint('disconnectStatus>> $disconnectStatus');
    await updateUserDeviceConnection(false, false, '', '');
    await clearResetLocalData();
    /*if(disConnect){
      deviceConnected = false;
      deviceSWName = "";
      deviceMacAddress = "";
      healthConnected = false;
      oxygenAvailable = false;
      this.update();
      sharedService.setSmartMConnected(deviceConnected);
      sharedService.setDeviceName(deviceSWName);
      sharedService.setDeviceMacAddress(deviceMacAddress);
      sharedService.setHealthConnected(healthConnected);
      sharedService.setOxygenAvailable(oxygenAvailable);
    }*/
    // update();
    return disconnectStatus;
  }

  Future<String> setDefaultLocationCoOrdinates(double lat, double long) async {
    deviceLatitude = lat;
    deviceLongitude = long;
   // Placemark address = await GlobalMethods.getLocationAddress(getDeviceLatitude, getDeviceLongitude);
   // if (address !=null) {
      // debugPrint('address.name>> ${address.name}');
      // debugPrint('address.street>> ${address.street}');
      // debugPrint('address.isoCountryCode>> ${address.isoCountryCode}');
      // debugPrint('address.country>> ${address.country}');
      // debugPrint('address.postal>> ${address.postalCode}');
      // debugPrint('address.administrativeArea>> ${address.administrativeArea}');
      // debugPrint('address.subAdministrativeArea>> ${address.subAdministrativeArea}');
      // debugPrint('address.locality>> ${address.locality}');
      // debugPrint('address.subLocality>> ${address.subLocality}');
      // debugPrint('address.thoroughfare>> ${address.thoroughfare}');
      // debugPrint('address.subThoroughfare>> ${address.subThoroughfare}');

      // if (address.locality != null && address.locality.isNotEmpty) {
      //   deviceCityName = address.locality;
      // } else {
      //   if (address.name != null && address.name.isNotEmpty) {
      //     deviceCityName = address.name;
      //   } else {
      //     if (address.administrativeArea != null &&
      //         address.administrativeArea.isNotEmpty) {
      //       deviceCityName = address.administrativeArea;
      //     } else {
      //       deviceCityName = address.subAdministrativeArea ?? '';
      //     }
      //   }
      // }

      update();
      sharedService.setLatitude(getDeviceLatitude.toString());
      sharedService.setLongitude(getDeviceLongitude.toString());
      sharedService.setDeviceCityName(getDeviceCityName);
      //return address.isoCountryCode ?? '';

   // }else{
      if (sharedService.getDeviceCityName() != null && sharedService.getLatitude() != null) {
        deviceCityName = sharedService.getDeviceCityName()!;
        deviceLatitude = double.tryParse(sharedService.getLatitude()!)!;
        deviceLongitude = double.tryParse(sharedService.getLongitude()!)!;
        update();
        sharedService.setLatitude(getDeviceLatitude.toString());
        sharedService.setLongitude(getDeviceLongitude.toString());
        sharedService.setDeviceCityName(getDeviceCityName);
      }
      return '';
    //}

  }

  Future<void> setLocationCoOrdinates(double lat, double long) async {
    deviceLatitude = lat;
    deviceLongitude = long;
    debugPrint('deviceLatitude>> $deviceLatitude');
    debugPrint('deviceLongitude>> $deviceLongitude');
    try{
      //Placemark address = await GlobalMethods.getLocationAddress(getDeviceLatitude, getDeviceLongitude);
      // debugPrint('address.locality>> ${address.locality}');
      // debugPrint('address.adminArea>> ${address.adminArea}');
      // debugPrint('address.region>> ${address.region}');
      // debugPrint('address.streetAddress>> ${address.streetAddress}');
      // debugPrint('address.city>> ${address.city}');
      // debugPrint('address.distance>> ${address.distance}');
      // debugPrint('address.countryCode>> ${address.countryCode}');
      // debugPrint('address.countryName>> ${address.countryName}');
      // if (address != null) {
      //   if (address.locality != null && address.locality.isNotEmpty) {
      //     deviceCityName = address.locality;
      //   } else {
      //     if (address.name != null && address.name.isNotEmpty) {
      //       deviceCityName = address.name;
      //     } else {
      //       if (address.administrativeArea != null &&
      //           address.administrativeArea.isNotEmpty) {
      //         deviceCityName = address.administrativeArea;
      //       } else {
      //         deviceCityName = address.subAdministrativeArea ?? '';
      //       }
      //     }
      //   }
      // }
    }catch(exp){
      debugPrint('placeMarkExp>> $exp');
      debugPrint('getDeviceCityName>> $getDeviceCityName');

    }
    update();
    sharedService.setLatitude(getDeviceLatitude.toString());
    sharedService.setLongitude(getDeviceLongitude.toString());
    sharedService.setDeviceCityName(getDeviceCityName);
  }

  Future<void> updateOxygenAvailability(bool isOxygenAvail) async {
    oxygenAvailable = isOxygenAvail;
    update();
    sharedService.setOxygenAvailable(oxygenAvailable);
  }

  Future<bool> checkIsDeviceConnected() async {
    //await Future.delayed(const Duration(milliseconds: 500));
    return await flutterBandFit.checkConectionStatus();
  }

  Future<Map<String, dynamic>?> fetchDeviceDataInfo() async {
    Map<String, dynamic> response = await flutterBandFit.fetchDeviceDataInfo();
    debugPrint('device_res>>$response');
    String status = response['status'].toString();
    if (status == BandFitConstants.SC_SUCCESS) {
      return response;
    } else {
      return null;
    }
  }

  Future<void> clearResetLocalData() async {
    //dashboard screen values reset
    stepsValue = 0;
    progressPercentage = 0;
    caloriesValue = '-';
    distanceValue = '-';
    heartRateValue = '-';
    hrDateTime = '';
    bloodPressureValue = '-';
    bpDateTime = '';
    temperatureValue = '-';
    temperatureDateTime = '';
    oxygenValue = '-';
    oxygenDateTime = '';
    sleepHrsValue = '-';
    sleepMinutesValue = '';
    sleepHrsDateTime = '';

    //json data stored values reset
    overAllStepsData = "";
    overAllSleepData = "";
    overAllHrData = "";
    overAllBPData = "";
    overAllTempData = "";
    overAllOxygenData = "";

    update();
    await sharedService.setOverAllSteps("");
    await sharedService.setOverAllSleep("");
    await sharedService.setOverAllHeartRate("");
    await sharedService.setOverAllBP("");
    await sharedService.setOverAllTemperature("");
    await sharedService.setOverAllOxygenData("");
    print('clearDataExecuted');
  }

  Future<void> updateUserDeviceConnection(bool isHealthConnected, bool isDeviceConnected, String deviceName, String deviceAddress) async {
    if (isHealthConnected) {
      healthConnected = true;
      oxygenAvailable = true;
      deviceConnected = false;
      showSyncProgress = false;
      deviceSWName = deviceName; //"Gfit"
      deviceMacAddress = deviceAddress; // device name "SamsungXYZ"
    } else {
      healthConnected = false;
      oxygenAvailable = false;
      showSyncProgress = false;
      if (isDeviceConnected) {
        //debugPrint('getDeviceMacAddress>>$getDeviceMacAddress');
        if (deviceName.toString().trim().isEmpty) {
          deviceSWName = '';
          deviceMacAddress = '';
          deviceConnected = false;
        } else {
          if (deviceName.trim().toLowerCase() == 'sp') {
            deviceSWName = sharedService.getDeviceName();
            deviceMacAddress = sharedService.getDeviceMacAddress();
            deviceConnected = true;
          } else {
            deviceSWName = deviceName;
            deviceMacAddress = deviceAddress;
            deviceConnected = true;
          }
        }
      } else {
        deviceConnected = false;
        showSyncProgress = false;
        deviceSWName = '';
        deviceMacAddress = '';
      }
    }

    debugPrint('deviceName>> $deviceName');
    debugPrint('deviceMacAddress>> $deviceAddress');
    update();
    debugPrint('getDeviceSWNameNotify>> $getDeviceSWName');
    debugPrint('getDeviceMacAddressNotify>> $getDeviceMacAddress');
    sharedService.setSmartMConnected(getDeviceConnected);
    sharedService.setDeviceName(getDeviceSWName);
    sharedService.setDeviceMacAddress(getDeviceMacAddress);
    sharedService.setHealthConnected(getHealthConnected);
    sharedService.setOxygenAvailable(getOxygenAvailable);
  }


  Future<void> enable24HourTest() async {
    //if (status.toString().trim() == BandFitConstants.SC_INIT) {
      // await Future.delayed(const Duration(milliseconds: 500));
      await set24HrHeartRate(true);
      // await Future.delayed(const Duration(milliseconds: 500));
      await set24HrOxygen(true);
      // await Future.delayed(const Duration(milliseconds: 500));
      await set24HrTemperatureTest(true);
   // }
  }
  Future<void> updateUserParamsWatch(bool enableHRTemperature) async {
    var userParams = {
      "age": sharedService.getUserAge(),
      // user age (0-254)
      "height": sharedService.getUserHeight(),
      // always cm
      "weight": sharedService.getUserWeight(),
      // always in kgs
      "gender": sharedService.getUserGender().toLowerCase(),
      //male  or female in lower case
      "steps": sharedService.getTargetedSteps(),
      // targeted goals
      "isCelsius": sharedService.getIsTempCelsius().toString(),
      //"false", // if celsius then send "true" else "false" for Fahrenheit
      "screenOffTime": sharedService.getScreenOffTime(),
      //screen off time
      "isChineseLang": "false",
      //true for chinese lang setup and false for english
      "raiseHandWakeUp": sharedService.getRaiseWakeUp().toString(),
      //"false", //true or false -- send true to wake up bright light switch
    };
    debugPrint('userParamsUpdate>>>$userParams');
    String status = await flutterBandFit.setUserParameters(userParams);
    debugPrint('userParamsStatus>>>$status');
    if (enableHRTemperature) {
      if (status.toString().trim() == BandFitConstants.SC_INIT) {
       // await Future.delayed(const Duration(milliseconds: 500));
        await set24HrHeartRate(true);
       // await Future.delayed(const Duration(milliseconds: 500));
        await set24HrOxygen(true);
       // await Future.delayed(const Duration(milliseconds: 500));
        await set24HrTemperatureTest(true);
      }
    }
    // else{
    //   if (status.toString().trim() == BandFitConstants.SC_INIT) {
    //
    //   }
    // }
  }

  Future<void> set24HrHeartRate(bool enable) async {
    String status = await flutterBandFit.set24HeartRate(enable);
    debugPrint('set24HeartRateStatus>>>$status');
    hr24Enabled = enable;
    update();
    // await fetchDeviceVersion();
    await sharedService.setHeartRate24HrEnabled(getHR24Enabled);
  }

  Future<void> set24HrOxygen(bool enable) async {
    String status = await flutterBandFit.set24BloodOxygen(enable);
    debugPrint('set24OxygenStatus>>>$status');
    oxygen24Enabled = enable;
    update();
    await sharedService.setOxygen24HrEnabled(getOxygen24Enabled);
  }

  Future<void> set24HrTemperatureTest(bool isEnabled) async {
    // setting 1 hour as interval
    String status = await flutterBandFit.set24HrTemperatureTest('24', isEnabled);
    debugPrint('set24HrTemperatureTest>>>$status');
    // this.temperature24Enabled = isEnabled;
    // this.update();
    temperature24Enabled = isEnabled;
    update();
    await sharedService.setTemperature24HrEnabled(getTemperature24Enabled);
  }

  Future<void> setDoNotDisturbEnable({required bool isMessageOn,required bool isMotorOn,required bool disturbTimeSwitch,required String fromHr,required String fromMin,required String toHour,required String toMin}) async {
    String status = await flutterBandFit.setDoNotDisturb(isMessageOn, isMotorOn, disturbTimeSwitch, fromHr, fromMin, toHour, toMin);
    debugPrint('setDoNotDisturbEnable>>>$status');

    dndEnabled = disturbTimeSwitch;
    messagesOnEnabled = isMessageOn;
    motorVibrateEnabled = isMotorOn;
    if (disturbTimeSwitch) {
      String enabledDNDTime = fromHr.padLeft(2, "0") + ":" + fromMin.padLeft(2, "0") + ":" + toHour.padLeft(2, "0") + ":" + toMin.padLeft(2, "0");
      dndEnabledTime = enabledDNDTime;
    }

    update();
    await sharedService.setDNDEnabled(getDndEnabled);
    await sharedService.setMessagesOnEnabled(getMessagesOnEnabled);
    await sharedService.setMotorVibrateEnabled(getMotorVibrateEnabled);
    if (getDndEnabled) {
      //String time format fromHr:fromMin:toHour:toMin
      //String enabledDNDTime = fromHr.toString()+":"+fromMin.toString()+":"+toHour.toString()+""+toMin.toString();
      await sharedService.setDNDEnabledTime(getDNDEnabledTime);
    }
  }

  Future<void> updateOnlyDoNotDisturbEnable(bool disturbTimeSwitch) async {
    dndEnabled = disturbTimeSwitch;
    update();
    //await sharedService.setDNDEnabled(getDndEnabled);
  }

  Future<void> updateDoNotDisturbEnable(bool disturbTimeSwitch, bool isMotorVibrateOn, bool isMessageReminderOn) async {
    dndEnabled = disturbTimeSwitch;
    messagesOnEnabled = isMessageReminderOn;
    motorVibrateEnabled = isMotorVibrateOn;
    update();
    await sharedService.setDNDEnabled(getDndEnabled);
    await sharedService.setMessagesOnEnabled(getMessagesOnEnabled);
    await sharedService.setMotorVibrateEnabled(getMotorVibrateEnabled);
  }

  Future<void> setWeatherInfoSevenDays() async {
    if (getJsonWeatherData.isNotEmpty) {
      String status = await flutterBandFit.setWeatherInfoSevenDays(getJsonWeatherData);
      debugPrint('setWeatherInfoSevenDays>>>$status');
    }
  }

  Future<void> callQuickSwitchSettingStatus() async {
    //await Future.delayed(const Duration(milliseconds: 500));
    String resultStatus = await flutterBandFit.callQuickSwitchSettingStatus();
    debugPrint('resultCallStatus>>>$resultStatus');
  }


  Future<void> fetchDeviceVersion() async {
    String resultVersionStatus = await flutterBandFit.getDeviceVersion();
    debugPrint('resultVersionStatus>>>$resultVersionStatus');
    //String status = resultVersionData['status'].toString();
    /*if (resultVersionStatus == BandFitConstants.SC_INIT) {
        // var resultData = resultVersionData['data'];
        // String deviceVersion = resultData['deviceVersion'];
        // setDeviceVersion(deviceVersion);
      }else if(resultVersionStatus == BandFitConstants.SC_DISCONNECTED){

      }else{
        // something went wrong.
      }
      return true;*/
  }

  /*void retryConnection(BuildContext context){
    GlobalMethods.showAlertDialogWithFunction(context, "Device Disconnected", "Your device got disconnected, retry to connect back.", "Retry", () async {
      debugPrint("pressed_ok");
      Navigator.of(context).pop();
      await connectDeviceWithMacAddress(context);
    });
  }*/

  void updateSyncingView(bool updateView) {
    showSyncProgress = updateView;
    update();
  }

  Future<void> updateSyncIsDone(bool syncBackend) async {
    showSyncProgress = false;
    update();

    //var outputFormat = new DateFormat('dd-MM-yyyy hh:mm:ss a');
    var outputFormat = DateFormat(defaultLastSyncDateTimeFormat);
    String outputDate = outputFormat.format(DateTime.now());
    debugPrint('last_sync_date>> $outputDate');
    lastSyncDated = outputDate;
    lastSyncDateTime = DateTime.now().toString();
    update();

    sharedService.setLastMacAddressId(lastMacAddressId);
    sharedService.setLastSyncDate(lastSyncDated);
    sharedService.setLastSyncDateTime(lastSyncDateTime);
    //syncing band data only as of now in case of IOS
  }



  Future<void> syncOverAllData() async {
    debugPrint('initiated_syncing');
    showSyncProgress = true;
    update();
    //sync started with steps data.
    await syncStepsData();
  }






  // backend variables
  var sendWalkingData = [];
  var sendSleepData = [];
  var sendHRData = [];
  var sendBPData = [];
  var sendTempData = [];
  var sendSpo2Data = [];

  // Individual Sync starts here
  Future<void> updateStepsSyncSDKData(List<dynamic> stepsData) async {
   // log('inside_stepsData>> $stepsData');
    List<StepsMainModel> stepsTodayList = await getSelectedDayStepsData(stepsData);
    debugPrint('stepsTodayList1>> ${stepsTodayList.length}');
    if (stepsTodayList.isNotEmpty) {
      StepsMainModel stepsMainModel = stepsTodayList[stepsTodayList.length - 1];
      updateDeviceStats(stepsMainModel.steps, stepsMainModel.distance, stepsMainModel.calories);
    }

    //sync save
    overAllStepsData = jsonEncode(stepsData);
    update();
    await sharedService.setOverAllSteps(getOverAllStepsData);

    //backend api sync
    sendWalkingData = [];
    if(isCurrentDataTime){
      if (stepsTodayList.isNotEmpty) {
        for (var item in stepsTodayList) {
          String calender = item.calender;
          String calories = item.calories;
          String distance = item.distance;
          //String totalSteps = element.steps;
          if (item.dataList.isNotEmpty) {
            for (var ele in item.dataList) {
              String dateTime = getTimeByCalenderTime(calender.toString(), ele.time);
              String jsonDateTime = DateTime.tryParse(dateTime)!.toUtc().toIso8601String();
              var jsonData = {
                "date": jsonDateTime,
                "target_steps": targetedSteps,
                "walked_steps": ele.step,
                "calories": calories, //common
                "distance": distance, //common
              };
              debugPrint('steps_map_data>> $jsonData');
              sendWalkingData.add(jsonData);
            }
          }
        }
      }
    }else{
      if (getCalenderDateTimeList.isNotEmpty) {
        for (String calender in getCalenderDateTimeList) {
         //int steps = 0;
         // DateTime dateTime = DateTime.tryParse(calender);
          stepsData.where((element) => element['calender'].toString().trim() == calender).toList().forEach((item) {
            //steps = steps + int.parse(element['step'].toString());
            double distance =  double.tryParse(item['distance'].toString())!;
            double kCal =  double.tryParse(item['calories'].toString())!;

            if (distance > 0.0) {
              distance = distance / 1000; //Converting in kM
            }
            if (kCal > 0.0) {
              kCal = kCal / 1000; //Converting in kCal
            }

            // String dateTime = getTimeByCalenderTime(element['calender'].toString(), element.time);
            // String jsonDateTime = DateTime.tryParse(dateTime).toUtc().toIso8601String();
            // var jsonData = {
            //   "date": jsonDateTime,
            //   "target_steps": targetedSteps,
            //   "walked_steps": element['step'].toString(),
            //   "calories": stepsMainModel.calories, //common
            //   "distance": stepsMainModel.distance, //common
            // };
           // sendWalkingData.add(jsonData);
          });
        }
      }
    }
   // overAllStepsData
  }

  Future<void> updateSleepSyncSDKData(List<dynamic> sleepData) async {
    List<SleepMainModel> sleepTodayList = await getSelectedDaySleepData(sleepData);
    if (sleepTodayList.isNotEmpty) {
      SleepMainModel sleepMainModel = sleepTodayList[sleepTodayList.length - 1];
      updateDeviceSleep(sleepMainModel.total, sleepMainModel.calender);
    }

    //sync save
    overAllSleepData = jsonEncode(sleepData);
    update();
    await sharedService.setOverAllSleep(getOverAllSleepData);

    if(isCurrentDataTime){
      if (sleepTodayList.isNotEmpty) {
        SleepMainModel sleepMainModel = sleepTodayList[sleepTodayList.length - 1];
        DateTime parseCalender = DateTime.parse(sleepMainModel.calender.toString().trim());
        var sleepJsonData = {
          "date": parseCalender.toUtc().toIso8601String(),
          "deep": sleepMainModel.deep,
          "light": sleepMainModel.light,
          "awake_hrs": sleepMainModel.awake,
          "sleep_hrs": sleepMainModel.total,
          "start_time": sleepMainModel.beginTime,
          "end_time": sleepMainModel.endTime,
        };
        debugPrint('sleepJsonData>> $sleepJsonData');
        sendSleepData.add(sleepJsonData);
      }
    }else {
      if (getCalenderDateTimeList.isNotEmpty) {
        for (String calender in getCalenderDateTimeList) {
          //DateTime dateTime = DateTime.tryParse(calender);
          //String week = calWeeks[dateTime.weekday - 1];
          int totalHrsNum = 0;
          int totalLightNum = 0;
          int totalAwakeNum = 0;
          int totalDeepNum = 0;

          List<dynamic> sleepDataList = sleepData.where((element) => element['calender'].toString().trim() == calender).toList();

          if (sleepDataList.isNotEmpty) {

            DateTime parseCalender = DateTime.parse(calender.toString().trim());

            for (var element in sleepDataList) {
              //debugPrint('sleep_element>> $element');
              int startNum = int.parse(element['startTimeNum'].toString());
              int endNum = int.parse(element['endTimeNum'].toString());
              int diffNum = endNum - startNum;

              if (element['state'].toString() == "0") {
                totalDeepNum = totalDeepNum + diffNum;
              }
              if (element['state'].toString() == "1") {
                totalLightNum = totalLightNum + diffNum;
              }
              if (element['state'].toString() == "2") {
                totalAwakeNum = totalAwakeNum + diffNum;
              }
              totalHrsNum = totalHrsNum + diffNum;
            }

            String total = GlobalMethods.getTimeByIntegerMin(totalHrsNum);
            String deep = GlobalMethods.getTimeByIntegerMin(totalDeepNum);
            String light = GlobalMethods.getTimeByIntegerMin(totalLightNum);
            String awake = GlobalMethods.getTimeByIntegerMin(totalAwakeNum);

            String beginTime = sleepDataList[0]["startTime"].toString();
            //String beginTimeNum = sleepDataList[0]["startTimeNum"].toString();
            String endTime = sleepDataList[sleepDataList.length - 1]["endTime"].toString();
            //String endTimeNum = sleepDataList[sleepDataList.length - 1]["endTimeNum"].toString();

            var sleepJsonData = {
              "date": parseCalender.toUtc().toIso8601String(),
              "deep": deep,
              "light": light,
              "awake_hrs": awake,
              "sleep_hrs": total,
              "start_time": beginTime,
              "end_time": endTime,
            };

            sendSleepData.add(sleepJsonData);
          }
        }
      }
    }
  }

  Future<void> updateHR24SyncSDKData(var hr24Data) async {
    List<BandHRModel> smartHr24List = await getCurrentDayHRData(hr24Data);
    //debugPrint('smartHr24List>> $smartHr24List');
    if (smartHr24List.isNotEmpty) {
      //debugPrint('inside_smartHr24List >> $smartHr24List');
      String hr24Value = smartHr24List[smartHr24List.length - 1].rate;
      String calender = smartHr24List[smartHr24List.length - 1].calender ?? '';
      String time = smartHr24List[smartHr24List.length - 1].time;
      String dateTime = getTimeByCalenderTime(calender, time);
      updateHearRate(hr24Value, dateTime);
    }

    //sync save
    overAllHrData = jsonEncode(hr24Data);
    update();
    await sharedService.setOverAllHeartRate(getOverAllHrData);

    if (isCurrentDataTime) {
      for (var element in smartHr24List) {
        String dateTime = getTimeByCalenderTime(element.calender, element.time);
        debugPrint('dateTime123>> $dateTime');
        String jsonDateTime = DateTime.parse(dateTime).toUtc().toIso8601String();
        var hrJsonData = {
          "date": jsonDateTime,
          "real_time_value": element.rate,
        };
        debugPrint('hrJsonData>> $hrJsonData');
        sendHRData.add(hrJsonData);
      }
    } else {
      if (getCalenderDateTimeList.isNotEmpty) {
        List<dynamic> lastHeartRateList = await getLastHRDataSyncAllData(hr24Data, getCalenderDateTimeList);
        debugPrint('lastHeartRateListSize>> ${lastHeartRateList.length}');
        sendHRData = lastHeartRateList;
      }
    }
  }

  Future<void> updateBloodPressureSyncSDKData(var bloodPressureData) async {
    // String calenderTime = GlobalMethods.convertBandReadableCalender(DateTime.now());
    // debugPrint('calenderTime>> $calenderTime');
    List<BandBPModel> smartBpDataList = await getCurrentDayBPData(bloodPressureData);
    if (smartBpDataList.isNotEmpty) {
      String high = smartBpDataList[smartBpDataList.length - 1].high ?? '-';
      String low = smartBpDataList[smartBpDataList.length - 1].low ?? '-';
      String calender = smartBpDataList[smartBpDataList.length - 1].calender ?? '';
      String time = smartBpDataList[smartBpDataList.length - 1].time;
      String dateTime = getTimeByCalenderTime(calender, time);
      debugPrint('bp value $high /$low - $dateTime');
      updateBloodPressure('$high /$low', dateTime);
    }
    //sync save
    overAllBPData = jsonEncode(bloodPressureData);
    update();
    await sharedService.setOverAllBP(getOverAllBPData);

    if (isCurrentDataTime) {
      for (var bpData in smartBpDataList) {
        String calDateTime = getTimeByCalenderTime(bpData.calender, bpData.time);
        String bpSyncTime = DateTime.tryParse(calDateTime)!.toUtc().toIso8601String();
        var bpJsonData = {
          "date": bpSyncTime,
          "systolic": bpData.high,
          "dystolic": bpData.low,
          "unit": "mmHg"
        };
        debugPrint('bpJsonData>> $bpJsonData');
        sendBPData.add(bpJsonData);
      }
    } else {
      if (getCalenderDateTimeList.isNotEmpty) {
        List<dynamic> lastBPList = await getLastBPDataSync(bloodPressureData, getCalenderDateTimeList);
        debugPrint('lastBPList>> ${lastBPList.length}');
        sendBPData = lastBPList;
      }
    }
  }

  Future<void> updateTemperatureSyncSDKData(var temperatureData) async {
    // String calenderTime = GlobalMethods.convertBandReadableCalender(DateTime.now());
    // debugPrint('calenderTime>> $calenderTime');
    List<BandTempModel> smartTempDataList = await getCurrentDayTemperatureData(temperatureData);
    if (smartTempDataList.isNotEmpty) {
      String inFahrenheit = smartTempDataList[smartTempDataList.length - 1].inFahrenheit;
      String inCelsius = smartTempDataList[smartTempDataList.length - 1].inCelsius;
      String calender = smartTempDataList[smartTempDataList.length - 1].calender ?? '';
      String time = smartTempDataList[smartTempDataList.length - 1].time;
      String dateTime = getTimeByCalenderTime(calender, time);
      debugPrint('dateTime_inFahrenheit>> $dateTime');
      updateTemperature(inCelsius, inFahrenheit, dateTime);
    }
    //sync save
    overAllTempData = jsonEncode(temperatureData);
    update();
    await sharedService.setOverAllTemperature(getOverAllTempData);

    if (isCurrentDataTime) {
      for (var data in smartTempDataList) {
        String calDateTime = getTimeByCalenderTime(data.calender, data.time);
        debugPrint('calDateTime123>>$calDateTime');
        String tempSyncTime = DateTime.parse(calDateTime).toUtc().toIso8601String();
        var tempJsonData = {
          "date": tempSyncTime,
          "unit": getIsCelsius ? tempAPIInCelsius : tempAPIInFahrenheit,
          "temperature": getIsCelsius ? data.inCelsius : data.inFahrenheit
        };
        debugPrint('tempJsonData>> $tempJsonData');
        sendTempData.add(tempJsonData);
      }
    } else {
      if (getCalenderDateTimeList.isNotEmpty) {
        List<dynamic> lastTempList = await getLastTemperatureDataSync(temperatureData, getCalenderDateTimeList);
        debugPrint('lastTempList>> ${lastTempList.length}');
        sendTempData = lastTempList;
      }
    }
  }

  Future<void> updateOxygenSyncSDKData(var oxygenData) async {
    List<BandOxygenModel> smartOxygenDataList = await getCurrentDayOxygenData(oxygenData);
    if (smartOxygenDataList.isNotEmpty) {
      String oxygenValue = smartOxygenDataList[smartOxygenDataList.length - 1].value;
      String calender = smartOxygenDataList[smartOxygenDataList.length - 1].calender ?? '';
      String time = smartOxygenDataList[smartOxygenDataList.length - 1].time ?? '';
      String dateTime = getTimeByCalenderTime(calender, time);
      debugPrint('dateTime_Oxygen>> $dateTime');
      debugPrint('oxygenValue>> $oxygenValue');
      updateOxygenSaturation(oxygenValue, dateTime);
    }
    //sync save
    overAllOxygenData = jsonEncode(oxygenData);
    update();
    await sharedService.setOverAllOxygenData(getOverAllOxygenData);

    if (isCurrentDataTime) {
      for (var data in smartOxygenDataList) {
        String calDateTime = getTimeByCalenderTime(data.calender, data.time);
        String oxySyncTime = DateTime.tryParse(calDateTime)!.toUtc().toIso8601String();
        var oxyJsonData = {
          "date": oxySyncTime,
          "spo2": data.value,
        };
        debugPrint('oxyJsonData>> $oxyJsonData');
        sendSpo2Data.add(oxyJsonData);
      }
    } else {
      if (getCalenderDateTimeList.isNotEmpty) {
        List<dynamic> lastOxyList = await getLastOxygenDataSync(oxygenData, getCalenderDateTimeList);
        debugPrint('lastOxyList>> ${lastOxyList.length}');
        sendSpo2Data = lastOxyList;
      }
    }
  }

  Future<void> fetchOverAllDeviceDataSync() async {
    try {
      Map<String, dynamic> resultOverAllDeviceData = await flutterBandFit.fetchOverAllDeviceData();
      debugPrint('resultOverAllDeviceData>>$resultOverAllDeviceData');
      String status = resultOverAllDeviceData['status'].toString();

      //DateTime currentDataTime = DateTime.now();

      if (status == BandFitConstants.SC_SUCCESS) {
        var resultData = resultOverAllDeviceData['data'];
        var stepsData = resultData['steps'];
        var sleepData = resultData['sleep'];
        var hr24Data = resultData['hr24'];
        var bpData = resultData['bp'];
        var temperatureData = resultData['temperature'];
        var oxygenData = resultData['oxygen'];

        // debugPrint('steps data>> $stepsData');
        // debugPrint('sleep data>> $sleepData');
        // log('hr24 data>> $hr24Data');
        // debugPrint('bp data>> $bpData');
        // debugPrint('temperature data>> $temperatureData');
        // debugPrint('oxygenData>> $oxygenData');

        String calenderTime = GlobalMethods.convertBandReadableCalender(DateTime.now());
        debugPrint('calenderTime>> $calenderTime');
        await verifyToSendCurrentData(getLastSyncDated, getLastSyncDateTime);

        //bool currentData = true; // true always
        //List<String> calenderDateList = [];
        /*if (getLastSyncDated.isNotEmpty && getLastSyncDateTime != null && getLastSyncDateTime.isNotEmpty) {
          debugPrint('getLastSyncDatedTime >> $getLastSyncDated');
          currentDataTime = DateTime.tryParse(getLastSyncDateTime);
          //lastTime = DateTime.parse('20220401'); //static
          debugPrint('lastTime>> $currentDataTime');
          debugPrint('lastTimeDay>> ${currentDataTime.day}');
          int timeDifference = currentTimeDayDifference(currentDataTime);
          debugPrint('timeDifference>>$timeDifference');
          if (timeDifference >= 1) {
            currentData = false;
            calenderDateList = await GlobalMethods.getDatesListByLastDateTime(currentDataTime);
          } else {
            currentData = true;
          }
        }*/

        debugPrint('isCurrentDataTime>> $isCurrentDataTime');
        debugPrint('calenderDateList>> $getCalenderDateTimeList');

        // backend sending data
        var sendWalking = [];
        var sendSleep = [];
        var sendHR = [];
        var sendBP = [];
        var sendTemp = [];
        var sendSpo2 = [];

        if (stepsData != null && stepsData.length > 0) {
         // log('inside_stepsData>> $stepsData');
          List<StepsMainModel> stepsTodayList = await getCurrentDaySteps(stepsData);
          debugPrint('stepsTodayList1>> ${stepsTodayList.length}');
          if (stepsTodayList.isNotEmpty) {
            StepsMainModel stepsMainModel = stepsTodayList[stepsTodayList.length - 1];
            updateDeviceStats(stepsMainModel.steps, stepsMainModel.distance, stepsMainModel.calories);
            //adding for backend
            if (isCurrentDataTime) {
              for (var element in stepsTodayList) {
                String calender = element.calender;
                String calories = element.calories;
                String distance = element.distance;
                //String totalSteps = element.steps;
                if (element.dataList.isNotEmpty) {
                  for (var ele in element.dataList) {
                    String dateTime = getTimeByCalenderTime(calender.toString(), ele.time);
                    String jsonDateTime = DateTime.tryParse(dateTime)!.toUtc().toIso8601String();
                    var jsonData = {
                      "date": jsonDateTime,
                      "target_steps": targetedSteps,
                      "walked_steps": ele.step,
                      "calories": calories, //common
                      "distance": distance, //common
                    };
                    debugPrint('steps_map_data>> $jsonData');
                    sendWalking.add(jsonData);
                  }
                }
              }
            } else {
              if (getCalenderDateTimeList.isNotEmpty) {
                for (String dateTime in getCalenderDateTimeList) {
                  debugPrint('step_dateTime>> $dateTime');
                  Map<String, dynamic> response = await flutterBandFit.fetchStepsByDate(dateTime);
                  debugPrint('step_response>>$response');
                  if (response.isNotEmpty) {
                    String status = response['status'].toString();
                    if (status == BandFitConstants.SC_SUCCESS) {
                      StepsMainModel stepsMainModel = StepsMainModel.fromJson(response);
                      for (var element in stepsMainModel.dataList) {
                        String dateTime = getTimeByCalenderTime(stepsMainModel.calender.toString(), element.time);
                        String jsonDateTime = DateTime.tryParse(dateTime)!.toUtc().toIso8601String();
                        var jsonData = {
                          "date": jsonDateTime,
                          "target_steps": targetedSteps,
                          "walked_steps": element.step,
                          "calories": stepsMainModel.calories, //common
                          "distance": stepsMainModel.distance, //common
                        };
                        debugPrint('steps_map_data>> $jsonData');
                        sendWalking.add(jsonData);
                      }
                    }
                  }
                }
              }
            }
          }
        }

        if (sleepData != null && sleepData.length > 0) {
          debugPrint('inside_sleepData >> $sleepData');
          List<SleepMainModel> sleepTodayList = await getCurrentDaySleepData(sleepData);
          if (sleepTodayList.isNotEmpty) {
            SleepMainModel sleepMainModel = sleepTodayList[sleepTodayList.length - 1];
            updateDeviceSleep(sleepMainModel.total, sleepMainModel.calender);
            if (isCurrentDataTime) {
              DateTime parseCalender = DateTime.parse(sleepMainModel.calender.toString().trim());
              var sleepJsonData = {
                "date": parseCalender.toUtc().toIso8601String(),
                "deep": sleepMainModel.deep,
                "light": sleepMainModel.light,
                "awake_hrs": sleepMainModel.awake,
                "sleep_hrs": sleepMainModel.total,
                "start_time": sleepMainModel.beginTime,
                "end_time": sleepMainModel.endTime,
              };
              debugPrint('sleepJsonData>> $sleepJsonData');
              sendSleep.add(sleepJsonData);
            } else {
              List<dynamic> lastSleepList = await getLastSleepDataSync(sleepData, getCalenderDateTimeList);
              debugPrint('lastSleepList>> ${lastSleepList.length}');
              sendSleep = lastSleepList;
            }
          }
        }

        if (hr24Data != null && hr24Data.length > 0) {
          List<BandHRModel> smartHr24List = await getCurrentDayHRData(hr24Data);
          debugPrint('smartHr24List>> $smartHr24List');
          if (smartHr24List.isNotEmpty) {
            //debugPrint('inside_smartHr24List >> $smartHr24List');
            String hr24Value = smartHr24List[smartHr24List.length - 1].rate;
            String calender = smartHr24List[smartHr24List.length - 1].calender ?? '';
            String time = smartHr24List[smartHr24List.length - 1].time ?? '';
            String dateTime = getTimeByCalenderTime(calender, time);
            updateHearRate(hr24Value, dateTime);

            if (isCurrentDataTime) {
              for (var element in smartHr24List) {
                String dateTime = getTimeByCalenderTime(element.calender, element.time);
                String jsonDateTime = DateTime.tryParse(dateTime)!.toUtc().toIso8601String();
                var hrJsonData = {
                  "date": jsonDateTime,
                  "real_time_value": element.rate,
                };
                debugPrint('hrJsonData>> $hrJsonData');
                sendHR.add(hrJsonData);
              }
            } else {
              if (getCalenderDateTimeList.isNotEmpty) {
                List<dynamic> lastHeartRateList = await getLastHRDataSyncAllData(hr24Data, getCalenderDateTimeList);
                debugPrint('lastHeartRateListSize>> ${lastHeartRateList.length}');
                sendHR = lastHeartRateList;
              }
            }
          }
        }

        if (bpData != null && bpData.length > 0) {
          List<BandBPModel> smartBpDataList = await getCurrentDayBPData(bpData);
          if (smartBpDataList.isNotEmpty) {
            String high = smartBpDataList[smartBpDataList.length - 1].high ?? '-';
            String low = smartBpDataList[smartBpDataList.length - 1].low ?? '-';
            String calender = smartBpDataList[smartBpDataList.length - 1].calender ?? '';
            String time = smartBpDataList[smartBpDataList.length - 1].time ?? '';
            String dateTime = getTimeByCalenderTime(calender, time);
            debugPrint('bp value $high /$low - $dateTime');
            updateBloodPressure('$high /$low', dateTime);
            if (isCurrentDataTime) {
              for (var bpData in smartBpDataList) {
                String calDateTime = getTimeByCalenderTime(bpData.calender, bpData.time);
                String bpSyncTime = DateTime.tryParse(calDateTime)!.toUtc().toIso8601String();
                var bpJsonData = {
                  "date": bpSyncTime,
                  "systolic": bpData.high,
                  "dystolic": bpData.low,
                  "unit": "mmHg"
                };
                debugPrint('bpJsonData>> $bpJsonData');
                sendBP.add(bpJsonData);
              }
            } else {
              if (getCalenderDateTimeList.isNotEmpty) {
                List<dynamic> lastBPList = await getLastBPDataSync(bpData, getCalenderDateTimeList);
                debugPrint('lastBPList>> ${lastBPList.length}');
                sendBP = lastBPList;
              }
            }
          }
        }

        if (temperatureData != null && temperatureData.length > 0) {
          List<BandTempModel> smartTempDataList = await getCurrentDayTemperatureData(temperatureData);
          //update temperature to UI
          if (smartTempDataList.isNotEmpty) {
            String inFahrenheit = smartTempDataList[smartTempDataList.length - 1].inFahrenheit;
            String inCelsius = smartTempDataList[smartTempDataList.length - 1].inCelsius;
            String calender = smartTempDataList[smartTempDataList.length - 1].calender ?? '';
            String time = smartTempDataList[smartTempDataList.length - 1].time ?? '';
            //  String startDate = smartTempData[smartTempData.length-1].startDate??'';
            String dateTime = getTimeByCalenderTime(calender, time);
            //debugPrint('inFahrenheit>> $inFahrenheit - $dateTime');
            debugPrint('dateTime_inFahrenheit>> $dateTime');
            //debugPrint('dateTimeISO_inFahrenheit>> ${DateTime.tryParse(dateTime).toIso8601String()}');
            // String tempSyncTime = DateTime.tryParse(dateTime).toUtc().toIso8601String();
            updateTemperature(inCelsius, inFahrenheit, dateTime);

            if (isCurrentDataTime) {
              for (var data in smartTempDataList) {
                String calDateTime = getTimeByCalenderTime(data.calender, data.time);
                String tempSyncTime = DateTime.tryParse(calDateTime)!.toUtc().toIso8601String();
                var tempJsonData = {
                  "date": tempSyncTime,
                  "unit": getIsCelsius ? tempAPIInCelsius : tempAPIInFahrenheit,
                  "temperature": getIsCelsius ? data.inCelsius : data.inFahrenheit
                };
                debugPrint('tempJsonData>> $tempJsonData');
                sendTemp.add(tempJsonData);
              }
            } else {
              if (getCalenderDateTimeList.isNotEmpty) {
                List<dynamic> lastTempList = await getLastTemperatureDataSync(temperatureData, getCalenderDateTimeList);
                debugPrint('lastTempList>> ${lastTempList.length}');
                sendTemp = lastTempList;
              }
            }
          }
        }

        if (oxygenData != null && oxygenData.length > 0) {
          List<BandOxygenModel> smartOxygenDataList = await getCurrentDayOxygenData(oxygenData);
          //update temperature to UI
          if (smartOxygenDataList.isNotEmpty) {
            String oxygenValue = smartOxygenDataList[smartOxygenDataList.length - 1].value;
            String calender = smartOxygenDataList[smartOxygenDataList.length - 1].calender ?? '';
            String time = smartOxygenDataList[smartOxygenDataList.length - 1].time ?? '';
            String dateTime = getTimeByCalenderTime(calender, time);
            debugPrint('dateTime_Oxygen>> $dateTime');
            debugPrint('oxygenValue>> $oxygenValue');
            updateOxygenSaturation(oxygenValue, dateTime);

            if (isCurrentDataTime) {
              for (var data in smartOxygenDataList) {
                String calDateTime = getTimeByCalenderTime(data.calender, data.time);
                String oxySyncTime = DateTime.tryParse(calDateTime)!.toUtc().toIso8601String();
                var oxyJsonData = {
                  "date": oxySyncTime,
                  "spo2": data.value,
                };
                debugPrint('oxyJsonData>> $oxyJsonData');
                sendSpo2.add(oxyJsonData);
              }
            } else {
              if (getCalenderDateTimeList.isNotEmpty) {
                List<dynamic> lastOxyList = await getLastOxygenDataSync(oxygenData, getCalenderDateTimeList);
                debugPrint('lastOxyList>> ${lastOxyList.length}');
                sendSpo2 = lastOxyList;
              }
            }
          }
        }

        overAllStepsData = jsonEncode(stepsData);
        overAllSleepData = jsonEncode(sleepData);
        overAllHrData = jsonEncode(hr24Data);
        overAllBPData = jsonEncode(bpData);
        overAllTempData = jsonEncode(temperatureData);
        overAllOxygenData = jsonEncode(oxygenData);

        update();

        await sharedService.setOverAllSteps(overAllStepsData);
        await sharedService.setOverAllSleep(overAllSleepData);
        await sharedService.setOverAllHeartRate(overAllHrData);
        await sharedService.setOverAllBP(overAllBPData);
        await sharedService.setOverAllTemperature(overAllTempData);
        await sharedService.setOverAllOxygenData(overAllOxygenData);

      } else if (status == BandFitConstants.SC_DISCONNECTED) {
        // device got disconnected.
      } else if (status == BandFitConstants.SC_FAILURE) {
        // something went wrong
      } else {
        // something went wrong
      }
    } catch (e) {
      debugPrint('fetchExp: $e');
    }
  }

  int currentTimeDayDifference(DateTime lastTime) {
    var currentTime = DateTime.now();
    int timeDifference = currentTime.difference(lastTime).inDays;
    return timeDifference;
  }

  Future<List<StepsMainModel>> getSelectedDayStepsData(List<dynamic> overAllStepsData, [String? calenderTime]) async {
    String findCalenderTime = '';
    if (calenderTime != null && calenderTime.isNotEmpty) {
      findCalenderTime = calenderTime;
    } else {
      //current calender time
      String currentCalTime = GlobalMethods.convertBandReadableCalender(DateTime.now());
      findCalenderTime = currentCalTime;
    }

    List<StepsMainModel> stepsMainList = [];
    List<BandStepsModel> dataList = [];

    List<BandStepsDataModel> stepsSelectedList = [];

    int totalStepsValue = 0;
    double totalCal = 0.0;
    double totalDistance = 0.0;

    for (var data in overAllStepsData) {
      if (data['calender'].toString().trim() == findCalenderTime) {
        BandStepsDataModel stepsDataModel = BandStepsDataModel.fromJson(data);
        dataList.add(BandStepsModel(step: stepsDataModel.step, time: stepsDataModel.time));

        totalStepsValue = totalStepsValue + int.parse(stepsDataModel.step);

      //  debugPrint('stepsDataModel.calories>> ${double.parse(stepsDataModel.calories).toStringAsFixed(2)}');
       // debugPrint('stepsDataModel.distance>> ${double.parse(stepsDataModel.distance).round()}');

        totalCal = totalCal + double.parse(stepsDataModel.calories);
        totalDistance = totalDistance + double.parse(stepsDataModel.distance);
        stepsSelectedList.add(stepsDataModel);
      }
    }
    if (stepsSelectedList.isNotEmpty) {

      debugPrint('totalCal>> $totalCal');
      debugPrint('totalDistance>> $totalDistance');

     // debugPrint('stepsDataModel.distance>> ${totalDistance.round()}');
     // debugPrint('stepsDataModel.distance>> ${totalDistance.roundToDouble()}');

      if (totalDistance > 0.0) {
        totalDistance = totalDistance.roundToDouble() / 1000; //Converting in kM
      }

     // debugPrint('totalDistance12>> $totalDistance');
      // if (totalCal > 0.0) {
      //   totalCal = totalCal.roundToDouble() / 1000; //Converting in kCal
      // }
      // roundToDouble()
      // totalCal.toStringAsFixed(2)
      stepsMainList.add(StepsMainModel(calender: findCalenderTime, dataList: dataList,
          steps: totalStepsValue.toString(),
          distance: totalDistance.toStringAsFixed(2),
          calories: totalCal.toStringAsFixed(2)));
    }
    //  debugPrint('return_stepsList>>$stepsList');
    return stepsMainList;
  }

  Future<List<StepsMainModel>> getCurrentDaySteps(var overAllStepsData, [String? calenderTime]) async {
    String findCalenderTime = '';
    if (calenderTime != null && calenderTime.isNotEmpty) {
      findCalenderTime = calenderTime;
    } else {
      //current calender time
      String currentCalTime = GlobalMethods.convertBandReadableCalender(DateTime.now());
      findCalenderTime = currentCalTime;
    }

    List<StepsMainModel> stepsList = [];
    for (var data in overAllStepsData) {
      //debugPrint('step_data>> $data');
      if (data['calender'].toString().trim() == findCalenderTime) {

        debugPrint('stepsDataModel.calories>> ${data['calories']}');
        debugPrint('stepsDataModel.distance>> ${data['distance']}');

        stepsList.add(StepsMainModel.fromJson(data));
      }
    }
    //  debugPrint('return_stepsList>>$stepsList');
    return stepsList;
  }

  Future<List<dynamic>> getSelectedRangeStepsData(bool isMonthly, List<dynamic> overAllStepsData, List<String> calenderWeekList, BuildContext context, int totalTargetedSteps) async {

    //List<BandStepsDataModel> stepsList =[];
    List<WeekStepsData> weekDataList = [];
    List<MonthStepsData> monthDataList = [];
    double totalSteps = 0.0;
    double totalDistance = 0.0;
    double totalCalories = 0.0;

    for (var calender in calenderWeekList) {
      int steps = 0;
      double kCal = 0.0;
      double distance = 0.0;

      DateTime? dateTime = DateTime.tryParse(calender);
      String week = calWeeks[dateTime!.weekday - 1];

      overAllStepsData.where((element) => element['calender'].toString().trim() == calender).toList().forEach((element) {
        steps = steps + int.parse(element['step'].toString());
        distance = distance + double.tryParse(element['distance'].toString())!;
        kCal = kCal + double.tryParse(element['calories'].toString())!;
      });

      if (isMonthly) {
        monthDataList.add(
          MonthStepsData(
              dayNumber: dateTime.day,
              dataPoint: steps,
              color: steps >= totalTargetedSteps ? completeColor : darkStepsColor),
        );
      } else {
        weekDataList.add(WeekStepsData(
            weekName: week,
            dateTime: dateTime,
            dataPoint: steps,
            color: steps < totalTargetedSteps ? darkStepsColor : completeColor));
      }

      //adding all the data based on the calender
      totalSteps = totalSteps + steps.toDouble();
      totalDistance = totalDistance + distance;
      totalCalories = totalCalories + kCal;
    }

    if (weekDataList.isNotEmpty || monthDataList.isNotEmpty) {
      if (totalDistance > 0.0) {
        totalDistance = totalDistance / 1000; //Converting in kM
      }
      if (totalCalories > 0.0) {
        totalCalories = totalCalories / 1000; //Converting in kCal
      }
    }
    // for(var data in overAllStepsData){
    //   if(weekList.contains(data['calender'].toString().trim())){
    //     //verification all the list of week data
    //     stepsList.add(BandStepsDataModel.fromJson(data));
    //   }
    // }
    if (isMonthly) {
      return [monthDataList, totalSteps, totalDistance, totalCalories];
    } else {
      return [weekDataList, totalSteps, totalDistance, totalCalories];
    }
  }

  Future<List<StepsMainModel>> getStepsBySelectedWeek(var overAllStepsData, List<String> weekList) async {
    List<StepsMainModel> stepsList = [];
    for (var data in overAllStepsData) {
      //debugPrint('step_data>> $data');
      if (weekList.contains(data['calender'].toString().trim())) {
        stepsList.add(StepsMainModel.fromJson(data));
      }
    }
    //debugPrint('return_weekList>>$stepsList');
    return stepsList;
  }

  Future<List<SleepMainModel>> getSelectedDaySleepData(var overAllSleepData, [String? calenderTime]) async {
    String findCalenderTime = '';
    if (calenderTime != null && calenderTime.isNotEmpty) {
      findCalenderTime = calenderTime;
    } else {
      //current calender time
      String currentCalTime = GlobalMethods.convertBandReadableCalender(DateTime.now());
      findCalenderTime = currentCalTime;
    }

    List<SleepMainModel> sleepMainList = [];
    List<BandSleepModel> dataList = [];

    int totalDeepNum = 0;
    int totalLightNum = 0;
    int totalAwakeNum = 0;
    int totalNum = 0;

    for (var data in overAllSleepData) {
      if (data['calender'].toString().trim() == findCalenderTime) {
        // deep sleep: 0, Light sleep: 1,  awake: 2
        debugPrint('sleepData>> $data');
        BandSleepModel sleepModel = BandSleepModel.fromJson(data);

        DateTime startDateTime = DateTime.parse(sleepModel.startDateTime);
        DateTime endDateTime = DateTime.parse(sleepModel.endDateTime);

        //int inHours = endDateTime.difference(startDateTime).inHours;
        int inMinutes = endDateTime.difference(startDateTime).inMinutes;
        //int diffNum =  inMinutes;

        debugPrint("diffNum>> $inMinutes");
        totalNum = totalNum + inMinutes;

        if (sleepModel.state == "0") {
          //deep
          totalDeepNum = totalDeepNum + inMinutes;
        }
        if (sleepModel.state == "1") {
          //light
          totalLightNum = totalLightNum + inMinutes;
        }
        if (sleepModel.state == "2") {
          // awake
          totalAwakeNum = totalAwakeNum + inMinutes;
        }

        dataList.add(sleepModel);
      }
    }
    if (dataList.isNotEmpty) {
      String deepHours = GlobalMethods.getTimeByIntegerMin(totalDeepNum);
      String lightHours = GlobalMethods.getTimeByIntegerMin(totalLightNum);
      String awakeHours = GlobalMethods.getTimeByIntegerMin(totalAwakeNum);
      String totalHours = GlobalMethods.getTimeByIntegerMin(totalNum);

      BandSleepModel beginModel = dataList[0];
      BandSleepModel endModel = dataList[dataList.length - 1];

      //debugPrint("deepHours>> $deepHours");
      //debugPrint("lightHours>> $lightHours");
      //debugPrint("awakeHours>> $awakeHours");
      //debugPrint("totalHours>> $totalHours");

      sleepMainList.add(SleepMainModel(
        calender: findCalenderTime,
        total: totalHours,
        totalNum: totalNum.toString(),
        deep: deepHours,
        deepNum: totalDeepNum.toString(),
        light: lightHours,
        lightNum: totalLightNum.toString(),
        awake: awakeHours,
        awakeNum: totalAwakeNum.toString(),
        beginTime: beginModel.startTime,
        beginTimeNum: beginModel.startTimeNum,
        endTime: endModel.endTime,
        endTimeNum: endModel.endTimeNum, dataList:dataList,
      ));
    }
    return sleepMainList;
  }

  Future<List<dynamic>> getSleepDataSelectedRange(bool isMonthly, var overAllSleepData, List<String> calenderWeekList, BuildContext context) async {

    List<WeeklySleepData> weeklyDataList = [];
    List<MonthlySleepData> monthlyDataList = [];

    int totalHrsNum = 0;
    int totalLightNum = 0;
    int totalAwakeNum = 0;
    int totalDeepNum = 0;

    for (var calender in calenderWeekList) {
      DateTime? dateTime = DateTime.tryParse(calender);
      String week = calWeeks[dateTime!.weekday - 1];

      List<dynamic> sleepDataList = overAllSleepData.where((element) => element['calender'].toString().trim() == calender).toList();

      if (sleepDataList.isNotEmpty) {
        for (var element in sleepDataList) {
         // debugPrint('sleep_element>> $element');
          try{
            DateTime startDateTime = DateTime.parse(element['startDateTime'].toString());//.toLocal();
            DateTime endDateTime = DateTime.parse(element['endDateTime'].toString());//.toLocal();

            //int inHours = endDateTime.difference(startDateTime).inHours;
            int inMinutes = endDateTime.difference(startDateTime).inMinutes;
            //int inSeconds = endDateTime.difference(startDateTime).inSeconds;
            //debugPrint('inHours>> $inHours, inMinutes>> $inMinutes');
           // int diffNum =  inMinutes;
            if (element['state'].toString() == "0") {//deep
              totalDeepNum = totalDeepNum + inMinutes;
            }
            if (element['state'].toString() == "1") {//light
              totalLightNum = totalLightNum + inMinutes;
            }
            if (element['state'].toString() == "2") {// awake
              totalAwakeNum = totalAwakeNum + inMinutes;
            }
            totalHrsNum = totalHrsNum + inMinutes;
          }catch(e){
            debugPrint('sleep_exp>> $e');
          }
          //int startNum = int.parse(element['startTimeNum'].toString());
         // int endNum = int.parse(element['endTimeNum'].toString());
          //int diffNum = endNum - startNum;
          // if (element['state'].toString() == "0") {
          //   //deep
          //   totalDeepNum = totalDeepNum + diffNum;
          // }
          // if (element['state'].toString() == "1") {
          //   //light
          //   totalLightNum = totalLightNum + diffNum;
          // }
          // if (element['state'].toString() == "2") {
          //   // awake
          //   totalAwakeNum = totalAwakeNum + diffNum;
          // }
          // totalHrsNum = totalHrsNum + diffNum;
        }

        List<String> beginTime = sleepDataList[0]["startTime"].toString().split(':');
        String beginTimeNum = sleepDataList[0]["startTimeNum"].toString();

        List<String> endTime = sleepDataList[sleepDataList.length - 1]["endTime"].toString().split(':');
        String endTimeNum = sleepDataList[sleepDataList.length - 1]["endTimeNum"].toString();

        if (isMonthly) {
          monthlyDataList.add(MonthlySleepData(
            color: sleepLightColor,
            dayNumber: dateTime.day,
            startTime: DateTime(dateTime.year, dateTime.month, dateTime.day, int.tryParse(beginTime[0])!, int.tryParse(beginTime[1])!),
            endTime: DateTime(dateTime.year, dateTime.month, dateTime.day, int.tryParse(endTime[0])!, int.tryParse(endTime[1])!),
            startTimeNum: int.tryParse(beginTimeNum)!,
            endTimeNum: int.tryParse(endTimeNum)!,
          ));
        } else {
          weeklyDataList.add(WeeklySleepData(
            weekName: week,
            color: sleepLightColor,
            startTime: DateTime(dateTime.year, dateTime.month, dateTime.day, int.tryParse(beginTime[0])!, int.tryParse(beginTime[1])!),
            endTime: DateTime(dateTime.year, dateTime.month, dateTime.day, int.tryParse(endTime[0])!, int.tryParse(endTime[1])!),
            startTimeNum: int.tryParse(beginTimeNum)!,
            endTimeNum: int.tryParse(endTimeNum)!,
          ));
        }
      }
    }
    if (isMonthly) {
      return [
        monthlyDataList,
        totalHrsNum,
        totalDeepNum,
        totalAwakeNum,
        totalLightNum
      ];
    } else {
      return [
        weeklyDataList,
        totalHrsNum,
        totalDeepNum,
        totalAwakeNum,
        totalLightNum
      ];
    }
  }

  Future<List<dynamic>> getLastSleepDataSync(var overAllSleepData, List<String> calenderDateList) async {
    List<dynamic> lastSleepList = [];
    for (var data in overAllSleepData) {
      if (calenderDateList.contains(data['calender'].toString().trim())) {
        String calender = data['calender'].toString().trim();
        String deep = data['deep'].toString();
        String total = data['total'].toString();
        String light = data['light'].toString();
        String awake = data['awake'].toString();
        String beginTime = data['beginTime'].toString();
        String endTime = data['endTime'].toString();
        DateTime parseCalender = DateTime.parse(calender);

        var sleepJsonData = {
          "date": parseCalender.toUtc().toIso8601String(),
          "deep": deep,
          "light": light,
          "awake_hrs": awake,
          "sleep_hrs": total,
          "start_time": beginTime,
          "end_time": endTime,
        };

        debugPrint('sleepJsonData>> $sleepJsonData');
        lastSleepList.add(sleepJsonData);
      }
    }
    return lastSleepList;
  }

  Future<List<SleepMainModel>> getCurrentDaySleepData(var overAllSleepData, [String? calenderTime]) async {
    String findCalenderTime = '';
    if (calenderTime != null && calenderTime.isNotEmpty) {
      findCalenderTime = calenderTime;
    } else {
      //current calender time
      String currentCalTime = GlobalMethods.convertBandReadableCalender(DateTime.now());
      findCalenderTime = currentCalTime;
    }
    List<SleepMainModel> sleepList = [];
    for (var data in overAllSleepData) {
      //debugPrint('sleep_data >> $data');
      if (data['calender'].toString().trim() == findCalenderTime) {
        sleepList.add(SleepMainModel.fromJson(data));
      }
    }
    return sleepList;
  }

  Future<List<SleepMainModel>> getSleepBySelectedWeek(var overAllSleepData, List<String> weekList) async {
    List<SleepMainModel> sleepList = [];
    for (var data in overAllSleepData) {
      //debugPrint('step_data>> $data');
      if (weekList.contains(data['calender'].toString().trim())) {
        sleepList.add(SleepMainModel.fromJson(data));
      }
    }
    //debugPrint('return_weekList>>$stepsList');
    return sleepList;
  }

  Future<List<dynamic>> getLastHRDataSyncAllData(var overAllHrData, List<String> calenderDateList) async {
    List<dynamic> returnHRList = [];
    for (var data in overAllHrData) {
      if (calenderDateList.contains(data['calender'].toString().trim())) {
        BandHRModel bandHRModel = BandHRModel.fromJson(data);
        String dateTime = getTimeByCalenderTime(bandHRModel.calender, bandHRModel.time);
        String jsonDateTime = DateTime.tryParse(dateTime)!.toUtc().toIso8601String();

        var hrJsonData = {
          "date": jsonDateTime,
          "real_time_value": bandHRModel.rate,
        };
        debugPrint('hrJsonData>> $hrJsonData');
        returnHRList.add(hrJsonData);
      }
    }
    return returnHRList;
  }

  Future<List<BandHRModel>> getCurrentDayHRData(var overAllHrData, [String? calenderTime]) async {
    String findCalenderTime = '';
    if (calenderTime != null && calenderTime.isNotEmpty) {
      findCalenderTime = calenderTime;
    } else {
      //current calender time
      String currentCalTime = GlobalMethods.convertBandReadableCalender(DateTime.now());
      findCalenderTime = currentCalTime;
    }
    List<BandHRModel> hrList = [];
    try {
      for (var data in overAllHrData) {
        //debugPrint('hr_data >> $data');
        if (data['calender'].toString().trim() == findCalenderTime) {
          hrList.add(BandHRModel.fromJson(data));
        }
      }
    } catch (e) {
      debugPrint('inside_exp: $e');
    }
    return hrList;
  }

  Future<List<dynamic>> getLastBPDataSync(var overAllBPData, List<String> calenderDateList) async {
    List<dynamic> returnBpList = [];
    for (var data in overAllBPData) {
      if (calenderDateList.contains(data['calender'].toString().trim())) {
        BandBPModel bpModel = BandBPModel.fromJson(data);
        String calDateTime = getTimeByCalenderTime(bpModel.calender, bpModel.time);
        String bpSyncTime = DateTime.tryParse(calDateTime)!.toUtc().toIso8601String();

        var bpJsonData = {
          "date": bpSyncTime,
          "systolic": bpModel.high,
          "dystolic": bpModel.low,
          "unit": "mmHg"
        };
        debugPrint('bpJsonData>> $bpJsonData');

        returnBpList.add(bpJsonData);
      }
    }
    return returnBpList;
  }

  Future<List<BandBPModel>> getCurrentDayBPData(var overAllBPData, [String? calenderTime]) async {
    String findCalenderTime = '';
    if (calenderTime != null && calenderTime.isNotEmpty) {
      findCalenderTime = calenderTime;
    } else {
      //current calender time
      String currentCalTime = GlobalMethods.convertBandReadableCalender(DateTime.now());
      findCalenderTime = currentCalTime;
    }
    debugPrint('findCalenderTime>> $findCalenderTime');
    List<BandBPModel> bpList = [];
    for (var data in overAllBPData) {
      // debugPrint('bp_data >> $data');
      if (data['calender'].toString().trim() == findCalenderTime) {
        bpList.add(BandBPModel.fromJson(data));
      }
    }
    return bpList;
  }

  Future<List<BandOxygenModel>> getCurrentDayOxygenData(var oxyData, [String? calenderTime]) async {
    String findCalenderTime = '';
    if (calenderTime != null && calenderTime.isNotEmpty) {
      findCalenderTime = calenderTime;
    } else {
      //current calender time
      String currentCalTime = GlobalMethods.convertBandReadableCalender(DateTime.now());
      findCalenderTime = currentCalTime;
    }
    debugPrint('findCalenderTime>> $findCalenderTime');
    List<BandOxygenModel> oxyList = [];
    for (var data in oxyData) {
      if (data['calender'].toString().trim() == findCalenderTime) {
        oxyList.add(BandOxygenModel.fromJson(data));
      }
    }
    return oxyList;
  }

  Future<List<dynamic>> getLastOxygenDataSync(var overAllOxyData, List<String> calenderDateList) async {
    List<dynamic> returnOxyList = [];
    for (var data in overAllOxyData) {
      if (calenderDateList.contains(data['calender'].toString().trim())) {
        BandOxygenModel oxygenModel = BandOxygenModel.fromJson(data);
        String calDateTime = getTimeByCalenderTime(oxygenModel.calender, oxygenModel.time);
        String oxySyncTime = DateTime.tryParse(calDateTime)!.toUtc().toIso8601String();
        var oxyJsonData = {
          "date": oxySyncTime,
          "spo2": oxygenModel.value,
        };
        debugPrint('oxyJsonData>> $oxyJsonData');
        returnOxyList.add(oxyJsonData);
      }
    }
    return returnOxyList;
  }

  Future<List<dynamic>> getLastTemperatureDataSync(var temperatureData, List<String> calenderDateList) async {
    List<dynamic> lastTempList = [];
    for (var data in temperatureData) {
      if (calenderDateList.contains(data['calender'].toString().trim())) {
        BandTempModel bandTempModel = BandTempModel.fromJson(data);
        String calDateTime = getTimeByCalenderTime(bandTempModel.calender, bandTempModel.time);
        String tempSyncTime = DateTime.tryParse(calDateTime)!.toUtc().toIso8601String();
        var tempJsonData = {
          "date": tempSyncTime,
          "unit": getIsCelsius ? tempAPIInCelsius : tempAPIInFahrenheit,
          "temperature": getIsCelsius ? bandTempModel.inCelsius : bandTempModel.inFahrenheit
        };
        debugPrint('tempJsonData>> $tempJsonData');
        lastTempList.add(tempJsonData);
      }
    }
    return lastTempList;
  }

  Future<List<BandTempModel>> getCurrentDayTemperatureData(var temperatureData, [String? calenderTime]) async {
    String findCalenderTime = '';
    if (calenderTime != null && calenderTime.isNotEmpty) {
      findCalenderTime = calenderTime;
    } else {
      //current calender time
      String currentCalTime = GlobalMethods.convertBandReadableCalender(DateTime.now());
      findCalenderTime = currentCalTime;
    }
    debugPrint('findCalenderTime>> $findCalenderTime');
    List<BandTempModel> tempList = [];
    for (var data in temperatureData) {
      //debugPrint('temp_data >> $data');
      if (data['calender'].toString().trim() == findCalenderTime) {
       // debugPrint('todayTempData>> $data');
        tempList.add(BandTempModel.fromJson(data));
      }
    }
    return tempList;
  }

  String verifyTimeMinutes(String inputTime) {
    String timeString ='';
    debugPrint('inputTime>> $inputTime');
    try{
      if (inputTime.isNotEmpty) {
        List<String> times = inputTime.trim().split(':');
        int hour = int.parse(times[0]);
        int min = int.parse(times[1]);
        String hourStr ='';
        String minStr ='';
        if (hour < 9){
          hourStr = "0"+hour.toString();
        }else{
          hourStr = hour.toString();
        }
        if (min < 9){
          minStr = "0"+min.toString();
        }else{
          minStr = min.toString();
        }

        return hourStr+':'+minStr;

      }else{
        return timeString;
      }
    }catch(e){
      debugPrint('verifyTimeMinutes>>> $e');
      return timeString;
    }
  }

  String getTimeByCalenderTime(String calender, String time) {
    // return format `"20120227 13:27:00"`
    // `"20120227T132700"`
    try {
      if (calender.isNotEmpty) {
        DateTime parseDate = DateTime.parse(calender);
        //DateTime parseDate = new DateFormat('yyyyMMdd').parse(calender);
        //debugPrint('parseDate>>> $parseDate');
        var outputFormat = DateFormat(defaultDateFormat);
        String outputDate = outputFormat.format(parseDate);
        // debugPrint('outputFormat>>> $outputDate'+' '+time);
        //return outputDate+' '+ time.trim();
        String timeStr ='';
        if (time.isNotEmpty) {
          List<String> timesList = time.trim().split(':');
          if (timesList.length >2) {
            timeStr = timesList[0].padLeft(2,"0")+timesList[1].padLeft(2,"0")+timesList[2].padLeft(2,"0");
          }else{
            // convert it double digits
            timeStr = timesList[0].padLeft(2,"0")+timesList[1].padLeft(2,"0")+'00';
          }
          return outputDate+'T'+ timeStr;
        }else{
          return outputDate+'T'+ '000000';
        }
        //return outputDate+' '+ verifyTimeMinutes(time.trim());
        //return outputDate+'T'+ timeStr;
      } else {
        return '';
      }
    } catch (e) {
      debugPrint('getTimeByCalenderTimeError>>> $e');
      return '';
    }
  }

  Future<void> syncStepsData() async {
    String stepsStatus = await flutterBandFit.syncStepsData();
    debugPrint('syncStepsStatus>> $stepsStatus');
  }

  Future<void> syncHeartRate() async {
    String syncBPStatus = await flutterBandFit.syncRateData();
    debugPrint('syncHeartRate>> $syncBPStatus');
  }

  Future<void> syncSleepData() async {
    String stepsStatus = await flutterBandFit.syncSleepData();
    debugPrint('syncSleepStatus>> $stepsStatus');
  }

  Future<void> syncBloodPressure() async {
    String syncBPStatus = await flutterBandFit.syncBloodPressure();
    debugPrint('syncBloodPressure>> $syncBPStatus');
  }

  Future<void> syncTemperature() async {
    String syncTempStatus = await flutterBandFit.syncTemperature();
    debugPrint('syncTemperature>> $syncTempStatus');
  }

  Future<void> syncOxygen() async {
    String syncBPStatus = await flutterBandFit.syncOxygenSaturation();
    debugPrint('syncOxygen>> $syncBPStatus');
  }

  Future<String> startBloodPressure() async {
    String startBPStatus = await flutterBandFit.startBloodPressure();
    debugPrint('startBloodPressure>> $startBPStatus');
    return startBPStatus;
  }

  Future<void> stopBloodPressure() async {
    String stopBPStatus = await flutterBandFit.stopBloodPressure();
    debugPrint('stopBloodPressure>> $stopBPStatus');
  }

  Future<String> startOxygenTest() async {
    String startBPStatus = await flutterBandFit.startOxygenTest();
    debugPrint('startOxygenTest>> $startBPStatus');
    return startBPStatus;
  }

  Future<void> stopOxygenTest() async {
    String stopBPStatus = await flutterBandFit.stopOxygenTest();
    debugPrint('stopOxygenTest>> $stopBPStatus');
  }

  Future<String> startTestTempData() async {
    String testTempDataStatus = await flutterBandFit.testTempData();
    debugPrint('testTempDataStatus>> $testTempDataStatus');
    return testTempDataStatus;
  }

  Future<void> updateDeviceBandLanguage() async {
    String lang ='es';
    debugPrint('update_lang>> $lang');
    var result = await flutterBandFit.setDeviceBandLanguage(lang);
    debugPrint('update_lang_result>> $result');
    //also update the weather conditions along language
    //await callWeatherForecast(getDeviceLatitude.toString(), getDeviceLongitude.toString(), false);
  }
  

  /*Future<void> callWeatherForecast(String lat, String lon, [bool syncWeatherAPI]) async {
    String lang = await Utils.getLanguage();
    debugPrint('fetching_lang>> $lang');
    //String fetchUrl = 'https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon';
    String fetchUrl = 'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon';

    debugPrint('getIsCelsius>> $getIsCelsius');
    //set the excluding
    if (getIsCelsius) {
      fetchUrl += '&units=metric';
    } else {
      fetchUrl += '&units=imperial';
    }
    fetchUrl += '&exclude=hourly,minutely,alerts';
    fetchUrl += '&appid=${Settings.openWeatherAPIKey}';
    // fetchUrl += '&lang=en';
    fetchUrl += '&lang=$lang';

    debugPrint('fetchUrl>>$fetchUrl');

    Map<String, dynamic> response = await ApiClient().fetchSevenDaysWeather(fetchUrl);
    //debugPrint('weather_response>> $response');
    if (response != null) {
      var currentData = response['current'];
      List<dynamic> dailyList = response['daily'];

      WeatherMainModel weatherMainModel = WeatherMainModel(currentData, dailyList);
      weatherModelData = weatherMainModel;
      currentTemperature = double.tryParse(weatherMainModel.temperature.toString()).toStringAsFixed(2);
      currentWeatherUrl = weatherMainModel.currentIconUrl;

      String currentTempUnit = getIsCelsius ? tempAPIInCelsius : tempAPIInFahrenheit;

      var weeklyData = [];
      List<WeatherDailyData> dailyWeatherList = weatherMainModel.weatherDailyList;
      if (dailyWeatherList.isNotEmpty) {
        debugPrint('getDeviceCityName>> $getDeviceCityName');
        String backendCityName = ''; // in case 2 characters
        if (getDeviceCityName != null && getDeviceCityName.isNotEmpty) {
          if (getDeviceCityName.isNotEmpty && getDeviceCityName.length <= 2) {
            backendCityName = getDeviceCityName;
          } else if (getDeviceCityName.length > 2) {
            backendCityName = getDeviceCityName.substring(0, 3);
          }
        }
        debugPrint('backendCityName>> $backendCityName');
        for (var element in dailyWeatherList) {
          var listItem = {
            "date": element.date.toUtc().toIso8601String(),
            "title": element.mainTitle,
            "description": element.description,
            "temperature_min": element.temperatureData.min.toStringAsFixed(2),
            "temperature_max": element.temperatureData.max..toStringAsFixed(2),
            "temperature_unit": currentTempUnit
          };
          weeklyData.add(listItem);
        }

        var jsonWeatherPush = {
          //"cityName": getDeviceCityName.substring(0, 3),
          "cityName": backendCityName,
          //"cityName": getDeviceCityName,
          "todayWeatherCode": getDeviceWeatherCode(dailyWeatherList[0].weatherCode).toString(),
          //string
          // "todayTmpCurrent":dailyWeatherList[0].temperatureData.day.toInt(), //int
          "todayTmpCurrent": weatherMainModel.temperature.toInt(),
          //int
          "todayTmpMax": dailyWeatherList[0].temperatureData.max.toInt(),
          //int
          "todayTmpMin": dailyWeatherList[0].temperatureData.min.toInt(),
          "todayPm25": 0,
          "todayAqi": 0,

          "secondDayWeatherCode": getDeviceWeatherCode(dailyWeatherList[1].weatherCode).toString(),
          //string
          "secondDayTmpMax": dailyWeatherList[1].temperatureData.max.toInt(),
          //int
          "secondDayTmpMin": dailyWeatherList[1].temperatureData.min.toInt(),

          "thirdDayWeatherCode": getDeviceWeatherCode(dailyWeatherList[2].weatherCode).toString(),
          //string
          "thirdDayTmpMax": dailyWeatherList[2].temperatureData.max.toInt(),
          //int
          "thirdDayTmpMin": dailyWeatherList[2].temperatureData.min.toInt(),

          "fourthDayWeatherCode": getDeviceWeatherCode(dailyWeatherList[3].weatherCode).toString(),
          //string
          "fourthDayTmpMax": dailyWeatherList[3].temperatureData.max.toInt(),
          //int
          "fourthDayTmpMin": dailyWeatherList[3].temperatureData.min.toInt(),

          "fifthDayWeatherCode": getDeviceWeatherCode(dailyWeatherList[4].weatherCode).toString(),
          //string
          "fifthDayTmpMax": dailyWeatherList[4].temperatureData.max.toInt(),
          //int
          "fifthDayTmpMin": dailyWeatherList[4].temperatureData.min.toInt(),

          "sixthDayWeatherCode": getDeviceWeatherCode(dailyWeatherList[5].weatherCode).toString(),
          //string
          "sixthDayTmpMax": dailyWeatherList[5].temperatureData.max.toInt(),
          //int
          "sixthDayTmpMin": dailyWeatherList[5].temperatureData.min.toInt(),

          "seventhDayWeatherCode": getDeviceWeatherCode(dailyWeatherList[6].weatherCode).toString(),
          //string
          "seventhDayTmpMax": dailyWeatherList[6].temperatureData.max.toInt(),
          //int
          "seventhDayTmpMin": dailyWeatherList[6].temperatureData.min.toInt(),
        };
        jsonWeatherData = jsonEncode(jsonWeatherPush);
        debugPrint('jsonWeatherData>> $jsonWeatherData');
        weatherSyncDateTime = DateTime.now().toString();
        update();
        String jsonStr = jsonEncode(response);
        await sharedService.setWeatherResponseData(jsonStr);
        await sharedService.setJsonWeatherData(getJsonWeatherData);
        //add the date time in SP
        await sharedService.setWeatherSyncDateTime(weatherSyncDateTime);

        debugPrint('currentTemperature>>$currentTemperature');
        debugPrint('syncWeatherAPI>>$syncWeatherAPI');
        if (syncWeatherAPI) {
          var weatherData = {
            "date": weatherMainModel.date.toUtc().toIso8601String(),
            "temperature_day": currentTemperature,
            "temperature_unit": currentTempUnit,
            "city": getDeviceCityName,
            "lat": lat,
            "lon": lon,
            "humidity": weatherMainModel.humidity.toString(),
            "windSpeed": weatherMainModel.windSpeed.toString(),
            "uvName": weatherMainModel.stUVIStatus.toString(),
            "title": weatherMainModel.currentMainTitle.toString(),
            "description": weatherMainModel.currentDescription.toString(),
            "week": weeklyData
          };
          debugPrint('weatherData>> $weatherData');
          updateWeatherDataSync(weatherData);
        }
      }
    }
  }*/
  
  int getDeviceWeatherCode(int weatherCode) {
    //print('input_weatherCode>> $weatherCode');
    int returnValue = 999;
    //100 -104
    if (weatherCode >= 800 || weatherCode <= 804) {
      //800 -700 - logic
      //clear
      if (weatherCode == 800) {
        returnValue = 100;
      }
      if (weatherCode == 801) {
        returnValue = 101;
      }
      if (weatherCode == 802) {
        returnValue = 102;
      }
      if (weatherCode == 803) {
        returnValue = 103;
      }
      if (weatherCode == 804) {
        returnValue = 104;
      }
    }
    if (weatherCode >= 701 || weatherCode <= 781) {
      if (weatherCode == 701) {
        returnValue = 500;
      } // mist
      if (weatherCode == 741) {
        returnValue = 501;
      } // fog
      if (weatherCode == 721) {
        returnValue = 502;
      } // haze
      if (weatherCode == 751) {
        returnValue = 503;
      } // Sand
      if (weatherCode == 731) {
        returnValue = 504;
      } // Dust
      if (weatherCode == 761) {
        returnValue = 508;
      } // Strong Dust
      if (weatherCode == 711) {
        returnValue = 507;
      } // Smoke
      if (weatherCode == 781) {
        returnValue = 212;
      } // tornado
      if (weatherCode == 771) {
        returnValue = 200;
      } // squalls,
      if (weatherCode == 762) {
        returnValue = 900;
      } // volcanic ash,
    }
    if (weatherCode >= 600 || weatherCode <= 622) {
      //for snow =  no changes (600 -622)
      if (weatherCode == 600) {
        returnValue = 400;
      } // light snow
      if (weatherCode == 601) {
        returnValue = 401;
      } // medium snow
      if (weatherCode == 602) {
        returnValue = 402;
      } // heavy snow
      if (weatherCode == 611) {
        returnValue = 404;
      } // sleet
      if (weatherCode == 612 || weatherCode == 613) {
        returnValue = 406;
      } // Shower sleet
      if (weatherCode == 615 || weatherCode == 616) {
        returnValue = 405;
      } // rain and snow
      if (weatherCode == 620 || weatherCode == 621) {
        returnValue = 407;
      } // Shower snow
      if (weatherCode == 622) {
        returnValue = 403;
      } // Heavy shower snow
    }
    if (weatherCode >= 500 || weatherCode <= 531) {
      // for Rain  305-313 (500 -531)
      if (weatherCode == 500) {
        returnValue = 305;
      } // light rain
      if (weatherCode == 501) {
        returnValue = 306;
      } // moderate rain
      if (weatherCode == 502 || weatherCode == 503) {
        returnValue = 307;
      } // heavy intensity rain
      if (weatherCode == 504) {
        returnValue = 308;
      } // extreme rain
      if (weatherCode == 511) {
        returnValue = 313;
      } // freezing rain
      if (weatherCode == 520) {
        returnValue = 309;
      } // light intensity shower rain
      if (weatherCode == 521) {
        returnValue = 310;
      } // shower rain
      if (weatherCode == 522) {
        returnValue = 311;
      } // heavy intensity shower rain
      if (weatherCode == 531) {
        returnValue = 312;
      } // ragged shower rain
    }
    if (weatherCode >= 200 || weatherCode <= 321) {
      // drizzle - shower - 300 -
      if (weatherCode == 200) {
        returnValue = 901;
      }
      if (weatherCode == 201) {
        returnValue = 209;
      }
      if (weatherCode == 202) {
        returnValue = 210;
      }
      if (weatherCode == 210 || weatherCode == 211) {
        returnValue = 302;
      } // thunderstorm
      if (weatherCode == 212) {
        returnValue = 303;
      } //heavy thunderstorm
      if (weatherCode == 230 || weatherCode == 231) {
        returnValue = 304;
      } //thunderstorm with drizzle
      if (weatherCode == 221) {
        returnValue = 211;
      } //ragged thunderstorm
      if (weatherCode == 313) {
        returnValue = 300;
      } //shower rain and drizzle
      if (weatherCode == 314) {
        returnValue = 301;
      } //heavy shower rain and drizzle
      if (weatherCode == 300) {
        returnValue = 202;
      }
      if (weatherCode == 301) {
        returnValue = 203;
      }
      if (weatherCode == 302) {
        returnValue = 205;
      }
      if (weatherCode == 310) {
        returnValue = 206;
      }
      if (weatherCode == 311) {
        returnValue = 207;
      }
      if (weatherCode == 312) {
        returnValue = 208;
      }
      if (weatherCode == 321) {
        returnValue = 204;
      }
      if (weatherCode == 232) {
        returnValue = 213;
      } //thunderstorm with heavy drizzle
    } else {
      debugPrint('inside else returnValue = 201;');
      returnValue = 201;
    }
    debugPrint('input_returnValue>> $returnValue');
    return returnValue;
  }



//FETCH_OXYGEN_BY_DATE, SYNC_ALL_JUDGE
//START_HR_TEST, STOP_HR_TEST

/* Future<void> startHR() async {
    String startBPStatus = await _mobileSmartWatch.startHR();
    debugPrint('startHR>> $startBPStatus');
  }

  Future<void> stopHR() async {
    String stopBPStatus = await _mobileSmartWatch.stopHR();
    debugPrint('stopHR>> $stopBPStatus');
  }*/

/*Future<Map<String, dynamic>> fetchHeartRateByDate(String calender) async {
    return await _mobileSmartWatch.fetchHeartRateByDate(calender);
  }

  Future<Map<String, dynamic>> fetchOxygenByDate(String calender) async {
    return await _mobileSmartWatch.fetchOxygenByDate(calender);
  }*/

  Future<void> fetchAllJudgement() async {
    Map<String, dynamic> resultJudgeData = await flutterBandFit.fetchAllJudgement();
    debugPrint('fetchAllJudgementResultJudgeData>>$resultJudgeData');
    String status = resultJudgeData['status'].toString();
    if (status == BandFitConstants.SC_SUCCESS) {
      var resultData = resultJudgeData['data'];
      bool rkPlatform = resultData['rkPlatform'];
      bool isSupportNewParams = resultData['isSupportNewParams'];
      bool isBandLostFunction = resultData['isBandLostFunction'];
      bool isBraceletLangSwitch = resultData['isBraceletLangSwitch'];
      bool isTempUnitSwitch = resultData['isTempUnitSwitch'];
      bool isMinHRAlarm = resultData['isMinHRAlarm'];
      bool isTempTest = resultData['isTempTest'];
      bool isTempCalibration = resultData['isTempCalibration'];
      bool isSupportHorVer = resultData['isSupportHorVer'];
      bool isSupport24HrRate = resultData['isSupport24HrRate'];
      bool isSupportOxygen = resultData['isSupportOxygen'];
      debugPrint('rkPlatform>>>$rkPlatform');
      debugPrint('isSupportNewParams>>>$isSupportNewParams');
      debugPrint('isBandLostFunction>>>$isBandLostFunction');
      debugPrint('isBraceletLangSwitch>>>$isBraceletLangSwitch');
      debugPrint('isTempUnitSwitch>>>$isTempUnitSwitch');
      debugPrint('isMinHRAlarm>>>$isMinHRAlarm');
      debugPrint('isTempTest>>>$isTempTest');
      debugPrint('isTempCalibration>>>$isTempCalibration');
      debugPrint('isSupportHorVer>>>$isSupportHorVer');
      debugPrint('isSupport24HrRate>>>$isSupport24HrRate');
      debugPrint('isSupportOxygen>>>$isSupportOxygen');

      updateOxygenAvailability(isSupportOxygen);
      /* if(isSupportOxygen){
        oxygenAvailable = true;
      }*/

    } else if (status == BandFitConstants.SC_DISCONNECTED) {
      // device got disconnected.
    } else if (status == BandFitConstants.SC_FAILURE) {
      // something went wrong
    }
    debugPrint('resultJudgeData>> $resultJudgeData');
  }

}
