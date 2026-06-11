import 'package:flutter/cupertino.dart';
import 'package:flutter_band_fit_app/app/routes/app_routes.dart';
import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:flutter_band_fit_app/core/widgets/cupertino_button_widget.dart';
import 'package:flutter_band_fit_app/core/services/activity_service_provider.dart';
import 'package:flutter_band_fit_app/core/widgets/themed_picker_bottom_sheet.dart';
import 'package:flutter_band_fit_app/features/device/presentation/views/add_device.dart';
import 'package:flutter_band_fit_app/features/device/presentation/views/device_settings.dart';
import 'package:flutter_band_fit_app/features/health/presentation/views/apple_google_bind.dart';
import 'package:flutter_band_fit_app/features/profile/presentation/views/profile_update.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/views/details/activities_details.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/views/details/weather_in_details.dart';
import 'package:intl/intl.dart';

class GlobalMethods {
  static void navigateTo(dynamic page) {
    if (page is DeviceSettings) {
      Get.toNamed<void>(AppRoutes.deviceSettings);
      return;
    }
    if (page is AddDevice) {
      Get.toNamed<void>(AppRoutes.addDevice);
      return;
    }
    Get.to<dynamic>(page);
  }

  static void navigatePopBack() {
    Get.back<void>();
  }

  static Future<void> openProfileUpdate({bool fromSettings = true}) async {
    final provider = Get.find<ActivityServiceProvider>();
    await Get.to<void>(
      () => ProfileUpdate(
        key: const Key(WidgetKeys.profileUpdate),
        userFullName: 'User',
        gender: provider.getUserGender,
        height: provider.getUserHeight,
        weight: provider.getUserWeight,
        dob: provider.getUserDOB,
        waist: '',
        bloodGroup: '',
        fromSettings: fromSettings,
      ),
    );
    provider.update();
  }

  static void openHealthBind() {
    Get.to<void>(
      () => AppleGoogleBind(
        key: const Key(WidgetKeys.appleGoogleBind),
        deviceTypeName: Platform.isIOS ? appleHealthKey : googleFitKey,
      ),
    );
  }

  static void showSnackBar() {
    Get.snackbar(
      textBandFit,
      textSyncingDataMsg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.tealAccent,
    );
  }

  static void showDefaultDialog() {
    Get.defaultDialog<void>(
      title: textBandFit,
      middleText: textPleaseWaitMsg,
      textConfirm: okText,
      confirmTextColor: Colors.white,
      textCancel: cancelText,
    );
  }

