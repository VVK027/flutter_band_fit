import 'package:flutter/material.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/band_reminders_controller.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/widgets/details/band_reminders_body.dart';
import 'package:get/get.dart';

class BandReminders extends StatelessWidget {
  const BandReminders({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BandRemindersController>(
      init: BandRemindersController(),
      builder: (_) => const BandRemindersBody(),
    );
  }
}
