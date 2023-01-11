import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:get/get.dart';

class HeartRateDetail extends StatefulWidget {
  final String displayTitle;
  final String activityLabel;

  const HeartRateDetail({Key? key, required this.displayTitle, required this.activityLabel}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HeartRateDetailState();
  }
}

class HeartRateDetailState extends State<HeartRateDetail> {

   final  _activityServiceProvider = Get.put(ActivityServiceProvider());
  late TooltipBehavior _tooltipBehavior;


  DateTime todayTime = DateTime.now();
  DateTime currentDateTime = DateTime.now();

  String dateTitle = '';
  bool isNextDisable = true;

  var hr24Data;
  List<CommonDataResult> _dataRepresentList = [];

  String avgHeartRate ='--', maxHeartRate ='--', minHeartRate = '--';
  String currentMainHeartRate ='--';

  @override
  void initState() {
  // _activityServiceProvider = Provider.of<ActivityServiceProvider>(context, listen: false);
    _tooltipBehavior = TooltipBehavior(enable: true, canShowMarker: false);
    super.initState();
    Future.delayed(Duration.zero, () {
       initializeData();
    });
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //this._getCategories();
  }

  Future<void> initializeData() async {
    String hrData  = _activityServiceProvider.getOverAllHrData;
    setState(() {
      if (hrData!=null && hrData.isNotEmpty) {
        hr24Data = jsonDecode(hrData.toString());
      }
    });
    await setDateTitle(todayTime);
  }

