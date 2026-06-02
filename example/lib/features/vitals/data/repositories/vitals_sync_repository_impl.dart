import 'package:flutter/widgets.dart';
import 'package:flutter_band_fit_app/core/services/activity_service_provider.dart';
import 'package:flutter_band_fit_app/features/vitals/domain/entities/activity_monitor_settings.dart';
import 'package:flutter_band_fit_app/features/vitals/domain/repositories/vitals_sync_repository.dart';

class VitalsSyncRepositoryImpl implements VitalsSyncRepository {
  VitalsSyncRepositoryImpl(this._activityServiceProvider);

  final ActivityServiceProvider _activityServiceProvider;

  @override
  String getLastSyncDated() => _activityServiceProvider.getLastSyncDated;

  @override
  Future<void> syncOverallData() => _activityServiceProvider.syncOverAllData();

  @override
  Future<bool> checkIsDeviceConnected() {
    return _activityServiceProvider.checkIsDeviceConnected();
  }

  @override
  Future<bool> reconnectWithSavedDevice(BuildContext context) {
    return _activityServiceProvider.connectDeviceWithMacAddress(context);
  }

  @override
  ActivityMonitorSettings getActivityMonitorSettings() {
    return ActivityMonitorSettings(
      hrEnabled: _activityServiceProvider.getHR24Enabled,
      tempEnabled: _activityServiceProvider.getTemperature24Enabled,
      oxygenEnabled: _activityServiceProvider.getOxygen24Enabled,
    );
  }

  @override
  Future<void> saveActivityMonitorSettings(ActivityMonitorSettings settings) async {
    if (_activityServiceProvider.getHR24Enabled != settings.hrEnabled) {
      await _activityServiceProvider.set24HrHeartRate(settings.hrEnabled);
    }
    if (_activityServiceProvider.getTemperature24Enabled != settings.tempEnabled) {
      await _activityServiceProvider.set24HrTemperatureTest(settings.tempEnabled);
    }
    if (_activityServiceProvider.getOxygen24Enabled != settings.oxygenEnabled) {
      await _activityServiceProvider.set24HrOxygen(settings.oxygenEnabled);
    }
  }
}
