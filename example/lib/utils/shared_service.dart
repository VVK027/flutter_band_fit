// device related data constants
import 'package:flutter_band_fit_app/common/common_imports.dart';

final sharedService = SharedService();
class SharedService {
  final _storageBox = GetStorage(sharedStorageKey);

  T read<T>(String key) {
    return _storageBox.read(key);
  }
  void writeIfNull(String key, dynamic value) async {
    await _storageBox.writeIfNull(key, value);
  }

  void write(String key, dynamic value) async {
    await _storageBox.write(key, value);
  }

  Future<void> setInitialParams(String userGender, String userAge, String dob) async {
    // await setUserHeight(userHeight);
    // await setUserWeight(userWeight);
    //if (userSharedPref == null) {
    //  userSharedPref = await SharedPreferences.getInstance();
    //}
    await setUserGender(userGender);
    await setUserDOB(dob);
    await setUserAge(userAge);
  }

  Future<void> setInitialHeightWeight(String userHeight, String userWeight) async {
    // if (userSharedPref == null) {
    //   userSharedPref = await SharedPreferences.getInstance();
    // }
    await setUserHeight(userHeight);
    await setUserWeight(userWeight);
  }

  Future<void> updateBMIStatus(String bmiValue, String bmiStat) async {
    await setBMIValue(bmiValue);
    await setBMIStatus(bmiStat);
  }

  Future<void> setTargetedSteps(String targetedSteps) async {
    await _storageBox.write(targetStepsKey, targetedSteps);
  }
  String getTargetedSteps(){
    return _storageBox.read(targetStepsKey)??defaultTargetedSteps;
  }
  Future<void> setUserGender(String userGender) async {
    return await _storageBox.write(genderKey, userGender);
  }
  String getUserGender(){
    return _storageBox.read(genderKey)??'male';
  }
  Future<void> setScreenOffTime(String time) async {
     await _storageBox.write(screenOffTimeKey, time);
  }
  String getScreenOffTime(){
    return _storageBox.read(screenOffTimeKey)??screenOffTimeMin.toString();
  }

  Future<void> setBMIValue(String value) async {
     await _storageBox.write(bmiKey, value);
  }
  String getBMIValue(){
    return _storageBox.read(bmiKey)??'24.7';
  }
  Future<void> setBMIStatus(String status) async {
     await _storageBox.write(bmiStatusKey, status);
  }
  String getBMIStatus(){
    return _storageBox.read(bmiStatusKey)??'bmi_fit';
  }

  Future<void> setUserHeight(String userHeight) async {
     await _storageBox.write(heightKey, userHeight);
  }
  String getUserHeight(){
    return _storageBox.read(heightKey)??heightMin.toString();
  }
  Future<void> setUserWeight(String userWeight) async {
     await _storageBox.write(weightKey, userWeight);
  }
  String getUserWeight(){
    return _storageBox.read(weightKey)??weightMin.toString();
  }

  Future<void> setUserAge(String userAge) async {
     await _storageBox.write(ageKey, userAge);
  }
  String? getUserAge(){
    return _storageBox.read(ageKey);
  }
  Future<void> setUserDOB(String userDOB) async {
     await _storageBox.write(dobKey, userDOB);
  }
  String? getUserDOB(){
    return _storageBox.read(dobKey);
  }

  bool getProfileUpdate() {
    return _storageBox.read(isProfileUpdated)?? false;
  }

  Future<void>  setProfileUpdate(bool isUpdated) async {
    return await _storageBox.write(isProfileUpdated, isUpdated);
  }

  //
  // static Future<void> setProfileUpdate(bool isProfileUpdated) async {
  //   await await SharedPref().setBool('isProfileUpdated', isProfileUpdated);
  // }

  // device related preferences
  Future<void>  setSmartMConnected(bool isConnected) async {
    return await _storageBox.write(deviceConnectedKey, isConnected);
  }
  bool isSmartMConnected() {
    return _storageBox.read(deviceConnectedKey) ?? false;
  }

