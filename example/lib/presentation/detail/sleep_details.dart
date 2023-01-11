import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SleepDetails extends StatefulWidget {
  final String displayTitle;
  final String activityLabel;

  const SleepDetails({Key? key, required this.displayTitle, required this.activityLabel}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SleepDetailsState();
  }
}

class SleepDetailsState extends State<SleepDetails> {
  int selectedPage = 0;
  
   final  _activityServiceProvider = Get.put(ActivityServiceProvider());
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

 // TooltipBehavior _tooltipDayBehavior;
  late TooltipBehavior _tooltipWeekBehavior;

  late StateSetter actionState;

  @override
  void initState() {
  // _activityServiceProvider = Provider.of<ActivityServiceProvider>(context, listen: false);
    //_tooltipDayBehavior = TooltipBehavior(enable: true, canShowMarker: false);
    _tooltipWeekBehavior = TooltipBehavior(
        enable: true,
        canShowMarker: false,
        header: '',
        activationMode: ActivationMode.singleTap,
      //textStyle: TextStyle( color: Colors.white, fontSize: 8.0),
      builder: (data, point, series, pointIndex, seriesIndex) {
       // WeeklySleepData dataRep = data;
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
           /* Container(
              padding: EdgeInsets.all(2.0),
              child: Text(new DateFormat('yyyy-MM-dd').format(dataRep.startTime) ,style: TextStyle( color: Colors.white, fontSize: 8.0),),
            ),
            Text('----------' ,style: TextStyle( color: Colors.white, fontSize: 8.0),),*/
            Container(
                padding: const EdgeInsets.all(4.0),
                child: Text('${DateFormat('yyyy-MM-dd').format(data.startTime)}\nStart Time: ${GlobalMethods.getTimeByIntegerMin(data.startTimeNum)}\nEnd Time: ${GlobalMethods.getTimeByIntegerMin(data.endTimeNum)}',
                  style: const TextStyle( color: Colors.white, fontSize: 8.0),
                  textAlign: TextAlign.center,
                )
            ),
          ],
        );
      },
    );
    super.initState();
    Future.delayed(Duration.zero, () {
       initializeData();
    });
    //initializeData();
  }

  Future<void> initializeData() async {
    String sleepData = _activityServiceProvider.getOverAllSleepData;
    setState(() {
      if (sleepData != null && sleepData.isNotEmpty) {
        overAllSleepData = jsonDecode(sleepData.toString());
      }
    });
    await setCurrentDateTitle(todayTime);
    //week
    currentWeekDateTime = await GlobalMethods.getWeekDatesListByTime(todayTime);
    await setWeekDateTitle(currentWeekDateTime);
    //month
    currentMonthDateTime = await GlobalMethods.getMonthyDatesListByTime(todayTime);
    await setMonthDateTitle(currentMonthDateTime);
  }

  Future<void> setCurrentDateTitle(DateTime dateTime) async {
    String firstDay = dateTime.day.toString();
    String month = calMonths[dateTime.month - 1];
    String week = calWeeks[dateTime.weekday - 1];
    setState(() {
      dayDateTitle = '$firstDay, $month ($week)';
    });
    try {
      String calender = GlobalMethods.convertBandReadableCalender(dateTime);
      if (overAllSleepData != null) {
        List<SleepMainModel> sleepMainModelList = [];
        if (Platform.isIOS) {
          sleepMainModelList = await _activityServiceProvider.getSelectedDaySleepData(overAllSleepData, calender);
        }else{
          sleepMainModelList = await _activityServiceProvider.getCurrentDaySleepData(overAllSleepData, calender);
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

            setState(() {
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
            });
          // } else {
          //   setState(() {
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
          setState(() {
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
          });
        }
      } else {
        setState(() {
         // sleepDayDataList = [];
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
        });
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
    if (weekList.isNotEmpty) {
      /*String firstDay = weekList[0].day.toString();
      String lastDay = weekList[weekList.length - 1].day.toString();
      String month = calMonths[weekList[0].month - 1];
      setState(() {
        weekDateTitle = firstDay + ' ~ ' + lastDay + ' ' + Utils.tr(context,month);
      });*/
      String title = await GlobalMethods.getWeekTitleLabel(context, weekList);
      setState(() {
        weekDateTitle = title;
      });
      List<String> calenderList = [];
      for (var element in weekList) {
        calenderList.add(GlobalMethods.convertBandReadableCalender(element));
      }
      if (Platform.isIOS) {
        List<dynamic> sleepDataList = await _activityServiceProvider.getSleepDataSelectedRange(false, overAllSleepData, calenderList, context);

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

          setState(() {
            weekSleepDataList = weekDataSleepList;
            weekTotalSleepHours = total[0];
            weekTotalSleepMin = total[1];

            weekTotalDeepHours = deep[0];
            weekTotalDeepMin = deep[1];

            weekTotalLightHours = light[0];
            weekTotalLightMin = light[1];

            weekTotalAwakeHours = awake[0];
            weekTotalAwakeMin = awake[1];
          });

        }
        else{

          setState(() {
            weekSleepDataList = [];
            weekTotalSleepHours = '0';
            weekTotalSleepMin = '0';
            weekTotalDeepHours = '0';
            weekTotalDeepMin = '0';
            weekTotalLightHours = '0';
            weekTotalLightMin = '0';
            weekTotalAwakeHours = '0';
            weekTotalAwakeMin = '0';
          });

        }

      }else{
        List<SleepMainModel> sleepWeekModelList = await _activityServiceProvider.getSleepBySelectedWeek(overAllSleepData, calenderList);
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

          setState(() {
            weekSleepDataList = weekDataList;
            weekTotalSleepHours = total[0];
            weekTotalSleepMin = total[1];

            weekTotalDeepHours = deep[0];
            weekTotalDeepMin = deep[1];

            weekTotalLightHours = light[0];
            weekTotalLightMin = light[1];

            weekTotalAwakeHours = awake[0];
            weekTotalAwakeMin = awake[1];
          });
        } else {
          setState(() {
            weekSleepDataList = [];
            weekTotalSleepHours = '0';
            weekTotalSleepMin = '0';
            weekTotalDeepHours = '0';
            weekTotalDeepMin = '0';
            weekTotalLightHours = '0';
            weekTotalLightMin = '0';
            weekTotalAwakeHours = '0';
            weekTotalAwakeMin = '0';
          });
        }
      }
    } else {
      setState(() {
        weekSleepDataList = [];
        weekTotalSleepHours = '0';
        weekTotalSleepMin = '0';
        weekTotalDeepHours = '0';
        weekTotalDeepMin = '0';
        weekTotalLightHours = '0';
        weekTotalLightMin = '0';
        weekTotalAwakeHours = '0';
        weekTotalAwakeMin = '0';
      });
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
    if (monthList.isNotEmpty) {
      String year = monthList[0].year.toString();
      //String lastDay = monthList[monthList.length - 1].day.toString();
      String month = calMonths[monthList[0].month - 1];
      setState(() {
        monthlyDateTitle =   '$month $year';
      });

      List<String> calenderList = [];
      for (var element in monthList) {
        calenderList.add(GlobalMethods.convertBandReadableCalender(element));
      }
      if (Platform.isIOS) {
        List<dynamic> sleepDataList = await _activityServiceProvider.getSleepDataSelectedRange(true, overAllSleepData, calenderList, context);

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

          setState(() {
            monthSleepDataList = monthDataList;
            monthTotalSleepHours = total[0];
            monthTotalSleepMin = total[1];

            monthTotalDeepHours = deep[0];
            monthTotalDeepMin = deep[1];

            monthTotalLightHours = light[0];
            monthTotalLightMin = light[1];

            monthTotalAwakeHours = awake[0];
            monthTotalAwakeMin = awake[1];
          });
        }
        else{
          setState(() {
            monthSleepDataList = [];
            monthTotalSleepHours = '0';
            monthTotalSleepMin = '0';
            monthTotalDeepHours = '0';
            monthTotalDeepMin = '0';
            monthTotalLightHours = '0';
            monthTotalLightMin = '0';
            monthTotalAwakeHours = '0';
            monthTotalAwakeMin = '0';
          });
        }
      }else{
        List<SleepMainModel> sleepMonthModelList = await _activityServiceProvider.getSleepBySelectedWeek(overAllSleepData, calenderList);
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

          setState(() {
            monthSleepDataList = monthDataList;
            monthTotalSleepHours = total[0];
            monthTotalSleepMin = total[1];

            monthTotalDeepHours = deep[0];
            monthTotalDeepMin = deep[1];

            monthTotalLightHours = light[0];
            monthTotalLightMin = light[1];

            monthTotalAwakeHours = awake[0];
            monthTotalAwakeMin = awake[1];
          });

        }else{
          setState(() {
            monthSleepDataList = [];
            monthTotalSleepHours = '0';
            monthTotalSleepMin = '0';
            monthTotalDeepHours = '0';
            monthTotalDeepMin = '0';
            monthTotalLightHours = '0';
            monthTotalLightMin = '0';
            monthTotalAwakeHours = '0';
            monthTotalAwakeMin = '0';
          });
        }
      }
    } else {
      setState(() {
        monthSleepDataList = [];
        monthTotalSleepHours = '0';
        monthTotalSleepMin = '0';
        monthTotalDeepHours = '0';
        monthTotalDeepMin = '0';
        monthTotalLightHours = '0';
        monthTotalLightMin = '0';
        monthTotalAwakeHours = '0';
        monthTotalAwakeMin = '0';
      });
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          //backgroundColor: Colors.white,
          backgroundColor: sleepLightColor,
          elevation: 2,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          //iconTheme: IconThemeData(color: Colors.white),
          title: Text(widget.displayTitle,
            style: const TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            //labelColor: Colors.blueGrey,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)), color: Colors.white),
            tabs: buildDWMTabs(),
            onTap: (value) async{
              //Utils.showWaiting(context, false);
              debugPrint('Pressed $value');
              setState(() {
                selectedPage = value;
              });
              //Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 4.0, right: 4.0, top: 8.0),
              //margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
              padding: const EdgeInsets.all(4.0),
              child: Center(child: Text(widget.activityLabel, textAlign: TextAlign.center)),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  dayChartView(),
                  weekChartView(),
                  monthlyChartView(),
                ],
              ),
            ),
            const SizedBox(
              height: 2.0,
            ),

            //loadBottomView(selectedPage)
            //loadBottomView(selectedPage)
          ],
        ),
      ),
    );
  }

  Widget monthlyChartView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          // margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
          // padding: EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 18,
                onPressed: () async {
                  // debugPrint('date time>> ${currentMonthDateTime[0]}');
                  //Utils.showWaiting(context, false);
                  DateTime time = GlobalMethods.getOneDayBackward(currentMonthDateTime[0]);
                  List<DateTime> pastNextMonth = await GlobalMethods.getMonthyDatesListByTime(time);

                  setState(() {
                    monthNextDisable = false;
                    currentMonthDateTime = pastNextMonth;
                  });

                  await setMonthDateTitle(currentMonthDateTime);
                  //Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
              ),
              Center(
                  child: Text(monthlyDateTitle,
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w600))),
              IconButton(
                iconSize: 18,
                onPressed: monthNextDisable
                    ? null
                    : () async {
                        //Utils.showWaiting(context, false);
                        DateTime time = GlobalMethods.getOneDayForward(currentMonthDateTime[currentMonthDateTime.length - 1]);
                        List<DateTime> nextMonth = await GlobalMethods.getMonthyDatesListByTime(time);

                        setState(() {
                          currentMonthDateTime = nextMonth;
                          // if the today time is in the list then disable.
                          if (checkNextMonthAvailable(todayTime, currentMonthDateTime)) {
                            monthNextDisable = true;
                          }
                        });
                        await setMonthDateTitle(currentMonthDateTime);
                       // Navigator.pop(context);
                      },
                icon: Icon(Icons.arrow_forward_ios_outlined,
                    color: monthNextDisable
                        ? Colors.grey.withOpacity(0.5)
                        : Colors.black),
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
          padding: const EdgeInsets.all(4.0),
          width: double.infinity,
          height: 200,
          child: SfCartesianChart(
            plotAreaBorderWidth: 0,
            primaryXAxis: CategoryAxis(
              majorGridLines: const MajorGridLines(width: 0),
              majorTickLines: const MajorTickLines(size: 4),
              interval: 2,
              labelIntersectAction: AxisLabelIntersectAction.rotate90,
            ),
            primaryYAxis: NumericAxis(
              majorTickLines: const MajorTickLines(color: Colors.transparent),
              axisLabelFormatter: (axisLabelRenderArgs) {
                //debugPrint('axisLabelRenderArgs>> $axisLabelRenderArgs');
                return ChartAxisLabel(
                    GlobalMethods.getTimeByIntegerMin(axisLabelRenderArgs.value.toInt()),
                    const TextStyle(
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        fontSize: 12)
                );
              },
              //labelFormat: '{value}',
              //minimum: 0,
              //maximum: 25,
              //interval: 5,
              minimum: 0, //1,080
              maximum: 1440, //660 + 1day (1440)
              interval: 480,
              axisLine: const AxisLine(width: 0),
            ),
            tooltipBehavior: _tooltipWeekBehavior,
            series: getMonthlySeriesDataList(currentMonthDateTime),
          ),
        ),
        const SizedBox(
          height: 2.0,
        ),
        Expanded(
          child: GridView.extent(
            // crossAxisSpacing: 5,
            // mainAxisSpacing: 5,
            padding: const EdgeInsets.all(2.0),
            maxCrossAxisExtent: 250,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            //crossAxisCount: 2,
            childAspectRatio: (2 / 1),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            /* gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
             crossAxisCount: 3,
             crossAxisSpacing: 5.0,
             mainAxisSpacing: 5.0,
           ),*/
            // maxCrossAxisExtent: 2.0,
            children: [
              Card(
                child: Container(
                  // padding: EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.asset(
                          'assets/fit/sleep_duration.png',
                          width: 60.0,
                          height: 60.0,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text(textTotalSleepHours,//'Total Hours',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 18),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('$monthTotalSleepHours ', textAlign: TextAlign.center,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
                                  const Text('h', textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                                  Text('$monthTotalSleepMin ', textAlign: TextAlign.center,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
                                  const Text('m', textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.white70, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Card(
                child: Container(
                  // padding: EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.asset(
                          'assets/fit/sleep_deep.png',
                          width: 60.0,
                          height: 60.0,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text(textDeepHours,//'Deep Hours',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 18),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('$monthTotalDeepHours ', textAlign: TextAlign.center,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
                                  const Text('h', textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                                  Text('$monthTotalDeepMin ', textAlign: TextAlign.center,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
                                  const Text('m', textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.white70, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Card(
                child: Container(
                  // padding: EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.asset(
                          'assets/fit/sleep_light.png',
                          width: 60.0,
                          height: 60.0,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text(textLightHours,//'Light Hours',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 18),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('$monthTotalLightHours ', textAlign: TextAlign.center,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
                                  const Text('h', textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                                  Text('$monthTotalLightMin ', textAlign: TextAlign.center,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
                                  const Text('m', textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.white70, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Card(
                child: Container(
                  // padding: EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.asset(
                          'assets/fit/sleep_awake.png',
                          width: 60.0,
                          height: 60.0,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text(textAwakeHours,//'Awake Hours',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 18),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('$monthTotalAwakeHours ', textAlign: TextAlign.center,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
                                  const Text('h', textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                                  Text('$monthTotalAwakeMin ', textAlign: TextAlign.center,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
                                  const Text('m', textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.white70, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget weekChartView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          // margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
          // padding: EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 18,
                onPressed: () async {
                  // debugPrint('date time>> ${currentWeekDateTime[0]}');
                  //Utils.showWaiting(context, false);
                  DateTime time = GlobalMethods.getOneDayBackward(currentWeekDateTime[0]);
                  List<DateTime> pastNextWeek = await GlobalMethods.getWeekDatesListByTime(time);
                  setState(() {
                    weekNextDisable = false;
                    currentWeekDateTime = pastNextWeek;
                  });
                  await setWeekDateTitle(currentWeekDateTime);
                  //Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
              ),
              Center(child: Text(weekDateTitle, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600))),
              IconButton(
                iconSize: 18,
                onPressed: weekNextDisable
                    ? null
                    : () async {
                        ///Utils.showWaiting(context, false);
                        DateTime time = GlobalMethods.getOneDayForward(currentWeekDateTime[currentWeekDateTime.length - 1]);
                        List<DateTime> nextWeek = await GlobalMethods.getWeekDatesListByTime(time);
                        setState(() {
                          currentWeekDateTime = nextWeek;
                          // if the today time is in the list then disable.
                          if (checkNextWeekAvailable(todayTime, currentWeekDateTime)) {
                            weekNextDisable = true;
                          }
                        });
                        await setWeekDateTitle(currentWeekDateTime);
                        //Navigator.pop(context);
                      },
                icon: Icon(Icons.arrow_forward_ios_outlined, color: weekNextDisable ? Colors.grey.withOpacity(0.5) : Colors.black),
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
          padding: const EdgeInsets.all(4.0),
          width: double.infinity,
          height: 200,
          child: SfCartesianChart(
            plotAreaBorderWidth: 0,
            primaryXAxis: CategoryAxis(
              majorGridLines: const MajorGridLines(width: 0),
              majorTickLines: const MajorTickLines(size: 4),
            ),
            /*primaryYAxis: DateTimeAxis(
              majorTickLines: const MajorTickLines(color: Colors.transparent),
              majorGridLines: const MajorGridLines(width: 0),
              //majorTickLines: const MajorTickLines(size: 4,width: 2),
              dateFormat: DateFormat('''h:mm\na'''),
              labelIntersectAction: AxisLabelIntersectAction.wrap,
              axisLine: const AxisLine(width: 0),
            ), */
            primaryYAxis: NumericAxis(
              majorTickLines: const MajorTickLines(color: Colors.transparent),
              axisLabelFormatter: (axisLabelRenderArgs) {
                debugPrint('axisLabelRenderArgs>>value>> ${axisLabelRenderArgs.value}');
                debugPrint('axisLabelRenderArgs>>text>> ${axisLabelRenderArgs.text}');
                return ChartAxisLabel(
                    GlobalMethods.getTimeByIntegerMin(axisLabelRenderArgs.value.toInt()),
                    const TextStyle(
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        fontSize: 12)
                );
              },
              //labelFormat: '{value}',
              minimum: 0,
              maximum: 1440,
              interval: 480,
              axisLine: const AxisLine(width: 0),
            ),
            tooltipBehavior: _tooltipWeekBehavior,
            series: getWeekGradientComparisonSeries(currentWeekDateTime),
          ),
        ),
        const SizedBox(
          height: 2.0,
        ),
        Expanded(
          child: GridView.extent(
            // crossAxisSpacing: 5,
            // mainAxisSpacing: 5,
            padding: const EdgeInsets.all(2.0),
            maxCrossAxisExtent: 250,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            //crossAxisCount: 2,
            childAspectRatio: (2 / 1),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            /*gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
             crossAxisCount: 3,
             crossAxisSpacing: 5.0,
             mainAxisSpacing: 5.0,
           ),*/
            // maxCrossAxisExtent: 2.0,
            children: [
              Card(
                child: Container(
                 // height: 150,
                  // padding: EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.asset(
                          'assets/fit/sleep_duration.png',
                          width: 60.0,
                          height: 60.0,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text(textTotalHours,//'Total Hours',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 18),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('$weekTotalSleepHours ', textAlign: TextAlign.center,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
                                  const Text('h', textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                                  Text('$weekTotalSleepMin ', textAlign: TextAlign.center,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
                                  const Text('m', textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                                  /*Text(
                                    sleepDayDataList[index].diffHour.toString() +
                                        ' H ' +
                                        sleepDayDataList[index].diffMin.toString() +
                                        ' m',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal, fontSize: 12)),*/
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.white70, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Card(
                child: Container(
                  // padding: EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.asset(
                          'assets/fit/sleep_deep.png',
                          width: 60.0,
                          height: 60.0,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text(textDeepHours,//'Deep Hours',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 18),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('$weekTotalDeepHours ', textAlign: TextAlign.center,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
                                  const Text('h', textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                                  Text('$weekTotalDeepMin ', textAlign: TextAlign.center,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
                                  const Text('m', textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                                  /*Text(
                                    sleepDayDataList[index].diffHour.toString() +
                                        ' H ' +
                                        sleepDayDataList[index].diffMin.toString() +
                                        ' m',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal, fontSize: 12)),*/
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.white70, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Card(
                child: Container(
                  // padding: EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.asset(
                          'assets/fit/sleep_light.png',
                          width: 60.0,
                          height: 60.0,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text(textLightHours,//'Light Hours',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 18),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('$weekTotalLightHours ', textAlign: TextAlign.center,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
                                  const Text('h', textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                                  Text('$weekTotalLightMin ', textAlign: TextAlign.center,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
                                  const Text('m', textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                                  /*Text(
                                    sleepDayDataList[index].diffHour.toString() +
                                        ' H ' +
                                        sleepDayDataList[index].diffMin.toString() +
                                        ' m',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal, fontSize: 12)),*/
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.white70, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Card(
                child: Container(
                  // padding: EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.asset('assets/fit/sleep_awake.png',
                          width: 60.0,
                          height: 60.0,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text(textAwakeHours,//'Awake Hours',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 18),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('$weekTotalAwakeHours ', textAlign: TextAlign.center,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
                                  const Text('h', textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                                  Text('$weekTotalAwakeMin ', textAlign: TextAlign.center,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
                                  const Text('m', textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                                  /*Text(
                                    sleepDayDataList[index].diffHour.toString() +
                                        ' H ' +
                                        sleepDayDataList[index].diffMin.toString() +
                                        ' m',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal, fontSize: 12)),*/
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.white70, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget dayChartView() {
    double _width = MediaQuery.of(context).size.width;
    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 18,
                onPressed: () async {
                  // debugPrint('date time>> ${currentDayDateTime[0]}');
                  //Utils.showWaiting(context, false);
                  DateTime time = GlobalMethods.getOneDayBackward(currentDateTime);
                  setState(() {
                    dayNextDisable = false;
                    currentDateTime = time;
                  });

                  await setCurrentDateTitle(currentDateTime);
                 // Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
              ),
              Center(
                  child: Text(dayDateTitle,
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w600))),
              IconButton(
                iconSize: 18,
                onPressed: dayNextDisable
                    ? null
                    : () async {
                  //Utils.showWaiting(context, false);
                  DateTime nextDate =
                  GlobalMethods.getOneDayForward(currentDateTime);
                  setState(() {
                    if (checkNextDayAvailable(todayTime, nextDate)) {
                      dayNextDisable = true;
                    }
                    currentDateTime = nextDate;
                  });
                  await setCurrentDateTitle(currentDateTime);
                 // Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_forward_ios_outlined,
                    color: dayNextDisable
                        ? Colors.grey.withOpacity(0.5)
                        : Colors.black),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 4.0,
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0, right: 2.0),
                child: Text(dayTotalHours, textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 21.0)),
              ),
              const Text('h', textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0)),
              Padding(
                padding: const EdgeInsets.only(left: 4.0, top: 8.0, bottom: 8.0, right: 2.0),
                child: Text(dayTotalMin, textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 21.0)),
              ),
              const Text('m', textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0)),
            ],
          ),
        ),
        const SizedBox(
          height: 4.0,
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 12.0,
                child: VerticalDivider(
                  thickness: 1.0,
                  color: Colors.grey,
                ),
              ),
              CustomAssetsBar(
                width: _width * .75,
                background: const Color(0xFFCFD8DC),
                //height: 50,
                //radius: 10,
                assetsLimit: 100,
                //order: OrderType.Descending,
                assets: [
                  BarAsset(size: deepPercentage.toDouble(), color: const Color(0xFF7A58C9)),
                  BarAsset(size: lightPercentage.toDouble(), color: const Color(0xFFC7A9FE)),
                  BarAsset(size: awakePercentage.toDouble(), color: const Color(0xFFFF9A42)),
                ], radius: 4, order: OrderType.none,
                
              ),
              const SizedBox(
                height: 12.0,
                child: VerticalDivider(
                  thickness: 1.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(left:6.0),
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(textBegin,//'Begin',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0)),
                    ),
                    /* Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text('Begin',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0)),
                            ),
                          ],
                        ),
                      ),*/
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('$dayBeginHours:$dayBeginMin', textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0)),
                          /*  Text('h', textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                            Text('$dayBeginMin ', textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
                            Text('m', textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),*/
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right:16.0),
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(textEnd,//'End',
                          textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0)),
                    ),
                    /* Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                //margin:  const EdgeInsets.all(2.0),
                                //padding: const EdgeInsets.all(2.0),
                                decoration: BoxDecoration(
                                    color: awakeColor,
                                    shape: BoxShape.rectangle
                                ),
                                height: 12,
                                width: 12,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text('End',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500, fontSize: 14.0)),
                            ),
                          ],
                        ),
                      ),*/
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('$dayEndHours:$dayEndMin', textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0)),
                          /*Text('h', textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                            Text('$dayEndMin ', textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
                            Text('m', textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),*/
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 16.0, right: 16.0),
          //padding: EdgeInsets.all(4.0),
          child: Divider(
            color: Colors.grey[500],
            height: 3.0,
          ),
        ),
        const SizedBox(
          height: 4.0,
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              //margin:  const EdgeInsets.all(2.0),
                              //padding: const EdgeInsets.all(2.0),
                              decoration: const BoxDecoration(
                                  color: deepColor,
                                  shape: BoxShape.rectangle
                              ),
                              height: 12,
                              width: 12,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Text(textDeep,//'Deep',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('$dayDeepHours ', textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
                          const Text('h', textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                          Text('$dayDeepMin ', textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
                          const Text('m', textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                          /* Text(
                              '$dayDeepHours H $dayDeepMin m',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0),
                            ),*/
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 18.0,
                child: VerticalDivider(
                  thickness: 1.0,
                  color: Colors.grey,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              //margin:  const EdgeInsets.all(2.0),
                              //padding: const EdgeInsets.all(2.0),
                              decoration: const BoxDecoration(
                                  color: lightColor,
                                  shape: BoxShape.rectangle
                              ),
                              height: 12,
                              width: 12,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Text(textLight,//'Light',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('$dayLightHours ', textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
                          const Text('h', textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                          Text('$dayLightMin ', textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
                          const Text('m', textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                          /*Text('$dayLightHours H $dayLightMin m',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 14.0)),*/
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 18.0,
                child: VerticalDivider(
                  thickness: 1.0,
                  color: Colors.grey,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              //margin:  const EdgeInsets.all(2.0),
                              //padding: const EdgeInsets.all(2.0),
                              decoration: const BoxDecoration(
                                  color: awakeColor,
                                  shape: BoxShape.rectangle
                              ),
                              height: 12,
                              width: 12,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Text(textAwake,//'Awake',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14.0)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('$dayAwakeHours ', textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
                          const Text('h', textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                          Text('$dayAwakeMin ', textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
                          const Text('m', textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                          /* Text('$dayAwakeHours H $dayAwakeMin m',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 14.0)),*/
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 21.0,
        ),
        const Center(
          child: Text(textSleepQualityAnalysis,//'Sleep Quality Analysis',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18
            ),
          ),
        ),
        const SizedBox(
          height: 21.0,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(textSleepNotLate,
            // 'Sleep too late',
            //'Don’t sleep too late',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            sleepToLateString,
            textAlign: TextAlign.justify,
            style: TextStyle(
                fontSize: 14
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(textSleepLake,//'Lack of sleep',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            sleepLackString,
            textAlign: TextAlign.justify,
            style: TextStyle(
                fontSize: 14
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(textSleepWakeEarly,//'Wake up early',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            sleepEarlyWakeUpString,
            textAlign: TextAlign.justify,
            style: TextStyle(
                fontSize: 14
            ),
          ),
        ),
        /* Visibility(
            visible: sleepDayDataList.length >0,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 4.0, bottom: 4.0),
              child: Text('Source Data',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0)),
            ),
          ),
          SizedBox(
            height: 4.0,
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: sleepDayDataList.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white70, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: ListTile(
                          leading: Image.asset(
                            'assets/fit/sleep_time.png',
                            width: 35.0,
                            height: 35.0,
                            fit: BoxFit.fill,
                          ),
                          title: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(getTextBySleepState(sleepDayDataList[index].state),
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ),
                          subtitle: Container(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              children: [
                                Visibility(
                                  child: Text('${sleepDayDataList[index].diffHour} ', textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
                                  visible: (sleepDayDataList[index].diffHour.trim() =='00')?false :true,
                                ),
                                Visibility(
                                  visible: (sleepDayDataList[index].diffHour.trim() =='00')?false :true,
                                  child: Text('h', textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                                ),
                                Text('${sleepDayDataList[index].diffMin} ', textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
                                Text('m', textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                                *//*Text(
                                    sleepDayDataList[index].diffHour.toString() +
                                        ' H ' +
                                        sleepDayDataList[index].diffMin.toString() +
                                        ' m',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal, fontSize: 12)),*//*
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),*/
      ],
    );
  }

  List<RangeColumnSeries<WeeklySleepData, String>> getWeekGradientComparisonSeries(List<DateTime> currentDateTime) {
    return <RangeColumnSeries<WeeklySleepData, String>>[
      RangeColumnSeries<WeeklySleepData, String>(
        dataSource: weekSleepDataList,
        //name: currentDateTime.toString().substring(0,10),
        xValueMapper: (WeeklySleepData sales, _) => sales.weekName,
        lowValueMapper: (WeeklySleepData sales, _) => sales.startTimeNum,
        highValueMapper: (WeeklySleepData sales, _) => sales.endTimeNum,
        //isTrackVisible: true,
        //trackColor: inCompletedColor,
        borderRadius: BorderRadius.circular(8.0),
       // color: inCompletedColor,
        color: sleepLightColor,
        width: weekSleepDataList.length <= 4 ? 0.2 : 0.5,
        //dataLabelMapper: (datum, index) => datum.dateTime.toString().substring(0,10),
       // trackBorderColor: Colors.grey[500],
        /*dataLabelSettings: DataLabelSettings(
          isVisible: true,
          labelAlignment: ChartDataLabelAlignment.top,
        )*/
        // yValueMapper:(WeeklySleepData sales, _) => sales.dataPoint,
        //  dataLabelMapper: (datum, index) => datum.dateTime.toString().substring(0,10),
        /*onCreateShader: (ShaderDetails details) {
          return ui.Gradient.linear(
              details.rect.topCenter,
              details.rect.bottomCenter,
              const <Color>[Colors.red, Colors.orange, Colors.yellow],
              <double>[0.3, 0.6, 0.9]);
        },*/
        //width: weekSleepDataList.length <= 4 ? 0.2 : 0.5,
        //color: inCompletedColor,
        //dataLabelSettings: DataLabelSettings(isVisible: true, offset: const Offset(0, -5)),
      )
    ];
  }

  List<RangeColumnSeries<MonthlySleepData, num>> getMonthlySeriesDataList(List<DateTime> currentMonthDateTime) {
    return <RangeColumnSeries<MonthlySleepData, num>>[
      RangeColumnSeries<MonthlySleepData, num>(
          dataSource: monthSleepDataList,
          // name: tempCalenderMonth[currentMonthDateTime[0].month - 1].toString().substring(0, 3),
          xValueMapper: (MonthlySleepData sales, _) => sales.dayNumber,
          lowValueMapper: (MonthlySleepData sales, _) => sales.startTimeNum,
          highValueMapper: (MonthlySleepData sales, _) => sales.endTimeNum,
          // color: inCompletedColor,
          borderRadius: BorderRadius.circular(8.0),
          pointColorMapper: (MonthlySleepData datum, _) => datum.color,
          width: 0.5
          // markerSettings: const MarkerSettings(isVisible: true),
          )
    ];
  }
}
