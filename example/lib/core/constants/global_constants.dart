import 'package:flutter/material.dart';

export 'package:flutter_band_fit_app/app/theme/app_colors.dart' show AppColors;

//Default TargetedSteps
const String defaultTargetedSteps ='8000';

const String defaultDateFormat ='yyyy-MM-dd';
const String defaultDateTimeParseFormat ='yyyy-MM-dd HH:mm';
//const String defaultLastSyncDateTimeFormat ='yyyy-MM-dd hh:mm:ss a';
const String defaultLastSyncDateTimeFormat ='yyyy-MM-dd hh:mm a';

//const Color completeColor = Color(0xFF36688D);
const Color completeColor = Colors.deepPurple;
const Color inCompletedColor = Colors.lightBlueAccent;

const Color deepColor = Color(0xFF6366F1);
const Color lightColor = Color(0xFFA5B4FC);
const Color awakeColor = Color(0xFFF59E0B);

const Color lightStepsColor = Color(0xFF5EEAD4);
const Color darkStepsColor = Color(0xFF0D9488);
const Color calColor = Color(0xFFFBBF24);
const Color sleepLightColor = Color(0xFF818CF8);
const Color sleepDarkColor = Color(0xFF6366F1);
const Color bpColor = Color(0xFFF97316);
const Color heartRateColor = Color(0xFFF43F5E);
const Color temperatureColor = Color(0xFF22C55E);
const Color oxygenColorDark = Color(0xFF0284C7);
const Color oxygenColorLight = Color(0xFF38BDF8);
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
const String hrTimeMinutes ='bpm';

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
const String textSetOptions = 'Set your options';
const String textVersion = 'Version';
const String textBattery = 'Battery';
const String textAppleHealth = 'Apple Health';
const String textGoogleFit = 'Google Fit';
const String textUnlink = 'Unlink';
const String textLink = 'Link';
const String textLinked = 'Linked';
const String textConnect = 'Connect';
const String textSettings = 'Settings';
const String textSave = 'Save';
const String textDownloads = 'Downloads';
const String textDownloadingFile = 'Downloading…';
const String textLightMode = 'Light mode';
const String textDarkMode = 'Dark mode';
const String textAppTitle = 'Band Fit';
const String textMale = 'Male';
const String textFemale = 'Female';
const String textSecondsShort = 'sec';
const String textKcal = 'kcal';
const String textKm = 'km';
const String textBluetoothRequired = 'Bluetooth 4.0 required';
const String textGoal= 'Goal';
const String textSmartProfile= 'Smart Profile';
const String textNoWeatherData = 'Weather data is not available yet. Sync your band or check location permissions.';
const String textRecommendDialFace = 'Recommended';
const String textSearchDialOnline = 'Online';
const String textDialFaces = 'Dial faces';
const String textSynchronizing = 'Synchronizing';
const String textSynchronousDial = 'Sync dial face';
const String textSyncDoneSuccess = 'Sync completed successfully';
const String textDialFacesMsg = 'Customize your watch face to match your style';
const String textNoDevicesConnected = 'No devices are currently connected';
const String textStoragePermission =
    'Storage permission is required for the app to work properly.';

const String reconnectText = 'Reconnect';
const String textDisconnect = 'Disconnect';
const String reconnectingText = 'Reconnecting…';
const String deviceDisconnected = 'Device disconnected';
const String deviceDisconnectedMsg =
    'Your device was disconnected. Tap Reconnect to try again.';
const String deviceDisconnectedReconnectFailedMsg =
    'Your device was disconnected. Tap Reconnect to try again.\n\nOpen device settings and try again.';
const String syncFailed = 'Sync failed';
const String syncFailedMsg = 'Data sync timed out. Please try again.';
const String deviceConnected = 'Your device is connected!';

const String textTime = 'Time';
const String textToday = 'Today';
const String textTodayData = 'Today\'s Data';
const String textDay = 'Day';
const String textWeek = 'Week';
const String textMonth = 'Month';
const String textStart = 'Start';
const String textMeasuring = 'Measuring…';
const String textMeasuringVitalMsg =
    'Keep your device steady while we take a reading';
const String textGender = 'Gender';
const String textHeight = 'Height';
const String textWeight = 'Weight';
const String textDateOfBirth = 'Date of birth';
const String textBMI = 'BMI';
const String textDailyStepsGoal = 'Daily steps goal';
const String textBandScreenOffTime = 'Screen timeout';
const String textSetTemperatureUnit = 'Temperature unit';
const String textRaiseHandActivateLabel = 'Raise wrist to wake display';
const String textRaiseHandActivateMsg = 'Raise your wrist to wake the display';
const String textUpdateInfoMsg = 'Please update the following information';

