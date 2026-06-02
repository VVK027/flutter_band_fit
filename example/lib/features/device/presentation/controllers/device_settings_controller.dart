import 'package:flutter_band_fit_app/app/routes/app_routes.dart';
import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:flutter_band_fit_app/core/utils/shared_service.dart';
import 'package:flutter_band_fit_app/core/services/activity_service_provider.dart';
import 'package:flutter_band_fit_app/core/services/dial_face_prefetch_service.dart';
import 'package:flutter_band_fit_app/features/device/domain/repositories/device_presentation_repository.dart';
import 'package:flutter_band_fit_app/features/device/domain/usecases/check_device_connection_usecase.dart';
import 'package:flutter_band_fit_app/features/device/domain/usecases/reconnect_saved_device_usecase.dart';

class DeviceSettingsController extends GetxController {
  ActivityServiceProvider get provider => Get.find<ActivityServiceProvider>();

  final DevicePresentationRepository _deviceRepository = Get.find<DevicePresentationRepository>();
  final CheckDeviceConnectionUseCase _checkDeviceConnectionUseCase = Get.find<CheckDeviceConnectionUseCase>();
  final ReconnectSavedDeviceUseCase _reconnectSavedDeviceUseCase = Get.find<ReconnectSavedDeviceUseCase>();

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
    debugPrint('fetchDeviceData>>isConnected>> $isConnected');
    if (isConnected || _deviceRepository.getDeviceConnected()) {
      if (Platform.isAndroid) {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
      await _deviceRepository.fetchBatteryStatus();
      await _deviceRepository.fetchDeviceVersion();
      unawaited(Get.find<DialFacePrefetchService>().prefetchIfNeeded());
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
        debugPrint('statusReconnect>>$statusReconnect');
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
    if (!_deviceRepository.getHealthConnected() &&
        !_deviceRepository.getDeviceConnected()) {
      Get.offAllNamed<void>(AppRoutes.vitals);
    } else {
      GlobalMethods.navigatePopBack();
    }
  }

  Future<void> refreshPage([bool isDisconnected = false]) async {
    debugPrint('refreshPage ${_deviceRepository.getDeviceConnected()}');
    if (isDisconnected) {
      GlobalMethods.navigatePopBack();
    }
    _deviceRepository.refreshProvider();
  }
}
