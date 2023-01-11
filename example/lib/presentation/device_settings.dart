import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:flutter_band_fit_app/custom/battery_indicator.dart';
import 'package:flutter_band_fit_app/presentation/add_device.dart';
import 'package:flutter_band_fit_app/presentation/detail/activity_monitor.dart';
import 'package:flutter_band_fit_app/presentation/detail/band_reminders.dart';
import 'package:flutter_band_fit_app/presentation/detail/dial_face_details.dart';
import 'package:flutter_band_fit_app/presentation/detail/do_not_disturb.dart';
import 'package:flutter_band_fit_app/presentation/firmware_upgrade.dart';
import 'package:flutter_band_fit_app/presentation/vital_main.dart';
import 'package:get/get.dart';


class DeviceSettings extends StatefulWidget {
  final bool fromLogin;

  const DeviceSettings({Key? key, required this.fromLogin}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DeviceSettingsState();
  }
}

class DeviceSettingsState extends State<DeviceSettings> {
  List<String> connectedDeviceList = [];
  List<String> savedDeviceList = [];
  final  _activityServiceProvider = Get.put(ActivityServiceProvider());

  @override
  void dispose() {
    // TODO: implement dispose
    //_activityServiceProvider.cancelEventListeners();
    super.dispose();
  }

  @override
  void initState() {
    debugPrint('device_connected_status>>${_activityServiceProvider.getDeviceConnected}');
    super.initState();
    if (_activityServiceProvider.getHealthConnected) {
      // gfit or apple fit

    } else {
      //addDeviceConnectionListener();
       fetchDeviceData();
    }
  }

  Future<void> fetchDeviceData() async {
    bool isConnected = await _activityServiceProvider.checkIsDeviceConnected();
    debugPrint('fetchDeviceData>>isConnected>> $isConnected');
    //Utils.showWaiting(context, false);
    if (isConnected) {
      // fetch the status from watch.
      //await _activityServiceProvider.fetchBatteryNVersionStatus();
      // bool statusVersion = await _activityServiceProvider.fetchDeviceVersion();
    } else {
      // load from the sp and show a reconnect popup.
     /* if (_activityServiceProvider.getDeviceConnected && _activityServiceProvider.getDeviceMacAddress.isNotEmpty) {
        retryConnection(context);
      }*/
      /*
        setState(() {
          isReconnect = true;
        });
      else{
        //show message "No Device is Connected."
        GlobalMethods.showAlertDialog(context, Utils.tr(context,noDeviceFoundHead),  Utils.tr(context,noDeviceFoundMessage));
      }*/
    }
    //Navigator.pop(context);
  }

