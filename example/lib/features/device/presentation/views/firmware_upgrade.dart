import 'package:flutter/material.dart';
import 'package:flutter_band_fit_app/features/device/presentation/controllers/firmware_upgrade_controller.dart';
import 'package:flutter_band_fit_app/features/device/presentation/widgets/firmware_upgrade_body.dart';
import 'package:get/get.dart';

class FirmwareUpgrade extends StatelessWidget {
  const FirmwareUpgrade({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FirmwareUpgradeController>(
      init: FirmwareUpgradeController(),
      builder: (_) => const FirmwareUpgradeBody(),
    );
  }
}
