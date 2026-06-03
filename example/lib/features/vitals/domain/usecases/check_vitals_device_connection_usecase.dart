import 'package:flutter_band_fit_app/features/vitals/domain/repositories/vitals_sync_repository.dart';

class CheckVitalsDeviceConnectionUseCase {
  CheckVitalsDeviceConnectionUseCase(this._repository);

  final VitalsSyncRepository _repository;

  Future<bool> call() => _repository.checkIsDeviceConnected();
}
