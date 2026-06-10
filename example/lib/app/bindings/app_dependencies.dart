import 'package:flutter_band_fit_app/core/services/activity_service_provider.dart';
import 'package:flutter_band_fit_app/features/device/data/repositories/device_connection_repository_impl.dart';
import 'package:flutter_band_fit_app/features/device/data/repositories/device_presentation_repository_impl.dart';
import 'package:flutter_band_fit_app/features/device/domain/repositories/device_connection_repository.dart';
import 'package:flutter_band_fit_app/features/device/domain/repositories/device_presentation_repository.dart';
import 'package:flutter_band_fit_app/features/device/domain/usecases/check_device_connection_usecase.dart';
import 'package:flutter_band_fit_app/features/device/domain/usecases/reconnect_saved_device_usecase.dart';
import 'package:flutter_band_fit_app/features/device/domain/usecases/scan_devices_usecase.dart';
import 'package:flutter_band_fit_app/features/profile/data/repositories/profile_settings_repository_impl.dart';
import 'package:flutter_band_fit_app/features/profile/domain/repositories/profile_settings_repository.dart';
import 'package:flutter_band_fit_app/features/profile/domain/usecases/get_profile_settings_usecase.dart';
import 'package:flutter_band_fit_app/features/vitals/data/repositories/vitals_data_repository_impl.dart';
import 'package:flutter_band_fit_app/features/vitals/data/repositories/vitals_sync_repository_impl.dart';
import 'package:flutter_band_fit_app/features/vitals/domain/repositories/vitals_data_repository.dart';
import 'package:flutter_band_fit_app/features/vitals/domain/repositories/vitals_sync_repository.dart';
import 'package:flutter_band_fit_app/features/vitals/domain/usecases/check_vitals_device_connection_usecase.dart';
import 'package:flutter_band_fit_app/features/vitals/domain/usecases/get_activity_monitor_settings_usecase.dart';
import 'package:flutter_band_fit_app/features/vitals/domain/usecases/reconnect_vitals_device_usecase.dart';
import 'package:flutter_band_fit_app/features/vitals/domain/usecases/save_activity_monitor_settings_usecase.dart';
import 'package:flutter_band_fit_app/features/vitals/domain/usecases/should_sync_vitals_usecase.dart';
import 'package:flutter_band_fit_app/features/vitals/domain/usecases/sync_overall_vitals_usecase.dart';
import 'package:get/get.dart';

/// Shared repositories and use cases available from any navigation path.
class AppDependencies {
  AppDependencies._();

  static void register() {
    Get.lazyPut<ProfileSettingsRepository>(
      () => ProfileSettingsRepositoryImpl(Get.find<ActivityServiceProvider>()),
      fenix: true,
    );
    Get.lazyPut<GetProfileSettingsUseCase>(
      () => GetProfileSettingsUseCase(Get.find<ProfileSettingsRepository>()),
      fenix: true,
    );

    Get.lazyPut<VitalsSyncRepository>(
      () => VitalsSyncRepositoryImpl(Get.find<ActivityServiceProvider>()),
      fenix: true,
    );
    Get.lazyPut<VitalsDataRepository>(
      () => VitalsDataRepositoryImpl(Get.find<ActivityServiceProvider>()),
      fenix: true,
    );
    Get.lazyPut<ShouldSyncVitalsUseCase>(
      () => ShouldSyncVitalsUseCase(Get.find<VitalsSyncRepository>()),
      fenix: true,
    );
    Get.lazyPut<SyncOverallVitalsUseCase>(
      () => SyncOverallVitalsUseCase(Get.find<VitalsSyncRepository>()),
      fenix: true,
    );
    Get.lazyPut<CheckVitalsDeviceConnectionUseCase>(
      () =>
          CheckVitalsDeviceConnectionUseCase(Get.find<VitalsSyncRepository>()),
      fenix: true,
    );
    Get.lazyPut<ReconnectVitalsDeviceUseCase>(
      () => ReconnectVitalsDeviceUseCase(Get.find<VitalsSyncRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetActivityMonitorSettingsUseCase>(
      () => GetActivityMonitorSettingsUseCase(Get.find<VitalsSyncRepository>()),
      fenix: true,
    );
    Get.lazyPut<SaveActivityMonitorSettingsUseCase>(
      () =>
          SaveActivityMonitorSettingsUseCase(Get.find<VitalsSyncRepository>()),
      fenix: true,
    );

    Get.lazyPut<DeviceConnectionRepository>(
      () => DeviceConnectionRepositoryImpl(Get.find<ActivityServiceProvider>()),
      fenix: true,
    );
    Get.lazyPut<DevicePresentationRepository>(
      () =>
          DevicePresentationRepositoryImpl(Get.find<ActivityServiceProvider>()),
      fenix: true,
    );
    Get.lazyPut<CheckDeviceConnectionUseCase>(
      () =>
          CheckDeviceConnectionUseCase(Get.find<DeviceConnectionRepository>()),
      fenix: true,
    );
    Get.lazyPut<ReconnectSavedDeviceUseCase>(
      () => ReconnectSavedDeviceUseCase(Get.find<DeviceConnectionRepository>()),
      fenix: true,
    );
    Get.lazyPut<ScanDevicesUseCase>(
      () => ScanDevicesUseCase(Get.find<DeviceConnectionRepository>()),
      fenix: true,
    );
  }
}
