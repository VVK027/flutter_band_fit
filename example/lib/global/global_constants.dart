import '../common/common_imports.dart';

//Default TargetedSteps
const String defaultTargetedSteps ='8000';

const String defaultDateFormat ='yyyy-MM-dd';
const String defaultDateTimeParseFormat ='yyyy-MM-dd HH:mm';
//const String defaultLastSyncDateTimeFormat ='yyyy-MM-dd hh:mm:ss a';
const String defaultLastSyncDateTimeFormat ='yyyy-MM-dd hh:mm a';

//const Color completeColor = Color(0xFF36688D);
const Color completeColor = Colors.deepPurple;
const Color inCompletedColor = Colors.lightBlueAccent;

const Color deepColor = Color(0xFF7A58C9);
const Color lightColor = Color(0xFFC7A9FE);
const Color awakeColor = Color(0xFFFF9A42);

const Color lightStepsColor = Color(0xFF80FFA4);
const Color darkStepsColor = Color(0xFF10D8A1);
const Color calColor = Color(0xFFF6D505);
const Color sleepLightColor = Color(0xFFAA9CFF);
const Color sleepDarkColor = Color(0xFF61BEF7);
const Color bpColor = Color(0xFFEE7453);
const Color heartRateColor = Color(0xFFFF7373);
const Color temperatureColor = Color(0xFF33CC33);
const Color oxygenColorDark = Color(0xFF8A2418);
const Color oxygenColorLight = Color(0xFFFC5F1D);
//const Color temperatureColor = Color(0xFF96EE8D);

const int heightMin = 90;
const int heightMax = 300;
const int weightMin = 20;
const int weightMax = 200;
const int screenOffTimeMin = 15;

const String tempInCelsius ='°C';
const String tempInFahrenheit ='°F';
const String bpUnits ='mmHg';

const String tempAPIInCelsius ='C';
const String tempAPIInFahrenheit ='F';
const String hrTimeMinutes ='Times/minute';

const String okText = 'OK';
const String cancelText = 'Cancel';
const String doneText = 'Done';
const String retryText = 'Retry';
const String textRefresh = 'Refresh';
const String textOR = 'OR';
const String textOn = 'On';
const String textOff = 'Off';
const String textDear = 'Dear';
const String textBandFit = 'Band Fit';
const String textLinkAppleHealth = 'Link with Apple Health';
const String textLinkGoogleFit = 'Link with Google Fit';
const String textSetOptions = 'Set your Options';
const String textVersion = 'Version';
const String textBattery = 'Battery';
const String textAppleHealth = 'Apple Health';
const String textGoogleFit = 'Google Fit';
const String textUnlink = 'Unlink';
const String textLink = 'Link';
const String textSettings = 'Settings';
const String textDownloads = 'Downloads';
const String textDownloadingFile = 'Downloading File';
const String textGoal= 'Goal';
const String textSmartProfile= 'Smart Profile';
const String textDialFaces = 'Dial Faces';
const String textSynchronizing = 'Synchronizing';
const String textSynchronousDial = 'Synchronous Dial';
const String textSyncDoneSuccess = 'Sync Done Successfully';
const String textDialFacesMsg = 'Change your dial screen according to your style';
const String textNoDevicesConnected = 'No devices are connected currently';
const String textStoragePermission = 'Storage permission is required for proper functioning of application.';

const String reconnectText = 'Reconnect';
const String textDisconnect = 'Disconnect';
const String reconnectingText = 'Reconnecting..!';
const String deviceDisconnected = 'Device Disconnected';
const String deviceDisconnectedMsg = 'Your device got disconnected, retry to connect back.';
const String syncFailed = 'Sync Failed';
const String syncFailedMsg = 'There is a data sync timeout issue, Please try to sync again..!';
const String deviceConnected = 'Your Device is connected!';

const String textTime = 'Time';
const String textToday = 'Today';
const String textTodayData = 'Today\'s Data';
const String textDay = 'Day';
const String textWeek = 'Week';
const String textMonth = 'Month';
const String textStart = 'Start';
const String textGender = 'Gender';
const String textHeight = 'Height';
const String textWeight = 'Weight';
const String textDateOfBirth = 'Date Of Birth';
const String textBMI = 'BMI';
const String textDailyStepsGoal = 'Daily Steps Goal';
const String textBandScreenOffTime = 'Band Screen Off Time';
const String textSetTemperatureUnit = 'Set Temperature Unit';
const String textRaiseHandActivateLabel = 'Raise Hand to Activate Display';
const String textRaiseHandActivateMsg = 'Raise your hand to activate display';
const String textUpdateInfoMsg = 'Update the following information';

