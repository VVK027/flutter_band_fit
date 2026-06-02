import 'package:flutter/cupertino.dart';
import 'package:flutter_band_fit_app/core/exports/band_exports.dart';
import 'package:flutter_band_fit_app/core/widgets/vital_detail_scaffold.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/band_reminders_controller.dart';

class BandRemindersBody extends GetView<BandRemindersController> {
  const BandRemindersBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      title: 'Smart Band Reminders',
      onBack: GlobalMethods.navigatePopBack,
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () {},
        tooltip: textSaveContinue,
        child: const Icon(Icons.done),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              padding: const EdgeInsets.all(8),
              child: const Center(
                child: Text(
                  'Its Mandatory that the phone needs to be connected to the device, do not turn off Bluetooth',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 8),
            _ReminderTile(
              icon: Icons.people_rounded,
              title: 'Secondary Reminder',
              subtitle:
                  'In case of continuous time without exercise, the device will vibrate for reminding',
              value: controller.selectSecondaryReminder,
              onToggle: (v) => controller.selectSecondaryReminder.value = v,
              onTap: controller.toggleSecondary,
            ),
            const Divider(thickness: 1),
            _ReminderTile(
              icon: Icons.sms_outlined,
              title: 'SMS Reminder',
              subtitle:
                  'The phone receives a text message and the device vibrates an alert',
              value: controller.selectSmsReminder,
              onToggle: (v) => controller.selectSmsReminder.value = v,
              onTap: controller.toggleSms,
            ),
            const Divider(thickness: 1),
            _ReminderTile(
              icon: Icons.call_outlined,
              title: 'Call Reminder',
              subtitle: 'The phone has an incoming call and the device will vibrate',
              value: controller.selectCallReminder,
              onToggle: (v) => controller.selectCallReminder.value = v,
              onTap: controller.toggleCall,
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 21),
          ],
        ),
      ),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onToggle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final RxBool value;
  final ValueChanged<bool> onToggle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              Obx(
                () => Transform.scale(
                  scale: 0.8,
                  child: CupertinoSwitch(value: value.value, onChanged: onToggle),
                ),
              ),
            ],
          ),
          Text(subtitle, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