const String textStartTime = 'Start time';
const String textEndTime = 'End time';
const String textBegin = 'Begin';
const String textEnd = 'End';
const String textDeep = 'Deep';
const String textLight = 'Light';
const String textAwake = 'Awake';
const String textSelectStartTime = 'Select start time';
const String textSelectEndTime = 'Select end time';
const String textSyncNow = 'Sync now';
const String textHeartRate = 'Heart rate';
const String textSleepDuration = 'Sleep duration';
const String textTotalSleepHours = 'Total sleep';
const String textDeepHours = 'Deep sleep';
const String textLightHours = 'Light sleep';
const String textAwakeHours = 'Awake time';
const String textTotalHours = 'Total time';
const String textBP = 'BP';
const String textSpo2 = 'SpO₂';
const String textTemperature = 'Temperature';
const String textLastSynced = 'Last synced';
const String textLastSyncedNoData = 'No data has been synced yet';
const String textSyncingDataMsg = 'Please wait while we sync your data';
const String textPleaseWait = 'Please wait';
const String textPleaseWaitMsg = 'Syncing your data. Please wait…';
const String textPhysicalActivities = 'Activities';
const String textSteps = 'Steps';
const String textTotalSteps = 'Total steps';
const String textCalories = 'Calories';
const String textDistance = 'Distance';
const String textWeather = 'Weather';
const String textSaveContinue = 'Save and continue';
const String textUpdatedTo = 'Updated on';
const String textHumidity = 'Humidity';
const String textWindSpeed = 'Wind speed';
const String textUVIndex = 'UV index';
const String textSomethingWrong =
    'Something went wrong. Please try again later.';
const String textNeedProfileUpdate = 'Profile update required';
const String textConfigureMonitoring =
    'Configure your monitoring options below';
const String textMonitoringOptions = 'Monitoring options';
const String textMonitoringOptionsMsg =
    'Choose how your band collects health data';
const String textHeartRateMonitoring = 'Heart rate monitoring';
const String text24HrHeartRateTest = 'Automatic heart rate every 24 hours';
const String text24HrTempTest = 'Automatic body temperature every 24 hours';
const String text24HrOxygen = 'Automatic blood oxygen every 24 hours';
const String textBodyTemperatureMonitoring = 'Body temperature monitoring';
const String textBodyOxygenMonitoring = 'Blood oxygen monitoring';
const String textHighPressure = 'Systolic';
const String textLowPressure = 'Diastolic';
const String textDoNotDisturb = 'Do not disturb';
const String textDoNotDisturbMsg =
    'Choose when you want your band to stay quiet.';
const String textListenVibrate = 'Listen for your band';
const String textListenVibrateMsg =
    'Your band will vibrate three times. Listen to locate it.';
const String textFindBand = 'Find your band';
const String textFindBandMsg =
    'Your band will vibrate three times to help you find it';
const String textAverageHR = 'Average heart rate';
const String textMinHR = 'Minimum heart rate';
const String textMaxHR = 'Maximum heart rate';
const String textMinOxygen = 'Minimum SpO₂';
const String textMaxOxygen = 'Maximum SpO₂';
const String textDoNotDisturbLabel =
    'Keep your band quiet (screen, messages, and vibration)—for example, while you sleep';
const String textDNDTimeMsg =
    'Do Not Disturb will be active during the times below';
const String textDNDAdditionalMsg =
    'You can also configure these options during Do Not Disturb';
const String textDNDDisableReminder = 'Disable message reminders';
const String textDNDDisableReminderMsg =
    'Messages will not be sent to your band during this period';
const String textDNDDisableBandVibration = 'Disable band vibration';
const String textDNDDisableBandVibrationMsg =
    'This also disables Find Band';
const String textSelSameTimings = 'Same start and end time';
const String textSelSameTimingsMsg =
    "Start time and end time can't be the same. Please choose different times.";
const String textInvalidTimePeriod = 'Invalid time period';
const String textInvalidTimePeriodMsg =
    'End time must be after start time. Please choose a valid time range.';
const String textDNDStatus = 'Do Not Disturb updated';
const String textDNDStatusMsg = 'Do Not Disturb settings have been updated.';
const String textSleepQualityAnalysis = 'Sleep quality';
const String textSleepNotLate = 'Don\'t sleep too late';
const String textSleepLake = 'Lack of sleep';
const String textSleepWakeEarly = 'Wake up early';
const String textMinTemperature = 'Minimum body temperature';
const String textMaxTemperature = 'Maximum body temperature';
const String textRecentTemperature = 'Latest temperature';
const String textTempNotSupported = 'Temperature not supported';
const String textTempNotSupportedMsg =
    'Your device does not support temperature measurement.';



//const String okTextStr = 'OK';
//const String tempString = 'The normal body temperature of the human body averages between 36~37°C (96.8~98.6°F). The body temperature changes physiologically within a day, which can vary with day and night, age, gender, activity, medicine etc. Physiological changes occur,but the range of changes is very small.';
const String tempString = 'Our normal body temperature averages between 36 - 37 °C (96.8 - 98.6 °F). On a daily basis, the human body sees slight changes in body temperature depending on the time of day, age, gender, activity, etc.';