  Future<void> setHealthConnected(bool isConnected) async {
    return await _storageBox.write(healthConnected, isConnected);
  }
  bool isHealthConnected() {
    return _storageBox.read(healthConnected) ?? false;
  }

  Future<void>  setOxygenAvailable(bool isConnected) async {
    return await _storageBox.write(oxygenConnected, isConnected);
  }
  bool isOxygenAvailable() {
    return _storageBox.read(oxygenConnected) ?? false;
  }

  Future<void>  setHeartRate24HrEnabled(bool isEnable) async {
    return await _storageBox.write(HEART_RATE_ENABLED, isEnable);
  }
  bool isHeartRate24HrEnabled() {
    return _storageBox.read(HEART_RATE_ENABLED) ?? false;
  }

  Future<void>  setOxygen24HrEnabled(bool isEnable) async {
    return await _storageBox.write(OXYGEN_ENABLED, isEnable);
  }
  bool isOxygen24HrEnabled() {
    return _storageBox.read(OXYGEN_ENABLED) ?? false;
  }


  Future<void>  setTemperature24HrEnabled(bool isEnable) async {
    return await _storageBox.write(TEMPERATURE_ENABLED, isEnable);
  }
  bool isTemperatureEnabled() {
    return _storageBox.read(TEMPERATURE_ENABLED) ?? false;
  }


  Future<void>  setDNDEnabled(bool isEnable) async {
    return await _storageBox.write(DND_ENABLED, isEnable);
  }
  bool isDNDEnabled() {
    return _storageBox.read(DND_ENABLED) ?? false;
  }

  Future<void> setDNDEnabledTime(String enableTime) async {
    // startHr:startMin:endHr:endMin
    return await _storageBox.write(DND_ENABLED_TIME, enableTime);
  }
  String getDNDEnabledTime(){
    return _storageBox.read(DND_ENABLED_TIME) ?? '';
  }

  Future<void> setMessagesOnEnabled(bool isEnable) async {
    return await _storageBox.write(MSG_ON_ENABLED, isEnable);
  }
  bool isMessagesOnEnabled() {
    return _storageBox.read(MSG_ON_ENABLED) ?? false;
  }

  Future<void> setMotorVibrateEnabled(bool isEnable) async {
    return await _storageBox.write(MOTOR_VIBRATE_ENABLED, isEnable);
  }
  bool isMotorVibrateEnabled() {
    return _storageBox.read(MOTOR_VIBRATE_ENABLED) ?? false;
  }



  Future<void> setDeviceName(String deviceName) async {
    return await _storageBox.write(deviceNameKey, deviceName);
  }
  String getDeviceName(){
    return _storageBox.read(deviceNameKey) ?? '';
  }

  Future<void> setDeviceMacAddress(String deviceAddress) async {
    return await _storageBox.write(deviceMacAddressKey, deviceAddress);
  }
  String getDeviceMacAddress(){
    return _storageBox.read(deviceMacAddressKey) ?? '';
  }

  Future<void> setDeviceVersionId(String version) async {
    return await _storageBox.write(deviceVersionId, version);
  }
  String getDeviceVersionId()  {
    return _storageBox.read(deviceVersionId) ?? '';
  }

  Future<void> setBatteryStatus(String batteryStat) async {
    return await _storageBox.write(batteryStatus, batteryStat);
  }
  String getBatteryStatus() {
    return _storageBox.read(batteryStatus) ?? '0';
  }


  Future<void> setLastSyncDate(String syncDate) async {
    return await _storageBox.write(deviceSyncDateKey, syncDate);
  }

  String getLastSyncDate(){
    return _storageBox.read(deviceSyncDateKey) ?? '';
  }

  Future<void> setLastSyncDateTime(String syncDate) async {
    return await _storageBox.write(deviceSyncDateTime, syncDate);
  }

