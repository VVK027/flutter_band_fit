import 'package:flutter_band_fit_app/features/health/domain/repositories/health_bind_repository.dart';

class IsBoundToDeviceUseCase {
  IsBoundToDeviceUseCase(this._repository);

  final HealthBindRepository _repository;

  bool call(String deviceTypeName) {
    return _repository.getConnectedDeviceName() == deviceTypeName;
  }
}
