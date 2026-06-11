import 'package:flutter_band_fit_app/core/exports/band_exports.dart';
import 'package:flutter_band_fit_app/core/constants/widget_keys.dart';
import 'package:flutter_band_fit_app/core/widgets/fixed_section_list.dart';
import 'package:flutter_band_fit_app/core/widgets/settings_widgets.dart';
import 'package:flutter_band_fit_app/core/widgets/app_ui_components.dart';
import 'package:flutter_band_fit_app/core/widgets/vital_detail_scaffold.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/band_reminders_controller.dart';

class BandRemindersBody extends GetView<BandRemindersController> {
  const BandRemindersBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SettingsPageScaffold(
      key: const Key(WidgetKeys.settingsPageScaffold),
      title: textSmartBandReminders,
      onBack: GlobalMethods.navigatePopBack,
      onSave: GlobalMethods.navigatePopBack,
      body: FixedSectionListView(
        key: const Key(WidgetKeys.fixedSectionListView),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
        sections: [
          const DetailInfoBanner(
              key: Key(WidgetKeys.detailInfoBanner),
              text: textBluetoothReminderNotice),
          const SizedBox(height: 12),
          SettingsSectionCard(
            key: const Key(WidgetKeys.settingsSectionCard),
            children: [
              SettingsSwitchTile(
                icon: Icons.directions_walk_rounded,
                iconColor: theme.colorScheme.primary,
                title: textSecondaryReminder,
                subtitle: textSecondaryReminderMsg,
                value: controller.selectSecondaryReminder,
                onChanged: (v) => controller.selectSecondaryReminder.value = v,
                onTap: controller.toggleSecondary,
              ),
              SettingsSwitchTile(
                icon: Icons.sms_outlined,
                iconColor: theme.colorScheme.secondary,
                title: textSmsReminder,
                subtitle: textSmsReminderMsg,
                value: controller.selectSmsReminder,
                onChanged: (v) => controller.selectSmsReminder.value = v,
                onTap: controller.toggleSms,
              ),
              SettingsSwitchTile(
                icon: Icons.call_outlined,
                iconColor: theme.colorScheme.error,
                title: textCallReminder,
                subtitle: textCallReminderMsg,
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
