import 'package:flutter/material.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/sleep_details_controller.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/widgets/details/sleep_details_body.dart';
import 'package:get/get.dart';

class SleepDetails extends StatelessWidget {
  const SleepDetails({super.key, required this.displayTitle, required this.activityLabel});

  final String displayTitle;
  final String activityLabel;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SleepDetailsController>(
      init: SleepDetailsController(displayTitle: displayTitle, activityLabel: activityLabel),
      builder: (_) => const SleepDetailsBody(),
    );
  }
}
