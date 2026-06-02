import 'package:flutter_band_fit_app/app/routes/app_routes.dart';
import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:flutter_band_fit_app/features/device/domain/repositories/device_presentation_repository.dart';
import 'package:flutter_band_fit_app/features/device/domain/usecases/check_device_connection_usecase.dart';
import 'package:flutter_band_fit_app/features/device/domain/usecases/scan_devices_usecase.dart';
import 'package:flutter_band_fit_app/features/health/presentation/views/apple_google_bind.dart';

class AddDeviceController extends GetxController {
  static const String _doctyDeviceNamePrefix = 'Docty-M';
  static const String _smartBandDisplayName = 'SmartBand 9';

  final DevicePresentationRepository _deviceRepository = Get.find<DevicePresentationRepository>();
  final CheckDeviceConnectionUseCase _checkDeviceConnectionUseCase = Get.find<CheckDeviceConnectionUseCase>();
  final ScanDevicesUseCase _scanDevicesUseCase = Get.find<ScanDevicesUseCase>();

  final smartDevicesList = <BandDeviceModel>[].obs;
  final showProgress = false.obs;
  final isConnecting = false.obs;
  final showMessage = ''.obs;
  final arrConDisConButton = <String>[].obs;

  var selectedIndex = 0;
  late BandDeviceModel selectedDevice;

  var syncFailCounter = 0;
  var profileUpdatedBand = false;
  var _deviceSetupCompleted = false;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future<void> initialize() async {
    if (Platform.isAndroid) {
      final sdkInt = await _deviceRepository.getAndroidSDKInt();
      if (sdkInt >= 31) {
        await [
          Permission.bluetoothConnect,
          Permission.bluetoothScan,
          Permission.locationWhenInUse,
          Permission.location,
        ].request();
      } else {
        await [Permission.bluetooth, Permission.location].request();
      }
    } else {
      await [
        Permission.bluetooth,
        Permission.location,
        Permission.locationAlways,
        Permission.locationWhenInUse,
      ].request();
    }

    showProgress.value = true;
    final initResult = await _deviceRepository.initializeDeviceConnection();
    debugPrint('initResult $initResult');

    final ctx = Get.context;
    if (ctx == null) return;

    final result = initResult.toString();
    if (result == BandFitConstants.BLE_NOT_SUPPORTED) {
      if(ctx.mounted) {
        GlobalMethods.showAlertDialog(ctx, '$textBluetooth 4.0', '$bleNotSupported v4.0');
      }
    } else if (result == BandFitConstants.BLE_NOT_ENABLED ||
        result == BandFitConstants.SC_CANCELED) {
      if(ctx.mounted) {
        GlobalMethods.showAlertDialog(ctx, textBluetooth, bleNotConnected);
      }
    } else if (result == BandFitConstants.SC_INIT) {
      await addDeviceListener();
      await fetchBluDevicesList();
    }
  }

  Future<void> addDeviceListener() async {
    _deviceRepository.receiveEventsFrom(
      onDataUpdate: (data) async {
        final eventData = jsonDecode(data);
        debugPrint('addDeviceListener>> $data');
        final result = eventData['result'].toString();
        final status = eventData['status'].toString();

        if (result == BandFitConstants.DEVICE_CONNECTED) {
          if (status == BandFitConstants.SC_SUCCESS) {
            await checkDeviceConnectReset();
            if (Platform.isIOS) {
              await _deviceRepository.updateUserParamsWatch(false);
            }
          }
        } else if (result == BandFitConstants.SYNC_TIME_OK) {
          if (status == BandFitConstants.SC_SUCCESS) {
            await Future.delayed(const Duration(milliseconds: 500));
            await _deviceRepository.updateUserParamsWatch(false);
            // Some bands never emit updateDeviceParams after profile sync on Android.
            if (Platform.isAndroid) {
              await _finalizeDeviceConnection();
            }
          }
        } else if (result == BandFitConstants.UPDATE_DEVICE_LIST) {
          if (status == BandFitConstants.SC_SUCCESS) {
            final deviceList = <BandDeviceModel>[];
            final responseData = eventData['data'] as List<dynamic>;
            for (final item in responseData) {
              deviceList.add(_deviceFromScanResult(item));
            }
            if (deviceList.isNotEmpty) {
              arrConDisConButton.assignAll(
                List.filled(deviceList.length, 'Connect'),
              );
              smartDevicesList.assignAll(deviceList);
              showProgress.value = false;
            }
          }
        } else if (result == BandFitConstants.UPDATE_DEVICE_PARAMS) {
          if (status == BandFitConstants.SC_SUCCESS) {
            if (syncFailCounter == 1) {
              if (_deviceRepository.getJsonWeatherData().isNotEmpty) {
                await _deviceRepository.setWeatherInfoSevenDays();
              } else {
                await _finalizeDeviceConnection();
              }
            } else {
              profileUpdatedBand = true;
              if (_deviceRepository.getJsonWeatherData().isNotEmpty) {
                await _deviceRepository.setWeatherInfoSevenDays();
              } else {
                await _finalizeDeviceConnection();
              }
            }
          }
        } else if (result == BandFitConstants.DEVICE_DISCONNECTED) {
          if (status == BandFitConstants.SC_SUCCESS) {
            final alreadyConnected = await _checkDeviceConnectionUseCase();
            if (!alreadyConnected) {
              final address = await _deviceRepository.getConnectedLastDeviceAddress();
              final ctx = Get.context;
              if (ctx == null) return;
              if (selectedDevice.address.isNotEmpty) {
                if (address.trim() == selectedDevice.address.trim()) {
                  await _deviceRepository.connectWithLastDeviceAddress();
                } else if (!_deviceRepository.getDeviceConnected()) {
                  _stopConnecting();
                  if (!ctx.mounted) return;
                  GlobalMethods.showAlertDialog(
                    ctx,
                    textConnectionFailed,
                    textConnectionFailedMsg,
                  );
                  GlobalMethods.navigatePopBack();
                }
              }
            }
          }
        } else if (result == BandFitConstants.SYNC_TEMPERATURE_24_HOUR_AUTOMATIC) {
          final jsonData = eventData['data'];
          if (status == BandFitConstants.SC_SUCCESS) {
            final tempStatus = jsonData['status'].toString();
            if (tempStatus.isNotEmpty) {
              final updateStatus = tempStatus == 'true';
              await _deviceRepository.updateTemperature24Enabled(updateStatus);
            }
            await _finalizeDeviceConnection();
          }
        } else if (result == BandFitConstants.SYNC_BLE_WRITE_FAIL) {
          if (status == BandFitConstants.SC_SUCCESS) {
            syncFailCounter++;
            if (syncFailCounter == 2) {
              await _finalizeDeviceConnection();
            }
          }
        } else if (result == BandFitConstants.SYNC_WEATHER_SUCCESS) {
          if (status == BandFitConstants.SC_SUCCESS) {
            await _deviceRepository.enable24HourTest();
          }
        } else if (result == BandFitConstants.BATTERY_STATUS) {
          if (status == BandFitConstants.SC_SUCCESS) {
            final jsonData = eventData['data'];
            final batteryStat = jsonData['batteryStatus'].toString();
            _deviceRepository.setBatteryPercentage(batteryStat, false);
          }
        } else {
          final ctx = Get.context;
          if (ctx != null) {
            await _deviceRepository.updateEventResult(eventData, ctx);
          }
        }
      },
      onError: (error) => debugPrint('receiveEventsFromError::>> $error'),
      onDone: () {},
    );
  }

