import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/vital_main_controller.dart';
import 'package:get/get.dart';

class VitalsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VitalMainController>(() => VitalMainController());
  }
}
