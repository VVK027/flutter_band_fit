/*
import 'package:flutter_band_fit_app/common/common_imports.dart';

class AppleGoogleBind extends StatefulWidget {

  final String deviceTypeName;
  const AppleGoogleBind({Key? key, required this.deviceTypeName}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() {
    return AppleGoogleBindState();
  }
}

class AppleGoogleBindState extends State<AppleGoogleBind> {

  bool isBounded = false;
  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;
  ActivityServiceProvider _myActivityServiceProvider;
  HealthFactory health = HealthFactory();

  bool physicalActStatus = false;
  bool locationPermission = false;

  @override
  void initState() {
    super.initState();
    _myActivityServiceProvider = Provider.of<ActivityServiceProvider>(context, listen: false);
    // ask permissions for the physical activities, etc.
    initialize();
  }

  Future<bool> initialize() async {
    bool physicalAct = await Permissions.askPhysicalGranted();
    bool locationGranted = await Permissions.locationPermissionsGranted();
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

    var fiftyDaysFromNow = endDateTime.subtract(const Duration(days: 1));

    HealthFactory health = HealthFactory();

    // define the types to get
    List<HealthDataType> types = [
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.SLEEP_AWAKE,
      HealthDataType.HEART_RATE,
      HealthDataType.STEPS,
      HealthDataType.BLOOD_OXYGEN,
      HealthDataType.BODY_TEMPERATURE,
      HealthDataType.SLEEP_IN_BED,
      HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    ];
    final permissions = [
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
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
        Utils.showWaiting(context, false);
        // fetch new data
        List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(fiftyDaysFromNow, endDateTime, types);
        debugPrint('healthData $healthData');
        // save all the new data points
        if(healthData.isNotEmpty){
          _healthDataList.addAll(healthData);
          HealthDataPoint p = _healthDataList[0];
          _myActivityServiceProvider.updateUserDeviceConnection(true, false, widget.deviceTypeName, p.sourceName);
        }else{
          _myActivityServiceProvider.updateUserDeviceConnection(true, false, widget.deviceTypeName, widget.deviceTypeName);
        }
        Navigator.pop(context);
        setState(() {
          isBounded = true;
        });
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
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => GFitVitalMain(fromLogin: false)), (_) => false);
    }else {
      debugPrint('goDashboard_inside_else');
      //if(!Platform.isIOS){
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => VitalMain(fetchWeather: false, fromLogin: false,)), (_) => false);
     // }else{
     //   Navigator.pop(context);
     // }

    }
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => GFitVitalMain()),
    // );
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
          //  Platform.isIOS ? 'Apple Health' : 'Google Fit',
            Platform.isIOS ? Utils.tr(context, 'string_text_apple_health') :Utils.tr(context, 'string_text_google_fit'),
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
            onPressed: () => goDashboardPage(),
          ),
          */
/* actions: [
            IconButton(
              icon: Icon(Icons.refresh_outlined, color: Colors.black),
              onPressed: () {},
            ),
          ],*//*

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
                child: Text(Platform.isIOS ? Utils.tr(context, 'string_text_apple_health') : Utils.tr(context, 'string_text_google_fit'),
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
                        child: Text(Platform.isIOS ? Utils.tr(context, 'string_text_apple_health') : Utils.tr(context, 'string_text_google_fit'),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      ),

                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(isBounded ? Utils.tr(context, 'string_text_unbound') : Utils.tr(context, 'string_text_bound'),
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
              */
/*Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ]
                ),
              ),*//*

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
  AUTH_NOT_GRANTED
}
*/