  Future<bool> checkDeviceConnectReset() async {
    debugPrint('getLastMacAddressId>> ${_deviceRepository.getLastMacAddressId()}');
    final address = await _deviceRepository.getConnectedLastDeviceAddress();
    debugPrint('address>> $address');
    return false;
  }

  void _stopConnecting() {
    isConnecting.value = false;
  }

  Future<void> _finalizeDeviceConnection() async {
    if (_deviceSetupCompleted) return;
    _deviceSetupCompleted = true;
    await updateDeviceConnection();
  }

  Future<void> updateDeviceConnection() async {
    try {
    await _deviceRepository.fetchDeviceVersion();
    if (Platform.isAndroid) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    await _deviceRepository.fetchBatteryStatus();
    await _deviceRepository.updateUserDeviceConnection(
      false,
      true,
      selectedDevice.name,
      selectedDevice.address,
    );
    if (Platform.isAndroid) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    await _deviceRepository.updateDeviceBandLanguage();
    GlobalMethods.navigatePopBack();
    if (selectedIndex < arrConDisConButton.length) {
      arrConDisConButton[selectedIndex] = 'Disconnect';
      arrConDisConButton.refresh();
    }
    goDashboardPage();
    } finally {
      _stopConnecting();
    }
  }

  Future<void> fetchBluDevicesList() async {
    final resultDeviceList = await _scanDevicesUseCase();
    if (resultDeviceList.isNotEmpty) {
      final devices = resultDeviceList.map(_applyDisplayName).toList();
      arrConDisConButton.assignAll(
        List.filled(devices.length, 'Connect'),
      );
      smartDevicesList.assignAll(devices);
      showProgress.value = false;
    } else {
      smartDevicesList.clear();
      showProgress.value = false;
      showMessage.value = textNoDeviceMsg;
    }
  }

  Future<void> refreshScan() async {
    showProgress.value = true;
    await fetchBluDevicesList();
  }

  Future<void> connectDisconnectDevice(int index, BandDeviceModel device) async {
    selectedIndex = index;
    selectedDevice = device;

    if (index >= arrConDisConButton.length) return;

    if (arrConDisConButton[index] == 'Connect') {
      _deviceSetupCompleted = false;
      isConnecting.value = true;
      final connected = await _deviceRepository.connectSmartDevice(device);
      if (!connected) {
        _stopConnecting();
        final ctx = Get.context;
        if (ctx != null && ctx.mounted) {
          GlobalMethods.showAlertDialog(
            ctx,
            textConnectionFailed,
            textConnectionFailedMsg,
          );
        }
      }
    } else {
      _stopConnecting();
      await _deviceRepository.disconnectDevice();
      GlobalMethods.navigatePopBack();
      arrConDisConButton[index] = 'Connect';
      arrConDisConButton.refresh();
    }
  }

  void openHealthBind() {
    Get.to(
      () => AppleGoogleBind(
        deviceTypeName: Platform.isIOS ? appleHealthKey : googleFitKey,
      ),
    );
  }

  void goDashboardPage() {
    Get.offAllNamed(AppRoutes.vitals);
  }

  String actionLabel(int index) {
    if (index < arrConDisConButton.length) {
      return arrConDisConButton[index];
    }
    return 'Connect';
  }

  /// Maps vendor BLE names (e.g. Docty-M variants) to the display name shown in UI.
  BandDeviceModel _deviceFromScanResult(dynamic raw) {
    final data = Map<String, dynamic>.from(raw as Map);
    return _applyDisplayName(BandDeviceModel.fromJson(data));
  }

  BandDeviceModel _applyDisplayName(BandDeviceModel device) {
    if (device.name.contains(_doctyDeviceNamePrefix)) {
      return BandDeviceModel(
        name: _smartBandDisplayName,
        address: device.address,
        identifier: device.identifier,
      );
    }
    return device;
  }
}
