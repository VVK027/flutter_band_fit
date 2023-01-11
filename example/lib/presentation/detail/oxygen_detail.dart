import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:get/get.dart';

class OxygenDetail extends StatefulWidget {
  final String displayTitle;
  final String activityLabel;

  const OxygenDetail({Key? key, required this.displayTitle, required this.activityLabel}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OxygenDetailState();
  }

}

class OxygenDetailState extends State<OxygenDetail> {

   final  _activityServiceProvider = Get.put(ActivityServiceProvider());
  late TooltipBehavior _tooltipBehavior;


  DateTime todayTime = DateTime.now();
  DateTime currentDateTime = DateTime.now();

  String dateTitle = '';
  bool isNextDisable = true;

  dynamic oxygenData;
  List<CommonBandModel> _dataRepresentList = [];

  String maxOxygenValue ='--', minOxygenValue = '--';
  String currentOxygen ='--';

 // late String lang;
  bool statusReconnected = false;
  var oxyJsonData ={};

  late String latestOxyValue, latestOxyTime, latestOxyCalender;

  @override
  void initState() {
  // _activityServiceProvider = Provider.of<ActivityServiceProvider>(context, listen: false);
    _tooltipBehavior = TooltipBehavior(enable: true, canShowMarker: false);
    super.initState();
    listenResults();
    Future.delayed(Duration.zero, () {
      initializeOxygenData();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //this._getCategories();
  }

  Future<void> listenResults() async{
    //lang = await Utils.getLanguage();
    // resume bp listeners
    _activityServiceProvider.pauseEventListeners();
    _activityServiceProvider.receiveBPListeners(
        onDataUpdate: (data) async {
          debugPrint("receiveOxyListeners>> $data");
          var eventData = jsonDecode(data);
          String result = eventData['result'].toString();
          String status = eventData['status'].toString();
          var jsonData = eventData['data'];
          if (result == BandFitConstants.DEVICE_CONNECTED){
            if (status == BandFitConstants.SC_SUCCESS) {
              if (statusReconnected) {
                Navigator.pop(context);
                await startOxygenTest();
              }
            }
          }else if (result == BandFitConstants.OXYGEN_TEST_STARTED) {
            if (status == BandFitConstants.SC_SUCCESS) {
            // Utils.showToastMessage(context,Utils.tr(context, 'string_text_test_started'));
            }
          } else if (result == BandFitConstants.OXYGEN_TEST_FINISHED){
            if (status == BandFitConstants.SC_SUCCESS) {
              // String calender = GlobalMethods.convertBandReadableCalender(DateTime.now());
              //Map<String, dynamic> overAllData =  await _activityServiceProvider.fetchOxygenByDate(calender);
              // debugPrint('overAllData>> $overAllData');

              debugPrint('oxyJsonData>> $oxyJsonData');
              debugPrint('latestOxyTime>> $latestOxyTime');
              //print('latestOxyStartTime>> $latestOxyStartTime');

              //if (oxyJsonData !=null && latestOxyStartTime !=null) {
              if (!Platform.isIOS) {
                if (oxyJsonData !=null ) {
                  await updateOxygenData(oxyJsonData);
                }else{
                  Navigator.pop(context);
                }
              }
            }
          }/*else if(result == BandFitConstants.OXYGEN_TEST_TIME_OUT){
            Navigator.pop(context);
            //Utils.showToastMessage(context,'BP Test TimeOut !');
          // Utils.showToastMessage(context,Utils.tr(context, 'string_bp_test_time_out'));
          }else if(result == BandFitConstants.OXYGEN_TEST_ERROR){
            Navigator.pop(context);
            //Utils.showToastMessage(context,'Something went wrong, retry again..!');
          // Utils.showToastMessage(context,Utils.tr(context, 'string_something_went_wrong'));
          }*/else if (result == BandFitConstants.OXYGEN_RESULT){
            if (status == BandFitConstants.SC_SUCCESS) {
              debugPrint('jsonData>> $jsonData');
              // {calender: 20220614, value: 97, startDate: 202206141705, time: 17:05}
              String oxyValue = jsonData['value'].toString();
              String oxyTime = jsonData['time'].toString();
              // String oxyStartDate = jsonData['startDate'];
              String oxyCalender = jsonData['calender'].toString();
              setState(() {
                latestOxyValue = oxyValue;
                latestOxyTime = oxyTime;
                //latestOxyStartTime = oxyStartDate;
                latestOxyCalender = oxyCalender;
                oxyJsonData = jsonData;
              });

              if (Platform.isIOS) {
                if (oxyJsonData !=null ) {
                  await updateOxygenData(oxyJsonData);
                }else{
                  Navigator.pop(context);
                }
              }
            }
          }else{
            debugPrint("receiveOxyListeners::>> no result found");
            /* if (mounted) {
            _activityServiceProvider.updateEventResult(eventData, context);
           }*/
          }
        },
        onError: (error) {
          debugPrint("receiveOxyListenersError::>> $error");
        },
        onDone: () {
          debugPrint("receiveOxyListenersOnDone::>> ");
        },
    );
    _activityServiceProvider.resumeBPListeners();
    /*_activityServiceProvider.receiveOxygenListeners(
        onDataUpdate: (data)  async {
          debugPrint("receiveOxyListeners>> " + data.toString());
          var eventData = jsonDecode(data);
          String result = eventData['result'].toString();
          String status = eventData['status'].toString();
          var jsonData = eventData['data'];
          if (result == BandFitConstants.OXYGEN_TEST_STARTED) {
            if (status == BandFitConstants.SC_SUCCESS) {
            // Utils.showToastMessage(context,Utils.tr(context, 'string_text_test_started'));
            }
          } else if (result == BandFitConstants.OXYGEN_TEST_FINISHED){
            if (status == BandFitConstants.SC_SUCCESS) {
             // String calender = GlobalMethods.convertBandReadableCalender(DateTime.now());
              //Map<String, dynamic> overAllData =  await _activityServiceProvider.fetchOxygenByDate(calender);
             // debugPrint('overAllData>> $overAllData');

              debugPrint('oxyJsonData>> $oxyJsonData');
              debugPrint('latestOxyTime>> $latestOxyTime');
              //print('latestOxyStartTime>> $latestOxyStartTime');

              //if (oxyJsonData !=null && latestOxyStartTime !=null) {
              if (oxyJsonData !=null ) {
                await updateOxygenData(oxyJsonData);
              }else{
                Navigator.pop(context);
              }
            }
          }*//*else if(result == BandFitConstants.OXYGEN_TEST_TIME_OUT){
            Navigator.pop(context);
            //Utils.showToastMessage(context,'BP Test TimeOut !');
          // Utils.showToastMessage(context,Utils.tr(context, 'string_bp_test_time_out'));
          }else if(result == BandFitConstants.OXYGEN_TEST_ERROR){
            Navigator.pop(context);
            //Utils.showToastMessage(context,'Something went wrong, retry again..!');
          // Utils.showToastMessage(context,Utils.tr(context, 'string_something_went_wrong'));
          }*//*else if (result == BandFitConstants.OXYGEN_RESULT){
            if (status == BandFitConstants.SC_SUCCESS) {
              debugPrint('jsonData>> $jsonData');
              // {calender: 20220614, value: 97, startDate: 202206141705, time: 17:05}
              String oxyValue = jsonData['value'].toString();
              String oxyTime = jsonData['time'].toString();
             // String oxyStartDate = jsonData['startDate'];
              String oxyCalender = jsonData['calender'].toString();
              setState(() {
                latestOxyValue = oxyValue;
                latestOxyTime = oxyTime;
                //latestOxyStartTime = oxyStartDate;
                latestOxyCalender = oxyCalender;
                oxyJsonData = jsonData;
              });
              // if(high!=null ){
              //   updateBPData(high, low);
              // }else{
              //   Navigator.pop(context);
              // }
            }
          }else{
            debugPrint("receiveOxyListeners::>> no result found");
            *//* if (mounted) {
            _activityServiceProvider.updateEventResult(eventData, context);
           }*//*
          }
        }, onError: (error) {
      debugPrint("receiveOxyListenersError::>> " + error.toString());
    }, onDone: () {
      debugPrint("receiveOxyListenersOnDone::>> ");
    });*/
   // _activityServiceProvider.resumeOxygenListeners();
  }
  
  @override
  void dispose() {
    _activityServiceProvider.cancelBPEvents();
    _activityServiceProvider.resumeEventListeners();
    //_activityServiceProvider.pauseOxygenListeners();
    super.dispose();
  }
  
  Future<void> updateOxygenData(dynamic addData) async {
    DateTime dateTime = DateTime.now();
    if (oxygenData != null) {

      debugPrint('oxygenDataLength>> ${oxygenData.length}');
      String oxyValue = addData['value'].toString();
      String oxyTime = addData['time'].toString();
      String oxyCalender = addData['calender'].toString();
      String oxyDateTime = _activityServiceProvider.getTimeByCalenderTime(oxyCalender, oxyTime);

      oxygenData.add(addData);

      debugPrint('oxygenDataAfterLength>> ${oxygenData.length}');
      await setDateTitle(dateTime);
      Navigator.pop(context);
    // Utils.showToastMessage(context,Utils.tr(context, 'string_test_completed'));
      _activityServiceProvider.updateOxygenSaturation(oxyValue, oxyDateTime);
    }
  }

  Future<void> initializeOxygenData() async {
    String oxyData  = _activityServiceProvider.getOverAllOxygenData;
    setState(() {
      if (oxyData!=null && oxyData.isNotEmpty) {
        oxygenData = jsonDecode(oxyData.toString());
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
      if (oxygenData != null) {
        List<BandOxygenModel> smartOxygenList = await _activityServiceProvider.getCurrentDayOxygenData(oxygenData, calender);
        debugPrint('smartOxygenList>> $smartOxygenList -- ${smartOxygenList.length}');
        if (smartOxygenList.isNotEmpty) {
          List<CommonBandModel> dataRepList = [];
          //List<double> dataPointsList =[];
          int sumOfDataPoints = 0;
          int largestValue = int.parse(smartOxygenList[0].value);
          int smallestValue = int.parse(smartOxygenList[0].value);

          String currentValue = smartOxygenList[smartOxygenList.length - 1].value;

          for (var element in smartOxygenList) {
            List<String> times = element.time.split(':');
            DateTime _dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, int.tryParse(times[0])!, int.tryParse(times[1])!);
            //final dateTime = DateTime.parse(element.time);
            int dataPoint = int.parse(element.value);
            //debugPrint('oxyDataPoint>> $dataPoint');
            if (dataPoint > largestValue) {
              largestValue = dataPoint;
            }
            if (dataPoint < smallestValue) {
              smallestValue = dataPoint;
            }
            // dataPointsList.add(dataPoint);
            sumOfDataPoints = sumOfDataPoints + dataPoint;
           // dataRepList.add(DayDataRep(time: _dateTime, dataPoint: dataPoint, color: inCompletedColor));
            dataRepList.add(CommonBandModel(time: _dateTime, dataPoint: dataPoint, color:oxygenColorLight));
          }

          double average = (sumOfDataPoints / smartOxygenList.length);
          showCalculateData(currentValue, average.toInt().toString(), largestValue.toInt().toString(), smallestValue.toInt().toString());

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
      debugPrint('setOxyTitleException:: $e');
    }
  }

  void showCalculateData(String currentValue, String  average, String largestValue, String smallestValue) {
    debugPrint('average >> $average');
    debugPrint('largestValue >> $largestValue');
    debugPrint('smallestValue >> $smallestValue');
    setState(() {
      currentOxygen = currentValue;
      maxOxygenValue = largestValue;
      minOxygenValue = smallestValue;
    });
  }

  bool checkIsTodayAvail(DateTime todayTime, DateTime currentDayDateTime) {
    bool tempFlag = false;
    if (todayTime.toString().substring(0, 10).trim() == currentDayDateTime.toString().substring(0, 10).trim()) {
      tempFlag = true;
    }
    return tempFlag;
  }

  void refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: oxygenColorDark,
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
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.06, left: 10,right: 10),
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: const Color(0xff2786fb),// // background
            onPrimary: Colors.white, // foreground
            onSurface: const Color(0xFFCCCCCC),
            textStyle: const TextStyle(fontSize: 18.0),
          ),
          onPressed: () async {
            bool isConnected = await _activityServiceProvider.checkIsDeviceConnected();
            if (isConnected) {
              await startOxygenTest();
            }else{
              retryConnection(context);
            }
          },
          child: const Text(textStart,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          // color: Colors.blue,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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
                        color: isNextDisable ? Colors.grey.withOpacity(0.5) : Colors.black),
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
                  majorTickLines: const MajorTickLines(size: 4),

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
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/fit/blood_oxygen.png',
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  width: 4.0,
                ),
                // Text('77 Times/minutes'),
                Text('$currentOxygen %',style: const TextStyle(
                  fontWeight: FontWeight.bold
                ),),
              ],
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
                  /*Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(2.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(Utils.tr(context, 'string_avg_heart_rate'), textAlign: TextAlign.center, style:  const TextStyle(
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
                  ),*/
                  Expanded(
                    child: Container(
                      margin:const EdgeInsets.all(2.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(textMinOxygen, textAlign: TextAlign.center, style:  TextStyle(
                              // color: Colors.blue,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.0,
                            ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(minOxygenValue.toString(), textAlign: TextAlign.center,
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
                            padding: EdgeInsets.all(8.0),
                            child: Text(textMaxOxygen, textAlign: TextAlign.center, style:  TextStyle(
                              // color: Colors.blue,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.0,
                            ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(maxOxygenValue.toString(), textAlign: TextAlign.center,
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
            // Text('$avgHeartRate, $minHeartRate, $maxHeartRate'),
          ],
        ),
      ),
    );
  }
  Future<void> startOxygenTest() async {
    String status = await _activityServiceProvider.startOxygenTest();
    if (status == BandFitConstants.SC_INIT) {
      //Utils.showWaiting(context, false);
    // Utils.showToastMessage(context, Utils.tr(context, 'string_text_test_started'));
    } else if (status == BandFitConstants.SC_DISCONNECTED) {
      // disconnected
    } else if (status == BandFitConstants.SC_NOT_SUPPORTED) {
      // disconnected
    // Utils.showToastMessage(context, Utils.tr(context, 'oxy_not_support'));
    }
  }
  List<LineSeries<CommonBandModel, DateTime>> getSeriesDataList(DateTime currentDateTime) {
    return [
      LineSeries<CommonBandModel, DateTime>(
        name: currentDateTime.toString().substring(0, 10),
        dataSource: _dataRepresentList,
        xValueMapper: (CommonBandModel x, int xx) => x.time,
        yValueMapper: (CommonBandModel sales, _) => sales.dataPoint,
       // color: inCompletedColor,
        color: oxygenColorLight,
        //pointColorMapper: (datum, index) =>  datum.color,
        markerSettings: const MarkerSettings(isVisible: true),
      )
    ];
  }

  void retryConnection(BuildContext context) {
    GlobalMethods.showAlertDialogWithFunction(context, deviceDisconnected, deviceDisconnectedMsg, reconnectText, () async {
      debugPrint("pressed_ok");
      Navigator.of(context).pop();
      //Utils.showLoading(context, false, title: reconnectingText);
      bool statusReconnect = await _activityServiceProvider.connectDeviceWithMacAddress(context);
      setState(() {
        statusReconnected = statusReconnect;
      });
    });
  }
}