  void retryConnection(BuildContext context) {
    GlobalMethods.showAlertDialogWithFunction(context, deviceDisconnected,
        deviceDisconnectedMsg, reconnectText, () async {
      //debugPrint("pressed_ok");
      Navigator.of(context).pop();
      //Utils.showWaiting(context, false);
      bool statusReconnect = await _activityServiceProvider.connectDeviceWithMacAddress(context);
      debugPrint('statusReconnect>>$statusReconnect');
      if (statusReconnect) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('_activityServiceProvider.getDeviceConnected>> ${_activityServiceProvider.getDeviceConnected}');
    debugPrint('_activityServiceProvider.getHealthConnected>> ${_activityServiceProvider.getHealthConnected}');
    
    return GetBuilder<ActivityServiceProvider>(
        builder: (provider) {
      return WillPopScope(
        onWillPop: () => goDashboardPage(),
        child: Scaffold(
          //backgroundColor: Colors.white,
          appBar: AppBar(
            //title: Text('Devices and Accounts'),
            backgroundColor: Colors.white,
            // elevation: 0,
            title: const Text(textSetOptions,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
              onPressed: () => goDashboardPage(),
            ),
            actions: const [],
          ),
          /*bottomNavigationBar: Visibility(
          visible: _activityServiceProvider.isDeviceConnected,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            height: 140,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.black,
                side: BorderSide(color: Colors.blue),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () async {

              },
              child: Text("UnBind",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),*/
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                (provider.getDeviceConnected)
                    ? Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const SizedBox(
                              height: 4.0,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                              child: Card(
                                elevation: 2.0,
                                margin: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      //margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                         /* Icon(
                                            Icons.watch_outlined,
                                            color: Colors.black,
                                            size: 30.0,
                                          ),*/
                                          Image.asset(
                                            'assets/fit/watch_selected.png',
                                            width: 44.0,
                                            height: 44.0,
                                            fit: BoxFit.fill,
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    //mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(2.0),
                                                        child: Text(provider.getDeviceSWName,
                                                            style: const TextStyle(fontWeight: FontWeight.w500,
                                                                fontSize: 16.0)),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(2.0),
                                                        child: Text(provider.getDeviceMacAddress ?? '',
                                                            style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Spacer(),
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    //fixedSize: Size(86.0, 16.0),
                                                    primary: Colors.blue,
                                                    //onSurface: Colors.red,
                                                  ),
                                                  onPressed: () async {
                                                    // Utils.showWaiting(context, false);
                                                    //Utils.showToastMessage(context, '${_activityServiceProvider.getDeviceSWName} is disconnecting..!');
                                                    bool isDeviceDisconnected = await _activityServiceProvider.disconnectDevice();
                                                    debugPrint("isDeviceDisconnected>>> $isDeviceDisconnected");
                                                    refreshPage(isDeviceDisconnected);

                                                    /*if (isReconnect) {
                                                    Utils.showWaiting(context, false);
                                                    bool statusReconnect =  await _activityServiceProvider.connectDeviceWithMacAddress(context);
                                                    if (!statusReconnect) {
                                                      Navigator.pop(context);
                                                    }else{
                                                      Navigator.pop(context);
                                                      await updateDeviceConnection(true);
                                                    }
                                                  }else{
                                                    bool isDeviceDisconnected = await _activityServiceProvider.disconnectDevice();
                                                    Utils.showToastMessage(context, '${_activityServiceProvider.getDeviceSWName} is disconnecting..!');
                                                    debugPrint("isDeviceDisconnected>>> $isDeviceDisconnected");
                                                    refreshPage();
                                                  }*/
                                                  },
                                                  child: const Text(
                                                    textDisconnect,
                                                    //isReconnect ? Utils.tr(context, 'string_text_reconnect'): Utils.tr(context, 'string_text_disconnect'),
                                                    //'Disconnect',
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        //decoration: TextDecoration.underline,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14.0),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(2.0),
                                            child: Text('$textVersion: ',
                                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: Text(_activityServiceProvider.getDeviceVersion,
                                                  style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400)),
                                            ),
                                          ),
                                          // Spacer(),
                                          // Spacer(),
                                          const Padding(
                                            padding: EdgeInsets.all(2.0),
                                            child: Text('$textBattery: ',
                                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: BatteryIndicator(
                                              style: BatteryIndicatorStyle.values[1], // 0 or 1 for style selection
                                              size: 20.0,
                                              ratio: 2.7,
                                              batteryLevel: _activityServiceProvider.batteryPercentage,
                                              showPercentNum: true,
                                              percentNumSize: 12,
                                              colorful: true,
                                              mainColor: Colors.grey.withOpacity(0.7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : (provider.getHealthConnected)
                        ? Container(
                            margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                            child: Card(
                              elevation: 2.0,
                              margin: const EdgeInsets.all(4.0),
                              child: Container(
                                //margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Image.asset(Platform.isIOS ? 'assets/fit/apple_health.png': 'assets/fit/gfit.png',
                                        width: 30.0,
                                        height: 30.0,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Column(
                                              //mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: Text(Platform.isIOS ? textAppleHealth : textGoogleFit, //'Google Fit',
                                                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0)),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: Text(
                                                      (_activityServiceProvider.getDeviceMacAddress.contains('com'))
                                                          ? _activityServiceProvider.getDeviceSWName
                                                          : _activityServiceProvider.getDeviceMacAddress,
                                                      style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              //fixedSize: Size(86.0, 16.0),
                                              primary: Colors.blue,
                                              //onSurface: Colors.red,
                                            ),
                                            onPressed: () {
                                              _activityServiceProvider.updateUserDeviceConnection(false, false, '', '');
                                              refreshPage(false);
                                            },
                                            child: const Text(textUnlink,
                                              style: TextStyle(color: Colors.blue, //decoration: TextDecoration.underline,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                                  padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                                  child: const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        textNoDevicesConnected,
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => const AddDevice());
                                  },
                                  child: Card(
                                    elevation: 2.0,
                                    margin: const EdgeInsets.all(4.0),
                                    child: Container(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                         /* Icon(
                                            Icons.watch_sharp,
                                            color: Colors.black,
                                            size: 30.0,
                                          ),*/
                                          Image.asset(
                                            'assets/fit/watch.png',
                                            width: 35.0,
                                            height: 35.0,
                                            fit: BoxFit.fill,
                                          ),
                                          const Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(addSmartWatchText),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                                  child: Card(
                                    elevation: 2.0,
                                    margin: const EdgeInsets.all(4.0),
                                    child: Container(
                                      //margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Image.asset(
                                              Platform.isIOS ? 'assets/fit/apple_health.png':'assets/fit/gfit.png',
                                              width: 30.0,
                                              height: 30.0,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: Column(
                                                    //mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(2.0),
                                                        child: Text(Platform.isIOS ? textAppleHealth:textGoogleFit,
                                                            //'Google Fit',
                                                            style: const TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 16.0)),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(2.0),
                                                        child: Text(provider.getDeviceSWName,
                                                            style: const TextStyle(fontSize: 12.0,
                                                                fontWeight: FontWeight.w300)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Spacer(),
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    //fixedSize: Size(86.0, 16.0),
                                                    primary: Colors.blue,
                                                    //onSurface: Colors.red,
                                                  ),
                                                  onPressed: () {
                                                   // Get.to(() =>  AppleGoogleBind(deviceTypeName: provider.getDeviceSWName));
                                                    // refreshPage();
                                                  },
                                                  child: const Text(textLink, //'Link',
                                                    style: TextStyle(color: Colors.blue,
                                                        //decoration: TextDecoration.underline,
                                                        fontWeight: FontWeight.bold, fontSize: 14.0),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    top: 8.0,
                  ),
                  child: const Text(
                    textSettings,
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    String data = await GlobalMethods.selectGoalSteps(context, _activityServiceProvider.getTargetedSteps);
                    if (data.isNotEmpty) {
                      debugPrint('selectedGoal>> $data');
                      _activityServiceProvider.updateTargetedSteps(data);
                      refreshPage(false);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                    child: Card(
                      elevation: 2.0,
                      margin: const EdgeInsets.all(4.0),
                      child: Container(
                        // margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Image.asset('assets/fit/goal_right.png',
                                width: 40.0,
                                height: 40.0,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      //mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(2.0),
                                          child: Text(textGoal,
                                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                              '${GlobalMethods.formatNumber(int.parse(_activityServiceProvider.getTargetedSteps))} $textSteps',
                                              style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Colors.black38,
                                size: 18.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: true,
                  //visible: provider.getDeviceConnected,
                  child: GestureDetector(
                    onTap: () {
                      //debugPrint('_selectedSteps>>> $_selectedSteps');
                      // Get.to(() =>  ProfileUpdate(
                      //   userFullName: currentUserDetails.firstName + ' ' + currentUserDetails.lastName,
                      //   gender: _activityServiceProvider.getUserGender,
                      //   height: _activityServiceProvider.getUserHeight,
                      //   weight: _activityServiceProvider.getUserWeight,
                      //   dob: _activityServiceProvider.getUserDOB,
                      //   waist: currentUserDetails.waist,
                      //   bloodGroup: currentUserDetails.bloodGroup,
                      //   fromSettings: true,
                      // ));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
                      child: Card(
                        elevation: 2.0,
                        margin: const EdgeInsets.all(4.0),
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Image.asset(
                                  'assets/fit/smart_profile.png',
                                  width: 40.0,
                                  height: 40.0,
                                  fit: BoxFit.fill,
                                ),
                                /*child: Icon(
                                  Icons.person_pin_outlined,
                                  color: Colors.black,
                                  size: 32.0,
                                ),*/
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Column(
                                        //mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(2.0),
                                            child: Text(textSmartProfile,
                                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Row(
                                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                const Text('$textBMI : ',
                                                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300),
                                                ),
                                                const SizedBox(
                                                  width: 4.0,
                                                ),
                                                Text(_activityServiceProvider.getUserBMI,
                                                  style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300),
                                                ),
                                                const SizedBox(
                                                  width: 6.0,
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.all(2.0),
                                                  decoration: BoxDecoration(
                                                      color: GlobalMethods.getColor(_activityServiceProvider.getUserBMIStatus),
                                                      shape: BoxShape.circle),
                                                  height: 12,
                                                  width: 12,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: Colors.black38,
                                  size: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: provider.getDeviceConnected,
                  //visible: true,
                  child: GestureDetector(
                    onTap: () async {
                      bool isConnected = await _activityServiceProvider.checkIsDeviceConnected();
                      if (isConnected) {
                         // Get.to(() =>  const DialFaceDetails());
                      }else {
                        retryConnection(context);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
                      child: Card(
                        elevation: 2.0,
                        margin: const EdgeInsets.all(4.0),
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Image.asset('assets/fit/watch.png',
                                  width: 40.0,
                                  height: 40.0,
                                  fit: BoxFit.fill,
                                ),
                                /* child: Icon(
                                  Icons.watch_later_outlined,
                                  color: Colors.black,
                                  size: 32.0,
                                ),*/
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: const [
                                            Padding(
                                              padding:
                                              EdgeInsets.all(2.0),
                                              child: Text(textDialFaces,
                                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0)),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(2.0),
                                              child: Text(textDialFacesMsg,
                                                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: Colors.black38,
                                  size: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: provider.getDeviceConnected,
                  //visible: false,
                  child: GestureDetector(
                    onTap: () async {
                      bool isConnected = await _activityServiceProvider.checkIsDeviceConnected();
                      if (isConnected) {
                        Get.to(() =>  const ActivityMonitor());
                      }else {
                        retryConnection(context);
                      }

                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
                      child: Card(
                        elevation: 2.0,
                        margin: const EdgeInsets.all(4.0),
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Image.asset('assets/fit/24hrs_blue.png',
                                  width: 40.0,
                                  height: 40.0,
                                  fit: BoxFit.fill,
                                ),
                               /* child: Icon(
                                  Icons.watch_later_outlined,
                                  color: Colors.black,
                                  size: 32.0,
                                ),*/
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  const Text( textMonitoringOptions,
                                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0)),
                                                  const SizedBox(
                                                    width: 4.0,
                                                  ),
                                                  Text( '(${provider.getTemperature24Enabled || provider.getHR24Enabled ? textOn: textOff})',
                                                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.0,
                                                          color: provider.getTemperature24Enabled || provider.getHR24Enabled ? Colors.green[400]: Colors.grey[350],),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.all(2.0),
                                              child: Text(textMonitoringOptionsMsg,
                                                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: Colors.black38,
                                  size: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: provider.getDeviceConnected,
                  //visible: false,
                  child: GestureDetector(
                    onTap: () async {
                      bool isConnected = await provider.checkIsDeviceConnected();
                      //await Future.delayed(const Duration(milliseconds: 500));
                      if (isConnected) {
                        Get.to(() =>  const DoNotDisturb());
                      }else {
                        retryConnection(context);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
                      child: Card(
                        elevation: 2.0,
                        margin: const EdgeInsets.all(4.0),
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Image.asset(
                                  'assets/fit/do_not_disturb.png',
                                  width: 40.0,
                                  height: 40.0,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  const Text(textDoNotDisturb,
                                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0)),
                                                  const SizedBox(
                                                    width: 4.0,
                                                  ),
                                                  Text( '(${provider.getDndEnabled || provider.getMotorVibrateEnabled || provider.getMessagesOnEnabled ? textOn: textOff})',
                                                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.0,
                                                      color: provider.getDndEnabled || provider.getMotorVibrateEnabled || provider.getMessagesOnEnabled ? Colors.green[400]: Colors.grey[350],),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.all(2.0),
                                              child: Text(textDoNotDisturbMsg,
                                                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: Colors.black38,
                                  size: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: provider.getDeviceConnected,
                 // visible: false,
                  child: GestureDetector(
                    onTap: () async {
                      bool isConnected = await _activityServiceProvider.checkIsDeviceConnected();
                      if (isConnected) {
                        String bandStatus = await provider.findDeviceBand();
                        debugPrint('bandStatus>> $bandStatus');
                        GlobalMethods.showAlertDialog(context, textListenVibrate,textListenVibrateMsg);
                      }else {
                        retryConnection(context);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
                      child: Card(
                        elevation: 2.0,
                        margin: const EdgeInsets.all(4.0),
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Image.asset(
                                  'assets/fit/find_band.png',
                                  width: 40.0,
                                  height: 40.0,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: const [
                                            Padding(
                                              padding: EdgeInsets.all(2.0),
                                              child: Text(textFindBand,
                                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0)),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(2.0),
                                              child: Text(textFindBandMsg,
                                                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: Colors.black38,
                                  size: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: false,
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => const BandReminders());
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
                      child: Card(
                        elevation: 2.0,
                        margin: const EdgeInsets.all(4.0),
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Image.asset(
                                  'assets/fit/reminders.png',
                                  width: 40.0,
                                  height: 40.0,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: const [
                                            Padding(
                                              padding: EdgeInsets.all(2.0),
                                              child: Text('Smart Reminders',
                                                  //Utils.tr(context, 'string_text_smart_profile'),//'Smart Profile',
                                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0)),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(2.0),
                                              child: Text('Reminders will notifies you to stay updated with Docty-m',
                                                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: Colors.black38,
                                  size: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Visibility(
                  visible: false,
                  child: GestureDetector(
                    onTap: () async {
                      Get.to(() => const FirmwareUpgrade());
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                      child: Card(
                        elevation: 2.0,
                        margin: const EdgeInsets.all(4.0),
                        child: Container(
                          // margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Image.asset('assets/fit/goal_right.png',
                                  width: 40.0,
                                  height: 40.0,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Column(
                                        //mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: const [
                                          Padding(
                                            padding: EdgeInsets.all(2.0),
                                            child: Text('Firmware upgrade', //'Goal',
                                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0)),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: Colors.black38,
                                  size: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: false,
                  child: GestureDetector(
                    onTap: () async {
                      String isResetDevice = await _activityServiceProvider.resetDevicesAllData();
                      debugPrint('isResetDevice>> $isResetDevice');
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                      child: Card(
                        elevation: 2.0,
                        margin: const EdgeInsets.all(4.0),
                        child: Container(
                          // margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Image.asset('assets/fit/goal_right.png',
                                  width: 40.0,
                                  height: 40.0,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Column(
                                        //mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: const [
                                          Padding(
                                            padding: EdgeInsets.all(2.0),
                                            child: Text('Reset Device',
                                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0)),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: Colors.black38,
                                  size: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  goDashboardPage() {
    if (!_activityServiceProvider.getHealthConnected && !_activityServiceProvider.getDeviceConnected) {

      Get.offAll(const VitalMain());

    } else {
      Navigator.of(context).pop();
    }
  }

  void refreshPage(bool isDisconnected) async {
    debugPrint("refreshPage ${_activityServiceProvider.getDeviceConnected}");
    setState(() {});
    if (isDisconnected) {
      Navigator.pop(context);
    }
  }

/* Future<void> addDeviceConnectionListener() async {
    _activityServiceProvider.receiveEventsFrom(
        onDataUpdate: (data) async {
          debugPrint("addDeviceConnectionListener>> " + data.toString());
          onDataUpdated(data);
        }, onError: (error) {
      debugPrint("addDeviceConnectionListenerError::>> " + error.toString());
    }, onDone: () {

    });
  }

  Future<void> onDataUpdated(dynamic data) async {
    var eventData = jsonDecode(data);
    String result = eventData['result'].toString();
    String status = eventData['status'].toString();
    // var jsonData = eventData['data'];
    if (result == BandFitConstants.DEVICE_CONNECTED) {
      debugPrint("addDeviceConnectionListener>> Device Connected");
      if (status == BandFitConstants.SC_SUCCESS) {
        await _activityServiceProvider.updateUserParamsWatch();
      }
    } else if (result == BandFitConstants.UPDATE_DEVICE_PARAMS) {
      if (status == BandFitConstants.SC_SUCCESS) {
        await updateDeviceConnection(true);
      }
    } else {
      if (mounted) {
        _activityServiceProvider.updateEventResult(eventData, context);
      }
    }
  }*/

/*Future<void> updateDeviceConnection(bool isConnected) async {
    _activityServiceProvider.updateUserDeviceConnection(false, isConnected, 'SP', 'SP');
    if (mounted) {
      Navigator.pop(context);
      Utils.showToastMessage(context, '${Utils.tr(context, 'string_smart_connect_msg')}..!');
    }
    await fetchDeviceData();
    refreshPage();
  }*/

/* getLocalData() async {
   // _selectedSteps = _activityServiceProvider.getTargetedSteps;
   //  _myBMIValue = _activityServiceProvider.getUserBMI ?? '18';
   //  _myBMIStatus = _activityServiceProvider.getUserBMIStatus ?? 'bmi_fit';
    //_myHeight = _activityServiceProvider.getUserHeight;
    //_myWeight = _activityServiceProvider.getUserWeight;
    //_myGender = _activityServiceProvider.getUserGender;
    //_myDOB = _activityServiceProvider.getUserDOB;
    isDeviceConnected = _activityServiceProvider.isDeviceConnected;
    deviceConnectedName = _activityServiceProvider.getDeviceSWName;
    deviceMacAddress = _activityServiceProvider.getDeviceMacAddress;

    // int tempTG  = await GlobalMethods.getTargetedSteps();
    // _selectedSteps = tempTG.toString();
    // _myBMIValue = await GlobalMethods.getBMIValue() ?? '18';
    // _myBMIStatus = await GlobalMethods.getBMIStatus() ?? 'bmi_fit';
    // deviceConnectedName = await GlobalMethods.getDeviceName();
    // deviceMacAddress = await GlobalMethods.getDeviceAddress();
    // _myHeight = await GlobalMethods.getHeightValue();
    // _myWeight = await GlobalMethods.getWeightValue();
    // _myGender = await GlobalMethods.getGenderValue();
    // _myDOB = await GlobalMethods.getDOBValue();
    // debugPrint('_myBMIValue>>> $_myBMIValue');
    // debugPrint('_myBMIStatus>>> $_myBMIStatus');
    // setState(() {});
  }*/

/* connectedDevice() {
    currentUserDetails = Provider.of<CurrentUserDetailsProvider>(context, listen: false).userDetailsValue;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 4.0,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
            padding: EdgeInsets.only(
              left: 8.0,
              top: 8.0,
            ),
            child: Text('Connected Device',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0)),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
            child: Card(
              elevation: 2.0,
              margin: EdgeInsets.all(8.0),
              child: Container(
                //margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                padding: EdgeInsets.all(4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.watch_outlined,
                      color: Colors.black,
                      size: 30.0,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(deviceConnectedName ?? '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(deviceMacAddress ?? '',
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w300)),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Visibility(
                            visible: deviceConnected,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                //fixedSize: Size(86.0, 16.0),
                                primary: Colors.blue,
                                //onSurface: Colors.red,
                              ),
                              onPressed: () async {
                                Utils.showWaiting(context, false);
                                bool isDeviceDisconnected =
                                    await _activityServiceProvider
                                        .disconnectDevice();
                                // bool isDeviceDisconnected = await _mobileSmartWatch.disconnectDevice();
                                // debugPrint("isDeviceDisconnected>>> $isDeviceDisconnected");
                                //  if (isDeviceDisconnected) {
                                //     await GlobalMethods.setDeviceName("");
                                //     await GlobalMethods.setDeviceAddress("");
                                Navigator.pop(context);
                                Utils.showToastMessage(context,
                                    deviceConnectedName + ' is disconnected');
                                getLocalData();
                                // }
                              },
                              child: Text(
                                'Disconnect',
                                style: TextStyle(
                                    color: Colors.blue,
                                    //decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: !deviceConnected,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                //fixedSize: Size(86.0, 16.0),
                                primary: Colors.blue,
                                //onSurface: Colors.red,
                              ),
                              onPressed: () {},
                              child: Text(
                                'Connect',
                                style: TextStyle(
                                    color: Colors.blue,
                                    //decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
            padding: EdgeInsets.only(
              left: 8.0,
              top: 8.0,
            ),
            child: Text('Settings',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0)),
          ),
          GestureDetector(
            onTap: () async {
              String data = await GlobalMethods.selectGoalSteps(
                  context, _activityServiceProvider.getTargetedSteps);
              if (data.isNotEmpty) {
                debugPrint('selectedGoal>> $data');
                _activityServiceProvider.updateTargetedSteps(data);

                // setState(() {
                //   _selectedSteps = data;
                //   // _textEditingController.text = pickedDate.toString();
                // });
              }

              //await GlobalMethods.setTargetedSteps(_selectedSteps);
              // var userParams = {
              //   "age": GlobalMethods.getAgeFromDOB(_myDOB).toString(),
              //   // user age (0-254)
              //   "height": _myHeight.toString(),
              //   // always cm
              //   "weight": _myWeight.toString(),
              //   // always in kgs
              //   "gender": _myGender.toString(),
              //   //male  or female in lower case
              //   "steps": _selectedSteps.toString(),
              //   // targeted goals
              //   "isCelsius": "true",
              //   // if celsius then send "true" else "false" for Fahrenheit
              //   "screenOffTime": "15",
              //   //screen off time
              //   "isChineseLang": "false",
              //   //true for chinese lang setup and false for english
              // };
              // debugPrint('userParams>> $userParams');
              // await _mobileSmartWatch.setUserParameters(userParams);
              //debugPrint('selectedGoal>> $_selectedSteps');
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
              child: Card(
                elevation: 2.0,
                margin: EdgeInsets.all(8.0),
                child: Container(
                  // margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                  padding: EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          'assets/fit/goal.png',
                          width: 30.0,
                          height: 30.0,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                //mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text('Goal',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16.0)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                        GlobalMethods.formatNumber(
                                                int.parse(_selectedSteps)) +
                                            ' Steps',
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w300)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              //debugPrint('_selectedSteps>>> $_selectedSteps');
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileUpdate(
                            userId: currentUserDetails.userId.toString(),
                            userFullName: currentUserDetails.firstName +
                                ' ' +
                                currentUserDetails.lastName,
                            gender: _myGender,
                            height: _myHeight,
                            weight: _myWeight,
                            dob: _myDOB,
                          )),
                  (_) => false);
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => VitalMain()),
              //         (_) => false);
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
              child: Card(
                elevation: 2.0,
                margin: EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.person_pin_outlined,
                          color: Colors.black,
                          size: 40.0,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4.0, top: 10),
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text('Smart Profile',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.0)),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text('BMI',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w300)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(_myBMIValue ?? '',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w300)),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(3.0),
                                    decoration: BoxDecoration(
                                        color: GlobalMethods.getColor(
                                            _myBMIStatus),
                                        shape: BoxShape.circle),
                                    height: 20,
                                    width: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  disConnectedDevice() {
    currentUserDetails = Provider.of<CurrentUserDetailsProvider>(context, listen: false).userDetailsValue;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
            padding: EdgeInsets.only(
              left: 8.0,
              top: 8.0,
            ),
            child: Column(
              children: [
                Center(
                    child: Text(
                        'No devices are currently connected (you have not linked any device)')),
                GestureDetector(
                  onTap: () {
                    //Get.to(() => AddDevice());
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddDevice()),
                    );
                  },
                  child: Card(
                    elevation: 2.0,
                    margin: EdgeInsets.all(4.0),
                    child: Container(
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.watch_sharp,
                            color: Colors.black,
                            size: 30.0,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('$addSmartWatchText'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ), // you have not linked a device.
          ),

          */ /* Container(
              margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
              padding: EdgeInsets.only(left:8.0, top: 8.0,),
              child: Text('Saved Devices', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16.0)),
            ),

            Visibility(
              visible: true,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                // padding: EdgeInsets.only(left:8.0, top: 8.0,),
                child: Center(child: Text('No devices are currently saved')),
              ),
            ),*/ /*

          Container(
            margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
            padding: EdgeInsets.only(
              left: 8.0,
              top: 8.0,
            ),
            child: Text('Link Apps & Services',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0)),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
            child: Card(
              elevation: 2.0,
              margin: EdgeInsets.all(8.0),
              child: Container(
                //margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                padding: EdgeInsets.all(4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.asset(
                        'assets/fit/gfit.png',
                        width: 30.0,
                        height: 30.0,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text('Google Fit',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text('linked (email id) to display',
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w300)),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Visibility(
                            visible: deviceConnected,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                //fixedSize: Size(86.0, 16.0),
                                primary: Colors.blue,
                                //onSurface: Colors.red,
                              ),
                              onPressed: () {},
                              child: Text(
                                deviceConnected
                                    ? 'Link'
                                    : 'Unlink', //!deviceConnected
                                style: TextStyle(
                                    color: Colors.blue,
                                    //decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
            padding: EdgeInsets.only(
              left: 8.0,
              top: 8.0,
            ),
            child: Text('Settings',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0)),
          ),
          GestureDetector(
            onTap: () async {
              //String selectedGoal ='';
              String data = await GlobalMethods.selectGoalSteps(context, _selectedSteps);
              if (data.isNotEmpty) {
                setState(() {
                  _selectedSteps = data;
                });
              }
              _activityServiceProvider.updateTargetedSteps(_selectedSteps);
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
              child: Card(
                elevation: 2.0,
                margin: EdgeInsets.all(8.0),
                child: Container(
                  // margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                  padding: EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          'assets/fit/goal.png',
                          width: 30.0,
                          height: 30.0,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                //mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text('Goal',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16.0)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                        GlobalMethods.formatNumber(int.parse(
                                                _activityServiceProvider
                                                    .targetedSteps)) +
                                            ' Steps',
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w300)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileUpdate(
                          userId: currentUserDetails.userId.toString(),
                          userFullName: currentUserDetails.firstName +
                              ' ' +
                              currentUserDetails.lastName,
                          gender: _activityServiceProvider.getUserGender,
                          height: _activityServiceProvider.getUserHeight,
                          weight: _activityServiceProvider.getUserWeight,
                          dob: _activityServiceProvider.getUserDOB,
                          // targetedSteps: _selectedSteps,
                        )),
              );

              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => ProfileUpdate(
              //             userId: currentUserDetails.userId.toString(),
              //             userFullName: currentUserDetails.firstName + ' ' + currentUserDetails.lastName,
              //             gender: _activityServiceProvider.getUserGender,
              //             height: _activityServiceProvider.getUserHeight,
              //             weight: _activityServiceProvider.getUserWeight,
              //             dob: _activityServiceProvider.getUserDOB,
              //            // targetedSteps: _selectedSteps,
              //         )),
              //     (_) => false);
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => VitalMain()),
              //         (_) => false);
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
              child: Card(
                elevation: 2.0,
                margin: EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.person_pin_outlined,
                          color: Colors.black,
                          size: 40.0,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4.0, top: 10),
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text('Smart Profile',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.0)),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text('BMI -',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w300)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                        _activityServiceProvider.getUserBMI ??
                                            '',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w300)),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(3.0),
                                    decoration: BoxDecoration(
                                        color: GlobalMethods.getColor(
                                            _activityServiceProvider
                                                .getUserBMIStatus),
                                        shape: BoxShape.circle),
                                    height: 16,
                                    width: 16,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }*/
}
