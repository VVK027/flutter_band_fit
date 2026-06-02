import 'package:flutter/material.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/do_not_disturb_controller.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/widgets/details/do_not_disturb_body.dart';
import 'package:get/get.dart';

class DoNotDisturb extends StatelessWidget {
  const DoNotDisturb({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DoNotDisturbController>(
      init: DoNotDisturbController(),
      builder: (_) => const DoNotDisturbBody(),
    );
  }
}
