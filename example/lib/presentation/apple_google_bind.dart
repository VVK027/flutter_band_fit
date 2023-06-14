import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:flutter_band_fit_app/presentation/vital_main.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'dart:developer';

class AppleGoogleBind extends StatefulWidget {

  final String deviceTypeName;
  const AppleGoogleBind({Key? key, required this.deviceTypeName}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AppleGoogleBindState();
  }
}

class AppleGoogleBindState extends State<AppleGoogleBind> {
  final  _myActivityServiceProvider = Get.put(ActivityServiceProvider());

  bool isBounded = false;
  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;
  HealthFactory health = HealthFactory();

  bool physicalActStatus = false;
  bool locationPermission = false;

  @override
  void initState() {
    super.initState();
    //_myActivityServiceProvider = Provider.of<ActivityServiceProvider>(context, listen: false);
    // ask permissions for the physical activities, etc.
    initialize();
  }
  Future<bool> askPhysicalGranted() async {
    var permission = await Permission.activityRecognition.status;
    print('permission>> $permission');
    if (permission.isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.activityRecognition.request().isGranted) {
      return true;
    } else {
      permission = await Permission.activityRecognition.request();
    }
    return permission.isGranted;
  }
  Future<bool> locationPermissionsGranted() async {
    var permission = await Permission.location.status;
    if (permission.isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.location.request().isGranted) {
      return true;
    } else {
      permission = await Permission.location.request();
    }
    return permission.isGranted;
  }

  Future<bool> initialize() async {
    bool physicalAct = await askPhysicalGranted();
    bool locationGranted = await locationPermissionsGranted();
    debugPrint('physicalAct>> $physicalAct');
    setState(() {
      physicalActStatus = physicalAct;
      locationPermission = locationGranted;
    });
    // if (physicalActStatus) {
    //
    // }
    return physicalAct && locationGranted;
  }
  // onresume please cross check the permissions

