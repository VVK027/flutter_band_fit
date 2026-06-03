import 'package:flutter/material.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/temperature_detail_controller.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/widgets/details/temperature_detail_body.dart';
import 'package:get/get.dart';

class TemperatureDetails extends StatelessWidget {
  const TemperatureDetails({
    super.key,
    required this.displayTitle,
    required this.activityLabel,
  });

  final String displayTitle;
  final String activityLabel;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TemperatureDetailController>(
      init: TemperatureDetailController(
        displayTitle: displayTitle,
        activityLabel: activityLabel,
      ),
      builder: (_) => const TemperatureDetailBody(),
    );
  }
}
