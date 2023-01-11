import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:get/get.dart';

class TemperatureDetails extends StatefulWidget {
  final String displayTitle;
  final String activityLabel;

  const TemperatureDetails({Key? key, required this.displayTitle, required this.activityLabel}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TemperatureDetailsState();
  }
}

class TemperatureDetailsState extends State<TemperatureDetails> {
  DateTime todayTime = DateTime.now();
  DateTime currentDateTime = DateTime.now();

  String dateTitle = '';
  bool isNextDisable = true;

  String avgTemperature = '--', maxTemperature = '--', minTemperature = '--';
  String recentTemperature = '--';
  bool statusReconnected = false;
  List temperatureData = [];

   final  _activityServiceProvider = Get.put(ActivityServiceProvider());
  late TooltipBehavior _tooltipBehavior;

  List<CommonDataResult> _dataRepresentList = [];

  String tempUnits = '';
  bool isTempCelsius = false;

  @override
  void dispose() {
    _activityServiceProvider.cancelBPEvents();
    _activityServiceProvider.resumeEventListeners();
    //_activityServiceProvider.pauseTemperatureListeners();
    super.dispose();
  }

  @override
  void initState() {
  // _activityServiceProvider = Provider.of<ActivityServiceProvider>(context, listen: false);
    isTempCelsius = _activityServiceProvider.getIsCelsius;
    tempUnits = isTempCelsius ? tempInCelsius : tempInFahrenheit;
    _tooltipBehavior = TooltipBehavior(enable: true, canShowMarker: false);
    super.initState();

    // listenTempResults();
    Future.delayed(Duration.zero, () {
      listenTempResults();
      initializeTempData();
    });
    //initializeTempData();
  }

  Future<void> listenTempResults() async {

    _activityServiceProvider.pauseEventListeners();

    _activityServiceProvider.receiveBPListeners(onDataUpdate: (data) async {
      debugPrint("receiveTemperatureListeners>> $data");
      var eventData = jsonDecode(data);
      String result = eventData['result'].toString();
      String status = eventData['status'].toString();
      var jsonData = eventData['data'];
      print('tempJsonData>>$jsonData');

      if (result == BandFitConstants.DEVICE_CONNECTED){
        if (status == BandFitConstants.SC_SUCCESS) {
          if (statusReconnected) {
            Navigator.pop(context);
            await startTemperatureTest();
          }
        }
      }else if (result == BandFitConstants.TEMP_RESULT) {
        if (status == BandFitConstants.SC_SUCCESS) {
          if (jsonData != null) {
            updateTemperatureData(jsonData);
          }
        }
      } else if (result == BandFitConstants.TEMP_TEST_OK) {
        if (status == BandFitConstants.SC_SUCCESS) {
        }
      } else if (result == BandFitConstants.TEMP_TEST_TIME_OUT) {
        if (status == BandFitConstants.SC_SUCCESS) {
          Navigator.pop(context);
        // Utils.showToastMessage(context, 'Temperature Test TimeOut !');
        }
      } else {
        debugPrint("receiveTemperatureListeners::>> no result found");
      }
    }, onError: (error) {
      debugPrint("receiveTemperatureListenersError::>> $error");
    }, onDone: () {
      debugPrint("receiveTemperatureListenersOnDone::>> ");
    });
    _activityServiceProvider.resumeBPListeners();

    // resume temp listeners
    /*_activityServiceProvider.receiveTemperatureListeners(
        onDataUpdate: (data) {
      debugPrint("receiveTemperatureListeners>> " + data.toString());
      var eventData = jsonDecode(data);
      String result = eventData['result'].toString();
      String status = eventData['status'].toString();
      var jsonData = eventData['data'];
      if (result == BandFitConstants.TEMP_RESULT) {
        if (status == BandFitConstants.SC_SUCCESS) {
          if (jsonData!=null) {
            updateTemperatureData(jsonData);
          }
          */ /* String inCelsius = jsonData['inCelsius'].toString() ?? '-';
          String inFahrenheit = jsonData['inFahrenheit'].toString() ?? '-';
          String startDate = jsonData['startDate'].toString();
          String time = jsonData['time'].toString();
          String calender = jsonData['calender'].toString();*/ /*
          // String dateTime = getTimeByCalenderTime(calender, time);
          // updateTemperature(inCelsius, inFahrenheit, dateTime);
        }
      } else if (result == BandFitConstants.TEMP_TEST_OK) {
        if (status == BandFitConstants.SC_SUCCESS) {
          // _activityServiceProvider.fetchAllJudgement();
          //_activityServiceProvider.set24HrHeartRate(true);
          //_activityServiceProvider.updateDeviceBandLanguage();
        }
      } else if (result == BandFitConstants.TEMP_TEST_TIME_OUT) {
        if (status == BandFitConstants.SC_SUCCESS) {
          Navigator.pop(context);
        // Utils.showToastMessage(context,'Temperature Test TimeOut !');
        }
      } else {
        debugPrint("receiveTemperatureListeners::>> no result found");
        */ /* if (mounted) {
          _activityServiceProvider.updateEventResult(eventData, context);
        }*/ /*
      }
    }, onError: (error) {
      debugPrint("receiveTemperatureListenersError::>> " + error.toString());
    }, onDone: () {
      debugPrint("receiveTemperatureListenersOnDone::>> ");
    });
    _activityServiceProvider.resumeTemperatureListeners();*/
  }

