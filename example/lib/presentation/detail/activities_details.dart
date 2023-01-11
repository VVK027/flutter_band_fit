import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ActivitiesDetails extends StatefulWidget {
  final String displayTitle;
  final String activityLabel;
  final bool stepsView;
  final bool calView;
  final bool distanceView;

  const ActivitiesDetails({Key? key, required this.displayTitle, required this.activityLabel, required this.stepsView, required this.calView, required this.distanceView}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ActivitiesDetailsState();
  }
}

//Color inCompletedColor  = darkStepsColor;
class ActivitiesDetailsState extends State<ActivitiesDetails> {
  int selectedPage = 0;



  final  _activityServiceProvider = Get.put(ActivityServiceProvider());

  List<dynamic> overAllStepsData = [];
  int totalTargetedSteps = 0;

  //current day
  DateTime todayTime = DateTime.now();
  DateTime currentDateTime = DateTime.now();
  String dayDateTitle = '';
  bool dayNextDisable = true;
  List<CommonBandModel> stepsDayDataList = [];
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

  late TooltipBehavior _tooltipDayBehavior;
  late TooltipBehavior _tooltipWeekBehavior;

  @override
  void initState() {
    //_activityServiceProvider = Provider.of<ActivityServiceProvider>(context, listen: false);
    _tooltipDayBehavior = TooltipBehavior(enable: true, canShowMarker: false);
    _tooltipWeekBehavior = TooltipBehavior(enable: true, canShowMarker: false, header: '');
    super.initState();
    Future.delayed(Duration.zero, () {
       initializeData();
    });
    //initializeData();
  }

