import 'package:flutter/widgets.dart';
import 'package:flutter_band_fit_app/features/device/domain/repositories/device_connection_repository.dart';

class ReconnectSavedDeviceUseCase {
  ReconnectSavedDeviceUseCase(this._repository);

  final DeviceConnectionRepository _repository;

  Future<bool> call(BuildContext context) {
    return _repository.reconnectWithSavedDevice(context);
  }
}
