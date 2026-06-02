import 'package:flutter/material.dart';
import 'package:flutter_band_fit_app/features/splash/presentation/controllers/splash_controller.dart';
import 'package:get/get.dart';

class Splash extends GetView<SplashController> {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: AnimatedBuilder(
          animation: controller.animation,
          builder: (context, child) {
            final size = controller.animation.value * 250;
            return Image.asset(
              'assets/logo.png',
              width: size,
              height: size,
            );
          },
          child: const SizedBox.shrink(),
        ),
      ),
    );
  }
}
