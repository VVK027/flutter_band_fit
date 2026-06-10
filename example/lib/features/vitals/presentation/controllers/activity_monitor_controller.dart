import 'package:flutter_band_fit_app/core/exports/band_exports.dart';
import 'package:flutter_band_fit_app/features/vitals/domain/entities/activity_monitor_settings.dart';
import 'package:flutter_band_fit_app/features/vitals/domain/usecases/get_activity_monitor_settings_usecase.dart';
import 'package:flutter_band_fit_app/features/vitals/domain/usecases/save_activity_monitor_settings_usecase.dart';

class ActivityMonitorController extends GetxController {
  final GetActivityMonitorSettingsUseCase _getSettingsUseCase =
      Get.find<GetActivityMonitorSettingsUseCase>();
  final SaveActivityMonitorSettingsUseCase _saveSettingsUseCase =
      Get.find<SaveActivityMonitorSettingsUseCase>();

  final selectHrMonitor = false.obs;
  final selectTempMonitor = false.obs;
  final selectOxygenMonitor = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadValues();
  }

  void _loadValues() {
    final settings = _getSettingsUseCase();
    selectHrMonitor.value = settings.hrEnabled;
    selectTempMonitor.value = settings.tempEnabled;
    selectOxygenMonitor.value = settings.oxygenEnabled;
  }

  void toggleHr() => selectHrMonitor.toggle();
  void toggleTemp() => selectTempMonitor.toggle();
  void toggleOxygen() => selectOxygenMonitor.toggle();

  Future<void> saveAndClose() async {
    await _saveSettingsUseCase(
      ActivityMonitorSettings(
        hrEnabled: selectHrMonitor.value,
        tempEnabled: selectTempMonitor.value,
        oxygenEnabled: selectOxygenMonitor.value,
      ),
    );
    GlobalMethods.navigatePopBack();
  }
}