  Future<void> setDateTitle(DateTime dateTime) async {
    String firstDay = dateTime.day.toString();
    // String month = tempCalenderMonth[dateTime.month - 1];
    // String week = tempCalenderWeek[dateTime.weekday - 1];
    String month = calMonths[dateTime.month - 1];
    String week = calWeeks[dateTime.weekday - 1];
    setState(() {
     // dateTitle = firstDay + ', ' + month + ' (' + week + ')';
      dateTitle = '$firstDay, $month ($week)';
    });
    try {
      String calender = GlobalMethods.convertBandReadableCalender(dateTime);
      if (hr24Data != null) {
        List<BandHRModel> smartHr24List = await _activityServiceProvider.getCurrentDayHRData(hr24Data, calender);
        debugPrint('smartHr24List>> $smartHr24List -- ${smartHr24List.length}');
        if (smartHr24List.isNotEmpty) {
          List<CommonDataResult> dataRepList = [];
          //List<double> dataPointsList =[];
          double sumOfDataPoints = 0;
          double largestValue = double.tryParse(smartHr24List[0].rate)!;
          double smallestValue = double.tryParse(smartHr24List[0].rate)!;

          String currentValue = smartHr24List[smartHr24List.length - 1].rate;

          for (var element in smartHr24List) {
            List<String> times = element.time.split(':');
            DateTime _dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, int.tryParse(times[0])!, int.tryParse(times[1])!);
            //final dateTime = DateTime.parse(element.time);
            double dataPoint = double.tryParse(element.rate)!;
            //debugPrint('dataPoint>> $dataPoint');
            if (dataPoint > largestValue) {
              largestValue = dataPoint;
            }
            if (dataPoint < smallestValue) {
              smallestValue = dataPoint;
            }
            // dataPointsList.add(dataPoint);
            sumOfDataPoints = sumOfDataPoints + dataPoint;
           // dataRepList.add(DayDataRep(time: _dateTime, dataPoint: dataPoint, color: inCompletedColor));
            dataRepList.add(CommonDataResult(time: _dateTime, dataPoint: dataPoint, color:heartRateColor));
          }

          double average = (sumOfDataPoints / smartHr24List.length);
          showCalculateData(currentValue, average.toInt().toString(), largestValue.toInt().toString(), smallestValue.toInt().toString());

          /*if (_activityServiceProvider.getMaxHrValue != null && _activityServiceProvider.getMaxHrValue.isNotEmpty) {
            debugPrint('inside_if_check');
            DateTime time = DateTime.now();
            if (firstDay == time.day.toString()) {
              debugPrint('inside_if_check_if');
              showCalculateData(currentValue, _activityServiceProvider.getAvgHrValue, _activityServiceProvider.getMaxHrValue, _activityServiceProvider.getMinHrValue);
            } else {
              debugPrint('inside_if_check_else');
              double average = (sumOfDataPoints / smartHr24List.length);
              showCalculateData(currentValue, average.toInt().toString(), largestValue.toInt().toString(), smallestValue.toInt().toString());
            }
          } else {
            double average = (sumOfDataPoints / smartHr24List.length);
            showCalculateData(currentValue, average.toInt().toString(), largestValue.toInt().toString(), smallestValue.toInt().toString());
          }*/
          setState(() {
            _dataRepresentList = dataRepList;
          });
        } else {
          setState(() {
            _dataRepresentList = [];
          });
          showCalculateData("--", "--", "--", "--");
        }
      } else {
        setState(() {
          _dataRepresentList = [];
        });
        showCalculateData("--", "--", "--", "--");
      }
    } catch (e) {
      debugPrint('setHRTitleException:: $e');
    }
  }

  void showCalculateData(String currentValue, String  average, String largestValue, String smallestValue) {

    /*dataPointsList.sort();
    double minimum = dataPointsList.first;
    double maximum = dataPointsList.last;*/

   /* debugPrint('maximum1 >> ${maximum}');
    debugPrint('minimum1 >> ${minimum}');
    */
    debugPrint('average >> $average');
    debugPrint('largestValue >> $largestValue');
    debugPrint('smallestValue >> $smallestValue');
    setState(() {
      currentMainHeartRate = currentValue;
      maxHeartRate = largestValue;
      minHeartRate = smallestValue;
      avgHeartRate = average;
    });
  }

  bool checkIsTodayAvail(DateTime todayTime, DateTime currentDayDateTime) {
    bool tempFlag = false;
    if (todayTime.toString().substring(0, 10).trim() ==
        currentDayDateTime.toString().substring(0, 10).trim()) {
      tempFlag = true;
    }
    return tempFlag;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(

        //backgroundColor: Colors.white,
      //  backgroundColor: Colors.redAccent,
        //backgroundColor: Color(0xffef999f),
        //backgroundColor: Color(0xffff8080), // #FF6365
       // backgroundColor: Color(0xffFA8072),
       // backgroundColor: Color(0xffFF6666),
        backgroundColor: heartRateColor,
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
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              DateTime data = await GlobalMethods.selectCalenderDate(context, DateTime.now());
              debugPrint('dataTime>> $data');
              if (data != DateTime.now()) {
                setState(() {
                  currentDateTime = data;
                });
                await setDateTitle(currentDateTime);
              }
            },
          )
        ],
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text(widget.activityLabel, textAlign: TextAlign.center)),
          ),
          Container(
            //margin: EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
            // padding: EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 20,
                  onPressed: () async {
                    // debugPrint('date time>> ${currentDayDateTime[0]}');
                    DateTime time = GlobalMethods.getOneDayBackward(currentDateTime);
                    setState(() {
                      isNextDisable = false;
                      currentDateTime = time;
                    });
                    await setDateTitle(currentDateTime);
                  },
                  icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
                ),
                Center(child: Text(dateTitle, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),),),
                IconButton(
                  iconSize: 20,
                  onPressed: isNextDisable ? null : () async {
                    DateTime nextDate = GlobalMethods.getOneDayForward(currentDateTime);
                    setState(() {
                      if (checkIsTodayAvail(todayTime, nextDate)) {
                        isNextDisable = true;
                      }
                      currentDateTime = nextDate;
                    });
                    await setDateTitle(currentDateTime);
                  },
                  icon: Icon(Icons.arrow_forward_ios_outlined,
                      color: isNextDisable
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
              // borderWidth: 0,
              onSelectionChanged: (selectionArgs) {
                debugPrint('selectionArgs>> $selectionArgs');
              },
              primaryXAxis: DateTimeCategoryAxis(
                majorGridLines: const MajorGridLines(width: 0),
                majorTickLines: const MajorTickLines(size: 3),

                // dateFormat: DateFormat('''h:mm\na'''),
                minimum: DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day,0,0,0),
                maximum: DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day,24,0,0),
                labelIntersectAction: AxisLabelIntersectAction.wrap,
                labelAlignment: LabelAlignment.center,
                intervalType: DateTimeIntervalType.minutes,

                /*title: AxisTitle(
              text: isCardView ? '' : 'Start time',
            ),*/
              ),
              primaryYAxis: NumericAxis(
                majorTickLines: const MajorTickLines(size: 4),
                //interval: 1000,
                minimum: 0,
                maximum: 200,
                //maximum: 50,
                axisLine: const AxisLine(width: 0),
                labelFormat: '{value}',
                /* title: AxisTitle(
              text: isCardView ? '' : 'Duration in minutes',
            ),*/
              ),
              series: getSeriesDataList(currentDateTime),

              // for the default tool tip behaviour
              tooltipBehavior: _tooltipBehavior,

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
                  // hideDelay: 1.0 * 1000,
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
          //SyncDayLineChart(selectedTime :_selectedDate, isHrData: true),
          const SizedBox(
            height: 4.0,
          ),
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/fit/heart.png',
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  width: 4.0,
                ),
                // Text('77 Times/minutes'),
                Text('$currentMainHeartRate ${hrTimeMinutes}',style: const TextStyle(
                    fontWeight: FontWeight.bold
                ),),
              ],
            ),
          ),
          const SizedBox(
            height: 4.0,
          ),
          Card(
            // margin:const EdgeInsets.all(2.0),
            // elevation: 0.5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(2.0),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(textAverageHR, textAlign: TextAlign.center, style:  TextStyle(
                            // color: Colors.blue,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.0,
                          ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(avgHeartRate.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40.0,
                  child: VerticalDivider(
                    thickness: 1.0,
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin:const EdgeInsets.all(2.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(textMinHR, textAlign: TextAlign.center, style:  TextStyle(
                            // color: Colors.blue,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.0,
                          ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(minHeartRate.toString(), textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40.0,
                  child: VerticalDivider(
                    thickness: 1.0,
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin:const EdgeInsets.all(2.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(textMaxHR, textAlign: TextAlign.center, style:  TextStyle(
                            // color: Colors.blue,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.0,
                          ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(maxHeartRate.toString(), textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // body: SingleChildScrollView(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //     ],
      //   ),
      // ),
    );
  }

  List<LineSeries<CommonDataResult, DateTime>> getSeriesDataList(DateTime currentDateTime) {
    return [
      LineSeries<CommonDataResult, DateTime>(
        name: currentDateTime.toString().substring(0, 10),
        dataSource: _dataRepresentList,
        xValueMapper: (CommonDataResult x, int xx) => x.time,
        yValueMapper: (CommonDataResult sales, _) => sales.dataPoint,
       // color: inCompletedColor,
        color:heartRateColor,
        //pointColorMapper: (datum, index) =>  datum.color,
        // markerSettings: const MarkerSettings(isVisible: true),
      )
    ];
  }


}