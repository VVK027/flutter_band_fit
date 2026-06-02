import 'package:flutter_band_fit_app/features/vitals/domain/repositories/vitals_sync_repository.dart';

class SyncOverallVitalsUseCase {
  SyncOverallVitalsUseCase(this._repository);

  final VitalsSyncRepository _repository;

  Future<void> call() {
    return _repository.syncOverallData();
  }
}