  Future<void> initializeData() async {

    String stepsData = _activityServiceProvider.getOverAllStepsData;
    setState(() {
      totalTargetedSteps = int.tryParse(_activityServiceProvider.getTargetedSteps)!;
      if (stepsData.isNotEmpty) {
        overAllStepsData = jsonDecode(stepsData.toString());
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
    // String month = tempCalenderMonth[dateTime.month - 1];
    // String week = tempCalenderWeek[dateTime.weekday - 1];
    String month = calMonths[dateTime.month - 1];
    String week = calWeeks[dateTime.weekday - 1];
    setState(() {
     // dayDateTitle = firstDay + ', ' + month + ' (' + week + ')';
      dayDateTitle = '$firstDay, $month ($week)';
    });
    try {
      String calender = GlobalMethods.convertBandReadableCalender(dateTime);
      if (overAllStepsData != null) {
        //List<StepsMainModel> stepsMainModelList = await _activityServiceProvider.getCurrentDaySteps(overAllStepsData, calender);
        List<StepsMainModel> stepsMainModelList = [];
        if (Platform.isIOS) {
          stepsMainModelList = await _activityServiceProvider.getSelectedDayStepsData(overAllStepsData, calender);
        }else{
          stepsMainModelList = await _activityServiceProvider.getCurrentDaySteps(overAllStepsData, calender);
        }

        debugPrint('stepsMainModelList>>  ${stepsMainModelList.length}');
        if (stepsMainModelList.isNotEmpty) {
          StepsMainModel stepsMainModel = stepsMainModelList[0];
          List<BandStepsModel> stepsDataList = stepsMainModelList[0].dataList;
          List<CommonBandModel> dataRepList = [];
          double totalSteps = double.tryParse(stepsMainModel.steps)!;
          double totalDistance = double.tryParse(stepsMainModel.distance)!;
          double totalCalories = double.tryParse(stepsMainModel.calories)!;
          if (stepsDataList.isNotEmpty) {
            for (var element in stepsDataList) {
              int stepValue = int.tryParse(element.step)!;
              List<String> times = element.time.split(':');
              DateTime _dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, int.tryParse(times[0])!, int.tryParse(times[1])!);
              dataRepList.add(CommonBandModel(
                  time: _dateTime,
                  dataPoint: stepValue,
                  //color: stepValue >= totalTargetedSteps ?completeColor :inCompletedColor
                  color: stepValue < totalTargetedSteps - 1500
                      ? darkStepsColor
                      : completeColor));
            }
            setState(() {
              stepsDayDataList = dataRepList;
              dayTotalSteps = totalSteps.toInt().toString();
              dayTotalDistance = totalDistance.toString();
              dayTotalCalories = totalCalories.toString();
            });
          } else {
            setState(() {
              stepsDayDataList = [];
              dayTotalSteps = '0';
              dayTotalDistance = '0.0';
              dayTotalCalories = '0.0';
            });
          }
        } else {
          setState(() {
            stepsDayDataList = [];
            dayTotalSteps = '0';
            dayTotalDistance = '0.0';
            dayTotalCalories = '0.0';
          });
        }
      } else {
        setState(() {
          stepsDayDataList = [];
          dayTotalSteps = '0';
          dayTotalDistance = '0.0';
          dayTotalCalories = '0.0';
        });
      }
    } catch (e) {
      debugPrint('setStepsTitleException:: $e');
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

  Future<void> setWeekDateTitle(List<DateTime> weekList) async{
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
      setState(() {
        weekDateTitle = firstDay + ' ' +prevMonth+ ' ~ ' + lastDay + ' ' + nextMonth;
      });*/
      String title = await GlobalMethods.getWeekTitleLabel(context, weekList);
      setState(() {
        weekDateTitle = title;
      });
      List<String> calenderList =[];
      for (var element in weekList) {
        calenderList.add(GlobalMethods.convertBandReadableCalender(element));
      }
      if (Platform.isIOS) {
        List<dynamic> dataList = await _activityServiceProvider.getSelectedRangeStepsData(false, overAllStepsData, calenderList, context, totalTargetedSteps);
        List<WeekStepsData> weekDataList = dataList[0];
        double totalSteps = dataList[1];
        double totalDistance = dataList[2];
        double totalCalories = dataList[3];

        if (weekDataList.isNotEmpty) {
          setState(() {
            weekStepsDataList = weekDataList;
            weekTotalSteps = totalSteps.toInt().toString();
            weekTotalDistance = totalDistance.toStringAsFixed(2);
            weekTotalCalories = totalCalories.toStringAsFixed(2);
          });

        }else{
          setState(() {
            weekStepsDataList = [];
            weekTotalSteps = '0';
            weekTotalDistance = '0.0';
            weekTotalCalories = '0.0';
          });
        }
      }else{
        List<StepsMainModel> stepsWeekModelList = await _activityServiceProvider.getStepsBySelectedWeek(overAllStepsData, calenderList);
        debugPrint('stepsWeekModelList>>  ${stepsWeekModelList.length}');
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
                color: elementSteps.toInt() < totalTargetedSteps * stepsWeekModelList.length ? darkStepsColor : completeColor
            ));
          }
          setState(() {
            weekStepsDataList = weekDataList;
            weekTotalSteps = totalSteps.toInt().toString();
            weekTotalDistance = totalDistance.toStringAsFixed(2);
            weekTotalCalories = totalCalories.toStringAsFixed(2);
          });
        }else{
          setState(() {
            weekStepsDataList = [];
            weekTotalSteps = '0';
            weekTotalDistance = '0.0';
            weekTotalCalories = '0.0';
          });
        }
      }

    }else{
      setState(() {
        weekStepsDataList = [];
        weekTotalSteps = '0';
        weekTotalDistance = '0.0';
        weekTotalCalories = '0.0';
      });
    }
  }

  bool checkNextWeekAvailable(DateTime todayTime, List<DateTime> currentWeekDateTime) {
    bool tempFlag = false;
    for(DateTime date in currentWeekDateTime){
      if (date.toString().substring(0,10).trim() == todayTime.toString().substring(0,10).trim()) {
        tempFlag = true;
        break;
      }
    }
    return  tempFlag;
  }

  Future<void> setMonthDateTitle(List<DateTime> monthList) async{
    if (monthList.isNotEmpty) {
      String year = monthList[0].year.toString();
      //String lastDay = monthList[monthList.length - 1].day.toString();
     // String month = tempCalenderMonth[monthList[0].month - 1];
      String month = calMonths[monthList[0].month - 1];
      setState(() {
        monthlyDateTitle ='$month $year';
        //monthlyDateTitle = Utils.tr(context,month) + ' ' + year;
      });

      List<String> calenderList =[];
      for (var element in monthList) {
        calenderList.add(GlobalMethods.convertBandReadableCalender(element));
      }
      if (Platform.isIOS) {
        List<dynamic> dataList = await _activityServiceProvider.getSelectedRangeStepsData(true, overAllStepsData, calenderList, context, totalTargetedSteps);
        List<MonthStepsData> monthDataList = dataList[0];
        double totalSteps = dataList[1];
        double totalDistance = dataList[2];
        double totalCalories = dataList[3];
        if(monthDataList.isNotEmpty){
          setState(() {
            monthStepsDataList = monthDataList;
            monthTotalSteps = totalSteps.toInt().toString();
            monthTotalDistance = totalDistance.toStringAsFixed(2);
            monthTotalCalories = totalCalories.toStringAsFixed(2);
          });
        }else{
          setState(() {
            monthStepsDataList = [];
            monthTotalSteps = '0';
            monthTotalDistance = '0.0';
            monthTotalCalories = '0.0';
          });
        }
      }else{
        List<StepsMainModel> stepsMonthModelList = await _activityServiceProvider.getStepsBySelectedWeek(overAllStepsData, calenderList);
        debugPrint('stepsMonthModelList>>  ${stepsMonthModelList.length}');
        if (stepsMonthModelList.isNotEmpty) {
          List<MonthStepsData> monthDataList =[];
          double totalSteps = 0;
          double totalDistance = 0;
          double totalCalories = 0;
          for (var element in stepsMonthModelList) {
            DateTime dateTime = DateTime.tryParse(element.calender)!;
            double elementSteps = double.tryParse(element.steps)!;
            totalSteps = totalSteps + elementSteps;
            totalDistance = totalDistance + double.tryParse(element.distance)!;
            totalCalories = totalCalories + double.tryParse(element.calories)!;
            monthDataList.add(MonthStepsData(
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

          setState(() {
            monthStepsDataList = monthDataList;
            monthTotalSteps = totalSteps.toInt().toString();
            monthTotalDistance = totalDistance.toStringAsFixed(2);
            monthTotalCalories = totalCalories.toStringAsFixed(2);
          });

        }else{
          setState(() {
            monthStepsDataList = [];
            monthTotalSteps = '0';
            monthTotalDistance = '0.0';
            monthTotalCalories = '0.0';
          });
        }
      }
    }else{
      setState(() {
        monthStepsDataList = [];
        monthTotalSteps = '0';
        monthTotalDistance = '0.0';
        monthTotalCalories = '0.0';
      });
    }
  }

  bool checkNextMonthAvailable(DateTime todayTime, List<DateTime> currentMonthDateTime) {
    bool tempFlag = false;
    for(DateTime date in currentMonthDateTime){
      if (date.toString().substring(0,10).trim() == todayTime.toString().substring(0,10).trim()) {
        tempFlag = true;
        break;
      }
    }
    return  tempFlag;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          //backgroundColor: Colors.white,
          //backgroundColor: Colors.lightBlueAccent,
          backgroundColor: darkStepsColor,
          elevation: 2,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          //iconTheme: IconThemeData(color: Colors.white),
          title: const Text(textPhysicalActivities,
            //Utils.tr(context,widget.displayTitle)
            style: TextStyle(color: Colors.white),
          ),
          actions: const <Widget>[],
          bottom: TabBar(
          //  labelColor: Colors.blueGrey,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0)),
                color: Colors.white),
            tabs: buildDWMTabs(),
            onTap: (value) {
              //debugPrint('Pressed $value');
              setState(() {
                selectedPage = value;
              });
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
              child: Center(
                  child: Text(widget.activityLabel, textAlign: TextAlign.center)),
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
                  //SyncMonthlyChart(),
                ],
              ),
            ),
            /* SizedBox(
              height: 2.0,
            ),*/
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
                 // Utils.showWaiting(context, false);
                  DateTime time = GlobalMethods.getOneDayBackward(currentMonthDateTime[0]);
                  List<DateTime> pastNextMonth = await GlobalMethods.getMonthyDatesListByTime(time);

                  setState(() {
                    monthNextDisable = false;
                    currentMonthDateTime = pastNextMonth;
                  });

                  await setMonthDateTitle(currentMonthDateTime);
                 // Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
              ),
              Center(child: Text(monthlyDateTitle, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600))),
              IconButton(
                iconSize: 18,
                onPressed: monthNextDisable ? null : () async {
                  //Utils.showWaiting(context, false);
                  DateTime time = GlobalMethods.getOneDayForward(currentMonthDateTime[currentMonthDateTime.length-1]);
                  List<DateTime> nextMonth = await GlobalMethods.getMonthyDatesListByTime(time);

                  setState(() {
                    currentMonthDateTime = nextMonth;
                    // if the today time is in the list then disable.
                    if(checkNextMonthAvailable(todayTime, currentMonthDateTime))
                    {
                      monthNextDisable = true;
                    }
                  });
                  await setMonthDateTitle(currentMonthDateTime);
                  //Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_forward_ios_outlined, color: monthNextDisable ? Colors.grey.withOpacity(0.5) : Colors.black),
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
          padding: const EdgeInsets.all(4.0),
          width: double.infinity,
          height: 180,
          child: SfCartesianChart(
            plotAreaBorderWidth: 0,
            onSelectionChanged: (selectionArgs) {
              debugPrint('selectionArgs>> $selectionArgs');
            },
            primaryXAxis: CategoryAxis(
              majorGridLines: const MajorGridLines(width: 0),
              majorTickLines: const MajorTickLines(size: 4),
              interval: 2,
              labelIntersectAction: AxisLabelIntersectAction.rotate90,
            ),
            /* primaryXAxis: NumericAxis(
              majorGridLines: const MajorGridLines(width: 0),
              interval: 1
            ),*/
            /* primaryXAxis: DateTimeCategoryAxis(
              majorGridLines: const MajorGridLines(width: 0),
              majorTickLines: const MajorTickLines(size: 4),
              dateFormat: DateFormat('dd'),
             interval: 1
             // labelIntersectAction: AxisLabelIntersectAction.wrap,

            ),*/
            primaryYAxis: NumericAxis(
              majorTickLines: const MajorTickLines(color: Colors.transparent),
              //interval: 1000,
              minimum: 0,
              //maximum: 50,
              axisLine: const AxisLine(width: 0),
              labelFormat: '{value}',
              /* title: AxisTitle(
                text: isCardView ? '' : 'Duration in minutes',
              ),*/
            ),

            series: getMonthlySeriesDataList(currentMonthDateTime),
            tooltipBehavior: _tooltipWeekBehavior,
            trackballBehavior: TrackballBehavior(
                enable: true,
                markerSettings: const TrackballMarkerSettings(
                  markerVisibility: TrackballVisibilityMode.hidden,
                  // markerVisibility: _showMarker
                  //     ? TrackballVisibilityMode.visible // to show always
                  //     : TrackballVisibilityMode.hidden,
                  height: 10,
                  width: 10,
                  borderWidth: 1,
                ),
                hideDelay: 1.0 * 1000,
                // hide delay 2 secs
                activationMode: ActivationMode.singleTap,
                tooltipAlignment: ChartAlignment.near,
                tooltipDisplayMode: TrackballDisplayMode.floatAllPoints,
                tooltipSettings: const InteractiveTooltip(
                    format: null,
                    // format: _mode != TrackballDisplayMode.groupAllPoints
                    //     ? 'series.name : point.y'
                    //     : null,
                    canShowMarker: false),
                shouldAlwaysShow: false,
                lineWidth: 0
            ),
          ),
        ),
        const SizedBox(
          height: 2.0,
        ),
        GridView.extent(
          // crossAxisSpacing: 5,
          // mainAxisSpacing: 5,
          padding: const EdgeInsets.all(2.0),
          maxCrossAxisExtent: 200,
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
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white70, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                // padding: EdgeInsets.all(2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.asset(
                        'assets/fit/footsteps.png',
                        width: 45.0,
                        height: 45.0,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(textTotalSteps,  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(GlobalMethods.formatNumber(int.parse(monthTotalSteps)), style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white70, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.asset('assets/fit/distance.png',
                        width: 45.0,
                        height: 45.0,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(textDistance,  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text('$monthTotalDistance kms',  style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white70, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                //alignment: Alignment.center,
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.asset('assets/fit/kcal.png',
                        width: 45.0,
                        height: 45.0,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(textCalories,  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text('$monthTotalCalories kCal', style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
                 // Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
              ),
              Center(child: Text(weekDateTitle, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600))),
              IconButton(
                iconSize: 18,
                onPressed: weekNextDisable ? null : () async {

                  //Utils.showWaiting(context, false);
                  DateTime time = GlobalMethods.getOneDayForward(currentWeekDateTime[currentWeekDateTime.length-1]);
                  List<DateTime> nextWeek = await GlobalMethods.getWeekDatesListByTime(time);

                  setState(() {
                    currentWeekDateTime = nextWeek;
                    // if the today time is in the list then disable.
                    if(checkNextWeekAvailable(todayTime, currentWeekDateTime))
                    {
                      weekNextDisable = true;
                    }
                  });
                  await setWeekDateTitle(currentWeekDateTime);
                 // Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_forward_ios_outlined,
                    color: weekNextDisable
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
            ),
            primaryYAxis: NumericAxis(
              majorTickLines: const MajorTickLines(color: Colors.transparent),
              labelFormat: '{value}',
              minimum: 0,
              //maximum: 25,
              //interval: 5,
              axisLine: const AxisLine(width: 0),
            ),
            tooltipBehavior: _tooltipWeekBehavior,
            series: getWeekGradientComparisonSeries(currentWeekDateTime),
          ),
        ),
        const SizedBox(
          height: 2.0,
        ),
        GridView.extent(
         // crossAxisSpacing: 5,
         // mainAxisSpacing: 5,
         padding: const EdgeInsets.all(2.0),
         maxCrossAxisExtent: 200,
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
            shape: RoundedRectangleBorder(
               side: const BorderSide(color: Colors.white70, width: 1),
               borderRadius: BorderRadius.circular(8),
             ),
            child: Container(
             // padding: EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      'assets/fit/footsteps.png',
                      width: 45.0,
                      height: 45.0,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(textTotalSteps,  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(GlobalMethods.formatNumber(int.parse(weekTotalSteps)), style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
           Card(
            shape: RoundedRectangleBorder(
               side: const BorderSide(color: Colors.white70, width: 1),
               borderRadius: BorderRadius.circular(8),
             ),
            child: Container(
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      'assets/fit/distance.png',
                      width: 45.0,
                      height: 45.0,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(textDistance,  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text('$weekTotalDistance kms',  style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
           Card(
            shape: RoundedRectangleBorder(
               side: const BorderSide(color: Colors.white70, width: 1),
               borderRadius: BorderRadius.circular(8),
             ),
            child: Container(
              //alignment: Alignment.center,
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      'assets/fit/kcal.png',
                      width: 45.0,
                      height: 45.0,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(textCalories, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text('$weekTotalCalories kCal', style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
       ),
      ],
    );
  }

  Widget dayChartView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          //margin: EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
          padding: const EdgeInsets.all(2.0),
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
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
          padding: const EdgeInsets.all(4.0),
          width: double.infinity,
          height: 180,
          child: SfCartesianChart(
            plotAreaBorderWidth: 0,
            // borderWidth: 0,
            onSelectionChanged: (selectionArgs) {
              debugPrint('selectionArgs>> $selectionArgs');
            },
            primaryXAxis: DateTimeCategoryAxis(
              majorGridLines: const MajorGridLines(width: 0),
              majorTickLines: const MajorTickLines(size: 2),
              // dateFormat: DateFormat('''h:mm\na'''),
              minimum: DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day, 0, 0, 0),
              maximum: DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day, 24, 0, 0),
              // labelIntersectAction: AxisLabelIntersectAction.wrap,
              // labelAlignment: LabelAlignment.center,
              // intervalType: DateTimeIntervalType.minutes,
              //labelIntersectAction: AxisLabelIntersectAction.wrap,
              intervalType: DateTimeIntervalType.minutes,
              labelAlignment: LabelAlignment.center,
              // interval: 1
              /*title: AxisTitle(
                text: isCardView ? '' : 'Start time',
              ),*/
            ),
            primaryYAxis: NumericAxis(
              majorTickLines: const MajorTickLines(size: 2),
              //interval: 1000,
              minimum: 0,
              //maximum: 50,
              axisLine: const AxisLine(width: 0),
              labelFormat: '{value}',
              /* title: AxisTitle(
                text: isCardView ? '' : 'Duration in minutes',
              ),*/
            ),
            series: getDaySeriesDataList(currentDateTime),

            // for the default tool tip behaviour
            tooltipBehavior: _tooltipDayBehavior,

            /// To set the track ball as true and customized trackball behaviour.
            trackballBehavior: TrackballBehavior(
                enable: true,
                markerSettings: const TrackballMarkerSettings(
                  markerVisibility: TrackballVisibilityMode.hidden,
                  // markerVisibility: _showMarker
                  //     ? TrackballVisibilityMode.visible // to show always
                  //     : TrackballVisibilityMode.hidden,
                  height: 10,
                  width: 10,
                  borderWidth: 1,
                ),
                hideDelay: 1.0 * 1000,
                // hide delay 2 secs
                activationMode: ActivationMode.singleTap,
                tooltipAlignment: ChartAlignment.near,
                tooltipDisplayMode: TrackballDisplayMode.floatAllPoints,
                tooltipSettings: const InteractiveTooltip(
                    format: null,
                    // format: _mode != TrackballDisplayMode.groupAllPoints
                    //     ? 'series.name : point.y'
                    //     : null,
                    canShowMarker: false),
                shouldAlwaysShow: false,
                lineWidth: 0),
          ),
        ),
        const SizedBox(
          height: 2.0,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text(textSteps,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16.0)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      GlobalMethods.formatNumber(int.parse(dayTotalSteps)),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          /*color: int.parse(dayTotalSteps) <
                                  totalTargetedSteps - 1500
                              ? inCompletedColor
                              : completeColor,*/
                          //color: int.parse(dayTotalSteps),
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0),
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
                children: [
                  const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text(textDistance,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16.0)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text('$dayTotalDistance km',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14.0)),
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
                children: [
                  const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text(textCalories,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16.0)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text('$dayTotalCalories kCal',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14.0)),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 2.0,
        ),
        /*Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text('Total Data (${stepsDayDataList.length})'),
        ),
        SizedBox(
          height: 2.0,
        ),*/
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: stepsDayDataList.length,
            itemBuilder: (context, index) {
              return Card(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.white70, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  leading: Image.asset(
                    'assets/fit/footsteps.png',
                    width: 35.0,
                    height: 35.0,
                    fit: BoxFit.fill,
                  ),
                  title: Text(
                    stepsDayDataList[index].dataPoint.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(DateFormat.jm().format(stepsDayDataList[index].time),
                      style: const TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 12)),
                ),
                /*child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: ListTile(
                        leading: Image.asset(
                          'assets/fit/footsteps.png',
                          width: 35.0,
                          height: 35.0,
                          fit: BoxFit.fill,
                        ),
                        title: Text(stepsDayDataList[index].dataPoint.toString(),style: TextStyle(
                            fontWeight: FontWeight.bold,fontSize: 16
                        ),),
                        subtitle: Text(stepsDayDataList[index].time.toString(),style: TextStyle(
                            fontWeight: FontWeight.normal,fontSize: 12)
                        ),
                      ),
                    ),
                  ],
                ),*/
              );
            },
          ),
        ),
      ],
    );
  }

  List<ColumnSeries<CommonBandModel, DateTime>> getDaySeriesDataList(DateTime currentDateTime) {
    return [
      ColumnSeries<CommonBandModel, DateTime>(
          name: currentDateTime.toString().substring(0, 10),
          dataSource: stepsDayDataList,
          xValueMapper: (CommonBandModel x, int xx) => x.time,
          yValueMapper: (CommonBandModel sales, _) => sales.dataPoint,
          color: darkStepsColor,
          width: stepsDayDataList.length <= 4 ? 0.15 : 0.5
          //pointColorMapper: (datum, index) =>  datum.color,
          // markerSettings: const MarkerSettings(isVisible: true),
          )
    ];
  }

  List<CartesianSeries<WeekStepsData, String>> getWeekGradientComparisonSeries(List<DateTime> currentDateTime) {
    return <CartesianSeries<WeekStepsData, String>>[
      ColumnSeries<WeekStepsData, String>(
        //name: currentDateTime.toString().substring(0,10),
        xValueMapper:  (WeekStepsData sales, _) => sales.weekName,
        yValueMapper:(WeekStepsData sales, _) => sales.dataPoint,
       // dataLabelMapper: (datum, index) => datum.dateTime.toString().substring(0,10),
        dataLabelMapper: (datum, index) => '${datum.dateTime.day.toString().padLeft(2,'0')}-${datum.dateTime.month.toString().padLeft(2,'0')}',
        /*onCreateShader: (ShaderDetails details) {
          return ui.Gradient.linear(
              details.rect.topCenter,
              details.rect.bottomCenter,
              const <Color>[Colors.red, Colors.orange, Colors.yellow],
              <double>[0.3, 0.6, 0.9]);
        },*/
        width: weekStepsDataList.length <= 4 ? 0.2 : 0.5,
        dataSource: weekStepsDataList,
        color: darkStepsColor,
        //color: ,
        dataLabelSettings: const DataLabelSettings(isVisible: true, offset: Offset(0, -5)),
      )
    ];
  }

  List<ColumnSeries<MonthStepsData, num>> getMonthlySeriesDataList( List<DateTime> currentMonthDateTime) {
    return <ColumnSeries<MonthStepsData, num>>[
      ColumnSeries<MonthStepsData, num>(
        // name: tempCalenderMonth[currentMonthDateTime[0].month - 1].toString().substring(0, 3),
          dataSource: monthStepsDataList,
          xValueMapper: (MonthStepsData sales,  _) => sales.dayNumber,
          yValueMapper: (MonthStepsData sales, _) => sales.dataPoint,
          // color: inCompletedColor,
          pointColorMapper: (MonthStepsData datum, _) =>  datum.color,
          width: 0.5
        // markerSettings: const MarkerSettings(isVisible: true),
      )
    ];
  }

}

/*
class DayDataRep {
  final DateTime time;
  final int dataPoint;
  final Color color;
  DayDataRep({required this.time, required this.dataPoint, required this.color});
}

class WeekStepsData {
  final String weekName;
  final DateTime dateTime;
  final int dataPoint;
  final Color color;
  WeekStepsData({required this.weekName, required this.dateTime,required this.dataPoint, required this.color});
}

class MonthStepsData {
  // final String monthDateName;
  final int dayNumber;
  final int dataPoint;
  final Color color;
  MonthStepsData({required this.dayNumber, required this.dataPoint, required this.color});
}*/
