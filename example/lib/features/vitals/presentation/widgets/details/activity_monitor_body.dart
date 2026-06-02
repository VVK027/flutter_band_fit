import 'package:flutter/cupertino.dart';
import 'package:flutter_band_fit_app/core/exports/band_exports.dart';
import 'package:flutter_band_fit_app/core/widgets/vital_detail_scaffold.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/activity_monitor_controller.dart';

class ActivityMonitorBody extends GetView<ActivityMonitorController> {
  const ActivityMonitorBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      title: textMonitoringOptions,
      onBack: GlobalMethods.navigatePopBack,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              padding: const EdgeInsets.all(8),
              child: const Center(
                child: Text(textConfigureMonitoring, textAlign: TextAlign.center),
              ),
            ),
            const SizedBox(height: 8),
            _MonitorTile(
              iconAsset: 'assets/fit/heart.png',
              title: textHeartRateMonitoring,
              subtitle: text24HrHeartRateTest,
              value: controller.selectHrMonitor,
              onToggle: (v) => controller.selectHrMonitor.value = v,
              onRowTap: controller.toggleHr,
            ),
            const Divider(thickness: 1),
            _MonitorTile(
              iconAsset: 'assets/fit/temperature.png',
              title: textBodyTemperatureMonitoring,
              subtitle: text24HrTempTest,
              value: controller.selectTempMonitor,
              onToggle: (v) => controller.selectTempMonitor.value = v,
              onRowTap: controller.toggleTemp,
              iconHeight: 21,
            ),
            const Divider(thickness: 1),
            _MonitorTile(
              iconAsset: 'assets/fit/blood_oxygen.png',
              title: textBodyOxygenMonitoring,
              subtitle: text24HrOxygen,
              value: controller.selectOxygenMonitor,
              onToggle: (v) => controller.selectOxygenMonitor.value = v,
              onRowTap: controller.toggleOxygen,
              iconHeight: 21,
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 21),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: controller.saveAndClose,
        tooltip: textSaveContinue,
        child: const Icon(Icons.done),
      ),
    );
  }
}

class _MonitorTile extends StatelessWidget {
  const _MonitorTile({
    required this.iconAsset,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onToggle,
    required this.onRowTap,
    this.iconHeight = 20,
  });

  final String iconAsset;
  final String title;
  final String subtitle;
  final RxBool value;
  final ValueChanged<bool> onToggle;
  final VoidCallback onRowTap;
  final double iconHeight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onRowTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Image.asset(
                  iconAsset,
                  width: iconHeight,
                  height: iconHeight,
                  fit: BoxFit.contain,
                ),
              ),
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
                    onChanged: onToggle,
                  ),
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
