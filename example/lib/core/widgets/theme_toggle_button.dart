import 'package:flutter/material.dart';
import 'package:flutter_band_fit_app/app/theme/theme_controller.dart';
import 'package:flutter_band_fit_app/core/constants/global_constants.dart';
import 'package:get/get.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ThemeController>();
    return Obx(
      () => IconButton(
        tooltip: controller.isDark ? textLightMode : textDarkMode,
        onPressed: controller.toggleTheme,
        icon: Icon(
          controller.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
        ),
      ),
    );
  }
}
