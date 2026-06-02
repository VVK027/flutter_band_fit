import 'package:flutter/material.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/heart_rate_detail_controller.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/widgets/details/heart_rate_detail_body.dart';
import 'package:get/get.dart';

class HeartRateDetail extends StatelessWidget {
  const HeartRateDetail({
    super.key,
    required this.displayTitle,
    required this.activityLabel,
  });

  final String displayTitle;
  final String activityLabel;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HeartRateDetailController>(
      init: HeartRateDetailController(
        displayTitle: displayTitle,
        activityLabel: activityLabel,
      ),
      builder: (_) => const HeartRateDetailBody(),
    );
  }
}
