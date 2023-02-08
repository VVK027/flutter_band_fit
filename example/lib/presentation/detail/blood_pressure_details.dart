import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BloodPressureDetails extends StatefulWidget {
  final String displayTitle;
  final String activityLabel;

  const BloodPressureDetails({Key? key, required this.displayTitle, required this.activityLabel}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BloodPressureDetailsState();
  }
}

class BloodPressureDetailsState extends State<BloodPressureDetails> {

  DateTime todayTime = DateTime.now();
  DateTime currentDateTime = DateTime.now();

  String dateTitle = '';
  bool isNextDisable = true;

  List<BPData> bpDataList =[];
  String highBPValue ='--', lowBPValue ='--';

  final  _activityServiceProvider = Get.put(ActivityServiceProvider());
  // TooltipBehavior _tooltipBehavior;
  List overAllBPData =[];
  // String lang;
  bool statusReconnected = false;

  @override
  void initState() {
    // _activityServiceProvider = Provider.of<ActivityServiceProvider>(context, listen: false);

    // _tooltipBehavior = TooltipBehavior(enable: true, canShowMarker: false);
    super.initState();
    listenResults();
    Future.delayed(Duration.zero, () {
      initializeBPData();
    });
  }

  Future<void> listenResults() async{
    // resume bp listeners
    _activityServiceProvider.pauseEventListeners();
    _activityServiceProvider.receiveBPListeners(
        onDataUpdate: (data)  async {
          debugPrint("receiveBPListeners>> $data");
          var eventData = jsonDecode(data);
          String result = eventData['result'].toString();
          String status = eventData['status'].toString();
          var jsonData = eventData['data'];
          debugPrint('jsonData>> $jsonData');
          if (result == BandFitConstants.DEVICE_CONNECTED){
            if (status == BandFitConstants.SC_SUCCESS) {
              if (statusReconnected) {
                GlobalMethods.navigatePopBack();
                await startBPTest();
              }
            }
          }else if (result == BandFitConstants.BP_TEST_STARTED) {
            if (status == BandFitConstants.SC_SUCCESS) {
              // Utils.showToastMessage(context,'Test Started');
              // Utils.showToastMessage(context,Utils.tr(context, 'string_text_test_started'));
            }
          }else if (result == BandFitConstants.BP_TEST_FINISHED){
            if (status == BandFitConstants.SC_SUCCESS) {
              GlobalMethods.navigatePopBack();
            }
          }else if(result == BandFitConstants.BP_TEST_TIME_OUT){
            GlobalMethods.navigatePopBack();
            //Utils.showToastMessage(context,'BP Test TimeOut !');
            // Utils.showToastMessage(context,Utils.tr(context, 'string_bp_test_time_out'));
          }else if(result == BandFitConstants.BP_TEST_ERROR){
            GlobalMethods.navigatePopBack();
            //Utils.showToastMessage(context,'Something went wrong, retry again..!');
            // Utils.showToastMessage(context,Utils.tr(context, 'string_something_went_wrong'));
          }else if (result == BandFitConstants.BP_RESULT){
            if (status == BandFitConstants.SC_SUCCESS) {
              String high = jsonData['high'].toString();
              String low = jsonData['low'].toString();
              String time = jsonData['time'].toString();
              if(high!=null ){
                updateBPData(high, low, time);
              }else{
                GlobalMethods.navigatePopBack();
              }
            }
          }else{
            debugPrint("receiveBPListeners::>> no result found");
            /* if (mounted) {
          _activityServiceProvider.updateEventResult(eventData, context);
        }*/
          }
        }, onError: (error) {
      debugPrint("receiveBPListenersError::>> $error");
    }, onDone: () {
      debugPrint("receiveBPListenersOnDone::>> ");
    });
    _activityServiceProvider.resumeBPListeners();
  }

  Future<void> initializeBPData() async{
    String bpData  = _activityServiceProvider.getOverAllBPData;
    setState(() {
      if (bpData!=null && bpData.isNotEmpty) {
        overAllBPData = jsonDecode(bpData.toString()) as List;
        // debugPrint('overAllBPData>>$overAllBPData');
      }
    });
    await setDateTitle(todayTime);
  }

