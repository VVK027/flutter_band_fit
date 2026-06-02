import 'package:flutter_band_fit_app/features/health/domain/repositories/health_bind_repository.dart';

class UnbindHealthDeviceUseCase {
  UnbindHealthDeviceUseCase(this._repository);

  final HealthBindRepository _repository;

  Future<void> call() => _repository.unbindHealthDevice();
}
