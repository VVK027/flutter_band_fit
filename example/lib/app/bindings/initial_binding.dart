import 'package:flutter_band_fit_app/app/bindings/app_dependencies.dart';
import 'package:flutter_band_fit_app/app/theme/theme_controller.dart';
import 'package:flutter_band_fit_app/core/services/activity_service_provider.dart';
import 'package:get/get.dart';

/// Registers app-wide dependencies once at startup.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ThemeController(), permanent: true);
    Get.lazyPut<ActivityServiceProvider>(
      () => ActivityServiceProvider(),
      fenix: true,
    );
    AppDependencies.register();
  }
}
