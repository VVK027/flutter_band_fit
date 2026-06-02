import 'package:flutter/material.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/oxygen_detail_controller.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/widgets/details/oxygen_detail_body.dart';
import 'package:get/get.dart';

class OxygenDetail extends StatelessWidget {
  const OxygenDetail({
    super.key,
    required this.displayTitle,
    required this.activityLabel,
  });

  final String displayTitle;
  final String activityLabel;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OxygenDetailController>(
      init: OxygenDetailController(
        displayTitle: displayTitle,
        activityLabel: activityLabel,
      ),
      builder: (_) => const OxygenDetailBody(),
    );
  }
}