//const String tempDisclaimer = 'Declaration: All data or results are for reference only,and it is not recommended as a formal basis for medical or health conditions.';
const String tempDisclaimer =
    'Disclaimer: All data and readings are for reference only. They are not medical measurements and should not be used to diagnose or treat any health condition.';

//const String sleepToLateString = '''The best time to fall asleep before 22 o'clock,long-term stay up late may make the body's immune system decreased,accelerated aging.''';
const String sleepToLateString = '''Sleeping on time (best before 22:00) is a healthy habit. It keeps the body’s immune system balanced.''';

const String sleepEarlyWakeUpString =
    '''After a good night’s rest, waking up early helps you feel refreshed and ready for the day.''';

const String sleepLackString =
    '''Most adults need 7 to 9 hours of sleep per night. Too little sleep can weaken your immune system and leave you feeling sluggish.''';

//const String addSmartWatchText = 'Add a Smart watch to get to know more about your health information.';
const String addSmartWatchText =
    'Add your wearable band to view your health readings and insights';

//const String goalTextTitle = "According to the WHO recommendations, you need at least 150 minutes a week moderate aerobic activity which is equivalent to at least 8000 per day.";
const String goalTextTitle =
    'The World Health Organization recommends at least 8,000 steps per day to stay active.\nSelect your daily goal.';


const String raiseHandWakeUpText = 'The device lights up automatically when you raise your hand.';



const String noDeviceFoundHead = 'No device found';
const String textBluetooth = 'Bluetooth';
const String textAddDevice = 'Add Device';
const String bleNotConnected = 'Turn on Bluetooth to search for devices.';
const String bleNotSupported =
    "Your phone's Bluetooth version is too low. This app requires Bluetooth 4.0 or later.";
const String noDeviceFoundMessage = 'Connect your band to get started';
const String textNoDeviceMsg = 'No devices found. Tap Refresh to search again.';
const String textSearchingDevice = 'Searching for nearby bands…';
const String textConnectingDevice = 'Connecting to your band';
const String textConnectingDeviceMsg = 'Please wait while we pair your device';
const String textConnectionFailed = 'Connection failed';
const String textConnectionFailedMsg =
    'Something went wrong. Refresh the page and try again.';
const String textChooseSmartBand = 'Choose your band';
const String textChooseSmartBandMsg = 'Select your band from the list below';

const String textFirmwareUpgrade = 'Firmware upgrade';
const String textNewestVersion = 'Latest version';
const String textCheckForUpdates = 'Check for updates';
const String textSmartReminders = 'Smart reminders';
const String textSmartRemindersSubtitle =
    'Get band alerts for inactivity, text messages, and calls.';
const String textSmartBandReminders = 'Band reminders';
const String textSecondaryReminder = 'Inactivity reminder';
const String textSecondaryReminderMsg =
    'If you have been inactive for a while, your band vibrates to remind you to move.';
const String textSmsReminder = 'SMS reminder';
const String textSmsReminderMsg =
    'When your phone receives a text message, your band vibrates to alert you.';
const String textCallReminder = 'Call reminder';
const String textCallReminderMsg =
    'When your phone has an incoming call, your band vibrates to alert you.';
const String textBluetoothReminderNotice =
    'Your phone must stay connected to your band. Keep Bluetooth turned on.';
const String textNoOnlineDialFaces =
    'No online dial faces found for your device';
const String textNoDialFacesAvailable = 'No dial faces available';
const String textLoadMore = 'Load more';
const String healthStatusNormal = 'Normal';
const String healthStatusConsultDoctor = 'Consult your doctor';


// const String secondaryReminderMsg = 'In case of continuous time without exercise, the device will vibrate for reminding';
// const String smsReminderMsg = 'The phone needs to be connected to the device, do not turn off Bluetooth';
// const String callReminderMsg = 'The phone needs to be connected to the device, do not turn off Bluetooth';


enum Activity { steps, cal, distance, heartRate, bp, oxygen, temperature, sleepDuration }

extension ActivityExtension on Activity {
  String get name {
    return [
      'Steps',
      'Calories burned',
      'Distance',
      'Heart rate',
      'Blood pressure',
      'SpO₂',
      'Temperature',
      'Sleep duration',
    ][index];
  }
}

extension ActivityTextLabel on Activity {
   String get textLabel {
    return [
      'Steps show how much you move each day and help you spot changes in your activity.',
      'Your body burns calories at rest and during activity. This is an estimate of your total daily burn.',
      'Distance helps you track progress in walking, running, and other activities.',
      'Heart rate is measured in beats per minute (bpm). It often rises with activity, stress, or excitement.',
      'Blood pressure is measured in millimetres of mercury (mmHg). Systolic and diastolic readings reflect heart health.',
      'Blood oxygen (SpO₂) is the percentage of oxygen in your blood. It fuels physical and mental activity.',
      'Body temperature varies slightly through the day and may change more when you are unwell.',
      'Sleep duration is your total time asleep each night. Most healthy adults need 7 to 9 hours.',
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