  Future<void> fetchData() async {

    DateTime endDateTime = DateTime.now();

    var fiftyDaysFromNow = endDateTime.subtract(const Duration(days: 10));

    HealthFactory health = HealthFactory();

    // define the types to get
    List<HealthDataType> types = [
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.SLEEP_AWAKE,
      HealthDataType.HEART_RATE,
      HealthDataType.STEPS,
      HealthDataType.BLOOD_OXYGEN,
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.BODY_TEMPERATURE,
      HealthDataType.SLEEP_IN_BED,
      HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      //HealthDataType.ELECTROCARDIOGRAM, only on IOS
      HealthDataType.WORKOUT,
    ];
    final permissions = [
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      //HealthDataAccess.READ,
      HealthDataAccess.READ,
    ];

    List<HealthDataType> sleepTypes = [
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.SLEEP_AWAKE,
      HealthDataType.SLEEP_IN_BED,
    ];

    setState(() => _state = AppState.FETCHING_DATA);
    debugPrint('setState $_state');
    bool accessWasGranted = await health.requestAuthorization(types, permissions: permissions);
    debugPrint('accessWasGranted>67>> $accessWasGranted');

    if (accessWasGranted) {
      try {
        // _myActivityServiceProvider.updateUserDeviceConnection(true, false, 'GoogleFit', '');
        debugPrint('widget.deviceTypeName>> ${widget.deviceTypeName}');

        //_myActivityServiceProvider.updateUserDeviceConnection(true, false, widget.deviceTypeName, '');
        // await GlobalMethods.setDeviceType('fitBand');
        //Utils.showWaiting(context, false);
        int? steps;
        try {
          steps = await health.getTotalStepsInInterval(fiftyDaysFromNow, endDateTime);
        } catch (error) {
          print("Caught exception in getTotalStepsInInterval: $error");
        }

        print('Total number of steps: $steps');

        // fetch new data
        List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(fiftyDaysFromNow, endDateTime, types);

        List<HealthDataPoint> healthSleepData = await health.getHealthDataFromTypes(fiftyDaysFromNow, endDateTime, sleepTypes);


        //debugPrint('healthSleepData $healthSleepData');
        debugPrint('healthData ${healthData.length}');
        debugPrint('healthSleepData ${healthSleepData.length}');


        // save all the new data points
        if(healthData.isNotEmpty){
          _healthDataList.addAll(healthData);
          _healthDataList.addAll(healthSleepData);
          _healthDataList = HealthFactory.removeDuplicates(_healthDataList);
          debugPrint('_healthDataList ${_healthDataList.length}');

          _healthDataList.forEach((HealthDataPoint dataPoint) {
            print('dataPoint.unit>> ${dataPoint.unit}');
            print('dataPoint.dataType>> ${dataPoint.type}');
            print('dataPoint.value>> ${dataPoint.value}');
          });
          //HealthDataPoint p = _healthDataList[0];
          // _myActivityServiceProvider.updateUserDeviceConnection(true, false, widget.deviceTypeName, p.sourceName);
        }else{
          // _myActivityServiceProvider.updateUserDeviceConnection(true, false, widget.deviceTypeName, widget.deviceTypeName);
        }
        //GlobalMethods.navigatePopBack();
        // setState(() {
        //   isBounded = true;
        // });
        //if(Platform.isIOS){
        // await GlobalMethods.setDeviceName('Apple Fit Band');
        // }else {
        // _myActivityServiceProvider.updateUserDeviceConnection(true, false, 'GoogleFit', p.sourceName);

        // await GlobalMethods.setDeviceName('Google Fit Band');
        // await GlobalMethods.setDeviceAddress(p.sourceName);
        //}
      } catch (e) {
        debugPrint("exception in fetching data: $e");
        debugPrint("Caught exception in getHealthDataFromTypes: $e");
      }

      // filter out duplicates
      _healthDataList = await HealthFactory.removeDuplicates(_healthDataList);
      if(mounted){
        setState(() {
          _state = _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
        });
      }
    }
    else {
      debugPrint("Authorization not granted");
      setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
  }

  goDashboardPage() {
    debugPrint('goDashboard>> ${widget.deviceTypeName}');
    //if(_myActivityServiceProvider.getDeviceSWName == 'GoogleFit'){
    if(_myActivityServiceProvider.getDeviceSWName == widget.deviceTypeName){
      debugPrint('goDashboard_inside_if');
      // Navigator.pushAndRemoveUntil(context,
      //     MaterialPageRoute(builder: (context) => GFitVitalMain(fromLogin: false)), (_) => false);

    }else {
      debugPrint('goDashboard_inside_else');
      // Get.offAll(const VitalMain());
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => goDashboardPage(),
      child: Scaffold(
        // backgroundColor: Colors.white,
        appBar: AppBar(
          // title: Text('Add Device'),
          backgroundColor: Colors.white,
          elevation: 2.0,
          title: Text(
            Platform.isIOS ? textAppleHealth : textGoogleFit,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
            onPressed: () => goDashboardPage(),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh_outlined, color: Colors.black),
              onPressed: () {},
            ),
          ],

        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 16.0,
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(4.0),
                padding: const EdgeInsets.all(4.0),
                child: Image.asset(
                  Platform.isIOS ? 'assets/fit/apple_health.png' : 'assets/fit/gfit.png',
                  width: 70.0,
                  height: 70.0,
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(4.0),
                padding: const EdgeInsets.all(4.0),
                child: Text(Platform.isIOS ? textAppleHealth : textGoogleFit,
                    style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w500)),
              ),

              const SizedBox(
                height: 20.0,
              ),
              GestureDetector(
                onTap: () async{
                  if(isBounded){
                    _myActivityServiceProvider.updateUserDeviceConnection(false, false, '', '');
                    // debugPrint('accessWasGranted $accessWasGranted');
                  }else {
                    if (physicalActStatus && locationPermission) {
                      await fetchData();
                    }else{
                      bool status = await initialize();
                      if (status) {
                        await fetchData();
                      }
                    }
                  }
                },
                child: Container(

                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all( Radius.circular(2.0)),
                      color: Colors.white,
                      //color: Color(0xFFFAFAFA), grey[50]
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0,1.0),
                            blurRadius: 1.0
                        )
                      ]
                  ),
                  // color: Colors.white,
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(Platform.isIOS  ? textAppleHealth : textGoogleFit,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      ),

                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(isBounded ? 'UnBound' : 'Bound',
                                style: TextStyle(fontSize: 16, color: Colors.blueGrey.withOpacity(0.7),fontWeight: FontWeight.w400)),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child:  Icon(
                              Icons.arrow_forward_ios,
                              size: 16.0,
                              color: Colors.blueGrey.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED,
  DATA_ADDED,
  DATA_NOT_ADDED,
  STEPS_READY,
}
