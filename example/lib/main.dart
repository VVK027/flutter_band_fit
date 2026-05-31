import 'package:flutter/material.dart';
import 'package:flutter_band_fit_app/app/bindings/initial_binding.dart';
import 'package:flutter_band_fit_app/app/routes/app_pages.dart';
import 'package:flutter_band_fit_app/app/routes/app_routes.dart';
import 'package:flutter_band_fit_app/app/theme/app_theme.dart';
import 'package:flutter_band_fit_app/app/theme/theme_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  InitialBinding().dependencies();
  runApp(const BandFitApp());
}

class BandFitApp extends StatelessWidget {
  const BandFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Obx(
          () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Band Fit',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeController.theme,
        initialRoute: AppRoutes.splash,
        getPages: AppPages.pages,
        defaultTransition: Transition.cupertino,
      ),
    );
  }
}
