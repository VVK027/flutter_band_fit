import 'package:flutter_band_fit_app/core/exports/band_exports.dart';

abstract class DevicePresentationRepository {
  Future<int> getAndroidSDKInt();

  Future<String> initializeDeviceConnection();

  void receiveEventsFrom({
    required void Function(dynamic data) onDataUpdate,
    required void Function(dynamic error) onError,
    required void Function() onDone,
  });

  Future<void> updateUserParamsWatch(bool isDisconnected);

  String getJsonWeatherData();

  Future<void> setWeatherInfoSevenDays();

  Future<String> getConnectedLastDeviceAddress();

  Future<bool> connectWithLastDeviceAddress();

  bool getDeviceConnected();

  Future<void> updateTemperature24Enabled(bool enabled);

  Future<void> enable24HourTest();

  void setBatteryPercentage(String batteryStat, bool fromBle);

  Future<void> updateEventResult(Map<String, dynamic> eventData, BuildContext context);

  String getLastMacAddressId();

  Future<void> fetchDeviceVersion({int maxAttempts = 2});

  Future<void> fetchBatteryStatus();

  Future<void> updateUserDeviceConnection(
    bool isHealthConnected,
    bool isDeviceConnected,
    String deviceName,
    String deviceAddress,
  );

  Future<void> updateDeviceBandLanguage();

  Future<bool> connectSmartDevice(BandDeviceModel device);

  Future<void> disconnectDevice();

  Future<void> initializeProvider();

  bool getHealthConnected();

  void refreshProvider();
}