const String textStartTime = 'Start Time';
const String textEndTime = 'End Time';
const String textBegin = 'Begin';
const String textEnd = 'End';
const String textDeep = 'Deep';
const String textLight = 'Light';
const String textAwake = 'Awake';
const String textSelectStartTime = 'Select Start Time';
const String textSelectEndTime = 'Select End Time';
const String textSyncNow = 'Sync Now';
const String textHeartRate = 'Heart Rate';
const String textSleepDuration = 'Sleep Duration';
const String textTotalSleepHours = 'Total Sleep Hours';
const String textDeepHours = 'Deep Hours';
const String textLightHours = 'Light Hours';
const String textAwakeHours = 'Awake Hours';
const String textTotalHours = 'Total Hours';
const String textBP = 'BP';
const String textSpo2 = 'Spo2';
const String textTemperature = 'Temperature';
const String textLastSynced = 'Last Synced';
const String textLastSyncedNoData = 'No Data Syncing is Done';
const String textSyncingDataMsg = 'Please wait…! We are syncing your data';
const String textPleaseWait = 'Please Wait..!';
const String textPleaseWaitMsg = 'We are syncing your data now, please wait!';
const String textPhysicalActivities = 'Physical Activities';
const String textSteps = 'Steps';
const String textTotalSteps = 'Total Steps';
const String textCalories = 'Calories';
const String textDistance = 'Distance';
const String textWeather = 'Weather';
const String textSaveContinue = 'Save and Continue';
const String textUpdatedTo = 'Updated to';
const String textHumidity = 'Humidity';
const String textWindSpeed = 'Wind Speed';
const String textUVIndex = 'UV Index';
const String textSomethingWrong = 'Something went wrong ! Please try again later !';
const String textNeedProfileUpdate = 'Need a Profile Update';
const String textConfigureMonitoring = 'Configure your monitoring options below';
const String textMonitoringOptions = 'Monitoring Options';
const String textMonitoringOptionsMsg = 'Data collection configuration options';
const String textHeartRateMonitoring = 'Heart Rate Monitoring';
const String text24HrHeartRateTest = '24 hours automatic heart rate';
const String text24HrTempTest = '24 hours body temperature';
const String text24HrOxygen = '24-hour automatic body oxygen';
const String textBodyTemperatureMonitoring = 'Body Temperature Monitoring';
const String textBodyOxygenMonitoring = 'Body Oxygen Monitoring';
const String textHighPressure = 'High Pressure';
const String textLowPressure = 'Low Pressure';
const String textDoNotDisturb = 'Do Not Disturb';
const String textDoNotDisturbMsg = 'Choose when you want your Docty-M to keep quiet.(Zzz)';
const String textListenVibrate = 'Listen your band vibrate';
const String textListenVibrateMsg = 'Your band will vibrate 3 times. Happy Finding.';
const String textFindBand = 'Find your smart Band';
const String textFindBandMsg = 'Will send you 3 vibrations to your band to help you find it';
const String textAverageHR = 'Average Heart Rate';
const String textMinHR = 'Minimum Heart Rate';
const String textMaxHR = 'Maximum Heart Rate';
const String textMinOxygen = 'Minimum Blood Oxygen';
const String textMaxOxygen = 'Maximum Blood Oxygen';
const String textDoNotDisturbLabel = 'Enable this function to keep Docty-M quiet (Screen, Messages, Vibration) e.g.: While you sleep';
const String textDNDTimeMsg = 'Will turn on the do not disturb within the time below';
const String textDNDAdditionalMsg = 'In addition to the Do Not Disturb period, the following settings can be configured';
const String textDNDDisableReminder = 'Disable Message Reminder';
const String textDNDDisableReminderMsg = 'Messages will not be send to your band during the time above';
const String textDNDDisableBandVibration = 'Disable Band Vibration';
const String textDNDDisableBandVibrationMsg = 'Will also disable finding your band';
const String textSelSameTimings = 'Selected Same Timings';
const String textSelSameTimingsMsg = 'Start time and End time can&#x27;t be set the same. Kindly correct it.';
const String textInvalidTimePeriod = 'Invalid Time Period';
const String textInvalidTimePeriodMsg = 'Please select the appropriate start time and end time. The start time should not be greater than the end time.';
const String textDNDStatus = 'Do Not Disturb Status';
const String textDNDStatusMsg = 'Do Not Disturb status is updated. Thanks.';
const String textSleepQualityAnalysis = 'Sleep Quality Analysis';
const String textSleepNotLate = 'Don\'t sleep too late';
const String textSleepLake = 'Lack of sleep';
const String textSleepWakeEarly = 'Wake up early';
const String textMinTemperature = 'Minimum body temperature';
const String textMaxTemperature = 'Maximum body temperature';
const String textRecentTemperature = 'Recent Body Temperature';
const String textTempNotSupported = 'Temperature Not Supported';
const String textTempNotSupportedMsg = 'Your device doesn\'t support for the temperature testing.';