  Future<void> initializeTempData() async {
    String tempData = _activityServiceProvider.getOverAllTempData;
    setState(() {
      if (tempData != null && tempData.isNotEmpty) {
        temperatureData = jsonDecode(tempData.toString()) as List;
      }
    });
    await setDateTitle(todayTime);
  }

  Future<void> setDateTitle(DateTime dateTime) async {
    String firstDay = dateTime.day.toString();
    String month = calMonths[dateTime.month - 1];
    String week = calWeeks[dateTime.weekday - 1];
    setState(() {
      dateTitle = '$firstDay, $month ($week)';
    });
    try {
      String calender = GlobalMethods.convertBandReadableCalender(dateTime);
      if (temperatureData != null) {
        List<BandTempModel> smartTempList = await _activityServiceProvider.getCurrentDayTemperatureData(temperatureData, calender);
        debugPrint('smartTempList>> ${smartTempList.length}');
        if (smartTempList.isNotEmpty) {
          List<CommonDataResult> dataRepList = [];

          double sumOfDataPoints = 0;
          double largestValue = isTempCelsius ? double.tryParse(smartTempList[0].inCelsius)! : double.tryParse(smartTempList[0].inFahrenheit)!;
          double smallestValue = isTempCelsius ? double.tryParse(smartTempList[0].inCelsius)! : double.tryParse(smartTempList[0].inFahrenheit)!;
          String currentValue = isTempCelsius ? smartTempList[smartTempList.length - 1].inCelsius : smartTempList[smartTempList.length - 1].inFahrenheit;

          for (var element in smartTempList) {
            List<String> times = element.time.split(':');
            DateTime _dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, int.tryParse(times[0])!, int.tryParse(times[1])!);
            //final dateTime = DateTime.parse(element.time);
            double dataPoint = isTempCelsius ? double.tryParse(element.inCelsius)! : double.tryParse(element.inFahrenheit)!;
            if (dataPoint > largestValue) {
              largestValue = dataPoint;
            }
            if (dataPoint < smallestValue) {
              smallestValue = dataPoint;
            }
            // dataPointsList.add(dataPoint);
            sumOfDataPoints = sumOfDataPoints + dataPoint;
            dataRepList.add(CommonDataResult(
                time: _dateTime,
                dataPoint: dataPoint,
                color: temperatureColor));
          }

          double average = (sumOfDataPoints / smartTempList.length);

          setState(() {
            _dataRepresentList = dataRepList;
            recentTemperature = double.tryParse(currentValue)!.toStringAsFixed(1);
            avgTemperature = average.toStringAsFixed(1);
            minTemperature = smallestValue.toStringAsFixed(1);
            maxTemperature = largestValue.toStringAsFixed(1);
          });
        } else {
          setState(() {
            _dataRepresentList = [];
            recentTemperature = "--";
            avgTemperature = "--";
            minTemperature = "--";
            maxTemperature = "--";
          });
        }
      } else {
        setState(() {
          _dataRepresentList = [];
          recentTemperature = "--";
          avgTemperature = "--";
          minTemperature = "--";
          maxTemperature = "--";
        });
      }
    } catch (e) {
      debugPrint('setTempTitleException:: $e');
    }
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //backgroundColor: Colors.white,
        // backgroundColor: Colors.lightBlueAccent,
        backgroundColor: temperatureColor,
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
              DateTime data = await GlobalMethods.selectCalenderDate(
                  context, DateTime.now());
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
        /* bottom: TabBar(
          labelColor: Colors.blueGrey,
          unselectedLabelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.label,
          indicator: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0)),
              color: Colors.white),
          tabs: _buildTabs(),
        ),*/
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.06,
            left: 10,
            right: 10),
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: const Color(0xff2786fb), // background
            onPrimary: Colors.white, // foreground
            onSurface: const Color(0xFFCCCCCC),
            textStyle: const TextStyle(fontSize: 18.0),
          ),
          onPressed: () async {
            bool isConnected = await _activityServiceProvider.checkIsDeviceConnected();
            if (isConnected) {
              await startTemperatureTest();
              // String status = await _activityServiceProvider.startTestTempData();
              // if (status != null) {
              //   if (status == BandFitConstants.SC_INIT) {
              //     Utils.showWaiting(context, false);
              //   } else if (status == BandFitConstants.SC_NOT_SUPPORTED) {
              //     temperatureNotSupported(context);
              //   } else {
              //     temperatureNotSupported(context);
              //   }
              // }
            } else {
              retryConnection(context);
            }
          },
          child: const Text(
            textStart, //"Start",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          // color: Colors.blue,
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.max,
          children: [
            /* SizedBox(
              height: 4.0,
            ),*/
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text(widget.activityLabel,
                textAlign: TextAlign.center,
              )),
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
                      DateTime time =
                          GlobalMethods.getOneDayBackward(currentDateTime);
                      setState(() {
                        isNextDisable = false;
                        currentDateTime = time;
                      });
                      setDateTitle(currentDateTime);
                    },
                    icon: const Icon(Icons.arrow_back_ios_outlined,
                        color: Colors.black),
                  ),
                  Center(
                    child: Text(
                      dateTitle,
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w600),
                    ),
                  ),
                  IconButton(
                    iconSize: 20,
                    onPressed: isNextDisable
                        ? null
                        : () async {
                            DateTime nextDate =
                                GlobalMethods.getOneDayForward(currentDateTime);
                            setState(() {
                              if (checkIsTodayAvail(todayTime, nextDate)) {
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
              margin:
                  const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
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
                  majorTickLines: const MajorTickLines(size: 2),
                  // dateFormat: DateFormat('''h:mm\na'''),
                  // minimum: DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day,0,0,0),
                  // maximum: DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day,24,0,0),
                  labelIntersectAction: AxisLabelIntersectAction.wrap,
                  labelAlignment: LabelAlignment.center,
                  intervalType: DateTimeIntervalType.minutes,

                  /*title: AxisTitle(
              text: isCardView ? '' : 'Start time',
            ),*/
                ),
                primaryYAxis: NumericAxis(
                  majorTickLines: const MajorTickLines(size: 2),
                  //interval: 1000,
                  // minimum: 30,
                  // maximum: 200,
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
                            child: Text(
                              textMinTemperature,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                // color: Colors.blue,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text('$minTemperature $tempUnits',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400)),
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
                      margin: const EdgeInsets.all(2.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              textMaxTemperature,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                // color: Colors.blue,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text('$maxTemperature $tempUnits',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            const Text(textRecentTemperature,
                style:
                    TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
            const SizedBox(
              height: 8.0,
            ),
            Text('$recentTemperature $tempUnits',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
            const SizedBox(
              height: 16.0,
            ),
            const Card(
              //elevation: 5,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text( tempString,
                    textAlign: TextAlign.justify),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            const Card(
              //elevation: 5,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text( tempDisclaimer,
                    textAlign: TextAlign.justify),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> startTemperatureTest() async {
    String status = await _activityServiceProvider.startTestTempData();
    if (status != null) {
      if (status == BandFitConstants.SC_INIT) {
        //Utils.showWaiting(context, false);
      // Utils.showToastMessage(context, Utils.tr(context, 'string_text_test_started'));
      } else if (status == BandFitConstants.SC_NOT_SUPPORTED) {
        temperatureNotSupported(context);
      } else {
        temperatureNotSupported(context);
      }
    }
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

  void temperatureNotSupported(BuildContext context) {
    GlobalMethods.showAlertDialogWithFunction(context, textTempNotSupported, textTempNotSupportedMsg, okText, () async {
      debugPrint("pressed_ok");
      Navigator.of(context).pop();
    });
  }

  List<ColumnSeries<CommonDataResult, DateTime>> getSeriesDataList(
      DateTime currentDateTime) {
    return [
      ColumnSeries<CommonDataResult, DateTime>(
          name: currentDateTime.toString().substring(0, 10),
          dataSource: _dataRepresentList,
          xValueMapper: (CommonDataResult x, int xx) => x.time,
          yValueMapper: (CommonDataResult sales, _) => sales.dataPoint,
          color: temperatureColor,
          width: 0.03
          //pointColorMapper: (datum, index) =>  datum.color,
          // markerSettings: const MarkerSettings(isVisible: true),
          )
    ];
    /*return [
      new LineSeries<DayDataRep, DateTime>(
        name: currentDateTime.toString().substring(0, 10),
        dataSource: _dataRepresentList,
        xValueMapper: (DayDataRep x, int xx) => x.time,
        yValueMapper: (DayDataRep sales, _) => sales.dataPoint,
        color: temperatureColor,
        //width: 25.0
        //pointColorMapper: (datum, index) =>  datum.color,
        // markerSettings: const MarkerSettings(isVisible: true),
      )
    ];*/
  }

  Future<void> updateTemperatureData(var jsonData) async {
    DateTime dateTime = DateTime.now();
    if (temperatureData != null) {
      temperatureData.add(jsonData);
      await setDateTitle(dateTime);
      Navigator.pop(context);
    // Utils.showToastMessage(context, '${Utils.tr(context, 'string_test_completed')} !!!');
      await _activityServiceProvider.updateTemperatureWithData(jsonData, temperatureData, dateTime);
    }
  }
}


