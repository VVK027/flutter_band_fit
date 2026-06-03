import 'package:flutter/widgets.dart';
import 'package:flutter_band_fit_app/features/vitals/domain/entities/activity_monitor_settings.dart';

abstract class VitalsSyncRepository {
  String getLastSyncDated();

  Future<void> syncOverallData();

  Future<bool> checkIsDeviceConnected();

  Future<bool> reconnectWithSavedDevice(BuildContext context);

  ActivityMonitorSettings getActivityMonitorSettings();

  Future<void> saveActivityMonitorSettings(ActivityMonitorSettings settings);
}
