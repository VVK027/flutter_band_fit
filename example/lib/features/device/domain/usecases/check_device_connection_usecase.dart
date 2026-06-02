import 'package:flutter_band_fit_app/features/device/domain/repositories/device_connection_repository.dart';

class CheckDeviceConnectionUseCase {
  CheckDeviceConnectionUseCase(this._repository);

  final DeviceConnectionRepository _repository;

  Future<bool> call() => _repository.checkIsDeviceConnected();
}