//const String okTextStr = 'OK';
//const String tempString = 'The normal body temperature of the human body averages between 36~37°C (96.8~98.6°F). The body temperature changes physiologically within a day, which can vary with day and night, age, gender, activity, medicine etc. Physiological changes occur,but the range of changes is very small.';
const String tempString = 'Our normal body temperature averages between 36 - 37 °C (96.8 - 98.6 °F). On a daily basis, the human body sees slight changes in body temperature depending on the time of day, age, gender, activity, etc.';

//const String tempDisclaimer = 'Declaration: All data or results are for reference only,and it is not recommended as a formal basis for medical or health conditions.';
const String tempDisclaimer = 'Disclaimer: All data and readings are for reference only. These are not medical readings and it is recommended to not consider the same when judging a health condition.';

//const String sleepToLateString = '''The best time to fall asleep before 22 o'clock,long-term stay up late may make the body's immune system decreased,accelerated aging.''';
const String sleepToLateString = '''Sleeping on time (best before 22:00) is a healthy habit. It keeps the body’s immune system balanced.''';

const String sleepEarlyWakeUpString = '''After a good night’s rest, waking up early keeps the body relaxed and ready to take on the day’s activity.''';

const String sleepLackString = '''The best total sleep time is 7 to 9 hours. Insufficient sleep may make the body's immune system decreased and unresponsive.''';

//const String addSmartWatchText = 'Add a Smart watch to get to know more about your health information.';
const String addSmartWatchText = 'Add your wearable band to access your health reading and information';

//const String goalTextTitle = "According to the WHO recommendations, you need at least 150 minutes a week moderate aerobic activity which is equivalent to at least 8000 per day.";
const String goalTextTitle = "World Health Organization recommends at least 8000 steps per day to keep you fit. \nSelect your goal.";


const String raiseHandWakeUpText = 'The device lights up automatically when you raise your hand.';



const String noDeviceFoundHead = 'No Device Found';
const String textBluetooth = 'Bluetooth';
const String textAddDevice = 'Add Device';
const String bleNotConnected = 'Please enable the Bluetooth connectivity to search for devices.';
const String bleNotSupported = "The Bluetooth version of your handset is lower than the expectation. Your handset bluetooth doesn't support for the Bluetooth";
const String noDeviceFoundMessage = 'Connect your band device';
const String textNoDeviceMsg = 'No devices are found, Retry Again';
const String textSearchingDevice = 'Searching for your nearest band';
const String textConnectionFailed = 'Connection Failed';
const String textConnectionFailedMsg = 'Something went wrong..! Retry again by refreshing the page.';
const String textChooseSmartBand = 'Choose your SmartBand';
const String textChooseSmartBandMsg = 'Please select your band watch from the list';


// const String secondaryReminderMsg = 'In case of continuous time without exercise, the device will vibrate for reminding';
// const String smsReminderMsg = 'The phone needs to be connected to the device, do not turn off Bluetooth';
// const String callReminderMsg = 'The phone needs to be connected to the device, do not turn off Bluetooth';


enum Activity { steps, cal, distance, heartRate, bp, oxygen, temperature, sleepDuration }

extension ActivityExtension on Activity {
  String get name {
    return ["Steps", "Calories Burnt", "Distance", "Heart Rate", "Blood Pressure",
      "SPo2", "Temperature", "Sleep Duration"][index];
  }
}

extension ActivityTextLabel on Activity {
   String get textLabel {
    return [
      "Steps are a useful measure of how much you're moving around the world which can helps you spot changes in your activity levels",
      "Your body uses energy for more than just workouts. You'll see an estimate of your total calories burned while your are in rest as well as active.",
      'Measuring your distance is useful way to track your achievements in your running or walking activities',
      'Heart rate is measured in beats per minute (bpm) and can be elevated by things like activity, stress, or excitement',
      'Blood Pressure is measured in millimetres of mercury (mmHg), and your systolic and diastolic readings are an indicator of your heart health',
      'Oxygen Saturation (Spo2) is the percentage of oxygen in your blood, which gives your body energy to support physical and mental activity',
      'Your body temperature can vary slightly throughout the day, but you might notice more significant changes during illness',
      'Duration shows your total time slept each night. Mostly healthy adults need between 7 and 9 hours',
    ][index];
  }
}

// datetime.month - 1
List<String> calMonths = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

