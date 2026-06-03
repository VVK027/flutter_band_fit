import 'package:get/get.dart';

/// Tracks whether a manual vital measurement (BP, SpO₂, temperature) is running.
mixin VitalMeasurementLoadingMixin on GetxController {
  final isTestRunning = false.obs;

  void beginTestLoading() {
    if (!isTestRunning.value) {
      isTestRunning.value = true;
    }
  }

  void endTestLoading() {
    if (isTestRunning.value) {
      isTestRunning.value = false;
    }
  }
}
