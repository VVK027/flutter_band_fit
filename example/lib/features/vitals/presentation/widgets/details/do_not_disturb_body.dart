import 'package:flutter/cupertino.dart';
import 'package:flutter_band_fit_app/core/exports/vitals_imports.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/do_not_disturb_controller.dart';

class DoNotDisturbBody extends GetView<DoNotDisturbController> {
  const DoNotDisturbBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      title: textDoNotDisturb,
      onBack: GlobalMethods.navigatePopBack,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text(
                textDoNotDisturbLabel,
                textAlign: TextAlign.center,
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
            GestureDetector(
              onTap: () => controller.updateDndEnabled(!controller.dndEnabled.value),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          textDoNotDisturb,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Obx(
                        () => Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            value: controller.dndEnabled.value,
                            onChanged: controller.updateDndEnabled,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Text(textDNDTimeMsg, style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            const Divider(),
            Obx(
              () => _TimeRow(
                label: textStartTime,
                enabled: controller.dndEnabled.value,
                time: controller.startTime,
                onTap: () => controller.pickStartTime(context),
              ),
            ),
            const Divider(),
            Obx(
              () => _TimeRow(
                label: textEndTime,
                enabled: controller.dndEnabled.value,
                time: controller.endTime,
                onTap: () => controller.pickEndTime(context),
              ),
            ),
            const Divider(thickness: 1),
            const Text(textDNDAdditionalMsg, style: TextStyle(fontSize: 12)),
            const Divider(),
            _SwitchRow(
              title: textDNDDisableReminder,
              subtitle: textDNDDisableReminderMsg,
              value: controller.enableMessageOn,
              onChanged: (v) => controller.enableMessageOn.value = v,
            ),
            const Divider(thickness: 1),
            _SwitchRow(
              title: textDNDDisableBandVibration,
              subtitle: textDNDDisableBandVibrationMsg,
              value: controller.enableMotorOn,
              onChanged: (v) => controller.enableMotorOn.value = v,
            ),
            const SizedBox(height: 21),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () => controller.save(context),
        tooltip: textSaveContinue,
        child: const Icon(Icons.done),
      ),
    );
  }
}

class _TimeRow extends StatelessWidget {
  const _TimeRow({
    required this.label,
    required this.enabled,
    required this.time,
    required this.onTap,
  });

  final String label;
  final bool enabled;
  final Rx<TimeOfDay> time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: enabled
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(context).disabledColor,
                ),
              ),
            ),
            Obx(
              () => Text(
                time.value.format(context),
                style: TextStyle(
                  fontSize: 16,
                  color: enabled
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).disabledColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final RxBool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            Obx(
              () => Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                  value: value.value,
                  onChanged: onChanged,
                ),
              ),
            ),
          ],
        ),
        Text(subtitle, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
