import 'package:flutter/material.dart';
import 'package:flutter_band_fit_app/core/constants/widget_keys.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/activity_monitor_controller.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/widgets/details/activity_monitor_body.dart';
import 'package:get/get.dart';

class ActivityMonitor extends StatelessWidget {
  const ActivityMonitor({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ActivityMonitorController>(
      init: ActivityMonitorController(),
      builder: (_) => const ActivityMonitorBody(
        key: Key(WidgetKeys.activityMonitorBody),
      ),
    );
  }
}
