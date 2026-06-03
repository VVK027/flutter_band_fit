import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:flutter_band_fit_app/core/constants/weather_config.dart';
import 'package:flutter_band_fit_app/core/services/weather_api_client.dart';
import 'package:flutter_band_fit_app/core/services/weather_band_payload_builder.dart';
import 'package:flutter_band_fit_app/core/services/weather_device_code_mapper.dart';
import 'package:flutter_band_fit_app/core/utils/app_language_utils.dart';
import 'package:flutter_band_fit_app/core/utils/shared_service.dart';
import 'package:flutter_band_fit_app/features/vitals/data/models/band_data_model.dart';
import 'package:flutter_band_fit_app/features/vitals/data/models/weather_model.dart';
import 'package:intl/intl.dart';

/// Central GetX service for the example app: BLE band I/O, persisted vitals,
/// dashboard state, weather fetch, and dial-face sync.
///
/// UI controllers should prefer feature repositories/use cases where they exist;
/// this class remains the integration point for [FlutterBandFit] events and storage.
class ActivityServiceProvider extends GetxController {
  /// True after [fetchLocalDataAssign] finishes loading persisted vitals.
  final isLocalDataLoaded = false.obs;

  /// Incremented whenever stored sleep JSON is refreshed from sync or DB fetch.
  final sleepDataRevision = 0.obs;

  String targetedSteps = defaultTargetedSteps;
  String get getTargetedSteps => targetedSteps.obs.string;

  final FlutterBandFit flutterBandFit = FlutterBandFit();

  // --- User profile (defaults match [SharedService]) ---

  String userHeight = heightMin.toString();
  String get getUserHeight => userHeight;
  String userWeight = weightMin.toString();
  String get getUserWeight => userWeight;
  String userGender = 'male';
  String get getUserGender => userGender;
  String userAge = '';
  String get getUserAge => userAge;
  String userDOB = '';
  String get getUserDOB => userDOB;
  String userBMI = '24.7';
  String get getUserBMI => userBMI;
  String userBMIStatus = 'bmi_fit';
  String get getUserBMIStatus => userBMIStatus;
  String screenOffTime = screenOffTimeMin.toString();
  String get getScreenOffTime => screenOffTime;


  // --- Device connection and band settings ---
  bool deviceConnected = false;
  bool get getDeviceConnected => deviceConnected;

  bool _skipAutoReconnect = false;
  bool _autoReconnectInProgress = false;
  DateTime? _lastAutoReconnectAttempt;

  /// True when vitals are sourced from Apple Health or Google Fit instead of the band.
  bool healthConnected = false;
  bool get getHealthConnected => healthConnected;

  double deviceLatitude = 0.0;
  double get getDeviceLatitude => deviceLatitude;

  double deviceLongitude = 0.0;
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

  WeatherMainModel? _weatherModelData;
  WeatherMainModel? get getWeatherModelData => _weatherModelData;

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

  String weatherSyncDateTime = '';
  String get getWeatherSyncDateTime => weatherSyncDateTime;

  // --- Watch face (dial) download / transfer ---
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

  // --- Raw SDK payloads persisted as JSON strings ---
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