  static void showMaterialBanner(BuildContext context) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: const Text(textNoWeatherData),
        leading: const Icon(Icons.info_outline),
        padding: const EdgeInsets.all(15),
        backgroundColor: Colors.lightGreenAccent,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(okText),
          ),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
            },
            child: const Text(cancelText),
          ),
        ],
      ),
    );
  }

  //Related to GFit
  static List<DateTime> calReqDataDateTimeList(String lastSyncDate) {
    debugPrintI('lastSyncDate>>> $lastSyncDate');
    // lastSyncDate = '20220224';
    List<DateTime> reqDataDT = [];
    DateTime currDT = DateTime.now();
    var myLastSyncDT = DateTime.parse(lastSyncDate);
    debugPrintI('lastSyncGap>>> ${currDT.difference(myLastSyncDT).inDays}');
    int myLastSuncGap = currDT.difference(myLastSyncDT).inDays;
    // if (myLastSuncGap > 3) {
    //   myLastSuncGap = 3;
    // }
    int i = 0;
    while (i < myLastSuncGap + 1) {
      reqDataDT.add(DateTime(
          currDT.subtract(Duration(days: i)).year,
          currDT.subtract(Duration(days: i)).month,
          currDT.subtract(Duration(days: i)).day));

      // if (i == 0) {
      //   reqDataDT.add(DateTime(currDT.year, currDT.month, currDT.day));
      // } else if (i == 1) {
      //   reqDataDT.add(DateTime(
      //       currDT.subtract(Duration(days: 1)).year,
      //       currDT.subtract(Duration(days: 1)).month,
      //       currDT.subtract(Duration(days: 1)).day));
      // } else if (i == 2) {
      //   reqDataDT.add(DateTime(
      //       currDT.subtract(Duration(days: 2)).year,
      //       currDT.subtract(Duration(days: 2)).month,
      //       currDT.subtract(Duration(days: 2)).day));
      // }
      i++;
    }

    return reqDataDT;
  }

  static String getBPConditions(int systolic, int diastolic) {
    debugPrintI('_mySys>>> $systolic');
    debugPrintI('_myDia>>> $diastolic');
    String myBPCondition = '';
    if ((systolic < 110 || systolic > 140) ||
        (diastolic < 70 || diastolic > 90)) {
      myBPCondition = healthStatusConsultDoctor;
    } else {
      myBPCondition = healthStatusNormal;
    }
    return myBPCondition;
  }

  static String getHeartRateConditions(int todayTotalNoBpm) {
    debugPrintI('todayTotalNoBpm>>> $todayTotalNoBpm');
    String myHRCondition = '';
    if ((todayTotalNoBpm < 60 || todayTotalNoBpm > 85)) {
      myHRCondition = healthStatusConsultDoctor;
    } else {
      myHRCondition = healthStatusNormal;
    }
    return myHRCondition;
  }

  static String getSleepingConditions(int sleepingHr) {
    debugPrintI('sleepingHr>>> $sleepingHr');
    String myCondition = '';
    if ((sleepingHr < 4)) {
      myCondition = healthStatusConsultDoctor;
    } else {
      myCondition = healthStatusNormal;
    }
    return myCondition;
  }

  static String getSpo2Conditions(int spo2Value) {
    debugPrintI('spo2Value>>> $spo2Value');
    String myCondition = '';
    if ((spo2Value < 88)) {
      myCondition = healthStatusConsultDoctor;
    } else {
      myCondition = healthStatusNormal;
    }
    return myCondition;
  }

  static String getTempConditions(int myBodyTemp) {
    debugPrintI('myBodyTemp>>> $myBodyTemp');
    String myHRCondition = '';
    if ((myBodyTemp < 36 || myBodyTemp > 38)) {
      myHRCondition = healthStatusConsultDoctor;
    } else {
      myHRCondition = healthStatusNormal;
    }
    return myHRCondition;
  }

  static MaterialColor getConditionColor(String status) {
    debugPrintI('status>>> $status');
    if (status.trim() == healthStatusConsultDoctor) {
      return Colors.red;
    } else if (status.trim() == healthStatusNormal) {
      return Colors.green;
    }
    return Colors.green;
  }

  // For getting next month
  static DateTime getOneMonthForwardGFit(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month + 1, dateTime.day);
  }

  static int calculateStepDuration(DateTime from, DateTime to) {
    from = DateTime(
        from.year, from.month, from.day, from.hour, from.minute, from.second);
    to = DateTime(to.year, to.month, to.day, to.hour, to.minute, to.second);
    return (to.difference(from).inSeconds);
  }

  /*static List<int> getWeakDayList(int number) {
    List<int> weatherForcastingDaysList=[];
    for(int i=0;i<number;i++) {
      weatherForcastingDaysList.add(DateTime.now().add(Duration(days: i)).day);
    }
    return weatherForcastingDaysList;
  }*/

  static int getAgeFromDOB(String dOB) {
    try {
      DateTime dateOfBirth = DateTime.parse(dOB).toLocal();
      int age = DateTime.now().year - dateOfBirth.year;
      return age;
    } catch (error) {
      debugPrintI("age error $error");
      return 18;
    }
  }

  static Color getColor(dynamic status) {
    if (status.toString().toLowerCase().trim() == 'bmi_under_weight') {
      return Colors.red;
    } else if (status.toString().toLowerCase().trim() == 'bmi_fit') {
      return Colors.green;
    } else if (status.toString().toLowerCase().trim() == 'bmi_over_weight') {
      return Colors.yellow;
    } else if (status.toString().toLowerCase().trim() == 'bmi_obese') {
      return const Color(0xffCA5353);
    }
    return Colors.green;
  }

  static Future<String> selectGoalSteps(
      BuildContext context, String tempSelectedSteps) async {
    debugPrintI('inside goals');
    debugPrintI('tempSelectedSteps>> $tempSelectedSteps');
    // goalTextTitle
    String? selectedSteps = await showThemedPickerBottomSheet<String>(
      context: context,
      height: 310,
      builder: (sheetContext) {
        final itemStyle = themedPickerItemStyle(sheetContext);
        return Column(
          children: <Widget>[
            PickerSheetHeader(
              key: const Key(WidgetKeys.pickerSheetHeader),
              onCancel: GlobalMethods.navigatePopBack,
              onDone: () => Navigator.of(sheetContext).pop(tempSelectedSteps),
            ),
            const Divider(height: 0, thickness: 1),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Center(
                child: Text(
                  goalTextTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(sheetContext).textTheme.titleSmall,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(4.0),
                child: CupertinoPicker(
                  magnification: 2.35 / 2.1,
                  useMagnifier: true,
                  squeeze: 1.25,
                  onSelectedItemChanged: (value) {
                    tempSelectedSteps = totalGoalsList[value].toString();
                  },
                  selectionOverlay:
                      const CupertinoPickerDefaultSelectionOverlay(),
                  backgroundColor: themedPickerBackground(sheetContext),
                  itemExtent: 28,
                  scrollController: FixedExtentScrollController(
                    initialItem: totalGoalsList.indexOf(tempSelectedSteps),
                  ),
                  children: totalGoalsList
                      .map((e) => Text(e, style: itemStyle))
                      .toList(),
                ),
              ),
            ),
          ],
        );
      },
    );

    if (selectedSteps != null && selectedSteps != tempSelectedSteps) {
      return selectedSteps;
    } else {
      return tempSelectedSteps;
    }
  }

  // Find the first date of the week which contains the provided date.
  static DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  // Find last date of the week which contains provided date.
  static DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime
        .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  // Find the first date of the month which contains the provided date.
  static DateTime findFirstDateOfTheMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, 1);
  }

  // Find last date of the month which contains provided date.
  static DateTime findLastDateOfTheMonth(DateTime dateTime) {
    return dateTime.month < 12
        ? DateTime(dateTime.year, dateTime.month + 1, 0)
        : DateTime(dateTime.year + 1, 1, 0);
  }

  // operations for the calender shifts
  static DateTime getOneDayBackward(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day - 1);
  }

  static DateTime getOneDayForward(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day + 1);
  }

  static DateTime getLastDayOfCurrentMonth(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    return lastDayOfMonth;
  }

  static Future<List<DateTime>> findNextSevenWeekDatesListByTime(
      DateTime currentDateTime) async {
    List<DateTime> sevenWeekDays = [];
    //sevenWeekDays.add(DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day));
    int i = 0;
    while (i < 7) {
      sevenWeekDays.add(DateTime(
              currentDateTime.year, currentDateTime.month, currentDateTime.day)
          .add(Duration(days: i)));
      i++;
    }
    debugPrintI('$sevenWeekDays');
    return sevenWeekDays;
  }

  static Future<List<DateTime>> getWeekDatesListByTime(
      DateTime dateTime) async {
    //  debugPrintI('inside>> $dateTime');
    // pass the current date time or past week time
    DateTime firstDate = findFirstDateOfTheWeek(dateTime);
    // debugPrintI('firstDate>> $firstDate');
    DateTime lastDate = findLastDateOfTheWeek(dateTime);
    //  debugPrintI('lastDate>> $lastDate');
    List<DateTime> weekDays = [];
    if (firstDate.day > lastDate.day) {
      //27 > 3
      int i = 0;
      while (i < 7) {
        weekDays
            .add(DateTime(firstDate.year, firstDate.month, firstDate.day + i));
        i++;
      }
    } else {
      for (int i = firstDate.day; i <= lastDate.day; i++) {
        weekDays.add(DateTime(firstDate.year, firstDate.month, i));
      }
    }

    debugPrintI('$weekDays');
    return weekDays;
  }

  static Future<List<DateTime>> getMonthyDatesListByTime(
      DateTime dateTime) async {
    // below code is used for the current month

    // pass the current date time or past week time
    // debugPrintI('inside>> $dateTime');
    // pass the current date time or past week time
    DateTime firstDate = findFirstDateOfTheMonth(dateTime);
    // debugPrintI('firstDate>> $firstDate');
    DateTime lastDate = findLastDateOfTheMonth(dateTime);
    // debugPrintI('lastDate>> $lastDate');

    List<DateTime> monthDays = [];

    for (int i = firstDate.day; i <= lastDate.day; i++) {
      monthDays.add(DateTime(firstDate.year, firstDate.month, i));
    }
    return monthDays;
  }

  /*static List<String> getCurrentDayWeekDates() {
    // var dateFormatTemp = DateFormat("dd-MM-yyyy");
    //DateFormat("dd-MM-yyyy").format(DateTime.now());
    DateTime today = DateTime.now();
    DateTime firstDate = findFirstDateOfTheWeek(today);
    DateTime lastDate = findLastDateOfTheWeek(today);
    // or
    //String date = dateToday.toString().substring(0,10);

    debugPrintI('first date : >> ${firstDate.day}');
    debugPrintI('last date : >> ${lastDate.day}');

    List<String> weekDays = [];

    //var currentDate = DateTime(firstDate.year, 2 );
    for (int i = firstDate.day; i <= lastDate.day; i++) {
      weekDays.add(DateTime(firstDate.year, firstDate.month, i)
          .toString()
          .substring(0, 10)
          .trim());
    }

    debugPrintI('$weekDays');

    List<String> weekDays12 = [];

    DateTime pastNext = DateTime(firstDate.year, firstDate.month, firstDate.day - 1);

    DateTime firstDate12 = findFirstDateOfTheWeek(pastNext);
    DateTime lastDate12 = findLastDateOfTheWeek(pastNext);

    for (int i = firstDate12.day; i <= lastDate12.day; i++) {
      weekDays12.add(DateTime(firstDate12.year, firstDate12.month, i)
          .toString()
          .substring(0, 10)
          .trim());
    }

    debugPrintI('$weekDays12');

    List<String> weekDays23 = [];

    DateTime pastNext12 = DateTime(firstDate12.year, firstDate12.month, firstDate12.day - 1);

    DateTime firstDate23 = findFirstDateOfTheWeek(pastNext12);
    DateTime lastDate23 = findLastDateOfTheWeek(pastNext12);

    for (int i = firstDate23.day; i <= lastDate23.day; i++) {
      weekDays23.add(DateTime(firstDate23.year, firstDate23.month, i)
          .toString()
          .substring(0, 10)
          .trim());
    }

    debugPrintI('$weekDays23');

    return weekDays;
  }*/

  /// Find first date of previous week using a date in current week.
  /// [dateTime] A date in current week.
  DateTime findFirstDateOfPreviousWeek(DateTime dateTime) {
    final DateTime sameWeekDayOfLastWeek =
        dateTime.subtract(const Duration(days: 7));
    return findFirstDateOfTheWeek(sameWeekDayOfLastWeek);
  }

  /// Find last date of previous week using a date in current week.
  /// [dateTime] A date in current week.
  DateTime findLastDateOfPreviousWeek(DateTime dateTime) {
    final DateTime sameWeekDayOfLastWeek =
        dateTime.subtract(const Duration(days: 7));
    return findLastDateOfTheWeek(sameWeekDayOfLastWeek);
  }

  /// Find first date of next week using a date in current week.
  /// [dateTime] A date in current week.
  DateTime findFirstDateOfNextWeek(DateTime dateTime) {
    final DateTime sameWeekDayOfNextWeek =
        dateTime.add(const Duration(days: 7));
    return findFirstDateOfTheWeek(sameWeekDayOfNextWeek);
  }

  /// Find last date of next week using a date in current week.
  /// [dateTime] A date in current week.
  DateTime findLastDateOfNextWeek(DateTime dateTime) {
    final DateTime sameWeekDayOfNextWeek =
        dateTime.add(const Duration(days: 7));
    return findLastDateOfTheWeek(sameWeekDayOfNextWeek);
  }

  // returns string in calender format "20220115"
  static String convertBandReadableCalender(DateTime dateTime) {
    String calenderDate = DateFormat('yyyyMMdd').format(dateTime);
    return calenderDate;
  }

  /// Parses band calendar strings produced by [convertBandReadableCalender].
  static DateTime parseBandReadableCalender(String calender) {
    return DateFormat('yyyyMMdd').parse(calender.trim());
  }

  /// Week range label for detail screens, e.g. "1 June ~ 7 June".
  static String formatWeekTitleFromDate(DateTime dateTime) {
    final weekList = _weekDatesFromTime(dateTime);
    if (weekList.isEmpty) return '';
    return _formatWeekTitleLabel(weekList);
  }

  static List<DateTime> _weekDatesFromTime(DateTime dateTime) {
    final firstDate = findFirstDateOfTheWeek(dateTime);
    final lastDate = findLastDateOfTheWeek(dateTime);
    final weekDays = <DateTime>[];
    if (firstDate.day > lastDate.day) {
      for (var i = 0; i < 7; i++) {
        weekDays.add(
          DateTime(firstDate.year, firstDate.month, firstDate.day + i),
        );
      }
    } else {
      for (var i = firstDate.day; i <= lastDate.day; i++) {
        weekDays.add(DateTime(firstDate.year, firstDate.month, i));
      }
    }
    return weekDays;
  }

  static String _formatWeekTitleLabel(List<DateTime> weekList) {
    try {
      final firstDay = weekList.first.day.toString();
      final lastDay = weekList.last.day.toString();
      final firstMonth = weekList.first.month;
      final lastMonth = weekList.last.month;
      final prevMonth =
          firstMonth == lastMonth ? '' : calMonths[firstMonth - 1];
      final nextMonth = calMonths[lastMonth - 1];
      return '$firstDay $prevMonth ~ $lastDay $nextMonth'.trim();
    } catch (e) {
      debugPrintI('formatWeekTitleLabelExp: $e');
      return '';
    }
  }

  static String formatNumber(int number) {
    var f = NumberFormat("#,###", "en_US");
    return f.format(number);
  }

  static void showAlertDialog(
      BuildContext context, String title, String message) {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  // primary: Color(0xFF6200EE),
                  // primary: Colors.teal,
                  foregroundColor: Colors.teal,
                ),
                // textColor: Color(0xFF6200EE),
                onPressed: () {
                  //Navigator.of(context).pop();
                  GlobalMethods.navigatePopBack();
                },
                child: const Text(okText),
              )
            ],
          );
        });
  }

  static Future<void> showAlertDialogWithFunction(
    BuildContext context,
    String title,
    String message,
    String buttonText,
    Future<void> Function() onPressed,
  ) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          title: Text(title, style: theme.textTheme.titleMedium),
          content: Text(message, style: theme.textTheme.bodyMedium),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext, rootNavigator: true).pop();
                await onPressed();
              },
              child: Text(buttonText),
            ),
          ],
        );
      },
    );
  }

  static Future<DateTime> selectCalenderDate(
      BuildContext context, DateTime tempPickedDate) async {
    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoButtonWidget(
                    title: cancelText,
                    onPressed: () {
                      //Navigator.of(context).pop();
                      GlobalMethods.navigatePopBack();
                    },
                  ),
                  CupertinoButtonWidget(
                    title: doneText,
                    onPressed: () {
                      //Navigator.of(context).pop();
                      Navigator.of(context).pop(tempPickedDate);
                    },
                  ),
                ],
              ),
              const Divider(
                height: 0,
                thickness: 1,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  child: CupertinoDatePicker(
                    initialDateTime: tempPickedDate,
                    maximumDate: DateTime.now(),
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime dateTime) {
                      tempPickedDate = dateTime;
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    if (pickedDate != null && pickedDate != tempPickedDate) {
      return pickedDate;
    } else {
      return tempPickedDate;
    }
  }

  static String getTimeByIntegerMin(int minutes) {
    int hour = minutes ~/ 60;
    int min = minutes % 60;
    //return String.format(Locale.getDefault(), "%02d:%02d", hour, min);
    return '${hour.toString().padLeft(2, "0")}:${min.toString().padLeft(2, "0")}';
  }

  static Future<String> getWeekTitleLabel(
      BuildContext context, List<DateTime> weekList) async {
    return _formatWeekTitleLabel(weekList);
  }

/* static String getTimeByIntegerMin(int minutes) {
    double hour = minutes / 60;
    int min = minutes % 60;
    return String.format(Locale.getDefault(), "%02d:%02d", hour, min);
  }*/

/* "2012-02-27 13:27:00"
  "2012-02-27 13:27:00.123456789z"
  "2012-02-27 13:27:00,123456789z"
  "20120227 13:27:00"
  "20120227T132700"
  "20120227"
  "+20120227"
  "2012-02-27T14Z"
  "2012-02-27T14+00:00"
  "-123450101 00:00:00 Z": in the year -12345.
  "2002-02-27T14:00:00-0500": Same as "2002-02-27T19:00:00Z"*/

/*static Future<String> prepareDirectory(String folderName) async {
    String localPath = (await findLocalPath()) + Platform.pathSeparator + folderName;
    final savedDir = Directory(localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    return localPath;
  }

  static Future<String> findLocalPath() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final savedDir = Directory(directory.path + Platform.pathSeparator + Settings.docty_folder);
    bool dirExists = await savedDir.exists();
    if (!dirExists) {
      savedDir.create();
    }
    return savedDir.path;
  }*/
}

void openStepsDetail() {
  GlobalMethods.navigateTo(
    ActivitiesDetails(
      key: const Key(WidgetKeys.activitiesDetails),
      displayTitle: Activity.steps.name,
      activityLabel: Activity.steps.textLabel,
      stepsView: true,
      calView: false,
      distanceView: false,
    ),
  );
}

void openWeatherDetails() {
  final provider = Get.find<ActivityServiceProvider>();
  final model = provider.weatherReportForDetails();
  if (model == null) {
    Get.snackbar(
      textBandFit,
      textNoWeatherData,
      snackPosition: SnackPosition.BOTTOM,
    );
    return;
  }
  GlobalMethods.navigateTo(WeatherInDetails(
      key: const Key(WidgetKeys.weatherInDetails), weatherModelData: model));
}
