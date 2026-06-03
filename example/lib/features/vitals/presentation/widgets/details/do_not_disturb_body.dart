import 'package:flutter_band_fit_app/core/exports/vitals_imports.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/do_not_disturb_controller.dart';

class DoNotDisturbBody extends GetView<DoNotDisturbController> {
  const DoNotDisturbBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      title: textDoNotDisturb,
      onBack: GlobalMethods.navigatePopBack,
      onSave: () => controller.save(context),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
        children: [
          const DetailInfoBanner(text: textDoNotDisturbLabel),
          const SizedBox(height: 12),
          SettingsSectionCard(
            children: [
              SettingsSwitchTile(
                title: textDoNotDisturb,
                subtitle: textDNDTimeMsg,
                value: controller.dndEnabled,
                onChanged: controller.updateDndEnabled,
                onTap: () =>
                    controller.updateDndEnabled(!controller.dndEnabled.value),
              ),
              Obx(
                () => SettingsTimeTile(
                  label: textStartTime,
                  enabled: controller.dndEnabled.value,
                  time: controller.startTime,
                  onTap: () => controller.pickStartTime(context),
                ),
              ),
              Obx(
                () => SettingsTimeTile(
                  label: textEndTime,
                  enabled: controller.dndEnabled.value,
                  time: controller.endTime,
                  onTap: () => controller.pickEndTime(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              textDNDAdditionalMsg,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.65),
                    height: 1.4,
                  ),
            ),
          ),
          const SizedBox(height: 8),
          SettingsSectionCard(
            children: [
              SettingsSwitchTile(
                title: textDNDDisableReminder,
                subtitle: textDNDDisableReminderMsg,
                value: controller.enableMessageOn,
                onChanged: (v) => controller.enableMessageOn.value = v,
              ),
              SettingsSwitchTile(
                title: textDNDDisableBandVibration,
                subtitle: textDNDDisableBandVibrationMsg,
                value: controller.enableMotorOn,
                onChanged: (v) => controller.enableMotorOn.value = v,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
