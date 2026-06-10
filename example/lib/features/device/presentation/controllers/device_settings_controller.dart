import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:flutter_band_fit_app/core/utils/shared_service.dart';
import 'package:flutter_band_fit_app/core/services/activity_service_provider.dart';
import 'package:flutter_band_fit_app/features/device/domain/repositories/device_presentation_repository.dart';
import 'package:flutter_band_fit_app/features/device/domain/usecases/check_device_connection_usecase.dart';
import 'package:flutter_band_fit_app/features/device/domain/usecases/reconnect_saved_device_usecase.dart';

class DeviceSettingsController extends GetxController {
  ActivityServiceProvider get provider => Get.find<ActivityServiceProvider>();

  final DevicePresentationRepository _deviceRepository =
      Get.find<DevicePresentationRepository>();
  final CheckDeviceConnectionUseCase _checkDeviceConnectionUseCase =
      Get.find<CheckDeviceConnectionUseCase>();
  final ReconnectSavedDeviceUseCase _reconnectSavedDeviceUseCase =
      Get.find<ReconnectSavedDeviceUseCase>();

  @override
  void onInit() {
    super.onInit();
    // Defer so we do not call ActivityServiceProvider.update() during build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchDeviceData();
    });
  }

  Future<void> fetchDeviceData() async {
    final stored = sharedService.getDeviceVersionId();
    if (stored.isNotEmpty && provider.getDeviceVersion.isEmpty) {
      await provider.setDeviceVersion(stored);
    }

    final isConnected = await _checkDeviceConnectionUseCase();
    debugPrintI('fetchDeviceData>>isConnected>> $isConnected');
    if (isConnected || _deviceRepository.getDeviceConnected()) {
      if (Platform.isAndroid) {
        await Future<void>.delayed(const Duration(milliseconds: 300));
      }
      await _deviceRepository.fetchDeviceVersion(maxAttempts: 3);
      await _deviceRepository.fetchBatteryStatus();
    }
  }

  void retryConnection(BuildContext context) {
    GlobalMethods.showAlertDialogWithFunction(
      context,
      deviceDisconnected,
      deviceDisconnectedMsg,
      reconnectText,
      () async {
        final statusReconnect = await _reconnectSavedDeviceUseCase(context);
        debugPrintI('statusReconnect>>$statusReconnect');
        if (!statusReconnect && context.mounted) {
          GlobalMethods.showAlertDialog(
            context,
            deviceDisconnected,
            deviceDisconnectedMsg,
          );
        }
      },
    );
  }

  void goDashboardPage() {
    GlobalMethods.navigatePopBack();
  }

  Future<void> refreshPage([bool isDisconnected = false]) async {
    debugPrintI('refreshPage ${_deviceRepository.getDeviceConnected()}');
    if (isDisconnected) {
      GlobalMethods.navigatePopBack();
    }
    _deviceRepository.refreshProvider();
  }
}
