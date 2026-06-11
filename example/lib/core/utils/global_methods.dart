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

  // returns string in calender format "20220115"
  static String convertBandReadableCalender(DateTime dateTime) {
    String calenderDate = DateFormat('yyyyMMdd').format(dateTime);
    return calenderDate;
  }

  /// Parses band calendar strings produced by [convertBandReadableCalender].
  static DateTime parseBandReadableCalender(String calender) {
    return DateFormat('yyyyMMdd').parse(calender.trim());
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
