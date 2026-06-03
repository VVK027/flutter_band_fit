import 'package:flutter_band_fit_app/core/exports/band_exports.dart';
import 'package:flutter_band_fit_app/core/widgets/settings_widgets.dart';
import 'package:flutter_band_fit_app/core/widgets/app_ui_components.dart';
import 'package:flutter_band_fit_app/core/widgets/vital_detail_scaffold.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/activity_monitor_controller.dart';

class ActivityMonitorBody extends GetView<ActivityMonitorController> {
  const ActivityMonitorBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      title: textMonitoringOptions,
      onBack: GlobalMethods.navigatePopBack,
      onSave: controller.saveAndClose,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
        children: [
          const DetailInfoBanner(text: textConfigureMonitoring),
          const SizedBox(height: 12),
          SettingsSectionCard(
            children: [
              SettingsSwitchTile(
                iconAsset: 'assets/fit/heart.png',
                title: textHeartRateMonitoring,
                subtitle: text24HrHeartRateTest,
                value: controller.selectHrMonitor,
                onChanged: (v) => controller.selectHrMonitor.value = v,
                onTap: controller.toggleHr,
              ),
              SettingsSwitchTile(
                iconAsset: 'assets/fit/temperature.png',
                title: textBodyTemperatureMonitoring,
                subtitle: text24HrTempTest,
                value: controller.selectTempMonitor,
                onChanged: (v) => controller.selectTempMonitor.value = v,
                onTap: controller.toggleTemp,
              ),
              SettingsSwitchTile(
                iconAsset: 'assets/fit/blood_oxygen.png',
                title: textBodyOxygenMonitoring,
                subtitle: text24HrOxygen,
                value: controller.selectOxygenMonitor,
                onChanged: (v) => controller.selectOxygenMonitor.value = v,
                onTap: controller.toggleOxygen,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
