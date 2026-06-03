import 'package:flutter_band_fit_app/core/services/activity_service_provider.dart';
import 'package:get/get.dart';

/// Reloads vitals detail data when [ActivityServiceProvider] finishes reading storage.
mixin VitalsStorageReadyMixin on GetxController {
  Worker? _storageReadyWorker;

  void listenForLocalVitalsDataReady(Future<void> Function() reload) {
    final provider = Get.find<ActivityServiceProvider>();
    _storageReadyWorker = ever(provider.isLocalDataLoaded, (loaded) {
      if (loaded == true) {
        reload();
      }
    });
  }

  void disposeVitalsStorageReadyListener() {
    _storageReadyWorker?.dispose();
    _storageReadyWorker = null;
  }
}
