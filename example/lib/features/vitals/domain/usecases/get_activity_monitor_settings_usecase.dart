import 'package:flutter_band_fit_app/features/vitals/domain/entities/activity_monitor_settings.dart';
import 'package:flutter_band_fit_app/features/vitals/domain/repositories/vitals_sync_repository.dart';

class GetActivityMonitorSettingsUseCase {
  GetActivityMonitorSettingsUseCase(this._repository);

  final VitalsSyncRepository _repository;

  ActivityMonitorSettings call() => _repository.getActivityMonitorSettings();
}
