import 'package:flutter/material.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/activities_details_controller.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/widgets/details/activities_details_body.dart';
import 'package:get/get.dart';

class ActivitiesDetails extends StatelessWidget {
  const ActivitiesDetails({super.key, required this.displayTitle, required this.activityLabel, required this.stepsView, required this.calView, required this.distanceView});

  final String displayTitle;
  final String activityLabel;
  final bool stepsView;
  final bool calView;
  final bool distanceView;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ActivitiesDetailsController>(
      init: ActivitiesDetailsController(displayTitle: displayTitle, activityLabel: activityLabel, stepsView: stepsView, calView: calView, distanceView: distanceView),
      builder: (_) => ActivitiesDetailsBody(),
    );
  }
}
