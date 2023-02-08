import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:flutter_band_fit_app/presentation/apple_google_bind.dart';
import 'package:flutter_band_fit_app/presentation/vital_main.dart';
import 'package:get/get.dart';

class AddDevice extends StatefulWidget {
  const AddDevice({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddDeviceState();
  }
}

class AddDeviceState extends State<AddDevice> {
  // bool isGoogleFit = false;
  // final FlutterBlue flutterBlue = FlutterBlue.instance;
  // MobileSmartWatch _mobileSmartWatch = MobileSmartWatch();

  // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  List<BandDeviceModel> smartDevicesList = [];
  // Position myLocation;
  bool showProgress = false;
  String showMessage ='';
  List<String> arrConDisConButton = [];

  final  _activityServiceProvider = Get.put(ActivityServiceProvider());

  int selectedIndex =0;
  late BandDeviceModel selectedDevice;

  int syncFailCounter =0;
  bool profileUpdatedBand = false;
  bool doResetAllData = false;

  @override
  void initState() {
    // _activityServiceProvider = Provider.of<ActivityServiceProvider>(context, listen: false);
    super.initState();
    //_activityServiceProvider.startListeningCallBacks();
    initialize();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initialize() async {
    // bool bluetoothStatus = await Permissions.bluetoothPermissionsGranted();
    // debugPrint('bluetoothStatus>> $bluetoothStatus');
    // if (bluetoothStatus) {
    // myLocation = await GlobalMethods.fetchDeviceCurrentLocation(context);
    // if (myLocation != null) {
    // await _activityServiceProvider.setLocationCoOrdinates(myLocation.latitude, myLocation.longitude);
    Map<Permission, PermissionStatus> statuses;
    if(Platform.isAndroid) {
      //AndroidDeviceInfo androidInfo  = await deviceInfo.androidInfo;
      int sdkInt = await _activityServiceProvider.getAndroidSDKInt();
      if(sdkInt >= 31) {
        statuses = await [Permission.bluetoothConnect, Permission.bluetoothScan, Permission.locationWhenInUse, Permission.location,].request();
        // Permission.bluetoothAdvertise,
      } else {
        statuses = await [Permission.bluetooth, Permission.location].request();
      }
    } else {
      statuses = await [Permission.bluetooth, Permission.location, Permission.locationAlways, Permission.locationWhenInUse].request();
    }
    debugPrint('statuses>> $statuses');
    /*var bluPermission = await Permission.bluetooth.status;
    debugPrint('permission>>  $bluPermission');

    if (bluPermission.isDenied) {

      var bluetoothConnect = await Permission.bluetoothConnect.request();
      var bluetoothScan = await Permission.bluetoothScan.request();
      var bluetoothAdvertise = await Permission.bluetoothAdvertise.request();
      debugPrint('bluetoothConnect>>  $bluetoothConnect');
      debugPrint('bluetoothConnect>>  $bluetoothScan');
      debugPrint('bluetoothConnect>>  $bluetoothAdvertise');

    }*/

    if(mounted){
      setState(() {
        showProgress = true;
      });
    }
// handle only for android
    // if(!Platform.isIOS){
    // String initBlueResult = await _activityServiceProvider.reInitBluConnection();
    // debugPrint('initBlueResult $initBlueResult');
    String initResult = await _activityServiceProvider.initializeDeviceConnection();
    debugPrint('initResult $initResult');
    if (initResult != null) {
      if (initResult.toString() == BandFitConstants.BLE_NOT_SUPPORTED) {
        GlobalMethods.showAlertDialog(context, "$textBluetooth 4.0", "$bleNotSupported v4.0");
      } else if (initResult.toString() == BandFitConstants.BLE_NOT_ENABLED) {
        GlobalMethods.showAlertDialog(context, textBluetooth, bleNotConnected);
      } else if (initResult.toString() == BandFitConstants.SC_CANCELED) {
        GlobalMethods.showAlertDialog(context,textBluetooth, bleNotConnected);
      } else if (initResult.toString() == BandFitConstants.SC_INIT) {
        // fetch the bluetooth devices list
        await addDeviceListener();
        await fetchBluDevicesList();
      }
    }
    // }
    //  }
  }

  Future<void> addDeviceListener() async {
    _activityServiceProvider.receiveEventsFrom(
        onDataUpdate: (data) async {
          var eventData = jsonDecode(data);
          debugPrint("addDeviceListener>> $data");
          String result = eventData['result'].toString();
          String status = eventData['status'].toString();

          if (result == BandFitConstants.DEVICE_CONNECTED) {
            debugPrint("addDeviceListener>> Device Connected");
            if (status == BandFitConstants.SC_SUCCESS) {
              //await compute(_activityServiceProvider.updateUserParamsWatch,true);
              await checkDeviceConnectReset();

              // if(Platform.isIOS){
              //   await _activityServiceProvider.updateUserParamsWatch(false);
              // }
              // await _activityServiceProvider.updateUserParamsWatch(true);
            }
          }
          else if (result == BandFitConstants.SYNC_TIME_OK) {
            debugPrint("addDeviceListener>> SYNC_TIME_OK");
            if (status == BandFitConstants.SC_SUCCESS) {
              await Future.delayed(const Duration(milliseconds: 500));
              await _activityServiceProvider.updateUserParamsWatch(false);
            }
          }

          else if (result == BandFitConstants.UPDATE_DEVICE_LIST){
            if (status == BandFitConstants.SC_SUCCESS) {
              List<BandDeviceModel> deviceList = [];
              //print('eventData>> $eventData');
              List<dynamic> responseData = eventData["data"];
              for (var data in responseData) {
                deviceList.add(BandDeviceModel.fromJson(data));
              }

              if (deviceList.isNotEmpty) {
                for (int i = 0; i < deviceList.length; i++) {
                  arrConDisConButton.add('Connect');
                }
                if (mounted) {
                  setState(() {
                    smartDevicesList = deviceList;
                    //smartDevicesList = [];
                    showProgress = false;
                  });
                }
              }

            }
          }

          else if (result == BandFitConstants.UPDATE_DEVICE_PARAMS){
            if (status == BandFitConstants.SC_SUCCESS) {
              //updateDeviceConnection(true);
              debugPrint('syncFailCounter>>$syncFailCounter');
              if (syncFailCounter ==1) {
                if(_activityServiceProvider.getJsonWeatherData!=null && _activityServiceProvider.getJsonWeatherData.isNotEmpty){
                  await _activityServiceProvider.setWeatherInfoSevenDays();
                }else{
                  await updateDeviceConnection();
                }
              }else{
                setState(() {
                  profileUpdatedBand = true;
                });
                if(_activityServiceProvider.getJsonWeatherData!=null && _activityServiceProvider.getJsonWeatherData.isNotEmpty){
                  await _activityServiceProvider.setWeatherInfoSevenDays();
                }else{
                  await updateDeviceConnection();
                }
              }
            }
          }

          else if (result == BandFitConstants.DEVICE_DISCONNECTED) {
            if (status == BandFitConstants.SC_SUCCESS) {
              bool alreadyConnected = await _activityServiceProvider.checkIsDeviceConnected();
              debugPrint('alreadyConnected>> $alreadyConnected');
              if (!alreadyConnected) {
                // if any device is not connected.
                String address = await _activityServiceProvider.getConnectedLastDeviceAddress();
                if (selectedDevice !=null && selectedDevice.address!=null) {
                  if (address.toString().trim() == selectedDevice.address.toString().trim()) {
                    bool lastInitStatus = await _activityServiceProvider.connectWithLastDeviceAddress();
                    debugPrint('last_connected_status>> $lastInitStatus');
                  }else{
                    debugPrint('get_last_connect>> $address');
                    debugPrint('activityServiceProvider.getDeviceConnected>> ${_activityServiceProvider.getDeviceConnected}');
                    if (!_activityServiceProvider.getDeviceConnected) {
                      // no other device is not connected
                      GlobalMethods.navigatePopBack();
                      // disconnect the device.
                      // bool isDeviceDisconnected = await _activityServiceProvider.disconnectDevice();
                      GlobalMethods.showAlertDialog(context, textConnectionFailed, textConnectionFailedMsg);
                    }
                  }
                }

              }else{
                debugPrint('inside_else_disconnect>> $alreadyConnected');
              }
              // check if device is connected.
              /*if (!_activityServiceProvider.getDeviceConnected) {
                // no other device is not connected
                GlobalMethods.navigatePopBack();
                // disconnect the device.
               // bool isDeviceDisconnected = await _activityServiceProvider.disconnectDevice();
                GlobalMethods.showAlertDialog(context, Utils.tr(context, 'string_connection_failed'),Utils.tr(context, 'string_connection_failed_msg'));
              }*/
            }
          }

          else if (result == BandFitConstants.SYNC_TEMPERATURE_24_HOUR_AUTOMATIC){
            var jsonData = eventData['data'];
            if (status == BandFitConstants.SC_SUCCESS) {
              String status = jsonData['status'].toString() ?? '';
              if (status.isNotEmpty) {
                bool updateStatus = status == "true" ? true :false;
                debugPrint('tempUpdateStatus>> $updateStatus');
                await _activityServiceProvider.updateTemperature24Enabled(updateStatus);
              }
              // if(_activityServiceProvider.getJsonWeatherData!=null && _activityServiceProvider.getJsonWeatherData.isNotEmpty){
              //   await _activityServiceProvider.setWeatherInfoSevenDays();
              // }else{
              await updateDeviceConnection();
              //}
            }
          }

          else if (result == BandFitConstants.SYNC_BLE_WRITE_FAIL){
            if (status == BandFitConstants.SC_SUCCESS) {
              if (mounted) {
                setState(() {
                  syncFailCounter++;
                });
              }
              if (syncFailCounter == 2) {
                await updateDeviceConnection();
              }
            }
          }

          else if (result == BandFitConstants.SYNC_WEATHER_SUCCESS){
            if (status == BandFitConstants.SC_SUCCESS) {
              // await updateDeviceConnection();
              await _activityServiceProvider.enable24HourTest();
            }
          }

          else if (result == BandFitConstants.BATTERY_STATUS){
            if (status == BandFitConstants.SC_SUCCESS) {
              var jsonData = eventData['data'];
              String batteryStat = jsonData['batteryStatus'].toString() ?? '';
              debugPrint('batteryStatus>>$batteryStat');
              _activityServiceProvider.setBatteryPercentage(batteryStat, false);
            }
          }
          else{
            if (mounted) {
              await _activityServiceProvider.updateEventResult(eventData, context);
            }
          }
        }, onError: (error) {
      debugPrint("receiveEventsFromError::>> " + error.toString());
    }, onDone: () {

    });
  }

  Future<bool> checkDeviceConnectReset() async {
    debugPrint('getLastMacAddressId>> ${_activityServiceProvider.getLastMacAddressId}');
    String address = await _activityServiceProvider.getConnectedLastDeviceAddress();
    debugPrint('address>> $address');
    return false;
  }

  Future<void> updateDeviceConnection() async {
    debugPrint('updateDeviceConnection>> executed');
    //try {
    await _activityServiceProvider.fetchDeviceVersion();

    if (Platform.isAndroid) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    debugPrint('selectedDevice.name>>${selectedDevice.name}');
    debugPrint('selectedDevice.address>>${selectedDevice.address}');

    await _activityServiceProvider.updateUserDeviceConnection(false, true, selectedDevice.name, selectedDevice.address);

    if (Platform.isAndroid) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    await _activityServiceProvider.updateDeviceBandLanguage();
    GlobalMethods.navigatePopBack();
    if (mounted) {
      //Utils.showToastMessage(context, Utils.tr(context, 'string_band_selected'));
    }
    setState(() {
      arrConDisConButton[selectedIndex] = 'Disconnect';
    });
    goDashboardPage();
    // }catch(exp){
    //   debugPrint('updateDeviceConnectionExp>> $exp');
    // }
  }

  Future<void> fetchBluDevicesList() async {
    /*  setState(() {
      showProgress = true;
    });*/
    //Utils.showWaiting(context, false);
    List<BandDeviceModel> resultDeviceList = await _activityServiceProvider.startSearchingDevices();
    debugPrint('fetchBluDevicesList $resultDeviceList');
    if (resultDeviceList.isNotEmpty) {
      for (int i = 0; i < resultDeviceList.length; i++) {
        arrConDisConButton.add('Connect');
      }
      if (mounted) {
        setState(() {
          smartDevicesList = resultDeviceList;
          //smartDevicesList = [];
          showProgress = false;
        });
      }
    } else {
      // no devices are found
      if (mounted) {
        setState(() {
          smartDevicesList = [];
          showProgress = false;
          showMessage =textNoDeviceMsg;
        });
      }
      // Utils.showToastMessage(context, 'No Device found');
    }
    // GlobalMethods.navigatePopBack();
  }

  Widget showDeviceContainer(List<BandDeviceModel> deviceList) {
    if (showProgress) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: const [
          SizedBox(
            height: 180,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
          SizedBox(
            height: 8,
          ),
          //Text('Searching for docty smartwatch...', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
          //Text('Searching for Docty-m watch...', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
          Text('$textSearchingDevice...', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
        ],
      );
    } else {
      if (deviceList.isNotEmpty) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
          //padding: const EdgeInsets.all(2.0),
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (BuildContext context, int index) => const Divider(),
            itemCount: deviceList.length,
            itemBuilder: (BuildContext context, int index) {
              return _deviceItem(index);
            },
          ),
        );
      } else {
        return Column(
          children: [
            const SizedBox(
              height: 180,
            ),
            Center(child: Text(showMessage)),
          ],
        );
      }
    }
  }

  Widget _deviceItem(int index) {
    BandDeviceModel device = smartDevicesList[index];
    return Container(
      margin: const EdgeInsets.all(1.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 1.0,
            spreadRadius: 0.0,
            offset: Offset(0.2, 0.2), // shadow direction: bottom right
          )
        ],
      ),
      child: ListTile(
        onTap: () async {
          await connectDisconnectDevice(index, device);
        },
        /*subtitle:  Divider(
          color: Colors.grey,
        ),*/
        leading: const Icon(
          Icons.bluetooth_audio_outlined,
          color: Colors.black,
        ),
        title: Text(device.name),
        subtitle: Text(device.address),
        trailing: GestureDetector(
          onTap: () async {
            await connectDisconnectDevice(index, device);
          },
          child: Text(
            arrConDisConButton[index],
            style: const TextStyle(color: Colors.blueAccent),
          ),
        ),
      ),
    );

    /* return ListTile(
      onTap: onTap,
      trailing:menuList[index].hasNavigation ? Icon(Icons.keyboard_arrow_right_outlined, size: 30):Container(),
      title: Text(menuList[index].title, style: TextStyle(
        // fontWeight: FontWeight.w500,
          fontSize: 16.0
      )),
      // subtitle: Text('allow user'),
      leading: Icon(menuList[index].icon, size: 30),
    );*/
  }

  Future<void> connectDisconnectDevice(int index, BandDeviceModel device) async {
    setState(() {
      selectedIndex = index;
      selectedDevice = device;
    });

    if (arrConDisConButton[index] == "Connect") {
      //Utils.showWaiting(context, false);
      bool isDeviceConnected = await _activityServiceProvider.connectSmartDevice(device);
      debugPrint("isDeviceConnected>>> $isDeviceConnected");
      // if (isDeviceConnected && _activityServiceProvider.getConnectStatus) {
      /*if (isDeviceConnected ) {
        // await GlobalMethods.setDeviceName(device.name);
        // await GlobalMethods.setDeviceAddress(device.address);
        GlobalMethods.navigatePopBack();
        Utils.showToastMessage(context, device.name + ' is connected');
        setState(() {
          arrConDisConButton[index] = 'Disconnect';
        });
        //goDashboardPage();
      }*/
    } else {
      // Utils.showWaiting(context, false);
      bool isDeviceDisconnected = await _activityServiceProvider.disconnectDevice();
      debugPrint("isDeviceDisconnected>>> $isDeviceDisconnected");
      GlobalMethods.navigatePopBack();
      //Utils.showToastMessage(context, device.name + ' ${Utils.tr(context, 'string_device_got_disconnect_msg')}');
      setState(() {
        arrConDisConButton[index] = 'Connect';
      });
    }
  }

  goDashboardPage() {
    Get.offAll(const VitalMain());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        // title: Text('Add Device'),
        backgroundColor: Colors.white,
        elevation: 2.0,
        title: const Text(textAddDevice,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
          onPressed: () {
            GlobalMethods.navigatePopBack();
          },
          // onPressed: () => goDashboardPage(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined, color: Colors.black),
            tooltip: textRefresh,
            onPressed: () async {
              //await initialize();
              setState(() {
                showProgress = true;
              });
              await fetchBluDevicesList();
            },
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 160,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(textOR,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: Colors.blueGrey.withOpacity(0.7))),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            MaterialButton(
              color: const Color(0xfff7f7f7),
              disabledColor: Theme.of(context).disabledColor.withOpacity(0.12),
              shape: const StadiumBorder(),
              //shape: shape ?? StadiumBorder(),
              onPressed: () {
                Get.to(() =>  AppleGoogleBind(deviceTypeName: Platform.isIOS ? appleHealthKey : googleFitKey));
              },
              elevation: 2.0,
              child: Container(
                padding: const EdgeInsets.all(2.0),
                // width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Image.asset(
                        Platform.isIOS ? 'assets/fit/apple_health.png' : 'assets/fit/gfit.png',
                        width: 32.0,
                        height: 32.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        Platform.isIOS ? textLinkAppleHealth : textLinkGoogleFit,
                        style: const TextStyle(fontSize: 18.0, color: Colors.black
                          /* color: true
                                ? Colors.black
                                : Theme.of(context)
                                    .disabledColor
                                    .withOpacity(0.38),*/
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: const [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(textChooseSmartBand,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text(textChooseSmartBandMsg,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300)),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Container(
              //height: double.infinity,
              margin: const EdgeInsets.all(8.0),
              child: showDeviceContainer(smartDevicesList),
            ),
            /*  (deviceList.length == 0)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Text('Searching for docty smartwatch...',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400)),
                        )
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        //Text('No Devices Found'),
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          child: showDeviceContainer(smartDevicesList),
                        )
                      ],

                      // child: showDeviceContainer(deviceList),
                    ),*/
          ],
        ),
      ),
    );
    /*return WillPopScope(
      onWillPop: () {
        goDashboardPage();
        return Future.value(false);
      },
      child: ,
    );*/
  }



/*Widget _text(bool isGFit, bool _enabled) {
    return Text(
      isGFit ? 'Link with Google Fit' : 'Link with Apple Health',
      style: TextStyle(
        fontSize: 18.0,
        color: _enabled
            ? Colors.black
            : Theme.of(context).disabledColor.withOpacity(0.38),
      ),
    );
  }*/
}
