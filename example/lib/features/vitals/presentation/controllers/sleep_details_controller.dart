import 'package:flutter_band_fit_app/core/exports/vitals_controller_imports.dart';
import 'package:flutter_band_fit_app/core/widgets/custom_assets_bar.dart';
import 'package:flutter_band_fit_app/features/vitals/domain/repositories/vitals_data_repository.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/mixins/vitals_storage_ready_mixin.dart';

class SleepDetailsController extends GetxController
    with VitalsStorageReadyMixin {
  SleepDetailsController(
      {required this.displayTitle, required this.activityLabel});

  final String displayTitle;
  final String activityLabel;

  BuildContext get context => Get.context!;

  int selectedPage = 0;

  /// Rebuild scope for D/W/M tab bodies only (not the full scaffold).
  static const chartTabId = 'chartTab';

  void notifyChartTab() => update([chartTabId]);

  final VitalsDataRepository _vitalsDataRepository =
      Get.find<VitalsDataRepository>();
  final ActivityServiceProvider _activityServiceProvider =
      Get.find<ActivityServiceProvider>();
  Worker? _sleepRevisionWorker;
  List<dynamic> overAllSleepData = [];

  //current day
  DateTime todayTime = DateTime.now();
  DateTime currentDateTime = DateTime.now();
  String dayDateTitle = '';
  bool dayNextDisable = true;
  //List<SleepDayDataRep> sleepDayDataList = [];
  String dayTotalHours = '0', dayTotalMin = '0';
  String dayBeginHours = '--', dayBeginMin = '--';
  String dayEndHours = '--', dayEndMin = '--';
  String dayLightHours = '0', dayLightMin = '0';
  String dayAwakeHours = '0', dayAwakeMin = '0';
  String dayDeepHours = '0', dayDeepMin = '0';

  int deepPercentage = 0;
  int lightPercentage = 0;
  int awakePercentage = 0;
  List<BarAsset> daySleepBarAssets = [];

  static const Color _deepSleepBarColor = Color(0xFF7A58C9);
  static const Color _lightSleepBarColor = Color(0xFFC7A9FE);
  static const Color _awakeSleepBarColor = Color(0xFFFF9A42);

  // current week
  List<DateTime> currentWeekDateTime = [];
  String weekDateTitle = '';
  bool weekNextDisable = true;
  List<WeeklySleepData> weekSleepDataList = [];
  String weekTotalSleepHours = '0', weekTotalSleepMin = '0';
  String weekTotalDeepHours = '0', weekTotalDeepMin = '0';
  String weekTotalLightHours = '0', weekTotalLightMin = '0';
  String weekTotalAwakeHours = '0', weekTotalAwakeMin = '0';

  // monthly data
  List<DateTime> currentMonthDateTime = [];
  String monthlyDateTitle = '';
  bool monthNextDisable = true;
  List<MonthlySleepData> monthSleepDataList = [];
  String monthTotalSleepHours = '0', monthTotalSleepMin = '0';
  String monthTotalDeepHours = '0', monthTotalDeepMin = '0';
  String monthTotalLightHours = '0', monthTotalLightMin = '0';
  String monthTotalAwakeHours = '0', monthTotalAwakeMin = '0';

  /* String monthTotalSteps = '0';
  String monthTotalDistance = '0.0';
  String monthTotalCalories = '0.0';*/

  late StateSetter actionState;

  @override
  void onInit() {
    dayDateTitle = _formatDayTitle(todayTime);
    monthlyDateTitle = _formatMonthTitle(todayTime);
    super.onInit();
    listenForLocalVitalsDataReady(initializeData);
    _sleepRevisionWorker = ever(_activityServiceProvider.sleepDataRevision, (_) {
      unawaited(_reloadSleepViews());
    });
  }

  @override
  void onReady() {
    super.onReady();
    initializeData();
  }

  @override
  void onClose() {
    _sleepRevisionWorker?.dispose();
    _sleepRevisionWorker = null;
    disposeVitalsStorageReadyListener();
    super.onClose();
  }

  Future<void> _reloadSleepViews() async {
    _reloadStoredSleepData();
    await setCurrentDateTitle(currentDateTime);
    await setWeekDateTitle(currentWeekDateTime);
    await setMonthDateTitle(currentMonthDateTime);
    notifyChartTab();
  }

  String _formatMonthTitle(DateTime dateTime) {
    return '${calMonths[dateTime.month - 1]} ${dateTime.year}';
  }

  String _formatDayTitle(DateTime dateTime) {
    return '${dateTime.day}, ${calMonths[dateTime.month - 1]} (${calWeeks[dateTime.weekday - 1]})';
  }

  void _reloadStoredSleepData() {
    final sleepData = _vitalsDataRepository.getOverAllSleepData();
    if (sleepData.isEmpty) {
      overAllSleepData = [];
      return;
    }
    overAllSleepData = JsonUtils.asList(jsonDecode(sleepData.toString()));
  }

  Future<void> initializeData() async {
    _reloadStoredSleepData();
    notifyChartTab();
    await setCurrentDateTitle(todayTime);
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
    _reloadStoredSleepData();
    dayDateTitle = _formatDayTitle(dateTime);
    try {
      String calender = GlobalMethods.convertBandReadableCalender(dateTime);
      List<SleepMainModel> sleepMainModelList = [];
      if (Platform.isIOS) {
        sleepMainModelList = await _vitalsDataRepository
            .getSelectedDaySleepData(overAllSleepData, calender);
      } else {
        sleepMainModelList = await _vitalsDataRepository.getCurrentDaySleepData(
            overAllSleepData, calender);
      }

      debugPrintI('sleepMainModelList>>  ${sleepMainModelList.length}');
      if (sleepMainModelList.isNotEmpty) {
        SleepMainModel sleepMainModel =
            _selectSleepDayModel(sleepMainModelList);
        debugPrintI('sleepMainModel.calender>>  ${sleepMainModel.calender}');
        List<String> total = sleepMainModel.total.split(':');
        List<String> light = sleepMainModel.light.split(':');
        List<String> awake = sleepMainModel.awake.split(':');
        List<String> deep = sleepMainModel.deep.split(':');

        List<String> beginTime = sleepMainModel.beginTime.split(':');
        List<String> endTime = sleepMainModel.endTime.split(':');

        // List<SmartSleepModel> sleepDataList = sleepMainModel.dataList;
        // debugPrintI("sleepDataList>> ${sleepDataList.length} == ${sleepDataList}");

        dayTotalHours = total[0];
        dayTotalMin = total[1];
        dayDeepHours = deep[0];
        dayDeepMin = deep[1];
        dayLightHours = light[0];
        dayLightMin = light[1];
        dayAwakeHours = awake[0];
        dayAwakeMin = awake[1];
        dayBeginHours = beginTime[0];
        dayBeginMin = beginTime[1];
        dayEndHours = endTime[0];
        dayEndMin = endTime[1];
        _applySleepDayBarAssets(sleepMainModel);
        notifyChartTab();
        // } else {
        //     //sleepDayDataList = [];
        //     dayTotalHours = '0';
        //     dayTotalMin = '0';
        //     dayDeepHours = '0';
        //     dayDeepMin = '0';
        //     dayLightHours = '0';
        //     dayLightMin = '0';
        //     dayAwakeHours = '0';
        //     dayAwakeMin = '0';
        //     dayBeginHours = '--';
        //     dayBeginMin = '--';
        //     dayEndHours = '--';
        //     dayEndMin = '--';
        //      deepPercentage =0;
        //      lightPercentage =0;
        //      awakePercentage =0;
        //   });
        // }
      } else {
        //sleepDayDataList = [];
        dayTotalHours = '0';
        dayTotalMin = '0';
        dayDeepHours = '0';
        dayDeepMin = '0';
        dayLightHours = '0';
        dayLightMin = '0';
        dayAwakeHours = '0';
        dayAwakeMin = '0';
        dayBeginHours = '--';
        dayBeginMin = '--';
        dayEndHours = '--';
        dayEndMin = '--';
        deepPercentage = 0;
        lightPercentage = 0;
        awakePercentage = 0;
        daySleepBarAssets = [];
        notifyChartTab();
      }
    } catch (e) {
      debugPrintI('setSleepTitleException:: $e');
    }
  }

  int getCalculatePercentage(int obtained, int total) {
    if (total <= 0) {
      return 0;
    }
    return obtained * 100 ~/ total;
  }

  int _minutesFromDuration(String duration) {
    final parts = duration.split(':');
    if (parts.length < 2) {
      return 0;
    }
    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;
    return (hours * 60) + minutes;
  }

  void _applySleepStagePercentages(SleepMainModel sleepMainModel) {
    var totalNumber = int.tryParse(sleepMainModel.totalNum) ?? 0;
    var deepNumber = int.tryParse(sleepMainModel.deepNum) ?? 0;
    var lightNumber = int.tryParse(sleepMainModel.lightNum) ?? 0;
    var awakeNumber = int.tryParse(sleepMainModel.awakeNum) ?? 0;

    if (totalNumber <= 0) {
      totalNumber = _minutesFromDuration(sleepMainModel.total);
      deepNumber = _minutesFromDuration(sleepMainModel.deep);
      lightNumber = _minutesFromDuration(sleepMainModel.light);
      awakeNumber = _minutesFromDuration(sleepMainModel.awake);
    }

    if (totalNumber <= 0) {
      deepPercentage = 0;
      lightPercentage = 0;
      awakePercentage = 0;
      return;
    }

    deepPercentage = getCalculatePercentage(deepNumber, totalNumber);
    lightPercentage = getCalculatePercentage(lightNumber, totalNumber);
    awakePercentage = getCalculatePercentage(awakeNumber, totalNumber);
  }

  Color _sleepStateColor(String state) {
    switch (state) {
      case '0':
        return _deepSleepBarColor;
      case '1':
        return _lightSleepBarColor;
      case '2':
        return _awakeSleepBarColor;
      default:
        return _lightSleepBarColor;
    }
  }

  int _sleepModelCompletenessScore(SleepMainModel model) {
    final totalMinutes = int.tryParse(model.totalNum) ?? 0;
    final fallbackTotal = totalMinutes > 0
        ? totalMinutes
        : _minutesFromDuration(model.total);
    return (model.dataList.length * 1000) + fallbackTotal;
  }

  SleepMainModel _selectSleepDayModel(List<SleepMainModel> models) {
    if (models.length == 1) {
      return models.first;
    }
    return models.reduce(
      (best, current) => _sleepModelCompletenessScore(current) >
              _sleepModelCompletenessScore(best)
          ? current
          : best,
    );
  }

  static const double _sleepBarLimit = 100;

  void _applySleepDayBarAssets(SleepMainModel sleepMainModel) {
    _applySleepStagePercentages(sleepMainModel);

    if (sleepMainModel.dataList.isNotEmpty) {
      final timelineAssets = _normalizeBarAssets(
        _timelineBarAssets(sleepMainModel),
        limit: _sleepBarLimit,
      );
      if (_hasRenderableBarAssets(timelineAssets, limit: _sleepBarLimit)) {
        daySleepBarAssets = timelineAssets;
        return;
      }
    }

    daySleepBarAssets = _normalizeBarAssets(
      [
        BarAsset(
          size: deepPercentage.toDouble(),
          color: _deepSleepBarColor,
        ),
        BarAsset(
          size: lightPercentage.toDouble(),
          color: _lightSleepBarColor,
        ),
        BarAsset(
          size: awakePercentage.toDouble(),
          color: _awakeSleepBarColor,
        ),
      ].where((asset) => asset.size > 0).toList(),
      limit: _sleepBarLimit,
    );
  }

  bool _hasRenderableBarAssets(
    List<BarAsset> assets, {
    required double limit,
  }) {
    if (assets.isEmpty) {
      return false;
    }
    final totalSize = assets.fold<double>(0, (sum, asset) => sum + asset.size);
    return totalSize > 0 && totalSize <= limit;
  }

  List<BarAsset> _normalizeBarAssets(
    List<BarAsset> assets, {
    required double limit,
  }) {
    if (assets.isEmpty) {
      return const [];
    }
    final totalSize = assets.fold<double>(0, (sum, asset) => sum + asset.size);
    if (totalSize <= 0) {
      return const [];
    }
    if (totalSize <= limit) {
      return assets;
    }
    return assets
        .map(
          (asset) => BarAsset(
            size: (asset.size * limit) / totalSize,
            color: asset.color,
          ),
        )
        .toList();
  }

  int _segmentDurationMinutes(int start, int end) {
    if (end > start) {
      return end - start;
    }
    if (end < start) {
      // Segment crosses midnight (e.g. 23:30 -> 01:00).
      return (1440 - start) + end;
    }
    return 0;
  }

  int _sleepWindowMinutes(int beginNum, int endNum) {
    if (endNum > beginNum) {
      return endNum - beginNum;
    }
    if (endNum < beginNum) {
      return (1440 - beginNum) + endNum;
    }
    return 0;
  }

  List<BarAsset> _timelineBarAssets(SleepMainModel model) {
    final beginNum = int.tryParse(model.beginTimeNum) ?? 0;
    final endNum = int.tryParse(model.endTimeNum) ?? 0;
    var totalSpan = _sleepWindowMinutes(beginNum, endNum);

    if (totalSpan <= 0) {
      totalSpan = int.tryParse(model.totalNum) ?? 0;
      if (totalSpan <= 0) {
        totalSpan = _minutesFromDuration(model.total);
      }
    }

    if (totalSpan <= 0) {
      return [];
    }

    final assets = <BarAsset>[];
    for (final segment in model.dataList) {
      final start = int.tryParse(segment.startTimeNum) ?? 0;
      final end = int.tryParse(segment.endTimeNum) ?? 0;
      final duration = _segmentDurationMinutes(start, end);
      if (duration <= 0) {
        continue;
      }
      assets.add(
        BarAsset(
          size: (duration * _sleepBarLimit) / totalSpan,
          color: _sleepStateColor(segment.state),
        ),
      );
    }

    return assets;
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
    _reloadStoredSleepData();
    if (weekList.isNotEmpty) {
      /*String firstDay = weekList[0].day.toString();
      String lastDay = weekList[weekList.length - 1].day.toString();
      String month = calMonths[weekList[0].month - 1];
        weekDateTitle = firstDay + ' ~ ' + lastDay + ' ' + Utils.tr(context,month);
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
        List<dynamic> sleepDataList = [];
        if (context.mounted) {
          sleepDataList = await _vitalsDataRepository.getSleepDataSelectedRange(
              false, overAllSleepData, calenderList, context);
        }
        final weekDataSleepList =
            List<WeeklySleepData>.from(sleepDataList[0] as List);
        final totalHours = sleepDataList[1] as int;
        final totalDeep = sleepDataList[2] as int;
        final totalAwake = sleepDataList[3] as int;
        final totalLight = sleepDataList[3] as int;

        if (weekDataSleepList.isNotEmpty) {
          List<String> total =
              GlobalMethods.getTimeByIntegerMin(totalHours).split(':');
          List<String> deep =
              GlobalMethods.getTimeByIntegerMin(totalDeep).split(':');
          List<String> light =
              GlobalMethods.getTimeByIntegerMin(totalLight).split(':');
          List<String> awake =
              GlobalMethods.getTimeByIntegerMin(totalAwake).split(':');

          weekSleepDataList = weekDataSleepList;
          weekTotalSleepHours = total[0];
          weekTotalSleepMin = total[1];

          weekTotalDeepHours = deep[0];
          weekTotalDeepMin = deep[1];

          weekTotalLightHours = light[0];
          weekTotalLightMin = light[1];

          weekTotalAwakeHours = awake[0];
          weekTotalAwakeMin = awake[1];
          notifyChartTab();
        } else {
          weekSleepDataList = [];
          weekTotalSleepHours = '0';
          weekTotalSleepMin = '0';
          weekTotalDeepHours = '0';
          weekTotalDeepMin = '0';
          weekTotalLightHours = '0';
          weekTotalLightMin = '0';
          weekTotalAwakeHours = '0';
          weekTotalAwakeMin = '0';
          notifyChartTab();
        }
      } else {
        List<SleepMainModel> sleepWeekModelList = await _vitalsDataRepository
            .getSleepBySelectedWeek(overAllSleepData, calenderList);
        debugPrintI('sleepWeekModelList>>  ${sleepWeekModelList.length}');
        if (sleepWeekModelList.isNotEmpty) {
          List<WeeklySleepData> weekDataList = [];

          int totalHours = 0;
          int totalLight = 0;
          int totalAwake = 0;
          int totalDeep = 0;

          for (var element in sleepWeekModelList) {
            DateTime dateTime = DateTime.tryParse(element.calender)!;
            List<String> beginTime = element.beginTime.split(':');
            List<String> endTime = element.endTime.split(':');
            String week = calWeeks[dateTime.weekday - 1];
            //debugPrintI( 'startTimeNum >> ${element.beginTimeNum} --endTimeNum>> ${element.endTimeNum}');
            totalHours = totalHours + int.tryParse(element.totalNum)!;
            totalDeep = totalDeep + int.tryParse(element.deepNum)!;
            totalLight = totalLight + int.tryParse(element.lightNum)!;
            totalAwake = totalAwake + int.tryParse(element.awakeNum)!;
            weekDataList.add(WeeklySleepData(
              weekName: week,
              startTime: DateTime(dateTime.year, dateTime.month, dateTime.day,
                  int.tryParse(beginTime[0])!, int.tryParse(beginTime[1])!),
              endTime: DateTime(dateTime.year, dateTime.month, dateTime.day,
                  int.tryParse(endTime[0])!, int.tryParse(endTime[1])!),
              startTimeNum: int.tryParse(element.beginTimeNum)!,
              endTimeNum: int.tryParse(element.endTimeNum)!,
              //color: inCompletedColor,
              color: sleepLightColor,
            ));
          }

          List<String> total =
              GlobalMethods.getTimeByIntegerMin(totalHours).split(':');
          List<String> deep =
              GlobalMethods.getTimeByIntegerMin(totalDeep).split(':');
          List<String> light =
              GlobalMethods.getTimeByIntegerMin(totalLight).split(':');
          List<String> awake =
              GlobalMethods.getTimeByIntegerMin(totalAwake).split(':');

          weekSleepDataList = weekDataList;
          weekTotalSleepHours = total[0];
          weekTotalSleepMin = total[1];

          weekTotalDeepHours = deep[0];
          weekTotalDeepMin = deep[1];

          weekTotalLightHours = light[0];
          weekTotalLightMin = light[1];

          weekTotalAwakeHours = awake[0];
          weekTotalAwakeMin = awake[1];
          notifyChartTab();
        } else {
          weekSleepDataList = [];
          weekTotalSleepHours = '0';
          weekTotalSleepMin = '0';
          weekTotalDeepHours = '0';
          weekTotalDeepMin = '0';
          weekTotalLightHours = '0';
          weekTotalLightMin = '0';
          weekTotalAwakeHours = '0';
          weekTotalAwakeMin = '0';
          notifyChartTab();
        }
      }
    } else {
      weekSleepDataList = [];
      weekTotalSleepHours = '0';
      weekTotalSleepMin = '0';
      weekTotalDeepHours = '0';
      weekTotalDeepMin = '0';
      weekTotalLightHours = '0';
      weekTotalLightMin = '0';
      weekTotalAwakeHours = '0';
      weekTotalAwakeMin = '0';
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
    _reloadStoredSleepData();
    if (monthList.isNotEmpty) {
      String year = monthList[0].year.toString();
      //String lastDay = monthList[monthList.length - 1].day.toString();
      String month = calMonths[monthList[0].month - 1];
      monthlyDateTitle = '$month $year';
      notifyChartTab();

      List<String> calenderList = [];
      for (var element in monthList) {
        calenderList.add(GlobalMethods.convertBandReadableCalender(element));
      }
      if (Platform.isIOS) {
        List<dynamic> sleepDataList =
            await _vitalsDataRepository.getSleepDataSelectedRange(
                true, overAllSleepData, calenderList, context);

        final monthDataList =
            List<MonthlySleepData>.from(sleepDataList[0] as List);
        final totalHours = sleepDataList[1] as int;
        final totalDeep = sleepDataList[2] as int;
        final totalAwake = sleepDataList[3] as int;
        final totalLight = sleepDataList[3] as int;

        if (monthDataList.isNotEmpty) {
          List<String> total =
              GlobalMethods.getTimeByIntegerMin(totalHours).split(':');
          List<String> deep =
              GlobalMethods.getTimeByIntegerMin(totalDeep).split(':');
          List<String> light =
              GlobalMethods.getTimeByIntegerMin(totalLight).split(':');
          List<String> awake =
              GlobalMethods.getTimeByIntegerMin(totalAwake).split(':');

          monthSleepDataList = monthDataList;
          monthTotalSleepHours = total[0];
          monthTotalSleepMin = total[1];

          monthTotalDeepHours = deep[0];
          monthTotalDeepMin = deep[1];

          monthTotalLightHours = light[0];
          monthTotalLightMin = light[1];

          monthTotalAwakeHours = awake[0];
          monthTotalAwakeMin = awake[1];
          notifyChartTab();
        } else {
          monthSleepDataList = [];
          monthTotalSleepHours = '0';
          monthTotalSleepMin = '0';
          monthTotalDeepHours = '0';
          monthTotalDeepMin = '0';
          monthTotalLightHours = '0';
          monthTotalLightMin = '0';
          monthTotalAwakeHours = '0';
          monthTotalAwakeMin = '0';
          notifyChartTab();
        }
      } else {
        List<SleepMainModel> sleepMonthModelList = await _vitalsDataRepository
            .getSleepBySelectedWeek(overAllSleepData, calenderList);
        debugPrintI('sleepMonthModelList>>  ${sleepMonthModelList.length}');

        if (sleepMonthModelList.isNotEmpty) {
          List<MonthlySleepData> monthDataList = [];

          int totalHours = 0;
          int totalLight = 0;
          int totalAwake = 0;
          int totalDeep = 0;

          for (var element in sleepMonthModelList) {
            DateTime dateTime = DateTime.tryParse(element.calender)!;
            List<String> beginTime = element.beginTime.split(':');
            List<String> endTime = element.endTime.split(':');
            //String week = tempCalenderWeek[dateTime.weekday - 1];
            //debugPrintI( 'startTimeNum >> ${element.beginTimeNum} --endTimeNum>> ${element.endTimeNum}');
            totalHours = totalHours + int.tryParse(element.totalNum)!;
            totalDeep = totalDeep + int.tryParse(element.deepNum)!;
            totalLight = totalLight + int.tryParse(element.lightNum)!;
            totalAwake = totalAwake + int.tryParse(element.awakeNum)!;
            monthDataList.add(MonthlySleepData(
              dayNumber: dateTime.day,
              startTime: DateTime(dateTime.year, dateTime.month, dateTime.day,
                  int.tryParse(beginTime[0])!, int.tryParse(beginTime[1])!),
              endTime: DateTime(dateTime.year, dateTime.month, dateTime.day,
                  int.tryParse(endTime[0])!, int.tryParse(endTime[1])!),
              startTimeNum: int.tryParse(element.beginTimeNum)!,
              endTimeNum: int.tryParse(element.endTimeNum)!,
              color: sleepLightColor,
            ));
          }

          List<String> total =
              GlobalMethods.getTimeByIntegerMin(totalHours).split(':');
          List<String> deep =
              GlobalMethods.getTimeByIntegerMin(totalDeep).split(':');
          List<String> light =
              GlobalMethods.getTimeByIntegerMin(totalLight).split(':');
          List<String> awake =
              GlobalMethods.getTimeByIntegerMin(totalAwake).split(':');

          monthSleepDataList = monthDataList;
          monthTotalSleepHours = total[0];
          monthTotalSleepMin = total[1];

          monthTotalDeepHours = deep[0];
          monthTotalDeepMin = deep[1];

          monthTotalLightHours = light[0];
          monthTotalLightMin = light[1];

          monthTotalAwakeHours = awake[0];
          monthTotalAwakeMin = awake[1];
          notifyChartTab();
        } else {
          monthSleepDataList = [];
          monthTotalSleepHours = '0';
          monthTotalSleepMin = '0';
          monthTotalDeepHours = '0';
          monthTotalDeepMin = '0';
          monthTotalLightHours = '0';
          monthTotalLightMin = '0';
          monthTotalAwakeHours = '0';
          monthTotalAwakeMin = '0';
          notifyChartTab();
        }
      }
    } else {
      monthSleepDataList = [];
      monthTotalSleepHours = '0';
      monthTotalSleepMin = '0';
      monthTotalDeepHours = '0';
      monthTotalDeepMin = '0';
      monthTotalLightHours = '0';
      monthTotalLightMin = '0';
      monthTotalAwakeHours = '0';
      monthTotalAwakeMin = '0';
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

  Widget showSleepInfo(BuildContext buildContext, StateSetter state) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: Text(
                textSleepQualityAnalysis, //'Sleep Quality Analysis',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                textSleepNotLate,
                // 'Sleep too late',
                // 'Don’t sleep too late',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                sleepToLateString,
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                textSleepLake, //'lack of sleep',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                sleepLackString,
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                textSleepWakeEarly, //'Wake up early',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                sleepEarlyWakeUpString,
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
