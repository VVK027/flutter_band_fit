import 'package:flutter_band_fit_app/core/exports/band_exports.dart';
import 'package:flutter_band_fit_app/features/device/domain/repositories/device_connection_repository.dart';

class ScanDevicesUseCase {
  ScanDevicesUseCase(this._repository);

  final DeviceConnectionRepository _repository;

  Future<List<BandDeviceModel>> call() => _repository.startSearchingDevices();
}
