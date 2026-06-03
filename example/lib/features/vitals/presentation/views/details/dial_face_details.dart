import 'package:flutter/material.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/dial_face_details_controller.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/widgets/details/dial_face_details_body.dart';
import 'package:get/get.dart';

class DialFaceDetails extends GetView<DialFaceDetailsController> {
  const DialFaceDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DialFaceDetailsController>(
      init: DialFaceDetailsController(),
      builder: (_) => const DialFaceDetailsBody(),
    );
  }
}
