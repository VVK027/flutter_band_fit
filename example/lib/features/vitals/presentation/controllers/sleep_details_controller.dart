import 'package:flutter_band_fit_app/core/exports/vitals_imports.dart';
import 'package:flutter_band_fit_app/features/vitals/domain/repositories/vitals_data_repository.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/mixins/vitals_storage_ready_mixin.dart';
class SleepDetailsController extends GetxController with VitalsStorageReadyMixin {
  SleepDetailsController({required this.displayTitle, required this.activityLabel});

  final String displayTitle;
  final String activityLabel;

  BuildContext get context => Get.context!;


  int selectedPage = 0;

  final VitalsDataRepository _vitalsDataRepository = Get.find<VitalsDataRepository>();
  List overAllSleepData = [];

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
  String monthTotalDeepHours = '0',  monthTotalDeepMin = '0';
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

  void _reloadStoredSleepData() {
    final sleepData = _vitalsDataRepository.getOverAllSleepData();
    if (sleepData.isEmpty) {
      overAllSleepData = [];
      return;
    }
    overAllSleepData = jsonDecode(sleepData.toString());
  }

  Future<void> initializeData() async {
    _reloadStoredSleepData();
    update();
    await setCurrentDateTitle(todayTime);
    //week
    currentWeekDateTime = await GlobalMethods.getWeekDatesListByTime(todayTime);
    await setWeekDateTitle(currentWeekDateTime);
    //month
    currentMonthDateTime = await GlobalMethods.getMonthyDatesListByTime(todayTime);
    await setMonthDateTitle(currentMonthDateTime);
    update();
  }

  Future<void> setCurrentDateTitle(DateTime dateTime) async {
    _reloadStoredSleepData();
    dayDateTitle = _formatDayTitle(dateTime);
    update();
    try {
      String calender = GlobalMethods.convertBandReadableCalender(dateTime);
      List<SleepMainModel> sleepMainModelList = [];
      if (Platform.isIOS) {
        sleepMainModelList = await _vitalsDataRepository.getSelectedDaySleepData(overAllSleepData, calender);
      }else{
        sleepMainModelList = await _vitalsDataRepository.getCurrentDaySleepData(overAllSleepData, calender);
      }

      debugPrint('sleepMainModelList>>  ${sleepMainModelList.length}');
      if (sleepMainModelList.isNotEmpty) {
        SleepMainModel sleepMainModel = sleepMainModelList[0];
        debugPrint('sleepMainModel.calender>>  ${sleepMainModel.calender}');
        List<String> total = sleepMainModel.total.split(':');
        List<String> light = sleepMainModel.light.split(':');
        List<String> awake = sleepMainModel.awake.split(':');
        List<String> deep = sleepMainModel.deep.split(':');

        List<String> beginTime = sleepMainModel.beginTime.split(':');
        List<String> endTime = sleepMainModel.endTime.split(':');

        // List<SmartSleepModel> sleepDataList = sleepMainModel.dataList;
        // print("sleepDataList>> ${sleepDataList.length} == ${sleepDataList}");

        int totalNumber = int.tryParse(sleepMainModel.totalNum)!;
        int deepNumber = int.tryParse(sleepMainModel.deepNum)!;
        int awakeNumber = int.tryParse(sleepMainModel.awakeNum)!;
        int lightNumber = int.tryParse(sleepMainModel.lightNum)!;

        //if (sleepDataList.isNotEmpty) {

          //sleepDayDataList = sleepList;
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
          deepPercentage = getCalculatePercentage(deepNumber, totalNumber);
          lightPercentage = getCalculatePercentage(lightNumber, totalNumber);
          awakePercentage = getCalculatePercentage(awakeNumber, totalNumber);
    update();
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
          deepPercentage =0;
          lightPercentage =0;
          awakePercentage =0;
    update();
      }
    } catch (e) {
      debugPrint('setSleepTitleException:: $e');
    }
  }

