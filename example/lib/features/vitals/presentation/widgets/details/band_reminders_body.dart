import 'package:flutter_band_fit_app/core/exports/band_exports.dart';
import 'package:flutter_band_fit_app/core/widgets/settings_widgets.dart';
import 'package:flutter_band_fit_app/core/widgets/app_ui_components.dart';
import 'package:flutter_band_fit_app/core/widgets/vital_detail_scaffold.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/band_reminders_controller.dart';

class BandRemindersBody extends GetView<BandRemindersController> {
  const BandRemindersBody({super.key});

  static const String _bluetoothNotice =
      "It's mandatory that the phone stays connected to the device — do not turn off Bluetooth.";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SettingsPageScaffold(
      title: 'Smart Band Reminders',
      onBack: GlobalMethods.navigatePopBack,
      onSave: GlobalMethods.navigatePopBack,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
        children: [
          const DetailInfoBanner(text: _bluetoothNotice),
          const SizedBox(height: 12),
          SettingsSectionCard(
            children: [
              SettingsSwitchTile(
                icon: Icons.directions_walk_rounded,
                iconColor: theme.colorScheme.primary,
                title: 'Secondary Reminder',
                subtitle:
                    'If you have been inactive for a while, the band vibrates to remind you to move.',
                value: controller.selectSecondaryReminder,
                onChanged: (v) => controller.selectSecondaryReminder.value = v,
                onTap: controller.toggleSecondary,
              ),
              SettingsSwitchTile(
                icon: Icons.sms_outlined,
                iconColor: theme.colorScheme.secondary,
                title: 'SMS Reminder',
                subtitle:
                    'When your phone receives a text message, the band vibrates to alert you.',
                value: controller.selectSmsReminder,
                onChanged: (v) => controller.selectSmsReminder.value = v,
                onTap: controller.toggleSms,
              ),
              SettingsSwitchTile(
                icon: Icons.call_outlined,
                iconColor: theme.colorScheme.error,
                title: 'Call Reminder',
                subtitle:
                    'When your phone has an incoming call, the band vibrates to alert you.',
                value: controller.selectCallReminder,
                onChanged: (v) => controller.selectCallReminder.value = v,
                onTap: controller.toggleCall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
