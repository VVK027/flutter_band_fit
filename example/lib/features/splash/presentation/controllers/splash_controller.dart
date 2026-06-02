import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_band_fit_app/app/routes/app_routes.dart';
import 'package:get/get.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> animation;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    );
    animationController.forward();
    Timer(const Duration(seconds: 2), _goToVitals);
  }

  void _goToVitals() {
    if (Get.currentRoute != AppRoutes.vitals) {
      Get.offNamed(AppRoutes.vitals);
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