  int getCalculatePercentage(int obtained, int total) {
    return obtained * 100 ~/ total;
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
    update();
      List<String> calenderList = [];
      for (var element in weekList) {
        calenderList.add(GlobalMethods.convertBandReadableCalender(element));
      }
      if (Platform.isIOS) {
        if (Get.context == null) return;
        List<dynamic> sleepDataList = [];
        if(context.mounted) {
          sleepDataList = await _vitalsDataRepository.getSleepDataSelectedRange(false, overAllSleepData, calenderList, context);
        }
        List<WeeklySleepData> weekDataSleepList = sleepDataList[0];
        int totalHours = sleepDataList[1]; // total
        int totalDeep = sleepDataList[2]; //deep
        int totalAwake = sleepDataList[3]; //awake
        int totalLight = sleepDataList[3]; //light

        if (weekDataSleepList.isNotEmpty) {

          List<String> total = GlobalMethods.getTimeByIntegerMin(totalHours).split(':');
          List<String> deep = GlobalMethods.getTimeByIntegerMin(totalDeep).split(':');
          List<String> light = GlobalMethods.getTimeByIntegerMin(totalLight).split(':');
          List<String> awake = GlobalMethods.getTimeByIntegerMin(totalAwake).split(':');

            weekSleepDataList = weekDataSleepList;
            weekTotalSleepHours = total[0];
            weekTotalSleepMin = total[1];

            weekTotalDeepHours = deep[0];
            weekTotalDeepMin = deep[1];

            weekTotalLightHours = light[0];
            weekTotalLightMin = light[1];

            weekTotalAwakeHours = awake[0];
            weekTotalAwakeMin = awake[1];
    update();

        }
        else{

            weekSleepDataList = [];
            weekTotalSleepHours = '0';
            weekTotalSleepMin = '0';
            weekTotalDeepHours = '0';
            weekTotalDeepMin = '0';
            weekTotalLightHours = '0';
            weekTotalLightMin = '0';
            weekTotalAwakeHours = '0';
            weekTotalAwakeMin = '0';
    update();

        }

      }else{
        List<SleepMainModel> sleepWeekModelList = await _vitalsDataRepository.getSleepBySelectedWeek(overAllSleepData, calenderList);
        debugPrint('sleepWeekModelList>>  ${sleepWeekModelList.length}');
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
            //debugPrint( 'startTimeNum >> ${element.beginTimeNum} --endTimeNum>> ${element.endTimeNum}');
            totalHours = totalHours + int.tryParse(element.totalNum)!;
            totalDeep = totalDeep + int.tryParse(element.deepNum)!;
            totalLight = totalLight + int.tryParse(element.lightNum)!;
            totalAwake = totalAwake + int.tryParse(element.awakeNum)!;
            weekDataList.add(WeeklySleepData(
              weekName: week,
              startTime: DateTime(dateTime.year, dateTime.month, dateTime.day, int.tryParse(beginTime[0])!, int.tryParse(beginTime[1])!),
              endTime: DateTime(dateTime.year, dateTime.month, dateTime.day, int.tryParse(endTime[0])!, int.tryParse(endTime[1])!),
              startTimeNum: int.tryParse(element.beginTimeNum)!,
              endTimeNum: int.tryParse(element.endTimeNum)!,
              //color: inCompletedColor,
              color: sleepLightColor,
            ));
          }

          List<String> total = GlobalMethods.getTimeByIntegerMin(totalHours).split(':');
          List<String> deep = GlobalMethods.getTimeByIntegerMin(totalDeep).split(':');
          List<String> light = GlobalMethods.getTimeByIntegerMin(totalLight).split(':');
          List<String> awake = GlobalMethods.getTimeByIntegerMin(totalAwake).split(':');

            weekSleepDataList = weekDataList;
            weekTotalSleepHours = total[0];
            weekTotalSleepMin = total[1];

            weekTotalDeepHours = deep[0];
            weekTotalDeepMin = deep[1];

            weekTotalLightHours = light[0];
            weekTotalLightMin = light[1];

            weekTotalAwakeHours = awake[0];
            weekTotalAwakeMin = awake[1];
    update();
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
    update();
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
    update();
    }
  }

  bool checkNextWeekAvailable(DateTime todayTime, List<DateTime> currentWeekDateTime) {
    bool tempFlag = false;
    for (DateTime date in currentWeekDateTime) {
      if (date.toString().substring(0, 10).trim() == todayTime.toString().substring(0, 10).trim()) {
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
        monthlyDateTitle =   '$month $year';
    update();

      List<String> calenderList = [];
      for (var element in monthList) {
        calenderList.add(GlobalMethods.convertBandReadableCalender(element));
      }
      if (Platform.isIOS) {
        List<dynamic> sleepDataList = await _vitalsDataRepository.getSleepDataSelectedRange(true, overAllSleepData, calenderList, context);

        List<MonthlySleepData> monthDataList = sleepDataList[0];
        int totalHours = sleepDataList[1]; // total
        int totalDeep = sleepDataList[2]; //deep
        int totalAwake = sleepDataList[3]; //awake
        int totalLight = sleepDataList[3]; //light

        if (monthDataList.isNotEmpty) {
          List<String> total = GlobalMethods.getTimeByIntegerMin(totalHours).split(':');
          List<String> deep = GlobalMethods.getTimeByIntegerMin(totalDeep).split(':');
          List<String> light = GlobalMethods.getTimeByIntegerMin(totalLight).split(':');
          List<String> awake = GlobalMethods.getTimeByIntegerMin(totalAwake).split(':');

            monthSleepDataList = monthDataList;
            monthTotalSleepHours = total[0];
            monthTotalSleepMin = total[1];

            monthTotalDeepHours = deep[0];
            monthTotalDeepMin = deep[1];

            monthTotalLightHours = light[0];
            monthTotalLightMin = light[1];

            monthTotalAwakeHours = awake[0];
            monthTotalAwakeMin = awake[1];
    update();
        }
        else{
            monthSleepDataList = [];
            monthTotalSleepHours = '0';
            monthTotalSleepMin = '0';
            monthTotalDeepHours = '0';
            monthTotalDeepMin = '0';
            monthTotalLightHours = '0';
            monthTotalLightMin = '0';
            monthTotalAwakeHours = '0';
            monthTotalAwakeMin = '0';
    update();
        }
      }else{
        List<SleepMainModel> sleepMonthModelList = await _vitalsDataRepository.getSleepBySelectedWeek(overAllSleepData, calenderList);
        debugPrint('sleepMonthModelList>>  ${sleepMonthModelList.length}');

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
            //debugPrint( 'startTimeNum >> ${element.beginTimeNum} --endTimeNum>> ${element.endTimeNum}');
            totalHours = totalHours + int.tryParse(element.totalNum)!;
            totalDeep = totalDeep + int.tryParse(element.deepNum)!;
            totalLight = totalLight + int.tryParse(element.lightNum)!;
            totalAwake = totalAwake + int.tryParse(element.awakeNum)!;
            monthDataList.add(MonthlySleepData(
              dayNumber: dateTime.day,
              startTime: DateTime(dateTime.year, dateTime.month, dateTime.day, int.tryParse(beginTime[0])!, int.tryParse(beginTime[1])!),
              endTime: DateTime(dateTime.year, dateTime.month, dateTime.day, int.tryParse(endTime[0])!, int.tryParse(endTime[1])!),
              startTimeNum: int.tryParse(element.beginTimeNum)!,
              endTimeNum: int.tryParse(element.endTimeNum)!,
              color: sleepLightColor,
            ));
          }

          List<String> total = GlobalMethods.getTimeByIntegerMin(totalHours).split(':');
          List<String> deep = GlobalMethods.getTimeByIntegerMin(totalDeep).split(':');
          List<String> light = GlobalMethods.getTimeByIntegerMin(totalLight).split(':');
          List<String> awake = GlobalMethods.getTimeByIntegerMin(totalAwake).split(':');

            monthSleepDataList = monthDataList;
            monthTotalSleepHours = total[0];
            monthTotalSleepMin = total[1];

            monthTotalDeepHours = deep[0];
            monthTotalDeepMin = deep[1];

            monthTotalLightHours = light[0];
            monthTotalLightMin = light[1];

            monthTotalAwakeHours = awake[0];
            monthTotalAwakeMin = awake[1];
    update();

        }else{
            monthSleepDataList = [];
            monthTotalSleepHours = '0';
            monthTotalSleepMin = '0';
            monthTotalDeepHours = '0';
            monthTotalDeepMin = '0';
            monthTotalLightHours = '0';
            monthTotalLightMin = '0';
            monthTotalAwakeHours = '0';
            monthTotalAwakeMin = '0';
    update();
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
    update();
    }
  }

  bool checkNextMonthAvailable(DateTime todayTime, List<DateTime> currentMonthDateTime) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: const <Widget>[
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: Text(textSleepQualityAnalysis,//'Sleep Quality Analysis',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(textSleepNotLate,
                // 'Sleep too late',
                // 'Don’t sleep too late',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                sleepToLateString,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 14
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(textSleepLake,//'lack of sleep',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                sleepLackString,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 14
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(textSleepWakeEarly,//'Wake up early',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                sleepEarlyWakeUpString,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 14
                ),
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