  String getLastSyncDateTime(){
    return _storageBox.read(deviceSyncDateTime) ?? '';
  }

  Future<void> setLastMacAddressId(String macId) async {
    return await _storageBox.write(deviceMacAddressId, macId);
  }

  String getLastMacAddressId(){
    return _storageBox.read(deviceMacAddressId) ?? '';
  }

  Future<void> setWeatherSyncDateTime(String syncDate) async {
    return await _storageBox.write(weatherSyncDateTime, syncDate);
  }

  String getWeatherSyncDateTime(){
    return _storageBox.read(weatherSyncDateTime) ?? '';
  }

  Future<void>  setLatitude(String latitude) async {
    return await _storageBox.write(latitudeKey, latitude);
  }
  String? getLatitude(){
    return _storageBox.read(latitudeKey);
  }

  Future<void>  setLongitude(String longitude) async {
   return await _storageBox.write(longitudeKey, longitude);
  }
  String? getLongitude(){
    return _storageBox.read(longitudeKey);
  }

  Future<void>  setDeviceCityName(String cityName) async {
     await _storageBox.write(cityNameKey, cityName);
  }
  String? getDeviceCityName(){
    return _storageBox.read(cityNameKey);
  }

  Future<void> setJsonWeatherData(String weatherData) async {
    return await _storageBox.write(DEVICE_WEATHER_JSON_PUSH, weatherData);
  }
  String? getJsonWeatherData(){
    return _storageBox.read(DEVICE_WEATHER_JSON_PUSH);
  }

  Future<void> setWeatherResponseData(String weatherData) async {
    return await _storageBox.write(WEATHER_RESPONSE_DATA, weatherData);
  }
  String? getWeatherResponseData(){
    return _storageBox.read(WEATHER_RESPONSE_DATA);
  }

  // overall data after sync

  Future<void>setOverAllSteps(String stepsData) async {
    return await _storageBox.write(stepsDataKey, stepsData);
  }
  String getOverAllSteps(){
    return _storageBox.read(stepsDataKey) ?? '';
  }

  Future<void> setOverAllSleep(String sleepData) async {
    return await _storageBox.write(sleepDataKey, sleepData);
  }
  String getOverAllSleep(){
    return _storageBox.read(sleepDataKey) ?? '';
  }

  Future<void> setOverAllHeartRate(String hrData) async {
    return await _storageBox.write(hrDataKey, hrData);
  }
  String getOverAllHeartRate(){
    return _storageBox.read(hrDataKey) ?? '';
  }

  Future<void>  setOverAllBP(String bpData) async {
    return await _storageBox.write(bpDataKey, bpData);
  }
  String getOverAllBP(){
    return _storageBox.read(bpDataKey) ?? '';
  }

  Future<void> setOverAllTemperature(String tempData) async {
    return await _storageBox.write(tempDataKey, tempData);
  }
  String getOverAllTemperature(){
    return _storageBox.read(tempDataKey) ?? '';
  }


  Future<void>  setOverAllOxygenData(String oxyData) async {
    return await _storageBox.write(oxygenDataKey, oxyData);
  }
  String getOverAllOxygenData(){
    return _storageBox.read(oxygenDataKey) ?? '';
  }

  Future<void>  setTempCelsius(bool isCelsius) async {
    return await _storageBox.write(DEVICE_TEMP_UNITS, isCelsius);
  }
  bool getIsTempCelsius() {
    return _storageBox.read(DEVICE_TEMP_UNITS) ?? true;
  }

  Future<void>  setRaiseWakeUp(bool isWakeUp) async {
    return await _storageBox.write(DEVICE_HAND_WAKE_UP, isWakeUp);
  }
  bool getRaiseWakeUp() {
    return _storageBox.read(DEVICE_HAND_WAKE_UP) ?? true;
  }

}