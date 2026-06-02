import 'package:flutter_band_fit_app/features/device/presentation/controllers/add_device_controller.dart';
import 'package:flutter_band_fit_app/features/device/presentation/controllers/device_settings_controller.dart';
import 'package:get/get.dart';

class DeviceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddDeviceController>(() => AddDeviceController());
    Get.lazyPut<DeviceSettingsController>(() => DeviceSettingsController());
  }
}
