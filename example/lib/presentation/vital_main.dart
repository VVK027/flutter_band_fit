import 'dart:math' as math;

import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:flutter_band_fit_app/custom/custom_circle_progress.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class VitalMain extends StatefulWidget {

  const VitalMain({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return VitalMainState();
  }
}

class VitalMainState extends State<VitalMain> with TickerProviderStateMixin, WidgetsBindingObserver {
  //with SingleTickerProviderStateMixin

  final themeController = Get.find<ThemeController>();
  final  _activityServiceProvider = Get.put(ActivityServiceProvider());

  DateTime todayTime = DateTime.now();
  bool isReConnectStatus = false;
  bool deviceConnectedBleWriteStatus = false;
  bool isDeviceConnected = false;
  String reConnectMacAddress = '';

  //late Position myLocation;
  late AnimationController progressController, syncController;
  late Animation _animation;

  bool isLoadingProgress = true;
  bool notifiedDisconnected = false; // to notify a single reconnect

  late double lat, lon;
  double currentTempWeather = 0.0;

  int countStepsTimeOut =0, countSleepTimeOut =0, countTemperatureTimeOut =0;
  int syncFailureTimeOut = 0;

  @override
  void initState() {
   // _activityServiceProvider = Provider.of<ActivityServiceProvider>(context, listen: false);
    reConnectMacAddress = _activityServiceProvider.getDeviceMacAddress;
    initializeProgressController();
    //ws = new WeatherFactory(Settings.openWeatherAPIKey);
    super.initState();
    // Add the observer.
    //WidgetsBinding.instance.addObserver(this);
    if (_activityServiceProvider.getHealthConnected) {
      // gfit or apple fit
    } else {
      //_activityServiceProvider.startListeningCallBacks(context);
      listenFitBandUpdates();
      progressUpdate();
    }
  }

  Future<void> listenReceiveEvents() async {
    _activityServiceProvider.receiveEventsFrom(onDataUpdate: (data) {
      debugPrint("receiveEventsFromMainScreen>> $data");
      onDataUpdated(data);
    }, onError: (error) {
      debugPrint("receiveEventsFromError::>> $error");
    }, onDone: () {
      debugPrint("receiveEventsFromOnDone::>> ");
    });
    Map<Permission, PermissionStatus> statuses;
    if(Platform.isAndroid) {
      //AndroidDeviceInfo androidInfo  = await DeviceInfoPlugin().androidInfo;
      int sdkInt = await _activityServiceProvider.getAndroidSDKInt();
      if(sdkInt >= 31) {
        statuses = await [Permission.bluetoothConnect, Permission.bluetoothScan, Permission.locationWhenInUse, Permission.location].request();
        // Permission.bluetoothAdvertise,
      } else {
        statuses = await [Permission.bluetooth, Permission.location].request();
      }
     } else {
      statuses = await [Permission.bluetooth, Permission.location, Permission.locationAlways, Permission.locationWhenInUse].request();
    }
    debugPrint('statuses>> $statuses');
  }

  Future<void> listenFitBandUpdates() async {
    await listenReceiveEvents();
    // if (widget.fetchWeather) {
    //   myLocation = await GlobalMethods.fetchDeviceCurrentLocation(context);
    //   setState(() {
    //     isLoadingProgress = true;
    //   });
    //   bool syncWeather = await calculateWeatherSyncTimeDifference();
    //   if (!syncWeather) {
    //     if (myLocation != null) {
    //       // if (mounted) {
    //       //   Utils.showWaiting(context, false);
    //       // }
    //       //await _activityServiceProvider.setLocationCoOrdinates(myLocation.latitude, myLocation.longitude);
    //       await _activityServiceProvider.setLocationCoOrdinates(myLocation.latitude, myLocation.longitude);
    //       await _activityServiceProvider.callWeatherForecast(myLocation.latitude.toString(), myLocation.longitude.toString(), true);
    //       //  getCurrentWeatherByLocation(myLocation.latitude,myLocation.longitude);
    //       // if (mounted) {
    //       //   Navigator.pop(context);
    //       // }
    //       await checkConnectionValidate();
    //     }
    //   }else{
    //     debugPrint('weather sync skipped.');
    //     await checkConnectionValidate();
    //   }
    // }else{
      await checkConnectionValidate();
    //}
  }
  Future<void> checkConnectionValidate() async {
    bool isDeviceConnected = await _activityServiceProvider.checkIsDeviceConnected();
    debugPrint('isDeviceConnected>> $isDeviceConnected');
    setState(() {
      isLoadingProgress = false;
    });
    if (isDeviceConnected) {
      await validateTimeAndSync();
    } else {
      if (_activityServiceProvider.getDeviceConnected && _activityServiceProvider.getDeviceMacAddress.isNotEmpty) {
         //debugPrint('123 ${_activityServiceProvider.getDeviceConnected}');
         //debugPrint('12367 ${_activityServiceProvider.getDeviceMacAddress}');
         //debugPrint('12345 ${_activityServiceProvider.getDeviceSWName}');
         //debugPrint('isSyncProgress ${_activityServiceProvider.isSyncProgress}');
        if (_activityServiceProvider.isSyncProgress) {
          _activityServiceProvider.updateSyncingView(false);
        }else{
          if (!notifiedDisconnected) {
            retryConnection(context);
          }

        }
      } else {
        _activityServiceProvider.updateSyncingView(false);
        await _activityServiceProvider.updateUserDeviceConnection(false, false, '','');
        if (mounted) {
          GlobalMethods.showAlertDialog(context,  noDeviceFoundHead,noDeviceFoundMessage);
        }
      }
    }
  }

  Future<void> validateTimeAndSync() async {
    // var outputFormat = new DateFormat('yyyy-MM-dd hh:mm:ss a');
    // String outputDate = outputFormat.format(DateTime.now());
    // debugPrint('syncStartedTime>> $outputDate');
    bool doSync = await calculateSyncTimeDifference();
    debugPrint('doSync>> $doSync ');
    _activityServiceProvider.updateSyncingView(doSync);
    if (doSync) {
      await performOverAllSyncOperation();
    }
  }

  Future<bool> calculateWeatherSyncTimeDifference() async {
    String lastWeatherSyncTime = _activityServiceProvider.getWeatherSyncDateTime;
    debugPrint('lastWeatherSyncTime>> $lastWeatherSyncTime');
    //int timeDifference =0;
    if (lastWeatherSyncTime.isNotEmpty) {
      DateTime lastSyncTime = DateTime.parse(lastWeatherSyncTime);
      var currentDateTime = DateTime.now();
      debugPrint('currentWeaTime>> $currentDateTime');
      int diffDays = currentDateTime.difference(lastSyncTime).inDays;
      debugPrint('diffWeaDays>> $diffDays');
      if (diffDays >= 1) {
        return false;
      }else {
        if(diffDays < 1) {
          int timeDifference = currentDateTime.difference(lastSyncTime).inHours;
          debugPrint('diffWeaTime>> $timeDifference');
          if (timeDifference >= 2) {
            return false;
          }else{
            return true;
          }
        } else{
          return false;
        }
      }
    } else {
      return false;
    }
  }

  Future<bool> calculateSyncTimeDifference() async {
    String lastSyncTime = _activityServiceProvider.getLastSyncDated;
    debugPrint('lastSyncTime>> $lastSyncTime');
    //int timeDifference =0;
    if (lastSyncTime.isNotEmpty) {
      DateTime lastTime = DateFormat(defaultLastSyncDateTimeFormat).parse(lastSyncTime);
      var currentTime = DateTime.now();
      debugPrint('currentTime>> $currentTime');
      int diffDays = currentTime.difference(lastTime).inDays;
      debugPrint('diffDays>> $diffDays');
      if (diffDays >= 1) {
        return true;
      } else{
        int timeDifference = currentTime.difference(lastTime).inMinutes;
        debugPrint('diffTime>> $timeDifference');
        if (timeDifference >= 3) {
          return true;
        } else {
          return false;
        }
      }
    } else {
      return true;
    }
  }

  Future<void> onDataUpdated(dynamic data) async {
    var eventData = jsonDecode(data);
    String result = eventData['result'].toString();
    String status = eventData['status'].toString();
    // var jsonData = eventData['data'];

    if (result == BandFitConstants.UPDATE_DEVICE_LIST){
      if (status == BandFitConstants.SC_SUCCESS) {
        List<dynamic> deviceDataList = eventData["data"];
        BandDeviceModel? deviceModel;
        String swName = _activityServiceProvider.getDeviceSWName ??'';
        String macAddress = _activityServiceProvider.getDeviceMacAddress ?? '';

        debugPrint('swName>>$swName');
        debugPrint('macAddress>>$macAddress');
        debugPrint('deviceDataList>>$deviceDataList');
        if (swName.isEmpty) {
          swName = SharedService().getDeviceName();
        }
        if (macAddress.isEmpty) {
          macAddress = SharedService().getDeviceMacAddress();
        }

        for (var data in deviceDataList) {
          if (swName.isNotEmpty) {
            if (data['name'].toString() == swName && data['address'].toString() == macAddress) {
              deviceModel = BandDeviceModel.fromJson(data);
              break;
            }
          }
        }
        debugPrint('deviceModel>>$deviceModel');
        if (deviceModel != null ) {
          bool isDeviceReconnected = await _activityServiceProvider.reConnectSmartDevice(deviceModel);
          debugPrint("isDeviceReconnected>>> $isDeviceReconnected");
          if (isDeviceReconnected) {
            setState(() {
              isReConnectStatus = true;
              reConnectMacAddress = _activityServiceProvider.getDeviceMacAddress;
            });
          }
        }
        debugPrint('reConnectMacAddress>>$reConnectMacAddress');

      }

    }

    else if (result == BandFitConstants.DEVICE_CONNECTED) {
      debugPrint("receiveEventsFromMainScreen>> Device Connected");
      if (status == BandFitConstants.SC_SUCCESS) {
        //await Future.delayed(const Duration(milliseconds: 500));
        //await _activityServiceProvider.updateUserParamsWatch(false);
        // syncFailureTimeOut == 0 > Successfully Got Connected with profile update.
        debugPrint('syncFailureTimeOut>>$syncFailureTimeOut');
        if(Platform.isIOS){
          await _activityServiceProvider.updateUserParamsWatch(false);
        }
      }
    } else if (result == BandFitConstants.SYNC_TIME_OK) {
      //debugPrint("addDeviceListener>> SYNC_TIME_OK");
      if (status == BandFitConstants.SC_SUCCESS) {
        await Future.delayed(const Duration(milliseconds: 500));
        await _activityServiceProvider.updateUserParamsWatch(false);

        isDeviceConnected = true;
        debugPrint('syncFailureTimeOut>>$syncFailureTimeOut');
        if(Platform.isAndroid){
          if (syncFailureTimeOut > 1) {
           // something went wrong
            setState(() {
              isReConnectStatus = true;
            });
            await updateDeviceConnection();
          }
        }
      }
    }
    else if (result == BandFitConstants.UPDATE_DEVICE_PARAMS) {
      if (status == BandFitConstants.SC_SUCCESS) {
        //updateDeviceConnection(true);
        //if(_activityServiceProvider.getJsonWeatherData!=null && _activityServiceProvider.getJsonWeatherData.isNotEmpty){
          //await Future.delayed(const Duration(milliseconds: 500));
        //  await _activityServiceProvider.setWeatherInfoSevenDays();
          /*if (deviceConnectedBleWriteStatus) {
            debugPrint('deviceConnectedBleWriteStatus>>');
            updateDeviceConnection(true);
          }*/
       // }else{
          await updateDeviceConnection();
        //}
      }
    }else if (result == BandFitConstants.SYNC_BLE_WRITE_SUCCESS) {
      if (status == BandFitConstants.SC_SUCCESS) {
        // bool deviceConnected = await _activityServiceProvider.checkIsDeviceConnected();
        //if (deviceConnected) {
        //if (mounted) {
          setState(() {
            deviceConnectedBleWriteStatus = true;
            if (syncFailureTimeOut > 0) {
              syncFailureTimeOut--;
            }
          });
        //}
        //}
      }
    } else if (result == BandFitConstants.SYNC_BLE_WRITE_FAIL) {
      if (status == BandFitConstants.SC_SUCCESS) {
        // connect successfully and data sync failed. Sync again after some time.
        //syncFailureTimeOut++;
        //if (mounted) {
          setState(() {
            syncFailureTimeOut++;
          });
       /// }
          debugPrint('syncFailureTimeOut>> $syncFailureTimeOut');
        if (syncFailureTimeOut == 3) {
          if (deviceConnectedBleWriteStatus) {
            GlobalMethods.showAlertDialogWithFunction(context,syncFailed, syncFailedMsg, retryText, () async {
              Navigator.of(context).pop();
              validateTimeAndSync();
            });
          }
        }else if(syncFailureTimeOut == 1){
          if(deviceConnectedBleWriteStatus){
            if (isDeviceConnected) {
              await updateDeviceConnection();
              //Navigator.of(context).pop();
            }
          }
        }
      }
    }
    else if (result == BandFitConstants.DEVICE_DISCONNECTED) {
      if (status == BandFitConstants.SC_SUCCESS) {
        bool deviceConnected = await _activityServiceProvider.checkIsDeviceConnected();
        debugPrint('deviceConnectedStatus>> $deviceConnected');
        debugPrint('isReConnectStatus>> $isReConnectStatus');
        debugPrint('_activityServiceProvider.isSyncProgress>> ${_activityServiceProvider.isSyncProgress}');
        if (_activityServiceProvider.isSyncProgress) {
          // update syncing false
          _activityServiceProvider.updateSyncingView(false);
          if (mounted) {
            retryConnection(context);
          }
        }else{
          if (!deviceConnected) {
            setState(() {
              notifiedDisconnected = true;
            });
            if(isReConnectStatus){
              String address = await _activityServiceProvider.getConnectedLastDeviceAddress();
              debugPrint('last_address $address');
              if (address.toString().trim() == reConnectMacAddress.toString().trim()) {
                bool lastInitStatus = await _activityServiceProvider.connectWithLastDeviceAddress();
                debugPrint('last_connected_status>> $lastInitStatus');
              }else{
                if (mounted) {
                  Navigator.pop(context);
                  setState(() {
                    isReConnectStatus = false;
                  });
                  retryConnection(context);
                }
              }
            }else{
              debugPrint('isReConnectStatus_else $isReConnectStatus');
              //if(!Platform.isIOS){
              //}
              if(_activityServiceProvider.getDeviceConnected){
                if (mounted) {
                  retryConnection(context);
                }
              }
            }
          }
        }
      }
    }
    else if (result == BandFitConstants.SYNC_WEATHER_SUCCESS) {
      if (status == BandFitConstants.SC_SUCCESS) {
        await updateDeviceConnection();
      }
    }
    else if (result == BandFitConstants.SYNC_STEPS_TIME_OUT) {
      if (status == BandFitConstants.SC_SUCCESS) {
        if (mounted) {
          countStepsTimeOut++;
          if (countStepsTimeOut <=1) {
            if (deviceConnectedBleWriteStatus) {
              _activityServiceProvider.updateSyncingView(false);
              GlobalMethods.showAlertDialogWithFunction(context,syncFailed, syncFailedMsg, retryText, () async {
                Navigator.of(context).pop();
                validateTimeAndSync();
              });
            }
          }
        }
      }
    } else if (result == BandFitConstants.SYNC_SLEEP_TIME_OUT) {
      if (status == BandFitConstants.SC_SUCCESS) {
        // sync time out
        // retry again
        // GlobalMethods.showAlertDialog(context,Utils.tr(context, 'string_connection_failed'), Utils.tr(context, 'string_connection_failed_msg'));
        if (mounted) {
          countSleepTimeOut++;
          if (countSleepTimeOut <=1) {
            if (deviceConnectedBleWriteStatus) {
              _activityServiceProvider.updateSyncingView(false);
              GlobalMethods.showAlertDialogWithFunction(context,syncFailed, syncFailedMsg, retryText, () async {
                Navigator.of(context).pop();
                validateTimeAndSync();
              });
            }
          }
        }
      }
    } else if (result == BandFitConstants.SYNC_TEMPERATURE_TIME_OUT) {
      if (status == BandFitConstants.SC_SUCCESS) {
        // sync time out
        // retry again
        // GlobalMethods.showAlertDialog(context,Utils.tr(context, 'string_connection_failed'), Utils.tr(context, 'string_connection_failed_msg'));
        if (mounted) {
          countTemperatureTimeOut++;
          if (countTemperatureTimeOut <=1) {
            if (deviceConnectedBleWriteStatus) {
              _activityServiceProvider.updateSyncingView(false);
              GlobalMethods.showAlertDialogWithFunction(context,syncFailed, syncFailedMsg, retryText, () async {
                Navigator.of(context).pop();
                validateTimeAndSync();
              });
            }
          }
        }
      }
    }else {
      if (mounted) {
        await _activityServiceProvider.updateEventResult(eventData, context);
      }
    }
  }

  Future<void> updateDeviceConnection() async {
      await _activityServiceProvider.updateUserDeviceConnection(false, true, 'SP', 'SP');
      //await Future.delayed(const Duration(milliseconds: 500));
      await _activityServiceProvider.updateDeviceBandLanguage();
      debugPrint('isReConnectStatus>> $isReConnectStatus');
      if(isReConnectStatus){
        debugPrint('nav_pop>>440');
        Navigator.pop(context);
        setState(() {
          isReConnectStatus = false;
        });
      }
     // Utils.showToastMessage(context, deviceConnected);
      refreshPage();
      validateTimeAndSync();
  }

  void refreshPage() {
    setState(() {});
  }

  void retryConnection(BuildContext context) {
    GlobalMethods.showAlertDialogWithFunction(context, deviceDisconnected, deviceDisconnectedMsg, reconnectText, () async {
      debugPrint("pressed_ok");
      debugPrint('nav_pop>>457');
      Navigator.of(context).pop();
      //Utils.showLoading(context, false, title: reconnectingText);
      //await Future.delayed(const Duration(milliseconds: 500));
      bool statusReconnect = await _activityServiceProvider.connectDeviceWithMacAddress(context);
      //await Future.delayed(const Duration(milliseconds: 500));
      debugPrint("statusReconnect>> $statusReconnect");
      if (statusReconnect) {
        setState(() {
          isReConnectStatus = true;
          reConnectMacAddress = _activityServiceProvider.getDeviceMacAddress;
        });
        // Navigator.pop(context);
      }else{
        //await Future.delayed(const Duration(milliseconds: 500));
        String address = await _activityServiceProvider.getConnectedLastDeviceAddress();
        String selectedDevice = _activityServiceProvider.getDeviceMacAddress;
        if (address.toString().trim() == selectedDevice.toString().trim()) {
          //await Future.delayed(const Duration(milliseconds: 500));
          bool lastInitStatus = await _activityServiceProvider.connectWithLastDeviceAddress();
          debugPrint('last_connected_status>> $lastInitStatus');
          debugPrint('nav_pop>>477');
          Navigator.pop(context);
        }else{
          debugPrint('nav_pop>>480');
          Navigator.pop(context);
        }
      }

      /*if (!statusReconnect) {
        Navigator.pop(context);
      }*/
    });
  }

  Future<void> performOverAllSyncOperation() async {
    //await Future.delayed(const Duration(milliseconds: 500));
    await _activityServiceProvider.syncOverAllData();

    /*bool isConnected = await _activityServiceProvider.checkIsDeviceConnected();
    debugPrint('performOverAllSyncOperation_isConnected>> $isConnected');
    if (isConnected) {
      //check the sync time from preference, if > 1 min then start syncing all the listeners
      await _activityServiceProvider.syncOverAllData();
    } else {
      if (_activityServiceProvider.getDeviceConnected) {
        retryConnection(context);
      } else {
        //show message "No Device is Connected."
        if (showSync) {
          GlobalMethods.showAlertDialog(context, Utils.tr(context, noDeviceFoundHead), Utils.tr(context, noDeviceFoundMessage));
        }
      }
    }*/
  }

  void initializeProgressController() {
    progressController = AnimationController(
        vsync: this,
        // lowerBound: -1.0,
        // upperBound: 1.0,
        duration: const Duration(milliseconds: 800))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        debugPrint('anim status $status');
      });

    syncController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  Future<void> progressUpdate() async {
    double progressPercent = (_activityServiceProvider.getSteps * 100) / int.parse(_activityServiceProvider.getTargetedSteps);
    debugPrint('progressPercentage>> ${progressPercent.toString()}');
    updateProgress(progressPercent);
  }

  Future<void> updateProgress(double progress) async {
    Tween tween = Tween<double>(
      begin: 0,
      end: progress,
    );
    /*Tween _tween = new AlignmentTween(
           begin: new Alignment(0.0, 0.0),
        end: new Alignment(progressPercentage, 0.0),
      );*/
    /* animation = Tween<Offset>(
      begin: const Offset(100.0, 50.0),
      end: const Offset(200.0, 300.0),
    ).animate(progressController);*/
    _animation = tween.animate(progressController);
    /* if (mounted) {
      debugPrint('animation.value>> ${_animation.value.toString()}');
      _activityServiceProvider.setProgressPercentage(progress);
    }*/
    // progressController.value = progressPercentage;
    progressController.forward();
    debugPrint('progressController.value>> ${progressController.value.toString()}');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // These are the callbacks
    switch (state) {
      case AppLifecycleState.resumed:
      // widget is resumed
        debugPrint('AppLifecycleState.resumed');
        _activityServiceProvider.resumeEventListeners();
        break;
      case AppLifecycleState.inactive:
      // widget is inactive
        debugPrint('AppLifecycleState.inactive');
        // when device gets lock screen

        break;
      case AppLifecycleState.paused:
      // widget is paused
        debugPrint('AppLifecycleState.paused');
        break;
      case AppLifecycleState.detached:
      // widget is detached
        debugPrint('AppLifecycleState.detached');
        break;
    }
  }

  @override
  void dispose() {
    progressController.dispose();
    syncController.dispose();
    //WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  goBack() {
    debugPrint('inside_go_back');
    Navigator.pop(context);
   // Get.offAll(const VitalMain());
  }

  @override
  Widget build(BuildContext context) {
   
    return GetBuilder<ActivityServiceProvider>(
      builder: (provider) {
        return WillPopScope(
          onWillPop: () => goBack(),
          child: Scaffold(
            // backgroundColor: Colors.white,
            appBar: AppBar(
              //title: Text('Vitals Health Summary'),
              backgroundColor: Colors.white,
              //elevation: 2.0,
              // iconTheme: IconThemeData(color: Colors.black),
              title: const Text(textBandFit,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              //automaticallyImplyLeading: false,
              automaticallyImplyLeading: Platform.isIOS? true: false,
              leading:  Platform.isIOS? IconButton(
                icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
                /*onPressed: () {
                  Navigator.pop(context);
                },*/
                onPressed: () => goBack(),
              ) :null,
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    if (Get.isDarkMode) {
                      themeController.changeTheme(Themes.lightTheme);
                      themeController.saveTheme(false);
                    } else {
                      themeController.changeTheme(Themes.darkTheme);
                      themeController.saveTheme(true);
                    }
                  },
                  icon: Get.isDarkMode ? const Icon(Icons.light_mode_outlined) : const Icon(Icons.dark_mode_outlined),
                ),
                IconButton(
                  //icon: Icon(Icons.watch_outlined, color: Colors.black),
                  icon: Image.asset('assets/fit/watch_selected.png', width: 32.0, height: 32.0, fit: BoxFit.fill),
                  onPressed: () {
                    // navigate to device connections & goals seetings
                    //if (!provider.isSyncProgress) {
                    // Navigator.push(context,
                    //   MaterialPageRoute(builder: (context) => DeviceSettings(fromLogin: fromLoginUI)),
                    // );
                    // }else{
                    //   showSyncMessage(context);
                    // }

                  },
                ),
              ],
            ),
            body: isLoadingProgress ? const Center(child: CircularProgressIndicator()): ListView(
              children: [
                const SizedBox(
                  height: 8.0,
                ),
                Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 2.0,
                  color: Colors.white,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(2.0),
                    margin: const EdgeInsets.all(2.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // if (provider.getWeatherModelData != null) {
                                //   Navigator.push(context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             WeatherInDetails(weatherModelData: provider.getWeatherModelData,
                                //             )),
                                //   );
                                // }
                              },
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Image.asset('assets/fit/weather.png',
                                      width: 38.0,
                                      height: 38.0,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(2.0),
                                          child: Text(textToday,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                              '${provider.getCurrentTemperature} ${provider.getIsCelsius ? tempInCelsius : tempInFahrenheit}',
                                              // '${todayTime.day}, ${calMonths[todayTime.month - 1]}, ${todayTime.year}',
                                              style: const TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w300)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        const Text(textGoal,
                                          style: TextStyle(
                                            // color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        Text(GlobalMethods.formatNumber(int.parse(provider.targetedSteps)),
                                            style: const TextStyle(fontSize: 12,
                                                fontWeight: FontWeight.w300)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Image.asset(
                                      'assets/fit/goal_left.png',
                                      width: 38.0,
                                      height: 38.0,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Center(
                            child: CustomPaint(
                              //foregroundPainter: CircleProgress(double.parse(_animation.value.toString())),
                              foregroundPainter: CircleProgress(provider.getProgressPercentage),
                              // this will add custom painter after child
                              child: SizedBox(
                                width: 150,
                                height: 150,
                                child: GestureDetector(
                                  onTap: () {
                                    if (!provider.isSyncProgress) {
                                      // Navigator.push(context,
                                      //     MaterialPageRoute(
                                      //       builder: (context) => ActivitiesDetails(
                                      //         displayTitle: Activity.steps.name,
                                      //         activityLabel: Activity.steps.textLabel,
                                      //         stepsView: true,
                                      //         distanceView: false,
                                      //         calView: false,
                                      //       ),
                                      //     ));
                                    } else {
                                      showSyncMessage(context);
                                    }
                                  },
                                  child: Center(
                                    child: Image.asset(
                                      'assets/fit/running.png',
                                      width: 60.0,
                                      height: 60.0,
                                      fit: BoxFit.fill,
                                    ),
                                    /* child: Text(
                                "${animation.value}%",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),*/
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (!provider.isSyncProgress) {
                                  // Navigator.push(context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => ActivitiesDetails(
                                  //       displayTitle: Activity.steps.name,
                                  //       activityLabel: Activity.steps.textLabel,
                                  //       stepsView: true,
                                  //       distanceView: false,
                                  //       calView: false,
                                  //     ),
                                  //   ),
                                  // );
                                } else {
                                  showSyncMessage(context);
                                }
                              },
                              child: IconTextWidget(
                                imagePath: 'assets/fit/footsteps.png',
                                // mainTitle: GlobalMethods.formatNumber(int.parse(noOfSteps.toStringAsFixed(0))),
                                mainTitle: provider.getSteps == 0 ? '-' : GlobalMethods.formatNumber(provider.getSteps),
                                subMainTitle: textSteps,
                              ),
                            ),
                            const SizedBox(
                              height: 23.0,
                              child: VerticalDivider(
                                thickness: 1.0,
                                color: Colors.grey,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (!provider.isSyncProgress) {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => ActivitiesDetails(
                                  //       displayTitle: Activity.distance.name,
                                  //       activityLabel: Activity.distance.textLabel,
                                  //       stepsView: false,
                                  //       distanceView: true,
                                  //       calView: false,
                                  //     ),
                                  //   ),
                                  // );
                                } else {
                                  showSyncMessage(context);
                                }
                              },
                              child: IconTextWidget(
                                imagePath: 'assets/fit/distance.png',
                                //mainTitle: GlobalMethods.formatNumber(int.parse(noOfSteps.toStringAsFixed(0))),
                                mainTitle: provider.getDistance,
                                subMainTitle: 'Km',
                              ),
                            ),
                            const SizedBox(
                              height: 23.0,
                              child: VerticalDivider(
                                thickness: 1.0,
                                color: Colors.grey,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (!provider.isSyncProgress) {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => ActivitiesDetails(
                                  //       displayTitle: Activity.cal.name,
                                  //       activityLabel: Activity.cal.textLabel,
                                  //       stepsView: false,
                                  //       distanceView: false,
                                  //       calView: true,
                                  //     ),
                                  //   ),
                                  // );
                                } else {
                                  showSyncMessage(context);
                                }
                              },
                              child: IconTextWidget(
                                imagePath: 'assets/fit/kcal.png',
                                mainTitle: provider.getCalories,
                                subMainTitle: 'Kcal',
                              ),
                            ),
                            // Container(
                            //   height: 23.0,
                            //   child: VerticalDivider(
                            //     thickness: 1.0,
                            //     color: Colors.grey,
                            //   ),
                            // ),
                            // GestureDetector(
                            //   onTap: () {
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(builder: (context) => WeatherInDetails(
                            //         weatherData: _data,
                            //         weekData: _weekDdata,
                            //       )),
                            //     );
                            //   },
                            //   child: IconTextWidget(
                            //     imagePath: 'assets/fit/my_weather.png',
                            //     mainTitle: currentTempWeather.toStringAsFixed(1)??"0.0",
                            //     subMainTitle: tempInCelsius,
                            //   ),
                            // ),
                          ],
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Visibility(
                          //  visible: !provider.isSyncProgress,
                          visible: (!provider.isSyncProgress && provider.getLastSyncDated.isNotEmpty )&& provider.getDeviceConnected,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text('$textLastSynced : ',style: TextStyle(fontSize: 13), textAlign: TextAlign.center,),
                                  Expanded(
                                    child: Text(_activityServiceProvider.getLastSyncDated.isEmpty ? textLastSyncedNoData : _activityServiceProvider.getLastSyncDated,
                                      style: const TextStyle(fontSize: 12),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  //Spacer(),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Icon(
                                        Icons.sync,
                                        color: Colors.black,
                                        size: 18.0,
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          //fixedSize: Size(86.0, 16.0),
                                          primary: Colors.blue,
                                          //onSurface: Colors.red,
                                        ),
                                        onPressed: () async {
                                          // check if device is connected or not
                                          // then call the sync methods and wait until the result.
                                          // Utils.showLoading(context, false, title: reconnectingText);
                                          bool isConnected = await provider.checkIsDeviceConnected();
                                          debugPrint('sync_now_isConnected>> $isConnected');
                                          if (isConnected) {
                                            await performOverAllSyncOperation();
                                          }else {
                                            if (_activityServiceProvider.getDeviceConnected) {
                                              retryConnection(context);
                                            } else {
                                              //show message "No Device is Connected."
                                              if (provider.isSyncProgress) {
                                                GlobalMethods.showAlertDialog(context,  noDeviceFoundHead,  noDeviceFoundMessage);
                                              }
                                            }
                                          }

                                        },
                                        child: const Text(
                                          textSyncNow,
                                          style: TextStyle(
                                              color: Colors.blue,
                                              decoration: TextDecoration.underline,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: !provider.isSyncProgress && !provider.getDeviceConnected? true : false,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                    child: GestureDetector(
                      onTap: () {
                        // Get.to(() => AddDevice());
                        // Navigator.push(context,
                        //   MaterialPageRoute(
                        //       builder: (context) => const AddDevice()),
                        // );
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
                              Image.asset('assets/fit/watch.png',
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
                  ),
                ),
                Visibility(
                  visible: provider.isSyncProgress,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                    child: GestureDetector(
                      onTap: () {
                        // Get.to(() => AddDevice());
                        /*Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddDevice()),
                        );*/
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
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: AnimatedBuilder(
                                  animation: syncController,
                                  builder: (_, child) {
                                    return Transform.rotate(
                                      angle: syncController.value * 2 * math.pi,
                                      child: child,
                                    );
                                  },
                                  child: const Icon(
                                    Icons.sync_outlined,
                                    color: Colors.redAccent,
                                    size: 30.0,
                                  ),
                                ),
                              ),
                              /*Transform.rotate(
                                angle: 360,
                                child: Icon(
                                  Icons.sync_outlined,
                                  color: Colors.redAccent,
                                  size: 30.0,
                                ),
                              ),*/
                              const Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(textSyncingDataMsg),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                  child: GestureDetector(
                    onTap: () {
                      //Get.to(() => VitalInDetail( displayTitle: 'Heart Rate'));
                      // if (!provider.isSyncProgress) {

                      // Navigator.push(context,
                      //   MaterialPageRoute(
                      //       builder: (context) => HeartRateDetail(
                      //         displayTitle: Activity.heartRate.name,
                      //         activityLabel: Activity.heartRate.textLabel,
                      //       )),
                      // );

                      // } else {
                      //   showSyncMessage(context);
                      // }
                    },
                    child: VitalDataWidget(
                      imagePath: 'assets/fit/heart.png',
                      title: textHeartRate,
                      value: provider.getHRValue,
                      units: 'bpm',
                      minutes: '',
                      time: provider.getHRDateTime,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                  child: GestureDetector(
                    onTap: () {
                      //if (!provider.isSyncProgress) {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => SleepDetails(
                      //       displayTitle: Activity.sleepDuration.name,
                      //       activityLabel: Activity.sleepDuration.textLabel,
                      //     ),
                      //   ),
                      // );
                      // } else {
                      //   showSyncMessage(context);
                      // }
                    },
                    child: VitalDataWidget(
                      imagePath: 'assets/fit/sleep.png',
                      title: textSleepDuration,
                      value: provider.getSleepHrs,
                      //5h 21 min
                      units: '',
                      minutes: provider.getSleepMinutes,
                      time: provider.getSleepHrsDateTime,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                  child: GestureDetector(
                    onTap: () {
                      //Get.to(() => VitalInDetail( displayTitle: 'Blood Pressure'));
                      if (!provider.isSyncProgress) {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => BloodPressureDetails(
                        //         displayTitle: Activity.bp.name,
                        //         activityLabel: Activity.bp.textLabel,
                        //       )),
                        // );
                      } else {
                        showSyncMessage(context);
                      }
                    },
                    child: VitalDataWidget(
                      imagePath: 'assets/fit/blood_pressure.png',
                      //imagePath: 'assets/fit/bp_grey.png',
                      title: textBP,
                      value: provider.getBloodPressure,
                      //126/81 (range zero to 200 only 128 need to plot)
                      units: 'mmHg',
                      minutes: '',
                      time: provider.getBpDateTime,
                    ),
                  ),
                ),
                Visibility(
                  //visible: provider.getOxygenAvailable,
                  //visible: false,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                    child: GestureDetector(
                      onTap: () {
                        if (!provider.isSyncProgress) {
                          // Navigator.push(context,
                          //   MaterialPageRoute(
                          //       builder: (context) => OxygenDetail(
                          //         displayTitle: Activity.oxygen.name,
                          //         activityLabel: Activity.oxygen.textLabel,
                          //       )),
                          // );
                        } else {
                          showSyncMessage(context);
                        }
                      },
                      child: VitalDataWidget(
                        imagePath: 'assets/fit/blood_oxygen.png',
                        //imagePath: 'assets/fit/oxygen_saturation.png',
                        title: textSpo2,
                        value: provider.getOxygenValue,
                        units: '%',
                        time: provider.getOxygenDateTime,
                        minutes: '',
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                  child: GestureDetector(
                    onTap: () {
                      //Get.to(() => VitalInDetail( displayTitle: 'Body Temperature'));
                      //if (!provider.isSyncProgress) {
                      // Navigator.push(context,
                      //   MaterialPageRoute(
                      //       builder: (context) => TemperatureDetails(
                      //         displayTitle: Activity.temperature.name,
                      //         activityLabel: Activity.temperature.textLabel,
                      //       )),
                      // );
                      //} else {
                      //  showSyncMessage(context);
                      //}
                    },
                    child: VitalDataWidget(
                      imagePath: 'assets/fit/temperature.png',
                      //imagePath: 'assets/fit/temperature.png',
                      title: textTemperature,
                      value: provider.getTemperature,
                      //126/81 (range zero to 200 only 128 need to plot)
                      units: provider.getIsCelsius ? tempInCelsius : tempInFahrenheit,
                      minutes: '',
                      time: provider.getTemperatureDateTime,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showSyncMessage(BuildContext context) {
    GlobalMethods.showAlertDialog(context, textPleaseWait, textPleaseWaitMsg);
  }

/*getCurrentWeatherByLocation(double lat, double lon) async{
    Weather weather = await ws.currentWeatherByLocation(lat, lon);
    _weekDdata = await ws.fiveDayForecastByLocation(lat, lon);

    List<int> weatherForcastingDaysList = GlobalMethods.getWeakDayList(2);
    debugPrint('weatherForcastingDaysList>>17> ${weatherForcastingDaysList.length}');
    getFilteredData(weatherForcastingDaysList);

    debugPrint('_weekDdata>894>> ${_weekDdata}');
    _data = [weather];
    debugPrint('_data>>> ${_data}');
    setState(() {
     currentTempWeather = _data[0].temperature.celsius;
     debugPrint('currentTempWeather>> ${currentTempWeather}');
    });
  }*/

/*  getFilteredData(List<int> weatherForcastingDaysList) {
    List<Weather> sortedTwoDaysData = [];
    for(int forcastingDay in weatherForcastingDaysList){
      Weather oneDayWeather =  getSortedWeather(forcastingDay);
      sortedTwoDaysData.add(oneDayWeather);
    }
  }

  Weather getSortedWeather(int forcastingDay) {
    debugPrint('forcastingDay>> ${forcastingDay}');
    Weather currentWeather;
    for(int i=0;i<_weekDdata.length;i++){
      int dateTo = _weekDdata[i].date.day;
      if(dateTo == forcastingDay){
        currentWeather = _weekDdata[i];
      }
    }
    return currentWeather;
  }*/

}




