import 'package:flutter/material.dart';
import 'package:flutter_band_fit_app/features/health/presentation/controllers/apple_google_bind_controller.dart';
import 'package:flutter_band_fit_app/features/health/presentation/widgets/apple_google_bind_body.dart';
import 'package:get/get.dart';

class AppleGoogleBind extends StatelessWidget {
  const AppleGoogleBind({super.key, required this.deviceTypeName});

  final String deviceTypeName;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppleGoogleBindController>(
      init: AppleGoogleBindController(deviceTypeName: deviceTypeName),
      builder: (_) => const AppleGoogleBindBody(),
    );
  }
}
