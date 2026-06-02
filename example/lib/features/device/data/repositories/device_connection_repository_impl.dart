import 'package:flutter_band_fit_app/core/exports/band_exports.dart';
import 'package:flutter_band_fit_app/core/services/activity_service_provider.dart';
import 'package:flutter_band_fit_app/features/device/domain/repositories/device_connection_repository.dart';

class DeviceConnectionRepositoryImpl implements DeviceConnectionRepository {
  DeviceConnectionRepositoryImpl(this._provider);

  final ActivityServiceProvider _provider;

  @override
  Future<bool> checkIsDeviceConnected() => _provider.checkIsDeviceConnected();

  @override
  Future<bool> reconnectWithSavedDevice(BuildContext context) {
    return _provider.connectDeviceWithMacAddress(context);
  }

  @override
  Future<List<BandDeviceModel>> startSearchingDevices() {
    return _provider.startSearchingDevices();
  }
}