// datetime.weekday - 1
List<String> calWeeks = [
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun',
];


List<String> screenOffSecondsList = [
  '5',
  '10',
  '15',
  '20',
  '25',
  '30',
  '35',
  '40',
  '45',
  '50',
  '55',
  '60'
];

List<String> totalGoalsList = [
  '2000',
  '3000',
  '4000',
  '5000',
  '6000',
  '7000',
  '8000',
  '9000',
  '10000',
  '11000',
  '12000',
  '13000',
  '14000',
  '15000',
  '16000',
  '17000',
  '18000',
  '19000',
  '20000',
  '21000',
  '22000',
  '23000',
  '24000',
  '25000',
  '26000',
  '27000',
  '28000',
  '29000',
  '30000',
  '31000',
  '32000',
  '33000',
  '34000',
  '35000',
];

List<String> temperatureUnitsList = [
  tempInCelsius,
  tempInFahrenheit
];

/// List of data types available on iOS
///
// const List<HealthDataType> dataTypeKeysIOS = [
//   HealthDataType.ACTIVE_ENERGY_BURNED,
//   HealthDataType.BASAL_ENERGY_BURNED,
//   HealthDataType.BLOOD_GLUCOSE,
//   HealthDataType.BLOOD_OXYGEN,
//   HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
//   HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
//   HealthDataType.BODY_FAT_PERCENTAGE,
//   HealthDataType.BODY_MASS_INDEX,
//   HealthDataType.BODY_TEMPERATURE,
//   HealthDataType.DIETARY_CARBS_CONSUMED,
//   HealthDataType.DIETARY_ENERGY_CONSUMED,
//   HealthDataType.DIETARY_FATS_CONSUMED,
//   HealthDataType.DIETARY_PROTEIN_CONSUMED,
//   HealthDataType.ELECTRODERMAL_ACTIVITY,
//   HealthDataType.FORCED_EXPIRATORY_VOLUME,
//   HealthDataType.HEART_RATE,
//   HealthDataType.HEART_RATE_VARIABILITY_SDNN,
//   HealthDataType.HEIGHT,
//   HealthDataType.HIGH_HEART_RATE_EVENT,
//   HealthDataType.IRREGULAR_HEART_RATE_EVENT,
//   HealthDataType.LOW_HEART_RATE_EVENT,
//   HealthDataType.RESTING_HEART_RATE,
//   HealthDataType.STEPS,
//   HealthDataType.WAIST_CIRCUMFERENCE,
//   HealthDataType.WALKING_HEART_RATE,
//   HealthDataType.WEIGHT,
//   HealthDataType.FLIGHTS_CLIMBED,
//   HealthDataType.DISTANCE_WALKING_RUNNING,
//   HealthDataType.MINDFULNESS,
//   HealthDataType.SLEEP_IN_BED,
//   HealthDataType.SLEEP_AWAKE,
//   HealthDataType.SLEEP_ASLEEP,
//   HealthDataType.WATER,
//   HealthDataType.EXERCISE_TIME,
//   HealthDataType.WORKOUT,
// ];

/// List of data types available on Android
///
// const List<HealthDataType> dataTypeKeysAndroid = [
//   HealthDataType.ACTIVE_ENERGY_BURNED,
//   HealthDataType.BLOOD_GLUCOSE,
//   HealthDataType.BLOOD_OXYGEN,
//   HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
//   HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
//   HealthDataType.BODY_FAT_PERCENTAGE,
//   HealthDataType.BODY_MASS_INDEX,
//   HealthDataType.BODY_TEMPERATURE,
//   HealthDataType.HEART_RATE,
//   HealthDataType.HEIGHT,
//   HealthDataType.STEPS,
//   HealthDataType.WEIGHT,
//   HealthDataType.MOVE_MINUTES,
//   HealthDataType.DISTANCE_DELTA,
//   HealthDataType.SLEEP_AWAKE,
//   HealthDataType.SLEEP_ASLEEP,
//   HealthDataType.WATER,
// ];

class AppColors {
  AppColors._();

  // Dark Theme colors
  static const Color darkGrey = Color(0xff303041);
  static const Color lightGrey = Color(0xFF3D3A50);
  static const Color white = Color(0xFF0EA2F6);
  static const Color burgundy = Color(0xFF880d1e);
  static const Color spaceCadet = Color(0xFFF4FCFE);

  // Light Theme Colors
  static const Color babyPink = Color(0xFFFECEE9);
  static const Color lavender = Color(0xFFEB9FEF);
  static const Color gunMetal = Color(0xFF545677);
  static const Color spaceBlue = Color(0xFF03254E);
  static const Color darkBlue = Color(0xFF011C27);
}