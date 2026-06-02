import 'package:flutter_band_fit_app/core/exports/band_exports.dart';
import 'package:flutter_band_fit_app/core/services/activity_service_provider.dart';
import 'package:flutter_band_fit_app/features/device/domain/repositories/device_presentation_repository.dart';

class DevicePresentationRepositoryImpl implements DevicePresentationRepository {
  DevicePresentationRepositoryImpl(this._provider);

  final ActivityServiceProvider _provider;

  @override
  Future<int> getAndroidSDKInt() => _provider.getAndroidSDKInt();

  @override
  Future<String> initializeDeviceConnection() {
    return _provider.initializeDeviceConnection();
  }

  @override
  void receiveEventsFrom({
    required void Function(dynamic data) onDataUpdate,
    required void Function(dynamic error) onError,
    required void Function() onDone,
  }) {
    _provider.receiveEventsFrom(
      onDataUpdate: onDataUpdate,
      onError: onError,
      onDone: onDone,
    );
  }

  @override
  Future<void> updateUserParamsWatch(bool isDisconnected) {
    return _provider.updateUserParamsWatch(isDisconnected);
  }

  @override
  String getJsonWeatherData() => _provider.getJsonWeatherData;

  @override
  Future<void> setWeatherInfoSevenDays() => _provider.setWeatherInfoSevenDays();

  @override
  Future<String> getConnectedLastDeviceAddress() {
    return _provider.getConnectedLastDeviceAddress();
  }

  @override
  Future<bool> connectWithLastDeviceAddress() {
    return _provider.connectWithLastDeviceAddress();
  }

  @override
  bool getDeviceConnected() => _provider.getDeviceConnected;

  @override
  Future<void> updateTemperature24Enabled(bool enabled) {
    return _provider.updateTemperature24Enabled(enabled);
  }

  @override
  Future<void> enable24HourTest() => _provider.enable24HourTest();

  @override
  void setBatteryPercentage(String batteryStat, bool fromBle) {
    _provider.setBatteryPercentage(batteryStat, fromBle);
  }

  @override
  Future<void> updateEventResult(Map<String, dynamic> eventData, BuildContext context) {
    return _provider.updateEventResult(eventData, context);
  }

  @override
  String getLastMacAddressId() => _provider.getLastMacAddressId;

  @override
  Future<void> fetchDeviceVersion() => _provider.fetchDeviceVersion();

  @override
  Future<void> fetchBatteryStatus() => _provider.fetchBatteryStatus();

  @override
  Future<void> updateUserDeviceConnection(
    bool isHealthConnected,
    bool isDeviceConnected,
    String deviceName,
    String deviceAddress,
  ) {
    return _provider.updateUserDeviceConnection(
      isHealthConnected,
      isDeviceConnected,
      deviceName,
      deviceAddress,
    );
  }

  @override
  Future<void> updateDeviceBandLanguage() => _provider.updateDeviceBandLanguage();

  @override
  Future<bool> connectSmartDevice(BandDeviceModel device) {
    return _provider.connectSmartDevice(device);
  }

  @override
  Future<void> disconnectDevice() => _provider.disconnectDevice();

  @override
  Future<void> initializeProvider() => _provider.initializeProvider();

  @override
  bool getHealthConnected() => _provider.getHealthConnected;

  @override
  void refreshProvider() => _provider.update();
}
