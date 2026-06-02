import 'package:flutter_band_fit_app/features/vitals/domain/entities/activity_monitor_settings.dart';
import 'package:flutter_band_fit_app/features/vitals/domain/repositories/vitals_sync_repository.dart';

class SaveActivityMonitorSettingsUseCase {
  SaveActivityMonitorSettingsUseCase(this._repository);

  final VitalsSyncRepository _repository;

  Future<void> call(ActivityMonitorSettings settings) {
    return _repository.saveActivityMonitorSettings(settings);
  }
}
