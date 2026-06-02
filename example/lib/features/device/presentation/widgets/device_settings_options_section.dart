import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:flutter_band_fit_app/core/services/activity_service_provider.dart';
import 'package:flutter_band_fit_app/core/services/dial_face_prefetch_service.dart';
import 'package:flutter_band_fit_app/core/widgets/app_ui_components.dart';
import 'package:flutter_band_fit_app/core/widgets/settings_widgets.dart';
import 'package:flutter_band_fit_app/features/device/presentation/controllers/device_settings_controller.dart';
import 'package:flutter_band_fit_app/features/device/presentation/views/firmware_upgrade.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/views/details/activity_monitor.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/views/details/band_reminders.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/views/details/dial_face_details.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/views/details/do_not_disturb.dart';

/// Settings navigation rows on the device options hub.
class DeviceSettingsOptionsSection extends StatelessWidget {
  const DeviceSettingsOptionsSection({
    super.key,
    required this.provider,
    required this.controller,
  });

  final ActivityServiceProvider provider;
  final DeviceSettingsController controller;

  Future<bool> _requireConnection(BuildContext context) async {
    final connected = await provider.checkIsDeviceConnected();
    if (!context.mounted) return false;
    if (!connected) {
      controller.retryConnection(context);
    }
    return connected;
  }

  @override
  Widget build(BuildContext context) {
    final connected = provider.getDeviceConnected;
    final monitoringOn =
        provider.getTemperature24Enabled || provider.getHR24Enabled;
    final dndOn = provider.getDndEnabled ||
        provider.getMotorVibrateEnabled ||
        provider.getMessagesOnEnabled;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SettingsSectionLabel(label: textSettings),
        SettingsSectionCard(
          children: [
            SettingsNavigationTile(
              iconAsset: 'assets/fit/goal_right.png',
              title: textGoal,
              subtitle:
                  '${GlobalMethods.formatNumber(int.tryParse(provider.getTargetedSteps) ?? 8000)} $textSteps',
              onTap: () async {
                final data = await GlobalMethods.selectGoalSteps(
                  context,
                  provider.getTargetedSteps,
                );
                if (data.isNotEmpty) {
                  provider.updateTargetedSteps(data);
                  controller.refreshPage(false);
                }
              },
            ),
            SettingsNavigationTile(
              iconAsset: 'assets/fit/smart_profile.png',
              title: textSmartProfile,
              subtitle: '$textBMI : ${provider.getUserBMI}',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: GlobalMethods.getColor(provider.getUserBMIStatus),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 22,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.38),
                  ),
                ],
              ),
              onTap: () async {
                await GlobalMethods.openProfileUpdate();
                controller.refreshPage(false);
              },
            ),
            if (connected)
              SettingsNavigationTile(
                iconAsset: 'assets/fit/watch.png',
                title: textDialFaces,
                subtitle: textDialFacesMsg,
                onTap: () async {
                  if (await _requireConnection(context) && context.mounted) {
                    unawaited(
                      Get.find<DialFacePrefetchService>().prefetchIfNeeded(
                        force: true,
                      ),
                    );
                    Get.to<void>(() => const DialFaceDetails());
                  }
                },
              ),
            if (connected)
              SettingsNavigationTile(
                iconAsset: 'assets/fit/24hrs_blue.png',
                title: textMonitoringOptions,
                subtitle: textMonitoringOptionsMsg,
                statusChip: SettingsStatusChip(isOn: monitoringOn),
                onTap: () async {
                  if (await _requireConnection(context) && context.mounted) {
                    GlobalMethods.navigateTo(const ActivityMonitor());
                  }
                },
              ),
            if (connected)
              SettingsNavigationTile(
                iconAsset: 'assets/fit/do_not_disturb.png',
                title: textDoNotDisturb,
                subtitle: textDoNotDisturbMsg,
                statusChip: SettingsStatusChip(isOn: dndOn),
                onTap: () async {
                  if (await _requireConnection(context) && context.mounted) {
                    GlobalMethods.navigateTo(const DoNotDisturb());
                  }
                },
              ),
            if (connected)
              SettingsNavigationTile(
                iconAsset: 'assets/fit/reminders.png',
                title: textSmartReminders,
                subtitle: textSmartRemindersSubtitle,
                onTap: () => GlobalMethods.navigateTo(const BandReminders()),
              ),
            if (connected)
              SettingsNavigationTile(
                iconAsset: 'assets/fit/find_band.png',
                title: textFindBand,
                subtitle: textFindBandMsg,
                onTap: () async {
                  if (await _requireConnection(context) && context.mounted) {
                    await provider.findDeviceBand();
                    if (!context.mounted) return;
                    GlobalMethods.showAlertDialog(
                      context,
                      textListenVibrate,
                      textListenVibrateMsg,
                    );
                  }
                },
              ),
            if (connected)
            SettingsNavigationTile(
              iconAsset: 'assets/fit/goal_right.png',
              title: textFirmwareUpgrade,
              onTap: () => GlobalMethods.navigateTo(const FirmwareUpgrade()),
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
