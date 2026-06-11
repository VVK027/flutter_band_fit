import 'package:flutter_band_fit_app/core/exports/vitals_controller_imports.dart';
import 'package:flutter_band_fit_app/features/vitals/domain/repositories/vitals_data_repository.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/mixins/vitals_storage_ready_mixin.dart';

class ActivitiesDetailsController extends GetxController
    with VitalsStorageReadyMixin {
  ActivitiesDetailsController(
      {required this.displayTitle,
      required this.activityLabel,
      required this.stepsView,
      required this.calView,
      required this.distanceView});

  final String displayTitle;
  final String activityLabel;
  final bool stepsView;
  final bool calView;
  final bool distanceView;

  BuildContext get context => Get.context!;

  int selectedPage = 0;

  /// Rebuild scope for D/W/M tab bodies only (not the full scaffold).
  static const chartTabId = 'chartTab';

  void notifyChartTab() => update([chartTabId]);

  final VitalsDataRepository _vitalsDataRepository =
      Get.find<VitalsDataRepository>();

  List<dynamic> overAllStepsData = [];
  int totalTargetedSteps = 0;

  //current day
  DateTime todayTime = DateTime.now();
  DateTime currentDateTime = DateTime.now();
  String dayDateTitle = '';
  bool dayNextDisable = true;
  List<CommonDataResult> stepsDayDataList = [];
  String dayTotalSteps = '0';
  String dayTotalDistance = '0.0';
  String dayTotalCalories = '0.0';

  // current week
  List<DateTime> currentWeekDateTime = [];
  String weekDateTitle = '';
  bool weekNextDisable = true;
  List<WeekStepsData> weekStepsDataList = [];
  String weekTotalSteps = '0';
  String weekTotalDistance = '0.0';
  String weekTotalCalories = '0.0';

  // monthly data
  List<DateTime> currentMonthDateTime = [];
  String monthlyDateTitle = '';
  bool monthNextDisable = true;
  List<MonthStepsData> monthStepsDataList = [];
  String monthTotalSteps = '0';
  String monthTotalDistance = '0.0';
  String monthTotalCalories = '0.0';

  late TooltipBehavior tooltipDayBehavior;
  late TooltipBehavior tooltipWeekBehavior;

  @override
  void onInit() {
    tooltipDayBehavior = TooltipBehavior(enable: true, canShowMarker: false);
    tooltipWeekBehavior =
        TooltipBehavior(enable: true, canShowMarker: false, header: '');
    dayDateTitle = _formatDayTitle(todayTime);
    monthlyDateTitle = _formatMonthTitle(todayTime);
    super.onInit();
    listenForLocalVitalsDataReady(initializeData);
  }

  @override
  void onReady() {
    super.onReady();
    initializeData();
  }

  @override
  void onClose() {
    disposeVitalsStorageReadyListener();
    super.onClose();
  }

  String _formatMonthTitle(DateTime dateTime) {
    return '${calMonths[dateTime.month - 1]} ${dateTime.year}';
  }

  String _formatDayTitle(DateTime dateTime) {
    return '${dateTime.day}, ${calMonths[dateTime.month - 1]} (${calWeeks[dateTime.weekday - 1]})';
  }

  void _reloadStoredStepsData() {
    final stepsData = _vitalsDataRepository.getOverAllStepsData();
    totalTargetedSteps =
        int.tryParse(_vitalsDataRepository.getTargetedSteps()) ?? 0;
    if (stepsData.isEmpty) {
      overAllStepsData = [];
      return;
    }
    overAllStepsData = JsonUtils.asList(jsonDecode(stepsData.toString()));
  }

  Future<void> initializeData() async {
    _reloadStoredStepsData();
    await setCurrentDateTitle(todayTime);
    notifyChartTab();
    //week
    currentWeekDateTime = await GlobalMethods.getWeekDatesListByTime(todayTime);
    await setWeekDateTitle(currentWeekDateTime);
    //month
    currentMonthDateTime =
        await GlobalMethods.getMonthyDatesListByTime(todayTime);
    await setMonthDateTitle(currentMonthDateTime);
    notifyChartTab();
  }

  Future<void> setCurrentDateTitle(DateTime dateTime) async {
    _reloadStoredStepsData();
    dayDateTitle = _formatDayTitle(dateTime);
    notifyChartTab();
    try {
      String calender = GlobalMethods.convertBandReadableCalender(dateTime);
      //List<StepsMainModel> stepsMainModelList = await _activityServiceProvider.getCurrentDaySteps(overAllStepsData, calender);
      List<StepsMainModel> stepsMainModelList = [];
      if (Platform.isIOS) {
        stepsMainModelList = await _vitalsDataRepository
            .getSelectedDayStepsData(overAllStepsData, calender);
      } else {
        stepsMainModelList = await _vitalsDataRepository.getCurrentDaySteps(
            overAllStepsData, calender);
      }

      debugPrintI('stepsMainModelList>>  ${stepsMainModelList.length}');
      if (stepsMainModelList.isNotEmpty) {
        final stepsMainModel = stepsMainModelList[0];
        final stepsDataList = stepsMainModel.dataList;
        final dataRepList = <CommonDataResult>[];
        final totalSteps = double.tryParse(stepsMainModel.steps) ?? 0;
        final totalDistance = double.tryParse(stepsMainModel.distance) ?? 0;
        final totalCalories = double.tryParse(stepsMainModel.calories) ?? 0;

        dayTotalSteps = totalSteps.toInt().toString();
        dayTotalDistance = totalDistance.toStringAsFixed(2);
        dayTotalCalories = totalCalories.toStringAsFixed(2);

        if (stepsDataList.isNotEmpty) {
          for (final element in stepsDataList) {
            final stepValue = double.parse(element.step);
            final times = element.time.split(':');
            final pointTime = DateTime(
              dateTime.year,
              dateTime.month,
              dateTime.day,
              int.tryParse(times[0])!,
              int.tryParse(times[1])!,
            );
            dataRepList.add(
              CommonDataResult(
                time: pointTime,
                dataPoint: stepValue,
                color: stepValue < totalTargetedSteps - 1500
                    ? darkStepsColor
                    : completeColor,
              ),
            );
          }
        } else if (totalSteps > 0) {
          dataRepList.add(
            CommonDataResult(
              time: DateTime(dateTime.year, dateTime.month, dateTime.day, 12),
              dataPoint: totalSteps,
              color: totalSteps < totalTargetedSteps - 1500
                  ? darkStepsColor
                  : completeColor,
            ),
          );
        }
        stepsDayDataList = dataRepList;
        notifyChartTab();
      } else {
        stepsDayDataList = [];
        dayTotalSteps = '0';
        dayTotalDistance = '0.0';
        dayTotalCalories = '0.0';
        notifyChartTab();
      }
    } catch (e) {
      debugPrintI('setStepsTitleException:: $e');
    }
  }

  bool checkNextDayAvailable(DateTime todayTime, DateTime currentDayDateTime) {
    bool tempFlag = false;
    if (todayTime.toString().substring(0, 10).trim() ==
        currentDayDateTime.toString().substring(0, 10).trim()) {
      tempFlag = true;
    }
    return tempFlag;
  }

  Future<void> setWeekDateTitle(List<DateTime> weekList) async {
    _reloadStoredStepsData();
    if (weekList.isNotEmpty) {
      /*String firstDay = weekList[0].day.toString();
      String lastDay = weekList[weekList.length - 1].day.toString();
      // String month = calMonths[weekList[0].month - 1];
      String nextMonth = '';
      String prevMonth = '';
      int firstMonth =  weekList[0].month;
      int lastMonth =  weekList[weekList.length - 1].month;
      if (firstMonth == lastMonth) {
        prevMonth = '';
        nextMonth = Utils.tr(context,calMonths[lastMonth - 1]);
      }else{
        prevMonth = Utils.tr(context,calMonths[firstMonth - 1]);
        nextMonth = Utils.tr(context,calMonths[lastMonth - 1]);
      }
        weekDateTitle = firstDay + ' ' +prevMonth+ ' ~ ' + lastDay + ' ' + nextMonth;
      });*/
      String title = await GlobalMethods.getWeekTitleLabel(context, weekList);

      weekDateTitle = title;
      notifyChartTab();
      List<String> calenderList = [];
      for (var element in weekList) {
        calenderList.add(GlobalMethods.convertBandReadableCalender(element));
      }
      if (Platform.isIOS) {
        if (Get.context == null) return;
        List<dynamic> dataList = [];
        if (context.mounted) {
          dataList = await _vitalsDataRepository.getSelectedRangeStepsData(
              false,
              overAllStepsData,
              calenderList,
              context,
              totalTargetedSteps);
        }
        final weekDataList = List<WeekStepsData>.from(dataList[0] as List);
        final totalSteps = dataList[1] as double;
        final totalDistance = dataList[2] as double;
        final totalCalories = dataList[3] as double;

        if (weekDataList.isNotEmpty) {
          weekStepsDataList = weekDataList;
          weekTotalSteps = totalSteps.toInt().toString();
          weekTotalDistance = totalDistance.toStringAsFixed(2);
          weekTotalCalories = totalCalories.toStringAsFixed(2);
          notifyChartTab();
        } else {
          weekStepsDataList = [];
          weekTotalSteps = '0';
          weekTotalDistance = '0.0';
          weekTotalCalories = '0.0';
          notifyChartTab();
        }
      } else {
        List<StepsMainModel> stepsWeekModelList = await _vitalsDataRepository
            .getStepsBySelectedWeek(overAllStepsData, calenderList);
        debugPrintI('stepsWeekModelList>>  ${stepsWeekModelList.length}');
        if (stepsWeekModelList.isNotEmpty) {
          List<WeekStepsData> weekDataList = [];
          double totalSteps = 0;
          double totalDistance = 0;
          double totalCalories = 0;
          for (var element in stepsWeekModelList) {
            double elementSteps = double.tryParse(element.steps)!;
            totalSteps = totalSteps + elementSteps;
            totalDistance = totalDistance + double.tryParse(element.distance)!;
            totalCalories = totalCalories + double.tryParse(element.calories)!;
            DateTime dateTime = DateTime.tryParse(element.calender)!;
            String week = calWeeks[dateTime.weekday - 1];
            weekDataList.add(WeekStepsData(
                weekName: week,
                dateTime: dateTime,
                dataPoint: elementSteps.toInt(),
                //color: color,
                color: elementSteps.toInt() <
                        totalTargetedSteps * stepsWeekModelList.length
                    ? darkStepsColor
                    : completeColor));
          }
          weekStepsDataList = weekDataList;
          weekTotalSteps = totalSteps.toInt().toString();
          weekTotalDistance = totalDistance.toStringAsFixed(2);
          weekTotalCalories = totalCalories.toStringAsFixed(2);
          notifyChartTab();
        } else {
          weekStepsDataList = [];
          weekTotalSteps = '0';
          weekTotalDistance = '0.0';
          weekTotalCalories = '0.0';
          notifyChartTab();
        }
      }
    } else {
      weekStepsDataList = [];
      weekTotalSteps = '0';
      weekTotalDistance = '0.0';
      weekTotalCalories = '0.0';
      notifyChartTab();
    }
  }

  bool checkNextWeekAvailable(
      DateTime todayTime, List<DateTime> currentWeekDateTime) {
    bool tempFlag = false;
    for (DateTime date in currentWeekDateTime) {
      if (date.toString().substring(0, 10).trim() ==
          todayTime.toString().substring(0, 10).trim()) {
        tempFlag = true;
        break;
      }
    }
    return tempFlag;
  }

  Future<void> setMonthDateTitle(List<DateTime> monthList) async {
    _reloadStoredStepsData();
    if (monthList.isNotEmpty) {
      String year = monthList[0].year.toString();
      //String lastDay = monthList[monthList.length - 1].day.toString();
      // String month = tempCalenderMonth[monthList[0].month - 1];
      String month = calMonths[monthList[0].month - 1];
      monthlyDateTitle = '$month $year';
      //monthlyDateTitle = Utils.tr(context,month) + ' ' + year;
      notifyChartTab();

      List<String> calenderList = [];
      for (var element in monthList) {
        calenderList.add(GlobalMethods.convertBandReadableCalender(element));
      }
      if (Platform.isIOS) {
        List<dynamic> dataList =
            await _vitalsDataRepository.getSelectedRangeStepsData(true,
                overAllStepsData, calenderList, context, totalTargetedSteps);
        final monthDataList = List<MonthStepsData>.from(dataList[0] as List);
        final totalSteps = dataList[1] as double;
        final totalDistance = dataList[2] as double;
        final totalCalories = dataList[3] as double;
        if (monthDataList.isNotEmpty) {
          monthStepsDataList = monthDataList;
          monthTotalSteps = totalSteps.toInt().toString();
          monthTotalDistance = totalDistance.toStringAsFixed(2);
          monthTotalCalories = totalCalories.toStringAsFixed(2);
          notifyChartTab();
        } else {
          monthStepsDataList = [];
          monthTotalSteps = '0';
          monthTotalDistance = '0.0';
          monthTotalCalories = '0.0';
          notifyChartTab();
        }
      } else {
        List<StepsMainModel> stepsMonthModelList = await _vitalsDataRepository
            .getStepsBySelectedWeek(overAllStepsData, calenderList);
        debugPrintI('stepsMonthModelList>>  ${stepsMonthModelList.length}');
        if (stepsMonthModelList.isNotEmpty) {
          List<MonthStepsData> monthDataList = [];
          double totalSteps = 0;
          double totalDistance = 0;
          double totalCalories = 0;
          for (var element in stepsMonthModelList) {
            DateTime dateTime = DateTime.tryParse(element.calender)!;
            double elementSteps = double.tryParse(element.steps)!;
            totalSteps = totalSteps + elementSteps;
            totalDistance = totalDistance + double.tryParse(element.distance)!;
            totalCalories = totalCalories + double.tryParse(element.calories)!;
            monthDataList.add(
              MonthStepsData(
                  dayNumber: dateTime.day,
                  dataPoint: elementSteps.toInt(),
                  color: elementSteps.toInt() >= totalTargetedSteps
                      ? completeColor
                      : darkStepsColor),
              // color: elementSteps.toInt() < totalTargetedSteps - 1000
              //     ? darkStepsColor
              //     : completeColor),
            );
          }

          monthStepsDataList = monthDataList;
          monthTotalSteps = totalSteps.toInt().toString();
          monthTotalDistance = totalDistance.toStringAsFixed(2);
          monthTotalCalories = totalCalories.toStringAsFixed(2);
          notifyChartTab();
        } else {
          monthStepsDataList = [];
          monthTotalSteps = '0';
          monthTotalDistance = '0.0';
          monthTotalCalories = '0.0';
          notifyChartTab();
        }
      }
    } else {
      monthStepsDataList = [];
      monthTotalSteps = '0';
      monthTotalDistance = '0.0';
      monthTotalCalories = '0.0';
      notifyChartTab();
    }
  }

  bool checkNextMonthAvailable(
      DateTime todayTime, List<DateTime> currentMonthDateTime) {
    bool tempFlag = false;
    for (DateTime date in currentMonthDateTime) {
      if (date.toString().substring(0, 10).trim() ==
          todayTime.toString().substring(0, 10).trim()) {
        tempFlag = true;
        break;
      }
    }
    return tempFlag;
  }
}
