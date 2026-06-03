import 'package:flutter/material.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/blood_pressure_detail_controller.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/widgets/details/blood_pressure_detail_body.dart';
import 'package:get/get.dart';

class BloodPressureDetails extends StatelessWidget {
  const BloodPressureDetails({
    super.key,
    required this.displayTitle,
    required this.activityLabel,
  });

  final String displayTitle;
  final String activityLabel;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BloodPressureDetailController>(
      init: BloodPressureDetailController(
        displayTitle: displayTitle,
        activityLabel: activityLabel,
      ),
      builder: (_) => const BloodPressureDetailBody(),
    );
  }
}
