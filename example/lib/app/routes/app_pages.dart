import 'package:flutter_band_fit_app/app/routes/app_routes.dart';
import 'package:flutter_band_fit_app/features/device/presentation/bindings/device_binding.dart';
import 'package:flutter_band_fit_app/features/device/presentation/views/add_device.dart';
import 'package:flutter_band_fit_app/features/device/presentation/views/device_settings.dart';
import 'package:flutter_band_fit_app/features/splash/presentation/bindings/splash_binding.dart';
import 'package:flutter_band_fit_app/features/splash/presentation/views/splash_view.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/bindings/vitals_binding.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/views/vital_main.dart';
import 'package:get/get.dart';

class AppPages {
  AppPages._();

  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const Splash(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.vitals,
      page: () => const VitalMain(),
      binding: VitalsBinding(),
    ),
    GetPage(
      name: AppRoutes.addDevice,
      page: () => const AddDevice(),
      binding: DeviceBinding(),
    ),
    GetPage(
      name: AppRoutes.deviceSettings,
      page: () => const DeviceSettings(),
      binding: DeviceBinding(),
    ),
  ];
}
