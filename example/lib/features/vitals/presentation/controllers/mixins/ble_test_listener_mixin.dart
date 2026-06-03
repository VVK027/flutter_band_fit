import 'package:flutter_band_fit_app/core/exports/band_exports.dart';
import 'package:flutter_band_fit_app/core/services/activity_service_provider.dart';
import 'package:flutter_band_fit_app/features/vitals/domain/usecases/reconnect_vitals_device_usecase.dart';

/// Pauses main BLE listeners while BP/SpO₂/temperature test listeners are active.
mixin BleTestListenerMixin on GetxController {
  ActivityServiceProvider get bleProvider => Get.find<ActivityServiceProvider>();
  ReconnectVitalsDeviceUseCase get _reconnectUseCase =>
      Get.find<ReconnectVitalsDeviceUseCase>();

  @override
  void onClose() {
    bleProvider.cancelBPEvents();
    bleProvider.resumeEventListeners();
    super.onClose();
  }

  /// Shows reconnect dialog; [onResult] receives success; [onReconnected] runs after a successful reconnect.
  void retryDeviceConnection(
    void Function(bool reconnected) onResult, {
    Future<void> Function()? onReconnected,
  }) {
    final ctx = Get.context;
    if (ctx == null) return;
    GlobalMethods.showAlertDialogWithFunction(
      ctx,
      deviceDisconnected,
      deviceDisconnectedMsg,
      reconnectText,
      () async {
        final statusReconnect = await _reconnectUseCase(ctx);
        onResult(statusReconnect);
        if (statusReconnect) {
          await onReconnected?.call();
        } else if (ctx.mounted) {
          GlobalMethods.showAlertDialog(
            ctx,
            deviceDisconnected,
            deviceDisconnectedReconnectFailedMsg,
          );
        }
      },
    );
  }
}
