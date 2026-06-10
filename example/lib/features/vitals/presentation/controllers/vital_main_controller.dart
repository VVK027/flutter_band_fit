
import 'package:flutter_band_fit_app/app/theme/theme_controller.dart';
import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:flutter_band_fit_app/core/services/activity_service_provider.dart';
import 'package:flutter_band_fit_app/core/utils/shared_service.dart';
import 'package:flutter_band_fit_app/features/vitals/domain/usecases/check_vitals_device_connection_usecase.dart';
import 'package:flutter_band_fit_app/features/vitals/domain/usecases/reconnect_vitals_device_usecase.dart';
import 'package:flutter_band_fit_app/features/vitals/domain/usecases/should_sync_vitals_usecase.dart';
import 'package:flutter_band_fit_app/features/vitals/domain/usecases/sync_overall_vitals_usecase.dart';


/// Home / vitals dashboard: connection checks, pull-to-sync, and band event handling.
class VitalMainController extends GetxController
    with GetTickerProviderStateMixin, WidgetsBindingObserver {

  final themeController = Get.find<ThemeController>();
  final  _activityServiceProvider = Get.find<ActivityServiceProvider>();
  final CheckVitalsDeviceConnectionUseCase _checkVitalsDeviceConnectionUseCase =
      Get.find<CheckVitalsDeviceConnectionUseCase>();
  final ReconnectVitalsDeviceUseCase _reconnectVitalsDeviceUseCase =
      Get.find<ReconnectVitalsDeviceUseCase>();
  final ShouldSyncVitalsUseCase _shouldSyncVitalsUseCase = Get.find<ShouldSyncVitalsUseCase>();
  final SyncOverallVitalsUseCase _syncOverallVitalsUseCase = Get.find<SyncOverallVitalsUseCase>();

  DateTime todayTime = DateTime.now();
  bool isReConnectStatus = false;
  bool deviceConnectedBleWriteStatus = false;
  bool isDeviceConnected = false;
  String reConnectMacAddress = '';

  //late Position myLocation;
  late AnimationController progressController, syncController;

  final isLoadingProgress = true.obs;
  bool notifiedDisconnected = false; // to notify a single reconnect

  late double lat, lon;
  double currentTempWeather = 0.0;

  int countStepsTimeOut =0, countSleepTimeOut =0, countTemperatureTimeOut =0;
  int syncFailureTimeOut = 0;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    reConnectMacAddress = _activityServiceProvider.getDeviceMacAddress;
    initializeProgressController();
    if (!_activityServiceProvider.getHealthConnected) {
      listenFitBandUpdates();
      progressUpdate();
    }
  }

  Future<void> listenReceiveEvents() async {
    _activityServiceProvider.receiveEventsFrom(onDataUpdate: (data) {
      debugPrintI("receiveEventsFromMainScreen>> $data");
      onDataUpdated(data);
    }, onError: (error) {
      debugPrintI("receiveEventsFromError::>> $error");
    }, onDone: () {
      debugPrintI("receiveEventsFromOnDone::>> ");
    });
    Map<Permission, PermissionStatus> statuses;
    if (Platform.isAndroid) {
      final sdkInt = await _activityServiceProvider.getAndroidSDKInt();
      if (sdkInt >= 31) {
        statuses = await [
          Permission.bluetoothConnect,
          Permission.bluetoothScan,
          Permission.locationWhenInUse,
          Permission.location,
        ].request();
      } else {
        statuses = await [Permission.bluetooth, Permission.location].request();
      }
    } else {
      statuses = await [Permission.bluetooth, Permission.location, Permission.locationAlways, Permission.locationWhenInUse].request();
    }
    debugPrintI('statuses>> $statuses');
  }

  Future<void> listenFitBandUpdates() async {
    await listenReceiveEvents();
    await _waitForPersistedVitalsData();
    await checkConnectionValidate();
  }

  Future<void> _waitForPersistedVitalsData() async {
    if (_activityServiceProvider.isLocalDataLoaded.value) {
      return;
    }
    await _activityServiceProvider.isLocalDataLoaded.stream
        .firstWhere((loaded) => loaded);
  }
  Future<void> checkConnectionValidate() async {
    bool isDeviceConnected = await _checkVitalsDeviceConnectionUseCase();
    debugPrintI('isDeviceConnected>> $isDeviceConnected');
    if (Get.context == null) return;

    if (isDeviceConnected) {
      await _activityServiceProvider.syncPairedDeviceFromBle();
      isLoadingProgress.value = false;
      update();
      await validateTimeAndSync();
      return;
    }

    isLoadingProgress.value = false;
    update();

    final savedMac = sharedService.getDeviceMacAddress();
    final savedConnected = sharedService.isSmartMConnected();
    final hasPersistedDevice = savedConnected && savedMac.trim().isNotEmpty;

    if (hasPersistedDevice &&
        (!_activityServiceProvider.getDeviceConnected ||
            _activityServiceProvider.getDeviceMacAddress.isEmpty)) {
      await _activityServiceProvider.updateUserDeviceConnection(
        false,
        true,
        'SP',
        'SP',
      );
    }

    if (_activityServiceProvider.getDeviceConnected &&
        _activityServiceProvider.getDeviceMacAddress.isNotEmpty) {
      if (_activityServiceProvider.isSyncProgress) {
        _activityServiceProvider.updateSyncingView(false);
      } else if (!notifiedDisconnected) {
        retryConnection(Get.context!);
      }
    } else if (!hasPersistedDevice) {
      _activityServiceProvider.updateSyncingView(false);
      await _activityServiceProvider.updateUserDeviceConnection(
        false,
        false,
        '',
        '',
      );
      if (Get.context != null) {
        GlobalMethods.showAlertDialog(
          Get.context!,
          noDeviceFoundHead,
          noDeviceFoundMessage,
        );
      }
    } else if (!notifiedDisconnected) {
      retryConnection(Get.context!);
    }
  }

  Future<void> validateTimeAndSync() async {
    // var outputFormat = new DateFormat('yyyy-MM-dd hh:mm:ss a');
    // String outputDate = outputFormat.format(DateTime.now());
    // debugPrintI('syncStartedTime>> $outputDate');
    bool doSync = await calculateSyncTimeDifference();
    debugPrintI('doSync>> $doSync ');
    _activityServiceProvider.updateSyncingView(doSync);
    if (doSync) {
      await performOverAllSyncOperation();
    }
  }

  Future<bool> calculateWeatherSyncTimeDifference() async {
    String lastWeatherSyncTime = _activityServiceProvider.getWeatherSyncDateTime;
    debugPrintI('lastWeatherSyncTime>> $lastWeatherSyncTime');
    //int timeDifference =0;
    if (lastWeatherSyncTime.isNotEmpty) {
      DateTime lastSyncTime = DateTime.parse(lastWeatherSyncTime);
      var currentDateTime = DateTime.now();
      debugPrintI('currentWeaTime>> $currentDateTime');
      int diffDays = currentDateTime.difference(lastSyncTime).inDays;
      debugPrintI('diffWeaDays>> $diffDays');
      if (diffDays >= 1) {
        return false;
      }else {
        if(diffDays < 1) {
          int timeDifference = currentDateTime.difference(lastSyncTime).inHours;
          debugPrintI('diffWeaTime>> $timeDifference');
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
    return _shouldSyncVitalsUseCase();
  }

  Future<void> onDataUpdated(dynamic data) async {
    final eventData = JsonUtils.asMap(jsonDecode(data as String));
    final result = JsonUtils.asString(eventData['result']);
    final status = JsonUtils.asString(eventData['status']);
    // var jsonData = eventData['data'];

    if (result == BandFitConstants.UPDATE_DEVICE_LIST){
      if (status == BandFitConstants.SC_SUCCESS) {
        final deviceDataList = JsonUtils.asList(eventData['data']);
        BandDeviceModel? deviceModel;
        String swName = _activityServiceProvider.getDeviceSWName;
        String macAddress = _activityServiceProvider.getDeviceMacAddress;

        debugPrintI('swName>>$swName');
        debugPrintI('macAddress>>$macAddress');
        debugPrintI('deviceDataList>>$deviceDataList');
        if (swName.isEmpty) {
          swName = SharedService().getDeviceName();
        }
        if (macAddress.isEmpty) {
          macAddress = SharedService().getDeviceMacAddress();
        }

        for (var data in deviceDataList) {
          if (swName.isNotEmpty) {
            if (data['name'].toString() == swName && data['address'].toString() == macAddress) {
              deviceModel = BandDeviceModel.fromJson(JsonUtils.asMap(data));
              break;
            }
          }
        }
        debugPrintI('deviceModel>>$deviceModel');
        if (deviceModel != null ) {
          bool isDeviceReconnected = await _activityServiceProvider.reConnectSmartDevice(deviceModel);
          debugPrintI("isDeviceReconnected>>> $isDeviceReconnected");
          if (isDeviceReconnected) {
    isReConnectStatus = true;
              reConnectMacAddress = _activityServiceProvider.getDeviceMacAddress;
    update();
          }
        }
        debugPrintI('reConnectMacAddress>>$reConnectMacAddress');

      }

    }

    else if (result == BandFitConstants.DEVICE_CONNECTED) {
      debugPrintI("receiveEventsFromMainScreen>> Device Connected");
      _activityServiceProvider.clearAutoReconnectGuard();
      notifiedDisconnected = false;
      if (status == BandFitConstants.SC_SUCCESS) {
        //await Future.delayed(const Duration(milliseconds: 500));
        //await _activityServiceProvider.updateUserParamsWatch(false);
        // syncFailureTimeOut == 0 > Successfully Got Connected with profile update.
        debugPrintI('syncFailureTimeOut>>$syncFailureTimeOut');
        if(Platform.isIOS){
          await _activityServiceProvider.updateUserParamsWatch(false);
        }
      }
    } else if (result == BandFitConstants.SYNC_TIME_OK) {
      //debugPrintI("addDeviceListener>> SYNC_TIME_OK");
      if (status == BandFitConstants.SC_SUCCESS) {
        await Future<void>.delayed(const Duration(milliseconds: 500));
        await _activityServiceProvider.updateUserParamsWatch(false);

        isDeviceConnected = true;
        debugPrintI('syncFailureTimeOut>>$syncFailureTimeOut');
        if(Platform.isAndroid){
          if (syncFailureTimeOut > 1) {
            // something went wrong
    isReConnectStatus = true;
    update();
            await updateDeviceConnection();
          }
        }
      }
    }
    else if (result == BandFitConstants.UPDATE_DEVICE_PARAMS) {
      if (status == BandFitConstants.SC_SUCCESS) {
        await updateDeviceConnection();
      }
    } else if (result == BandFitConstants.SYNC_BLE_WRITE_SUCCESS) {
      if (status == BandFitConstants.SC_SUCCESS) {
        deviceConnectedBleWriteStatus = true;
        if (syncFailureTimeOut > 0) {
          syncFailureTimeOut--;
        }
        update();
      }
    } else if (result == BandFitConstants.SYNC_BLE_WRITE_FAIL) {
      if (status == BandFitConstants.SC_SUCCESS) {
        syncFailureTimeOut++;
        update();
        debugPrintI('syncFailureTimeOut>> $syncFailureTimeOut');
        if (syncFailureTimeOut == 3) {
          if (deviceConnectedBleWriteStatus) {
            GlobalMethods.showAlertDialogWithFunction(Get.context!,syncFailed, syncFailedMsg, retryText, () async {
              // Navigator.of(context).pop();
              GlobalMethods.navigatePopBack();
              validateTimeAndSync();
            });
          }
        }else if(syncFailureTimeOut == 1){
          if(deviceConnectedBleWriteStatus){
            if (isDeviceConnected) {
              await updateDeviceConnection();
            }
          }
        }
      }
    }
    else if (result == BandFitConstants.DEVICE_DISCONNECTED) {
      if (status == BandFitConstants.SC_SUCCESS) {
        final bleConnected = await _checkVitalsDeviceConnectionUseCase();
        debugPrintI('deviceConnectedStatus>> $bleConnected');
        debugPrintI('isReConnectStatus>> $isReConnectStatus');
        debugPrintI('_activityServiceProvider.isSyncProgress>> ${_activityServiceProvider.isSyncProgress}');
        if (_activityServiceProvider.isSyncProgress) {
          _activityServiceProvider.updateSyncingView(false);
        }
        if (!bleConnected) {
          unawaited(_handleUnexpectedDisconnect());
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
        _handleStepsTimeout();
      }
    } else if (result == BandFitConstants.SYNC_SLEEP_TIME_OUT) {
      if (status == BandFitConstants.SC_SUCCESS) {
        _handleSleepTimeout();
      }
    } else if (result == BandFitConstants.SYNC_TEMPERATURE_TIME_OUT) {
      if (status == BandFitConstants.SC_SUCCESS) {
        _handleTemperatureTimeout();
      }
    }else {
      if (Get.context != null) {
        await _activityServiceProvider.updateEventResult(eventData, Get.context!);
      }
    }
  }

  Future<void> updateDeviceConnection() async {
    await _activityServiceProvider.updateUserDeviceConnection(false, true, 'SP', 'SP');
    if (Platform.isAndroid) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
    }
    await _activityServiceProvider.fetchDeviceVersion();
    await _activityServiceProvider.fetchBatteryStatus();
    await _activityServiceProvider.updateDeviceBandLanguage();
    debugPrintI('isReConnectStatus>> $isReConnectStatus');
    if(isReConnectStatus){
      debugPrintI('nav_pop>>440');
      GlobalMethods.navigatePopBack();
    isReConnectStatus = false;
    update();
    }
    // Utils.showToastMessage(context, deviceConnected);
    refreshPage();
    validateTimeAndSync();
  }

  void refreshPage() => update();

  Future<void> _handleUnexpectedDisconnect() async {
    final savedMac = sharedService.getDeviceMacAddress().trim();
    final hadPairedDevice = savedMac.isNotEmpty ||
        _activityServiceProvider.getDeviceMacAddress.isNotEmpty;
    if (!hadPairedDevice) {
      return;
    }

    final reconnected =
        await _activityServiceProvider.attemptAutoReconnectAfterUnexpectedDisconnect();
    if (reconnected) {
      isReConnectStatus = true;
      reConnectMacAddress = _activityServiceProvider.getDeviceMacAddress;
      update();
      return;
    }

    if (isReConnectStatus) {
      final address = await _activityServiceProvider.getConnectedLastDeviceAddress();
      debugPrintI('last_address $address');
      if (address.trim() == reConnectMacAddress.trim()) {
        final lastInitStatus =
            await _activityServiceProvider.connectWithLastDeviceAddress();
        debugPrintI('last_connected_status>> $lastInitStatus');
        if (lastInitStatus) {
          return;
        }
      } else if (Get.context != null) {
        GlobalMethods.navigatePopBack();
        isReConnectStatus = false;
        update();
      }
    }

    if (!notifiedDisconnected && Get.context != null) {
      notifiedDisconnected = true;
      update();
      retryConnection(Get.context!);
    }
  }

  Future<void> _reconnectIfNeededOnResume() async {
    if (_activityServiceProvider.getHealthConnected) {
      return;
    }
    final connected = await _checkVitalsDeviceConnectionUseCase();
    if (connected) {
      return;
    }
    final savedMac = sharedService.getDeviceMacAddress().trim();
    if (savedMac.isEmpty) {
      return;
    }
    await _activityServiceProvider.attemptAutoReconnectAfterUnexpectedDisconnect();
  }

  void retryConnection(BuildContext context) {
    GlobalMethods.showAlertDialogWithFunction(Get.context!, deviceDisconnected, deviceDisconnectedMsg, reconnectText, () async {
      debugPrintI("pressed_ok");
      final ctx = Get.context;
      if (ctx == null) return;
      bool statusReconnect = await _reconnectVitalsDeviceUseCase(ctx);
      //await Future.delayed(const Duration(milliseconds: 500));
      debugPrintI("statusReconnect>> $statusReconnect");
      if (statusReconnect) {
    isReConnectStatus = true;
          reConnectMacAddress = _activityServiceProvider.getDeviceMacAddress;
    update();
        // GlobalMethods.navigatePopBack();
      } else {
        final lastInitStatus =
            await _activityServiceProvider.connectWithLastDeviceAddress();
        debugPrintI('last_connected_status>> $lastInitStatus');
        if (lastInitStatus) {
          isReConnectStatus = true;
          reConnectMacAddress = _activityServiceProvider.getDeviceMacAddress;
          update();
        }
      }

      /*if (!statusReconnect) {
        GlobalMethods.navigatePopBack();
      }*/
    });
  }

  Future<void> performOverAllSyncOperation() async {
    //await Future.delayed(const Duration(milliseconds: 500));
    await _syncOverallVitalsUseCase();

    /*bool isConnected = await _activityServiceProvider.checkIsDeviceConnected();
    debugPrintI('performOverAllSyncOperation_isConnected>> $isConnected');
    if (isConnected) {
      //check the sync time from preference, if > 1 min then start syncing all the listeners
      await _activityServiceProvider.syncOverAllData();
    } else {
      if (_activityServiceProvider.getDeviceConnected) {
        retryConnection(Get.context!);
      } else {
        //show message "No Device is Connected."
        if (showSync) {
          GlobalMethods.showAlertDialog(Get.context!, Utils.tr(context, noDeviceFoundHead), Utils.tr(context, noDeviceFoundMessage));
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
      ..addStatusListener((status) {
        debugPrintI('anim status $status');
      });

    syncController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  Future<void> progressUpdate() async {
    double progressPercent = (_activityServiceProvider.getSteps * 100) / int.parse(_activityServiceProvider.getTargetedSteps);
    debugPrintI('progressPercentage>> ${progressPercent.toString()}');
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
    tween.animate(progressController);
    // progressController.value = progressPercentage;
    progressController.forward();
    debugPrintI('progressController.value>> ${progressController.value.toString()}');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // These are the callbacks
    switch (state) {
      case AppLifecycleState.resumed:
      // widget is resumed
        debugPrintI('AppLifecycleState.resumed');
        _activityServiceProvider.resumeEventListeners();
        unawaited(_reconnectIfNeededOnResume());
        break;
      case AppLifecycleState.inactive:
      // widget is inactive
        debugPrintI('AppLifecycleState.inactive');
        // when device gets lock screen

        break;
      case AppLifecycleState.paused:
      // widget is paused
        debugPrintI('AppLifecycleState.paused');
        break;
      case AppLifecycleState.detached:
      // widget is detached
        debugPrintI('AppLifecycleState.detached');
        break;
      case AppLifecycleState.hidden:
        debugPrintI('AppLifecycleState.hidden');
        break;
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    progressController.dispose();
    syncController.dispose();
    super.onClose();
  }

  void goBack() {
    debugPrintI('inside_go_back');
    GlobalMethods.navigatePopBack();
    // Get.offAll(const VitalMain());
  }

  void showSyncMessage(BuildContext context) {
    GlobalMethods.showAlertDialog(Get.context!, textPleaseWait, textPleaseWaitMsg);
  }

  Future<void> handleSyncNow(BuildContext context) async {
    final provider = _activityServiceProvider;
    final isConnected = await _checkVitalsDeviceConnectionUseCase();
    if (!context.mounted) return;
    if (isConnected) {
      await performOverAllSyncOperation();
    } else if (provider.getDeviceConnected) {
      retryConnection(context);
    } else if (provider.isSyncProgress) {
      GlobalMethods.showAlertDialog(
        context,
        noDeviceFoundHead,
        noDeviceFoundMessage,
      );
    }
  }

  void _handleStepsTimeout() {
    _handleSingleRetryTimeout(
      counter: ++countStepsTimeOut,
    );
  }

  void _handleSleepTimeout() {
    // sync time out
    // retry again
    // GlobalMethods.showAlertDialog(Get.context!,Utils.tr(context, 'string_connection_failed'), Utils.tr(context, 'string_connection_failed_msg'));
    _handleSingleRetryTimeout(
      counter: ++countSleepTimeOut,
    );
  }

  void _handleTemperatureTimeout() {
    // sync time out
    // retry again
    // GlobalMethods.showAlertDialog(Get.context!,Utils.tr(context, 'string_connection_failed'), Utils.tr(context, 'string_connection_failed_msg'));
    _handleSingleRetryTimeout(
      counter: ++countTemperatureTimeOut,
    );
  }

  void _handleSingleRetryTimeout({required int counter}) {
    final ctx = Get.context;
    if (ctx == null) return;
    if (counter > 1 || !deviceConnectedBleWriteStatus) return;
    _activityServiceProvider.updateSyncingView(false);
    GlobalMethods.showAlertDialogWithFunction(
      ctx,
      syncFailed,
      syncFailedMsg,
      retryText,
      () async {
        //Navigator.of(context).pop();
        GlobalMethods.navigatePopBack();
        validateTimeAndSync();
      },
    );
  }

/*getCurrentWeatherByLocation(double lat, double lon) async{
    Weather weather = await ws.currentWeatherByLocation(lat, lon);
    _weekDdata = await ws.fiveDayForecastByLocation(lat, lon);

    List<int> weatherForcastingDaysList = GlobalMethods.getWeakDayList(2);
    debugPrintI('weatherForcastingDaysList>>17> ${weatherForcastingDaysList.length}');
    getFilteredData(weatherForcastingDaysList);

    debugPrintI('_weekDdata>894>> ${_weekDdata}');
    _data = [weather];
    debugPrintI('_data>>> ${_data}');
    currentTempWeather = _data[0].temperature.celsius;
     debugPrintI('currentTempWeather>> ${currentTempWeather}');
    update();
  }*/

/*  getFilteredData(List<int> weatherForcastingDaysList) {
    List<Weather> sortedTwoDaysData = [];
    for(int forcastingDay in weatherForcastingDaysList){
      Weather oneDayWeather =  getSortedWeather(forcastingDay);
      sortedTwoDaysData.add(oneDayWeather);
    }
  }

  Weather getSortedWeather(int forcastingDay) {
    debugPrintI('forcastingDay>> ${forcastingDay}');
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




