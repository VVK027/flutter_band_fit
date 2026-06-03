import 'package:flutter_band_fit_app/core/exports/band_exports.dart';

abstract class DeviceConnectionRepository {
  Future<bool> checkIsDeviceConnected();

  Future<bool> reconnectWithSavedDevice(BuildContext context);

  Future<List<BandDeviceModel>> startSearchingDevices();
}