  // --- OpenWeather in-memory cache (see [callWeatherForecast]) ---
  Future<void>? _weatherFetchInFlight;
  double? _lastWeatherFetchLat;
  double? _lastWeatherFetchLon;
  DateTime? _lastWeatherFetchAt;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeProvider();
    });
  }

  /// Loads profile, device flags, and cached vitals from [SharedService], then hydrates the dashboard.
  Future<void> initializeProvider() async {
    await fetchLocalDataAssign();
    debugPrint("inside initializeProvider");
    update();
  }

  /// Reads all persisted keys and populates in-memory dashboard fields.
  Future<void> fetchLocalDataAssign() async {
    isLocalDataLoaded.value = false;
    targetedSteps = sharedService.getTargetedSteps();
    userGender = sharedService.getUserGender().toUpperCase();
    userDOB = sharedService.getUserDOB() ?? '';
    userAge = _resolveStoredUserAge();
    userHeight = sharedService.getUserHeight(); // always cm
    userWeight = sharedService.getUserWeight();
    userGender = sharedService.getUserGender();
    screenOffTime = sharedService.getScreenOffTime();
    userBMI = sharedService.getBMIValue();
    userBMIStatus = sharedService.getBMIStatus();

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

    tempCelsius = sharedService.getIsTempCelsius();
    debugPrint('123>>tempCelsius>> $tempCelsius');
    raiseHandWakeUp = sharedService.getRaiseWakeUp();

    overAllStepsData = sharedService.getOverAllSteps();
    overAllSleepData = sharedService.getOverAllSleep();
    overAllHrData = sharedService.getOverAllHeartRate();
    overAllBPData = sharedService.getOverAllBP();
    overAllTempData = sharedService.getOverAllTemperature();
    overAllOxygenData = sharedService.getOverAllOxygenData();

    weatherSyncDateTime = sharedService.getWeatherSyncDateTime();

    lastMacAddressId = sharedService.getLastMacAddressId();
    lastSyncDated = sharedService.getLastSyncDate();
    lastSyncDateTime = sharedService.getLastSyncDateTime();

    update();
    debugPrint('deviceSWNameLast>>$deviceSWName');
    debugPrint('deviceMacAddressLast>>$deviceMacAddress');

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
    isLocalDataLoaded.value = true;
  }

  /// Restores dashboard vitals and weather from persisted JSON after app start.
  Future<void> addRecentDataUI(String weatherResponse) async {
    try {
      await _hydrateDashboardFromStoredVitals();
      await _applyStoredWeatherResponse(weatherResponse);
    } catch (e) {
      debugPrint('addRecentDataUIException: $e');
    }
  }

  /// Maps cached band payloads to today's summary fields on the home screen.
  Future<void> _hydrateDashboardFromStoredVitals() async {
    if (overAllStepsData.isNotEmpty) {
      await _applyStepsToDashboard(JsonUtils.asList(jsonDecode(overAllStepsData)));
    }
    if (overAllSleepData.isNotEmpty) {
      await _applySleepToDashboard(JsonUtils.asList(jsonDecode(overAllSleepData)));
    }
    if (overAllHrData.isNotEmpty) {
      await _applyHeartRateToDashboard(JsonUtils.asList(jsonDecode(overAllHrData)));
    }
    if (overAllBPData.isNotEmpty) {
      await _applyBloodPressureToDashboard(JsonUtils.asList(jsonDecode(overAllBPData)));
    }
    if (overAllTempData.isNotEmpty) {
      await _applyTemperatureToDashboard(JsonUtils.asList(jsonDecode(overAllTempData)));
    }
    if (overAllOxygenData.isNotEmpty) {
      await _applyOxygenToDashboard(JsonUtils.asList(jsonDecode(overAllOxygenData)));
    }
  }

  Future<void> _applyStoredWeatherResponse(String weatherResponse) async {
    if (weatherResponse.isEmpty) {
      return;
    }
    final weatherMainModel = _parseWeatherResponse(weatherResponse);
    if (weatherMainModel == null) {
      return;
    }
    _weatherModelData = weatherMainModel;
    currentTemperature = (double.tryParse(
              weatherMainModel.temperature.toString(),
            ) ??
            0)
        .toStringAsFixed(2);
    currentWeatherUrl = weatherMainModel.currentIconUrl;
    update();
  }

  /// iOS aggregates per-minute rows; Android uses pre-aggregated day records.
  Future<List<StepsMainModel>> _todayStepsModels(List<dynamic> stepsData) {
    return Platform.isIOS
        ? getSelectedDayStepsData(stepsData)
        : getCurrentDaySteps(stepsData);
  }

  Future<List<SleepMainModel>> _todaySleepModels(dynamic sleepData) {
    return Platform.isIOS
        ? getSelectedDaySleepData(sleepData)
        : getCurrentDaySleepData(sleepData);
  }

  Future<void> _applyStepsToDashboard(List<dynamic> stepsData) async {
    final stepsTodayList = await _todayStepsModels(stepsData);
    if (stepsTodayList.isEmpty) {
      return;
    }
    final latest = stepsTodayList.last;
    updateDeviceStats(latest.steps, latest.distance, latest.calories);
  }

  Future<void> _applySleepToDashboard(dynamic sleepData) async {
    final sleepTodayList = await _todaySleepModels(sleepData);
    if (sleepTodayList.isEmpty) {
      return;
    }
    final latest = sleepTodayList.last;
    updateDeviceSleep(latest.total, latest.calender);
  }

  Future<void> _applyHeartRateToDashboard(dynamic hrData) async {
    final hrList = await getCurrentDayHRData(hrData);
    if (hrList.isEmpty) {
      return;
    }
    final latest = hrList.last;
    updateHearRate(
      latest.rate,
      getTimeByCalenderTime(latest.calender, latest.time),
    );
  }

  Future<void> _applyBloodPressureToDashboard(dynamic bpData) async {
    final bpList = await getCurrentDayBPData(bpData);
    if (bpList.isEmpty) {
      return;
    }
    final latest = bpList.last;
    updateBloodPressure(
      '${latest.high} /${latest.low}',
      getTimeByCalenderTime(latest.calender, latest.time),
    );
  }

  Future<void> _applyTemperatureToDashboard(dynamic temperatureData) async {
    final tempList = await getCurrentDayTemperatureData(temperatureData);
    if (tempList.isEmpty) {
      return;
    }
    final latest = tempList.last;
    updateTemperature(
      latest.inCelsius,
      latest.inFahrenheit,
      getTimeByCalenderTime(latest.calender, latest.time),
    );
  }

  Future<void> _applyOxygenToDashboard(dynamic oxygenData) async {
    final oxyList = await getCurrentDayOxygenData(oxygenData);
    if (oxyList.isEmpty) {
      return;
    }
    final latest = oxyList.last;
    updateOxygenSaturation(
      latest.value,
      getTimeByCalenderTime(latest.calender, latest.time),
    );
  }

  /// Returns cached weather for detail screens, loading from storage if needed.
  WeatherMainModel? weatherReportForDetails() {
    if (_weatherModelData != null) {
      return _weatherModelData;
    }
    final weatherResponse = sharedService.getWeatherResponseData();
    if (weatherResponse == null || weatherResponse.isEmpty) {
      return null;
    }
    final model = _parseWeatherResponse(weatherResponse);
    if (model != null) {
      _weatherModelData = model;
    }
    return model;
  }

  WeatherMainModel? _parseWeatherResponse(String weatherResponse) {
    try {
      final response = jsonDecode(weatherResponse);
      if (response is! Map) {
        return null;
      }
      final current = response['current'];
      final daily = response['daily'];
      if (current is! Map || daily is! List) {
        return null;
      }
      return WeatherMainModel(
        Map<String, dynamic>.from(current),
        daily,
      );
    } catch (e) {
      debugPrint('_parseWeatherResponse: $e');
      return null;
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
    await sharedService.setInitialParams(userGender, userAge, userDOB);
    debugPrint("updated setWatchProfile");
  }

  Future<void> setDefaultHeightWeight(int height, int weight) async {
    userHeight = height.toString();
    userWeight = weight.toString();
    update();
    await sharedService.setInitialHeightWeight(getUserHeight, getUserWeight);
  }

  Future<void> updateWatchProfile(String height, String weight, String gender, String dob) async {
    userHeight = height;
    userWeight = weight;
    userGender = gender;
    userDOB = dob;
    userAge = GlobalMethods.getAgeFromDOB(dob).toString();
    update();
    await sharedService.setInitialParams(userGender, userAge, userDOB);
    await sharedService.setInitialHeightWeight(getUserHeight, getUserWeight);
    debugPrint("updated updateWatchProfile");
  }


  Future<void> updateBMIStatus(String bmiValue, String bmiStatus) async {
    userBMI = bmiValue;
    userBMIStatus = bmiStatus;
    update();
    sharedService.updateBMIStatus(getUserBMI, getUserBMIStatus);
    debugPrint("updated updateBMIStatus");
  }

  Future<void> updateTargetedSteps(String updatedSteps) async {
    targetedSteps = updatedSteps;
    update();
    await sharedService.setTargetedSteps(targetedSteps);
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
      deviceVersion = sharedService.getDeviceVersionId();
      update();
    }
  }

  Future<void> setBatteryPercentage(String batteryStat, bool callAPISync) async {
    if (batteryStat.isNotEmpty) {
      batteryPercentage = int.parse(batteryStat);
      update();
      await sharedService.setBatteryStatus(batteryStat);
    } else {
      batteryPercentage = int.parse(sharedService.getBatteryStatus());
      update();
    }
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
    caloriesValue = calories;
    distanceValue = distance;

    progressPercentage = (stepsValue * 100) / int.parse(targetedSteps);
    update();
  }

  void updateHearRate(String hr, String dateTime) {
    heartRateValue = hr;

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
    update();
  }

  Future<void> updateBPressureData(String high, String low, String calender, String time, dynamic bpData) async {
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
    overAllBPData = jsonEncode(bpData);
    update();
    await sharedService.setOverAllBP(getOverAllBPData);
  }

  void updateDeviceSleep(String totalHours, String calenderDate) {
    final list = totalHours.split(':');
    sleepHrsValue = list[0];
    sleepMinutesValue = list[1];

    final parseDate = DateTime.parse(calenderDate);
    var outputFormat = DateFormat(defaultDateFormat);
    String outputDate = outputFormat.format(parseDate);

    sleepHrsDateTime = outputDate;
    update();
  }

  void updateTemperature(String inCelsius, String inFahrenheit, String dateTime) {
    if (getIsCelsius) {
      temperatureValue = inCelsius;
    } else {
      temperatureValue = inFahrenheit;
    }
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
    if (dateTime.isNotEmpty) {
      var outputFormat = DateFormat(defaultDateTimeParseFormat);
      String outputDate = outputFormat.format(DateTime.parse(dateTime));
      oxygenDateTime = outputDate;
    }else{
      oxygenDateTime = dateTime;
    }
    update();
  }

  Future<void> updateTemperatureWithData(dynamic jsonData, dynamic temperatureData, DateTime dateTimeSend) async {
    String inCelsius = jsonData['inCelsius'].toString();
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

  /// Dispatches native band events (version, battery, sync finishes, DND, etc.).
  Future<void> updateEventResult(dynamic eventData, BuildContext buildContext) async {
    final event = JsonUtils.asMap(eventData);
    final result = JsonUtils.asString(event['result']);
    final status = JsonUtils.asString(event['status']);
    final jsonData = event['data'];
    switch (result) {
      case BandFitConstants.DEVICE_VERSION:
        final version = JsonUtils.asString(
          JsonUtils.asMap(jsonData)['deviceVersion'],
        );
        debugPrint('deviceVersion>>$version');
        if (version.isNotEmpty) {
          await setDeviceVersion(version);
        }
        break;

      case BandFitConstants.BATTERY_STATUS:
        String batteryStat = jsonData['batteryStatus'].toString();
        debugPrint('batteryStatus>>$batteryStat');
        setBatteryPercentage(batteryStat, true);
        break;

      case BandFitConstants.QUICK_SWITCH_STATUS:
        if (status == BandFitConstants.SC_SUCCESS) {
          String resultStatus = jsonData['result'].toString();
          if (resultStatus.isNotEmpty) {
            if (resultStatus == "119") {
              String resultValue = jsonData['value'].toString();
              debugPrint('resultValue>> $resultValue');
              if (Platform.isIOS) {
                if (resultValue.isNotEmpty) {
                  if(resultValue == "70"){
                    await updateDoNotDisturbEnable(false, getMotorVibrateEnabled, getMessagesOnEnabled);
                  }else if(resultValue == "78"){
                    await updateDoNotDisturbEnable(true, getMotorVibrateEnabled, getMessagesOnEnabled);
                  }else{

                  }
                }
              }else{
                final decimalData = JsonUtils.asList(jsonData['decimal']);
                if (decimalData.isNotEmpty) {
                  debugPrint('decimalData>> $decimalData');
                  String result = decimalData[0].toString();
                  debugPrint('result>> $result');
                  if (result == "66" || result == "2") {
                    await updateDoNotDisturbEnable(false, getMotorVibrateEnabled, getMessagesOnEnabled);
                  } else if (result == "74" || result == "10") {
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
          String resultStatus = jsonData['result'].toString();
          if (resultStatus.isNotEmpty) {
            if (resultStatus == "85") {
              String resultValue = jsonData['value'].toString();
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
                    await updateDoNotDisturbEnable(getDndEnabled, true, getMessagesOnEnabled);
                  } else if (dndValue == "08") {
                    await updateDoNotDisturbEnable(getDndEnabled, false, getMessagesOnEnabled);
                  } else if (dndValue == "0C") {
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
          String resultStatus = jsonData['result'].toString();
          if (resultStatus.isNotEmpty) {
            if (resultStatus == "84") {
              String resultValue = jsonData['value'].toString();
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
                    await updateDoNotDisturbEnable(true, getMotorVibrateEnabled, getMessagesOnEnabled);
                  } else if (dndValue == "0C") {
                    await updateDoNotDisturbEnable(true, getMotorVibrateEnabled, true);
                  } else if (dndValue == "0A") {
                    await updateDoNotDisturbEnable(true, true, getMessagesOnEnabled);
                  } else if (dndValue == "0E") {
                    await updateDoNotDisturbEnable(true, true, true);
                  } else {
                    debugPrint('dndNothingValue>> $dndValue');
                  }
                }
              }
            }
          }
        }
        break;

      // Vitals sync chain: steps → sleep → HR → BP → temperature → SpO₂.
      case BandFitConstants.SYNC_STEPS_FINISH:
        if (status == BandFitConstants.SC_SUCCESS) {
          await syncSleepData();
          if (jsonData != null) {
            final stepsData = JsonUtils.asList(jsonData);
            if (stepsData.isNotEmpty) {
              await updateStepsSyncSDKData(stepsData);
            }
          }
        }
        break;
      case BandFitConstants.SYNC_SLEEP_FINISH:
        if (status == BandFitConstants.SC_SUCCESS) {
          await syncHeartRate();
          var sleepData = jsonData != null ? JsonUtils.asList(jsonData) : <dynamic>[];
          if (sleepData.isEmpty && Platform.isAndroid) {
            await fetchAllSleepDataSync();
          } else if (sleepData.isNotEmpty) {
            await updateSleepSyncSDKData(sleepData);
          }
        }
        break;
      case BandFitConstants.SYNC_24_HOUR_RATE_FINISH:
        if (status == BandFitConstants.SC_SUCCESS) {
          await syncBloodPressure();
          if (jsonData != null) {
            final hrData = JsonUtils.asList(jsonData);
            if (hrData.isNotEmpty) {
              await updateHR24SyncSDKData(hrData);
            }
          }
        }
        break;
      case BandFitConstants.SYNC_BP_FINISH:
        if (status == BandFitConstants.SC_SUCCESS) {
          await syncTemperature();
          if (jsonData != null) {
            final bpData = JsonUtils.asList(jsonData);
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
                final tempData = JsonUtils.asList(jsonData);
                if (tempData.isNotEmpty) {
                  await updateTemperatureSyncSDKData(tempData);
                }
              }
              await updateSyncIsDone();
            } else {
              await fetchOverAllDeviceDataSync();
              await updateSyncIsDone();
            }
          } else {
            await syncOxygen();
            if (jsonData != null) {
              final tempData = JsonUtils.asList(jsonData);
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
              final oxyData = JsonUtils.asList(jsonData);
              debugPrint("oxyData>>> $oxyData");
              if (oxyData.isNotEmpty) {
                await updateOxygenSyncSDKData(oxyData);
              }
            }
            await updateSyncIsDone();
          } else {
            await fetchOverAllDeviceDataSync();
            await updateSyncIsDone();
          }
        }
        break;


      case BandFitConstants.STEPS_REAL_TIME:
      // real time sync as well as the daily sync
        if (status == BandFitConstants.SC_SUCCESS) {
          String steps = jsonData['steps'].toString();
          String distance = jsonData['distance'].toString();
          String calories = jsonData['calories'].toString();
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
        String status = jsonData['status'].toString();
        if (status.isNotEmpty) {
          await updateHeartRate24Enabled(status);
        }
        //await set24HrTemperatureTest(true);
        break;

      case BandFitConstants.SYNC_STATUS_24_HOUR_OXYGEN_OPEN:
        debugPrint('SYNC_STATUS_24_HOUR_OXYGEN_OPEN');
        String status = jsonData['status'].toString();
        debugPrint('SYNC_STATUS>> $status');
        if (status.isNotEmpty) {
          await updateOxygen24Enabled(status);
        }
        break;

      case BandFitConstants.SYNC_TEMPERATURE_24_HOUR_AUTOMATIC:
        debugPrint('SYNC_TEMPERATURE_24_HOUR_AUTOMATIC');
        String status = jsonData['status'].toString();
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

  /// Subscribes to the plugin event stream (typically forwarded to [updateEventResult]).
  void receiveEventsFrom({required void Function(dynamic) onDataUpdate, required void Function(dynamic) onError, required void Function() onDone}) {
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

  void receiveBPListeners({
    required void Function(dynamic) onDataUpdate,
    required void Function(dynamic) onError,
    required void Function() onDone,
  }) {
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

  void markUserInitiatedDisconnect() {
    _skipAutoReconnect = true;
    _autoReconnectInProgress = false;
  }

  void clearAutoReconnectGuard() {
    _skipAutoReconnect = false;
    _autoReconnectInProgress = false;
    _lastAutoReconnectAttempt = null;
  }

  /// Reconnects after an unexpected GATT drop (e.g. status 8 timeout).
  Future<bool> attemptAutoReconnectAfterUnexpectedDisconnect() async {
    if (_skipAutoReconnect || _autoReconnectInProgress) {
      return false;
    }

    final savedMac = sharedService.getDeviceMacAddress().trim();
    final lastMac = (await getConnectedLastDeviceAddress()).trim();
    final mac = getDeviceMacAddress.isNotEmpty
        ? getDeviceMacAddress
        : (savedMac.isNotEmpty ? savedMac : lastMac);
    if (mac.isEmpty) {
      return false;
    }

    final now = DateTime.now();
    if (_lastAutoReconnectAttempt != null &&
        now.difference(_lastAutoReconnectAttempt!) <
            const Duration(seconds: 4)) {
      return false;
    }
    _lastAutoReconnectAttempt = now;
    _autoReconnectInProgress = true;

    try {
      debugPrint('autoReconnect: attempting for $mac');
      if (Platform.isAndroid) {
        await flutterBandFit.clearGattDisconnect();
        await Future<void>.delayed(const Duration(milliseconds: 800));
      }

      if (!getDeviceConnected && savedMac.isNotEmpty) {
        await updateUserDeviceConnection(false, true, 'SP', 'SP');
      }

      var connected = await connectWithLastDeviceAddress();
      if (!connected) {
        final deviceModel = BandDeviceModel(
          address: mac,
          name: getDeviceSWName.isNotEmpty
              ? getDeviceSWName
              : sharedService.getDeviceName(),
          identifier: '',
        );
        final init = await initializeDeviceConnection();
        if (init == BandFitConstants.SC_INIT) {
          connected = await connectSmartDevice(deviceModel);
        } else if (init == BandFitConstants.SC_DISCONNECTED ||
            init == BandFitConstants.SC_RE_INIT) {
          connected = await reConnectSmartDevice(deviceModel);
        }
      }

      if (connected) {
        clearAutoReconnectGuard();
      }
      debugPrint('autoReconnect: result=$connected');
      return connected;
    } finally {
      _autoReconnectInProgress = false;
    }
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
    final mac = getDeviceMacAddress.isNotEmpty ? getDeviceMacAddress : deviceMacAddress;
    final name = getDeviceSWName.isNotEmpty ? getDeviceSWName : deviceSWName;
    debugPrint('reconnecting_with_name>>$name');
    debugPrint('reconnecting_with_mac>>$mac');
    update();

    if (mac.isEmpty) {
      return connectWithLastDeviceAddress();
    }

    final deviceModel = BandDeviceModel(
      address: mac,
      name: name,
      identifier: '',
    );

    final result = await initializeDeviceConnection();
    if (!context.mounted) return false;

    if (result == BandFitConstants.BLE_NOT_SUPPORTED) {
      GlobalMethods.showAlertDialog(
        context,
        textBluetoothRequired,
        bleNotSupported,
      );
      return false;
    }
    if (result == BandFitConstants.SC_CANCELED) {
      GlobalMethods.showAlertDialog(context, textBluetooth, bleNotConnected);
      return false;
    }

    if (result == BandFitConstants.SC_INIT) {
      final connected = await flutterBandFit.connectDevice(deviceModel);
      debugPrint('connect_with_mac_status $connected');
      if (connected) return true;
    }

    if (result == BandFitConstants.SC_DISCONNECTED ||
        result == BandFitConstants.SC_RE_INIT ||
        result == BandFitConstants.SC_BLE_RE_INIT) {
      final reconnected = await reConnectSmartDevice(deviceModel);
      debugPrint('reconnect_smart_device_status $reconnected');
      if (reconnected) return true;
    }

    if (await checkIsDeviceConnected()) return true;

    final lastAddress = await connectWithLastDeviceAddress();
    debugPrint('connect_last_device_status $lastAddress');
    return lastAddress;
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
    return resultConnected;
  }

  Future<bool> disconnectDevice() async {
    markUserInitiatedDisconnect();
    bool disconnectStatus = await flutterBandFit.disconnectDevice();
    debugPrint('disconnectStatus>> $disconnectStatus');
    await updateUserDeviceConnection(false, false, '', '');
    await clearResetLocalData();
    return disconnectStatus;
  }

  Future<String> setDefaultLocationCoOrdinates(double lat, double long) async {
    deviceLatitude = lat;
    deviceLongitude = long;
    update();
    await sharedService.setLatitude(getDeviceLatitude.toString());
    await sharedService.setLongitude(getDeviceLongitude.toString());
    await sharedService.setDeviceCityName(getDeviceCityName);

    if (sharedService.getDeviceCityName() != null &&
        sharedService.getLatitude() != null) {
      deviceCityName = sharedService.getDeviceCityName()!;
      deviceLatitude = double.tryParse(sharedService.getLatitude()!)!;
      deviceLongitude = double.tryParse(sharedService.getLongitude()!)!;
      update();
      await sharedService.setLatitude(getDeviceLatitude.toString());
      await sharedService.setLongitude(getDeviceLongitude.toString());
      await sharedService.setDeviceCityName(getDeviceCityName);
    }
    return '';
  }

  Future<void> setLocationCoOrdinates(double lat, double long) async {
    deviceLatitude = lat;
    deviceLongitude = long;
    update();
    await sharedService.setLatitude(getDeviceLatitude.toString());
    await sharedService.setLongitude(getDeviceLongitude.toString());
    await sharedService.setDeviceCityName(getDeviceCityName);
  }

  Future<void> updateOxygenAvailability(bool isOxygenAvail) async {
    oxygenAvailable = isOxygenAvail;
    update();
    sharedService.setOxygenAvailable(oxygenAvailable);
  }

  Future<bool> checkIsDeviceConnected() async {
    return await flutterBandFit.checkConectionStatus();
  }

  /// Marks the app as connected when BLE is already paired/connected but
  /// GetStorage was cleared or never persisted (common after hot restart).
  Future<void> syncPairedDeviceFromBle() async {
    final bleConnected = await checkIsDeviceConnected();
    debugPrint('syncPairedDeviceFromBle bleConnected=$bleConnected');
    if (!bleConnected) {
      return;
    }

    deviceConnected = true;
    healthConnected = false;
    await _ensureDeviceIdentityFromStorageOrNative();

    if (deviceMacAddress.isNotEmpty) {
      lastMacAddressId = deviceMacAddress;
    }

    update();
    await sharedService.setSmartMConnected(true);
    if (deviceMacAddress.isNotEmpty) {
      await sharedService.setDeviceMacAddress(deviceMacAddress);
      await sharedService.setLastMacAddressId(deviceMacAddress);
    }
    if (deviceSWName.isNotEmpty) {
      await sharedService.setDeviceName(deviceSWName);
    }
    debugPrint(
      'syncPairedDeviceFromBle name=$deviceSWName mac=$deviceMacAddress',
    );
    await fetchDeviceVersion();
    await fetchBatteryStatus();
  }

  Future<void> _ensureDeviceIdentityFromStorageOrNative() async {
    if (deviceMacAddress.trim().isEmpty) {
      final storedMac = sharedService.getDeviceMacAddress().trim();
      if (storedMac.isNotEmpty) {
        deviceMacAddress = storedMac;
      } else {
        final lastMacId = sharedService.getLastMacAddressId().trim();
        if (lastMacId.isNotEmpty) {
          deviceMacAddress = lastMacId;
        } else {
          try {
            final nativeMac = (await getConnectedLastDeviceAddress()).trim();
            if (nativeMac.isNotEmpty) {
              deviceMacAddress = nativeMac;
            }
          } catch (e) {
            debugPrint('_ensureDeviceIdentityFromStorageOrNative mac: $e');
          }
        }
      }
    }

    if (deviceSWName.trim().isEmpty) {
      final storedName = sharedService.getDeviceName().trim();
      if (storedName.isNotEmpty) {
        deviceSWName = storedName;
      }
    }
  }

  Future<Map<String, dynamic>?> fetchDeviceDataInfo() async {
    try {
      final Map<String, dynamic> response =
          await flutterBandFit.fetchDeviceDataInfo();
      debugPrint('device_res>>$response');
      final String status = response['status'].toString();
      if (status == BandFitConstants.SC_SUCCESS) {
        return response;
      }
    } catch (e) {
      debugPrint('fetchDeviceDataInfo error>> $e');
    }
    return null;
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
    debugPrint('clearDataExecuted');
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
            await _ensureDeviceIdentityFromStorageOrNative();
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

  String _resolveStoredUserAge() {
    final storedAge = sharedService.getUserAge();
    if (storedAge != null && storedAge.trim().isNotEmpty) {
      return storedAge;
    }
    final dob = userDOB.isNotEmpty ? userDOB : (sharedService.getUserDOB() ?? '');
    if (dob.isNotEmpty) {
      return GlobalMethods.getAgeFromDOB(dob).toString();
    }
    return '25';
  }

  Future<String> _ensureUserAgeStored() async {
    final age = _resolveStoredUserAge();
    userAge = age;
    final storedAge = sharedService.getUserAge();
    if (storedAge == null || storedAge.trim().isEmpty) {
      await sharedService.setUserAge(age);
    }
    return age;
  }

  Future<void> updateUserParamsWatch(bool enableHRTemperature) async {
    final age = await _ensureUserAgeStored();
    var userParams = {
      "age": age,
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
      String enabledDNDTime = "${fromHr.padLeft(2, "0")}:${fromMin.padLeft(2, "0")}:${toHour.padLeft(2, "0")}:${toMin.padLeft(2, "0")}";
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


  Future<bool> _isBandConnectedForRead() async {
    return deviceConnected || await checkIsDeviceConnected();
  }

  Future<void> fetchBatteryStatus() async {
    if (!await _isBandConnectedForRead()) {
      return;
    }
    final result = await flutterBandFit.getBatteryStatus();
    debugPrint('fetchBatteryStatus>>>$result');
  }

  Future<void> fetchDeviceVersion({int maxAttempts = 2}) async {
    final cached = sharedService.getDeviceVersionId();
    if (cached.isNotEmpty) {
      deviceVersion = cached;
      update();
    }

    if (!await _isBandConnectedForRead()) {
      return;
    }

    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      if (attempt > 0) {
        await Future<void>.delayed(const Duration(milliseconds: 700));
      }

      final resultVersionStatus = await flutterBandFit.getDeviceVersion();
      debugPrint(
        'fetchDeviceVersion status>>>$resultVersionStatus attempt=$attempt',
      );

      // Version is delivered asynchronously on the event channel.
      await Future<void>.delayed(const Duration(milliseconds: 500));

      final stored = sharedService.getDeviceVersionId().trim();
      if (deviceVersion.trim().isNotEmpty || stored.isNotEmpty) {
        if (deviceVersion.trim().isEmpty && stored.isNotEmpty) {
          deviceVersion = stored;
          update();
        }
        return;
      }

      if (resultVersionStatus != BandFitConstants.SC_INIT) {
        break;
      }
    }
  }

  void updateSyncingView(bool updateView) {
    showSyncProgress = updateView;
    update();
  }

  /// Hides sync UI and records last successful sync timestamp.
  Future<void> updateSyncIsDone() async {
    showSyncProgress = false;
    await syncPairedDeviceFromBle();

    final outputDate =
        DateFormat(defaultLastSyncDateTimeFormat).format(DateTime.now());
    debugPrint('last_sync_date>> $outputDate');
    lastSyncDated = outputDate;
    lastSyncDateTime = DateTime.now().toIso8601String();

    await sharedService.setLastMacAddressId(lastMacAddressId);
    await sharedService.setLastSyncDate(lastSyncDated);
    await sharedService.setLastSyncDateTime(lastSyncDateTime);
    update();
  }



  /// Starts the sequential BLE vitals sync (steps first; further types chain via events).
  Future<void> syncOverAllData() async {
    debugPrint('initiated_syncing');
    showSyncProgress = true;
    update();
    await syncStepsData();
  }

  /// Persists steps payload and updates today's step summary on the dashboard.
  Future<void> updateStepsSyncSDKData(List<dynamic> stepsData) async {
    await _applyStepsToDashboard(stepsData);
    overAllStepsData = jsonEncode(stepsData);
    update();
    await sharedService.setOverAllSteps(getOverAllStepsData);
  }

  Future<void> updateSleepSyncSDKData(List<dynamic> sleepData) async {
    await _applySleepToDashboard(sleepData);
    overAllSleepData = jsonEncode(sleepData);
    sleepDataRevision.value++;
    update();
    await sharedService.setOverAllSleep(getOverAllSleepData);
  }

  Future<void> updateHR24SyncSDKData(dynamic hr24Data) async {
    await _applyHeartRateToDashboard(hr24Data);
    overAllHrData = jsonEncode(hr24Data);
    update();
    await sharedService.setOverAllHeartRate(getOverAllHrData);
  }

  Future<void> updateBloodPressureSyncSDKData(dynamic bloodPressureData) async {
    await _applyBloodPressureToDashboard(bloodPressureData);
    overAllBPData = jsonEncode(bloodPressureData);
    update();
    await sharedService.setOverAllBP(getOverAllBPData);
  }

  Future<void> updateTemperatureSyncSDKData(dynamic temperatureData) async {
    await _applyTemperatureToDashboard(temperatureData);
    overAllTempData = jsonEncode(temperatureData);
    update();
    await sharedService.setOverAllTemperature(getOverAllTempData);
  }

  Future<void> updateOxygenSyncSDKData(dynamic oxygenData) async {
    await _applyOxygenToDashboard(oxygenData);
    overAllOxygenData = jsonEncode(oxygenData);
    update();
    await sharedService.setOverAllOxygenData(getOverAllOxygenData);
  }

  /// Reads all persisted sleep rows from the Android SDK database into [overAllSleepData].
  Future<void> fetchAllSleepDataSync() async {
    if (!Platform.isAndroid) return;
    try {
      final result = await flutterBandFit.fetchAllSleepData();
      debugPrint('fetchAllSleepData>> $result');
      if (result['status']?.toString() != BandFitConstants.SC_SUCCESS) return;
      final sleepData = JsonUtils.asList(result['data']);
      if (sleepData.isNotEmpty) {
        await updateSleepSyncSDKData(sleepData);
      }
    } catch (e) {
      debugPrint('fetchAllSleepDataSyncExp: $e');
    }
  }

  /// Android bulk fetch: applies each vital type then saves JSON to [SharedService].
  Future<void> fetchOverAllDeviceDataSync() async {
    try {
      final resultOverAllDeviceData =
          await flutterBandFit.fetchOverAllDeviceData();
      debugPrint('resultOverAllDeviceData>>$resultOverAllDeviceData');
      final status = resultOverAllDeviceData['status'].toString();
      if (status != BandFitConstants.SC_SUCCESS) {
        return;
      }

      final resultData = resultOverAllDeviceData['data'];
      final stepsData = resultData['steps'];
      final sleepData = resultData['sleep'];
      final hr24Data = resultData['hr24'];
      final bpData = resultData['bp'];
      final temperatureData = resultData['temperature'];
      final oxygenData = resultData['oxygen'];

      if (stepsData is List && stepsData.isNotEmpty) {
        await updateStepsSyncSDKData(stepsData);
      }
      if (sleepData is List && sleepData.isNotEmpty) {
        await updateSleepSyncSDKData(sleepData);
      }
      if (hr24Data is List && hr24Data.isNotEmpty) {
        await updateHR24SyncSDKData(hr24Data);
      }
      if (bpData is List && bpData.isNotEmpty) {
        await updateBloodPressureSyncSDKData(bpData);
      }
      if (temperatureData is List && temperatureData.isNotEmpty) {
        await updateTemperatureSyncSDKData(temperatureData);
      }
      if (oxygenData is List && oxygenData.isNotEmpty) {
        await updateOxygenSyncSDKData(oxygenData);
      }
    } catch (e) {
      debugPrint('fetchExp: $e');
    }
  }

  Future<List<StepsMainModel>> getSelectedDayStepsData(dynamic overAllStepsData, [String? calenderTime]) async {
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

    for (final data in JsonUtils.asList(overAllStepsData)) {
      if (data['calender'].toString().trim() == findCalenderTime) {
        BandStepsDataModel stepsDataModel = BandStepsDataModel.fromJson(JsonUtils.asMap(data));
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

  Future<List<StepsMainModel>> getCurrentDaySteps(dynamic overAllStepsData, [String? calenderTime]) async {
    String findCalenderTime = '';
    if (calenderTime != null && calenderTime.isNotEmpty) {
      findCalenderTime = calenderTime;
    } else {
      //current calender time
      String currentCalTime = GlobalMethods.convertBandReadableCalender(DateTime.now());
      findCalenderTime = currentCalTime;
    }

    List<StepsMainModel> stepsList = [];
    for (final data in JsonUtils.asList(overAllStepsData)) {
      //debugPrint('step_data>> $data');
      if (data['calender'].toString().trim() == findCalenderTime) {

        debugPrint('stepsDataModel.calories>> ${data['calories']}');
        debugPrint('stepsDataModel.distance>> ${data['distance']}');

        stepsList.add(StepsMainModel.fromJson(JsonUtils.asMap(data)));
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

      final dateTime = GlobalMethods.parseBandReadableCalender(calender);
      final week = calWeeks[dateTime.weekday - 1];

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
    //     stepsList.add(BandStepsDataModel.fromJson(JsonUtils.asMap(data)));
    //   }
    // }
    if (isMonthly) {
      return [monthDataList, totalSteps, totalDistance, totalCalories];
    } else {
      return [weekDataList, totalSteps, totalDistance, totalCalories];
    }
  }

  Future<List<StepsMainModel>> getStepsBySelectedWeek(dynamic overAllStepsData, List<String> weekList) async {
    List<StepsMainModel> stepsList = [];
    for (final data in JsonUtils.asList(overAllStepsData)) {
      //debugPrint('step_data>> $data');
      if (weekList.contains(data['calender'].toString().trim())) {
        stepsList.add(StepsMainModel.fromJson(JsonUtils.asMap(data)));
      }
    }
    //debugPrint('return_weekList>>$stepsList');
    return stepsList;
  }

  Future<List<SleepMainModel>> getSelectedDaySleepData(dynamic overAllSleepData, [String? calenderTime]) async {
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

    for (final data in JsonUtils.asList(overAllSleepData)) {
      if (data['calender'].toString().trim() == findCalenderTime) {
        // deep sleep: 0, Light sleep: 1,  awake: 2
        debugPrint('sleepData>> $data');
        BandSleepModel sleepModel = BandSleepModel.fromJson(JsonUtils.asMap(data));

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

  Future<List<dynamic>> getSleepDataSelectedRange(bool isMonthly, dynamic overAllSleepData, List<String> calenderWeekList, BuildContext context) async {

    List<WeeklySleepData> weeklyDataList = [];
    List<MonthlySleepData> monthlyDataList = [];

    int totalHrsNum = 0;
    int totalLightNum = 0;
    int totalAwakeNum = 0;
    int totalDeepNum = 0;

    for (var calender in calenderWeekList) {
      final dateTime = GlobalMethods.parseBandReadableCalender(calender);
      final week = calWeeks[dateTime.weekday - 1];

      final sleepDataList = JsonUtils.asList(overAllSleepData)
          .where((element) =>
              JsonUtils.asString(JsonUtils.asMap(element)['calender']).trim() ==
              calender)
          .toList();

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

  Future<List<SleepMainModel>> getCurrentDaySleepData(dynamic overAllSleepData, [String? calenderTime]) async {
    String findCalenderTime = '';
    if (calenderTime != null && calenderTime.isNotEmpty) {
      findCalenderTime = calenderTime;
    } else {
      //current calender time
      String currentCalTime = GlobalMethods.convertBandReadableCalender(DateTime.now());
      findCalenderTime = currentCalTime;
    }
    List<SleepMainModel> sleepList = [];
    for (final data in JsonUtils.asList(overAllSleepData)) {
      //debugPrint('sleep_data >> $data');
      if (data['calender'].toString().trim() == findCalenderTime) {
        sleepList.add(SleepMainModel.fromJson(JsonUtils.asMap(data)));
      }
    }
    return sleepList;
  }

  Future<List<SleepMainModel>> getSleepBySelectedWeek(dynamic overAllSleepData, List<String> weekList) async {
    List<SleepMainModel> sleepList = [];
    for (final data in JsonUtils.asList(overAllSleepData)) {
      //debugPrint('step_data>> $data');
      if (weekList.contains(data['calender'].toString().trim())) {
        sleepList.add(SleepMainModel.fromJson(JsonUtils.asMap(data)));
      }
    }
    //debugPrint('return_weekList>>$stepsList');
    return sleepList;
  }

  Future<List<BandHRModel>> getCurrentDayHRData(dynamic overAllHrData, [String? calenderTime]) async {
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
      for (final data in JsonUtils.asList(overAllHrData)) {
        //debugPrint('hr_data >> $data');
        if (data['calender'].toString().trim() == findCalenderTime) {
          hrList.add(BandHRModel.fromJson(JsonUtils.asMap(data)));
        }
      }
    } catch (e) {
      debugPrint('inside_exp: $e');
    }
    return hrList;
  }

  Future<List<BandBPModel>> getCurrentDayBPData(dynamic overAllBPData, [String? calenderTime]) async {
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
    for (final data in JsonUtils.asList(overAllBPData)) {
      // debugPrint('bp_data >> $data');
      if (data['calender'].toString().trim() == findCalenderTime) {
        bpList.add(BandBPModel.fromJson(JsonUtils.asMap(data)));
      }
    }
    return bpList;
  }

  Future<List<BandOxygenModel>> getCurrentDayOxygenData(dynamic oxyData, [String? calenderTime]) async {
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
    for (final data in JsonUtils.asList(oxyData)) {
      if (data['calender'].toString().trim() == findCalenderTime) {
        oxyList.add(BandOxygenModel.fromJson(JsonUtils.asMap(data)));
      }
    }
    return oxyList;
  }

  Future<List<BandTempModel>> getCurrentDayTemperatureData(dynamic temperatureData, [String? calenderTime]) async {
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
    for (final data in JsonUtils.asList(temperatureData)) {
      //debugPrint('temp_data >> $data');
      if (data['calender'].toString().trim() == findCalenderTime) {
        // debugPrint('todayTempData>> $data');
        tempList.add(BandTempModel.fromJson(JsonUtils.asMap(data)));
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
          hourStr = "0$hour";
        }else{
          hourStr = hour.toString();
        }
        if (min < 9){
          minStr = "0$min";
        }else{
          minStr = min.toString();
        }

        return '$hourStr:$minStr';

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
            timeStr = '${timesList[0].padLeft(2,"0")}${timesList[1].padLeft(2,"0")}00';
          }
          return '${outputDate}T$timeStr';
        }else{
          return '${outputDate}T000000';
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

  bool get _hasValidWeatherCoordinates =>
      deviceLatitude != 0 || deviceLongitude != 0;

  bool _isWeatherCacheFresh(double lat, double lon) {
    final fetchedAt = _lastWeatherFetchAt;
    if (fetchedAt == null) {
      return false;
    }
    if (_lastWeatherFetchLat != lat || _lastWeatherFetchLon != lon) {
      return false;
    }
    return DateTime.now().difference(fetchedAt) < WeatherConfig.fetchCacheTtl;
  }

  Future<void> updateDeviceBandLanguage() async {
    final lang = AppLanguageUtils.bandLanguageCode;
    debugPrint('update_lang>> $lang');
    final result = await flutterBandFit.setDeviceBandLanguage(lang);
    debugPrint('update_lang_result>> $result');

    if (!_hasValidWeatherCoordinates) {
      return;
    }

    await callWeatherForecast(
      deviceLatitude.toString(),
      deviceLongitude.toString(),
    );

    if (getJsonWeatherData.isNotEmpty && deviceConnected) {
      await setWeatherInfoSevenDays();
    }
  }

  /// Fetches 7-day OpenWeather data, updates UI, and persists locally.
  Future<void> callWeatherForecast(
    String lat,
    String lon, {
    bool forceRefresh = false,
  }) async {
    final latitude = double.tryParse(lat);
    final longitude = double.tryParse(lon);
    if (latitude == null || longitude == null) {
      debugPrint('callWeatherForecast: invalid coordinates');
      return;
    }
    if (latitude == 0 && longitude == 0) {
      debugPrint('callWeatherForecast: coordinates are zero');
      return;
    }

    if (!forceRefresh && _isWeatherCacheFresh(latitude, longitude)) {
      return;
    }

    if (_weatherFetchInFlight != null) {
      await _weatherFetchInFlight;
      if (!forceRefresh && _isWeatherCacheFresh(latitude, longitude)) {
        return;
      }
    }

    _weatherFetchInFlight = _fetchAndApplyWeather(
      latitude: latitude,
      longitude: longitude,
    );
    try {
      await _weatherFetchInFlight;
    } finally {
      _weatherFetchInFlight = null;
    }
  }

  Future<void> _fetchAndApplyWeather({
    required double latitude,
    required double longitude,
  }) async {
    final lang = await AppLanguageUtils.getLanguage();
    debugPrint('fetching_lang>> $lang');

    final response = await WeatherApiClient.instance.fetchOneCall(
      lat: latitude,
      lon: longitude,
      useMetricUnits: getIsCelsius,
      lang: lang,
    );
    if (response == null) {
      return;
    }

    final currentData = response['current'];
    final dailyList = response['daily'];
    if (currentData is! Map || dailyList is! List) {
      debugPrint('callWeatherForecast: unexpected API shape');
      return;
    }

    final weatherMainModel = WeatherMainModel(
      Map<String, dynamic>.from(currentData),
      dailyList,
    );
    final dailyWeatherList = weatherMainModel.weatherDailyList;
    final bandPayload = WeatherBandPayloadBuilder.buildBandSevenDayPayload(
      model: weatherMainModel,
      cityName: getDeviceCityName,
    );
    if (bandPayload == null) {
      debugPrint(
        'callWeatherForecast: need 7 daily entries, got ${dailyWeatherList.length}',
      );
      return;
    }

    _weatherModelData = weatherMainModel;
    currentTemperature = (double.tryParse(
              weatherMainModel.temperature.toString(),
            ) ??
            0)
        .toStringAsFixed(2);
    currentWeatherUrl = weatherMainModel.currentIconUrl;

    jsonWeatherData = WeatherBandPayloadBuilder.encodeBandPayload(bandPayload);
    weatherSyncDateTime = DateTime.now().toString();
    _lastWeatherFetchLat = latitude;
    _lastWeatherFetchLon = longitude;
    _lastWeatherFetchAt = DateTime.now();
    update();

    final jsonStr = jsonEncode(response);
    await Future.wait<void>([
      sharedService.setWeatherResponseData(jsonStr),
      sharedService.setJsonWeatherData(jsonWeatherData),
      sharedService.setWeatherSyncDateTime(weatherSyncDateTime),
    ]);

  }
  int getDeviceWeatherCode(int weatherCode) =>
      WeatherDeviceCodeMapper.map(weatherCode);

  Future<void> fetchAllJudgement() async {
    Map<String, dynamic> resultJudgeData = await flutterBandFit.fetchAllJudgement();
    debugPrint('fetchAllJudgementResultJudgeData>>$resultJudgeData');
    String status = resultJudgeData['status'].toString();
    if (status == BandFitConstants.SC_SUCCESS) {
      final resultData = JsonUtils.asMap(resultJudgeData['data']);
      final rkPlatform = JsonUtils.asBool(resultData['rkPlatform']);
      final isSupportNewParams = JsonUtils.asBool(resultData['isSupportNewParams']);
      final isBandLostFunction = JsonUtils.asBool(resultData['isBandLostFunction']);
      final isBraceletLangSwitch = JsonUtils.asBool(resultData['isBraceletLangSwitch']);
      final isTempUnitSwitch = JsonUtils.asBool(resultData['isTempUnitSwitch']);
      final isMinHRAlarm = JsonUtils.asBool(resultData['isMinHRAlarm']);
      final isTempTest = JsonUtils.asBool(resultData['isTempTest']);
      final isTempCalibration = JsonUtils.asBool(resultData['isTempCalibration']);
      final isSupportHorVer = JsonUtils.asBool(resultData['isSupportHorVer']);
      final isSupport24HrRate = JsonUtils.asBool(resultData['isSupport24HrRate']);
      final isSupportOxygen = JsonUtils.asBool(resultData['isSupportOxygen']);
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
    } else if (status == BandFitConstants.SC_DISCONNECTED) {
      // device got disconnected.
    } else if (status == BandFitConstants.SC_FAILURE) {
      // something went wrong
    }
    debugPrint('resultJudgeData>> $resultJudgeData');
  }

}