  Future<void> setDateTitle(DateTime dateTime) async{
    debugPrint('dateTime112>>$dateTime');
    String firstDay = dateTime.day.toString();
    // String month = tempCalenderMonth[dateTime.month - 1];
    // String week = tempCalenderWeek[dateTime.weekday - 1];
    String month = calMonths[dateTime.month - 1];
    String week = calWeeks[dateTime.weekday - 1];
    setState(() {
      dateTitle = '$firstDay, $month ($week)';
    });
    try{
      String calender = GlobalMethods.convertBandReadableCalender(dateTime);
      if (overAllBPData != null) {
        debugPrint('calender124>>$calender');
        List<BandBPModel> smartBPModelList = await _activityServiceProvider.getCurrentDayBPData(overAllBPData, calender);
        debugPrint('smartBPModelList>>${smartBPModelList.length}');
        if (smartBPModelList.isNotEmpty) {
          String highPressure = smartBPModelList[smartBPModelList.length-1].high;
          String lowPressure = smartBPModelList[smartBPModelList.length-1].low;

          List<BPData> bpDataRepList = [];
          for (var element in smartBPModelList) {
            debugPrint('element.time>>${element.time}');
            List<String> times = element.time.split(':');
            DateTime _dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, int.tryParse(times[0])!, int.tryParse(times[1])!);
            bpDataRepList.add(BPData(highPressure: element.high, lowPressure: element.low, time: _dateTime));
          }

          setState(() {
            bpDataList = bpDataRepList;
            highBPValue = highPressure;
            lowBPValue = lowPressure;
          });

        }else{
          setState(() {
            bpDataList = [];
            highBPValue = '--';
            lowBPValue = '--';
          });
        }
      }else{
        //handle empty if no data
        setState(() {
          bpDataList = [];
          highBPValue = '--';
          lowBPValue = '--';
        });
      }
    }catch(e){
      debugPrint('setBPTitleException: $e');
    }
  }

  @override
  void dispose() {
    _activityServiceProvider.cancelBPEvents();
    _activityServiceProvider.resumeEventListeners();
    super.dispose();
    // pause bp listeners
    //_activityServiceProvider.cancelEventListeners();
  }

  bool checkIsTodayAvail(DateTime todayTime, DateTime currentDayDateTime) {
    bool tempFlag = false;
    if (todayTime.toString().substring(0,10).trim() == currentDayDateTime.toString().substring(0,10).trim()) {
      tempFlag = true;
    }
    return  tempFlag;
  }

  /*goDashboardPage() {
    // Navigator.push(context, MaterialPageRoute(builder: (context) => VitalMain()));
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) => VitalMain()),
            (_) => false);

  }*/

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //backgroundColor: Colors.white,
        //backgroundColor: Colors.lightBlueAccent, // #EE7453
        backgroundColor: bpColor,
        elevation: 2,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
          //  onPressed: () => goDashboardPage(),
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
                setDateTitle(currentDateTime);
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
              await startBPTest();
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
        scrollDirection: Axis.vertical,
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text(widget.activityLabel, textAlign: TextAlign.center,)),
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
                      setDateTitle(currentDateTime);
                    },
                    icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
                  ),
                  Center(child: Text(dateTitle, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),),),
                  IconButton(
                    iconSize: 20,
                    onPressed: isNextDisable ? null : () async {
                      DateTime nextDate = GlobalMethods.getOneDayForward(currentDateTime);
                      setState(() {
                        if(checkIsTodayAvail(todayTime, nextDate))
                        {
                          isNextDisable = true;
                        }
                        currentDateTime = nextDate;
                      });
                      setDateTitle(currentDateTime);
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
                  majorTickLines: const MajorTickLines(size: 4,width: 1),
                  //dateFormat: DateFormat('''h:mm\na'''),
                  labelIntersectAction: AxisLabelIntersectAction.wrap,
                  minimum: DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day,0,0,0),
                  maximum: DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day,24,00,0),
                  labelAlignment: LabelAlignment.center,
                  intervalType: DateTimeIntervalType.minutes,
                  /*title: AxisTitle(
                text: isCardView ? '' : 'Start time',
              ),*/
                ),
                primaryYAxis: NumericAxis(
                  majorTickLines: const MajorTickLines(size: 0),
                  interval: 50,
                  minimum: 50,
                  maximum: 200,
                  axisLine: const AxisLine(width: 0),
                  labelFormat: '{value}',
                  /* title: AxisTitle(
                text: isCardView ? '' : 'Duration in minutes',
              ),*/
                ),
                series: getRangeDataList(currentDateTime),
                // for the default tool tip behaviour
                //  tooltipBehavior: _tooltipBehavior,
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
                    lineWidth: 0
                ),
              ),
            ),
            const SizedBox(
              height: 4.0,
            ),
            Container(
              padding: const EdgeInsets.all(4.0),
              width: double.infinity,
              child: Card(
                // margin:const EdgeInsets.all(2.0),
                // elevation: 0.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(2.0),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text(textHighPressure, textAlign: TextAlign.center, style:  TextStyle(
                                // color: Colors.blue,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                              ),),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text('$highBPValue $bpUnits',  textAlign: TextAlign.center,style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)
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
                              child: Text(textLowPressure, textAlign: TextAlign.center, style:  TextStyle(
                                // color: Colors.blue,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                              ),),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text('$lowBPValue $bpUnits', textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 4.0,
            ),
            Visibility(
              visible:  bpDataList.isNotEmpty ? true : false,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                margin:const EdgeInsets.all(2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.auto_graph_outlined,
                        color: Colors.amber,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text("$textTodayData (${bpDataList.length})"),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16.0, bottom: 2.0),
              padding: const EdgeInsets.all(4.0),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      child: const Text(textTime, textAlign: TextAlign.center, softWrap: true, style:  TextStyle(
                        // color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0,
                      ),),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.only(left: 24.0),
                      padding: const EdgeInsets.all(4.0),
                      child: const Text(textHighPressure, softWrap: true, textAlign: TextAlign.center, style:  TextStyle(
                        // color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0,
                      ),),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      child: const Text(textLowPressure,
                        textAlign: TextAlign.center, softWrap: true, style:  TextStyle(
                          // color: Colors.blue,
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                        ),),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: bpDataList.length,
                itemBuilder: (context, index) {
                  return  Container(
                    margin: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          //flex: 1,
                          child: Container(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(DateFormat.jm().format(bpDataList[index].time).toString(), textAlign: TextAlign.center, softWrap: true, style:  const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                            ),),
                          ),
                        ),
                        Expanded(
                          //flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: [
                                Text(bpDataList[index].highPressure,  textAlign: TextAlign.center, softWrap: true, style:  const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                ),),
                                const Text(' $bpUnits'),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          //flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: [
                                Text(bpDataList[index].lowPressure,  textAlign: TextAlign.center, softWrap: true, style:  const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                ),),
                                const Text(' $bpUnits'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            /* Visibility(
              visible:  bpDataList.isNotEmpty ? true : false,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      margin:const EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.auto_graph_outlined,
                              color: Colors.amber,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text("${Utils.tr(context, 'string_today_data')} (${bpDataList.length})"),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      //flex: 2,
                      fit: FlexFit.loose,
                      child: Container(
                        margin: const EdgeInsets.only(left: 16.0, bottom: 2.0),
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(Utils.tr(context, 'string_time'), textAlign: TextAlign.center, style:  const TextStyle(
                                // color: Colors.blue,
                                fontWeight: FontWeight.w600,
                                fontSize: 18.0,
                              ),),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 24.0),
                              padding: const EdgeInsets.all(4.0),
                              child: Text(Utils.tr(context, 'string_high_pressure'), softWrap: true, textAlign: TextAlign.center, style:  const TextStyle(
                                // color: Colors.blue,
                                fontWeight: FontWeight.w600,
                                fontSize: 18.0,
                              ),),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(Utils.tr(context, 'string_low_pressure'),
                                textAlign: TextAlign.center, softWrap: true,style:  const TextStyle(

                                  // color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.0,
                                ),),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      //flex: 1,
                      fit: FlexFit.loose,
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: bpDataList.length,
                          itemBuilder: (context, index) {
                            return  Container(
                              margin: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(DateFormat.jm(lang).format(bpDataList[index].time).toString(), textAlign: TextAlign.center, style:  const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0,
                                    ),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      children: [
                                        Text(bpDataList[index].highPressure,  textAlign: TextAlign.center, style:  const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0,
                                        ),),
                                        const Text(' '+bpUnits),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      children: [
                                        Text(bpDataList[index].lowPressure,  textAlign: TextAlign.center, style:  const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0,
                                        ),),
                                        const Text(' '+bpUnits),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                      ),
                    )
                  ],
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  Future<void> startBPTest() async {
    String status = await _activityServiceProvider.startBloodPressure();
    if (status == BandFitConstants.SC_INIT) {
      //Utils.showWaiting(context, false);
      // Utils.showToastMessage(context, Utils.tr(context, 'string_text_test_started'));
    }
  }

  void retryConnection(BuildContext context) {
    GlobalMethods.showAlertDialogWithFunction(context, deviceDisconnected, deviceDisconnectedMsg, reconnectText, () async {
      debugPrint("pressed_ok");
      //Navigator.of(context).pop();
      GlobalMethods.navigatePopBack();
      //Utils.showLoading(context, false, title: reconnectingText);
      bool statusReconnect = await _activityServiceProvider.connectDeviceWithMacAddress(context);
      print("statusReconnect>> $statusReconnect");
      setState(() {
        statusReconnected = statusReconnect;
      });
    });
  }

  List<RangeColumnSeries<BPData, DateTime>> getRangeDataList(DateTime currentDateTime) {
    return [
      RangeColumnSeries<BPData, DateTime>(
        dataSource: bpDataList,
        xValueMapper: (BPData datum, _) => datum.time,
        lowValueMapper: (BPData datum, _) => int.parse(datum.lowPressure),
        highValueMapper: (BPData datum, _) => int.parse(datum.highPressure),
        //color: inCompletedColor,
        color: bpColor,
        markerSettings: const MarkerSettings(
            color: Colors.black,
            width: 1
        ),
        // enableTooltip: true,
        width: 0.1,

      )
    ];

    /*return [
      new RangeColumnSeries<DayDataRep, DateTime>(
        name: currentDateTime.toString().substring(0, 10),
        dataSource: getSeriesData(currentDateTime),
        xValueMapper: (DayDataRep x, int xx) => x.time,
        yValueMapper: (DayDataRep sales, _) => sales.dataPoint,
        color: inCompletedColor,
        //pointColorMapper: (datum, index) =>  datum.color,
        // markerSettings: const MarkerSettings(isVisible: true),
      )
    ];*/
  }

  Future<void> updateBPData(String high, String low, String time) async {
    DateTime dateTime = DateTime.now();
    //debugPrint("hh: ${dateTime.hour} -- ${dateTime.minute}");
    //BPData data = BPData(highPressure: high, lowPressure: low, time: dateTime);
    if (overAllBPData != null) {
      String calender = GlobalMethods.convertBandReadableCalender(dateTime);
      String timeMin = "${dateTime.hour}:${dateTime.minute}";

      debugPrint('update>calender>>$calender');
      debugPrint('update>timeMin>>$timeMin');

      var addData = {
        "calender": calender,
        "time": Platform.isAndroid ? timeMin :time,
        "high": high,
        "low": low
      };
      debugPrint('addData>> $addData');
      overAllBPData.add(addData);
      await setDateTitle(dateTime);
      GlobalMethods.navigatePopBack();
      // Utils.showToastMessage(context,Utils.tr(context, 'string_test_completed'));
      await _activityServiceProvider.updateBPressureData(high, low,calender, timeMin, overAllBPData);
      //update bp in the backend.
    }
  }
}