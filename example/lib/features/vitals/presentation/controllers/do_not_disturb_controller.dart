import 'package:flutter_band_fit_app/core/exports/band_exports.dart';
import 'package:flutter_band_fit_app/core/services/activity_service_provider.dart';
import 'package:flutter_band_fit_app/features/vitals/domain/usecases/check_vitals_device_connection_usecase.dart';
import 'package:flutter_band_fit_app/features/vitals/domain/usecases/reconnect_vitals_device_usecase.dart';

class DoNotDisturbController extends GetxController {
  final ActivityServiceProvider provider = Get.find<ActivityServiceProvider>();
  final CheckVitalsDeviceConnectionUseCase _checkDeviceConnectionUseCase =
      Get.find<CheckVitalsDeviceConnectionUseCase>();
  final ReconnectVitalsDeviceUseCase _reconnectVitalsDeviceUseCase =
      Get.find<ReconnectVitalsDeviceUseCase>();

  final dndEnabled = false.obs;
  final enableMessageOn = false.obs;
  final enableMotorOn = false.obs;

  final startTime = const TimeOfDay(hour: 22, minute: 0).obs;
  final endTime = const TimeOfDay(hour: 8, minute: 0).obs;

  @override
  void onInit() {
    super.onInit();
    _assignValues();
  }

  Future<void> _assignValues() async {
    await provider.callQuickSwitchSettingStatus();
    dndEnabled.value = provider.getDndEnabled;
    enableMessageOn.value = provider.getMessagesOnEnabled;
    enableMotorOn.value = provider.getMotorVibrateEnabled;

    if (dndEnabled.value && provider.getDNDEnabledTime.isNotEmpty) {
      final times = provider.getDNDEnabledTime.split(':');
      if (times.length >= 4) {
        startTime.value = TimeOfDay(
          hour: int.parse(times[0]),
          minute: int.parse(times[1]),
        );
        endTime.value = TimeOfDay(
          hour: int.parse(times[2]),
          minute: int.parse(times[3]),
        );
      }
    }
  }

  Future<void> pickStartTime(BuildContext context) async {
    if (!dndEnabled.value) return;
    final newTime = await showTimePicker(
      context: context,
      initialTime: startTime.value,
      initialEntryMode: TimePickerEntryMode.dial,
      helpText: textSelectStartTime,
      confirmText: 'Ok',
      cancelText: 'Cancel',
    );
    if (newTime != null) startTime.value = newTime;
  }

  Future<void> pickEndTime(BuildContext context) async {
    if (!dndEnabled.value) return;
    final newTime = await showTimePicker(
      context: context,
      initialTime: endTime.value,
      initialEntryMode: TimePickerEntryMode.dial,
      helpText: textSelectEndTime,
      confirmText: okText,
      cancelText: cancelText,
    );
    if (newTime != null) endTime.value = newTime;
  }

  Future<void> save(BuildContext context) async {
    final isConnected = await _checkDeviceConnectionUseCase();
    if (!context.mounted) return;
    if (!isConnected) {
      _retryConnection(context);
      return;
    }

    if (dndEnabled.value) {
      if (startTime.value.period.index == endTime.value.period.index) {
        if (startTime.value.hour == endTime.value.hour) {
          GlobalMethods.showAlertDialog(
            context,
            textSelSameTimings,
            textSelSameTimingsMsg,
          );
          return;
        }
        if (startTime.value.hour > endTime.value.hour) {
          GlobalMethods.showAlertDialog(
            context,
            textInvalidTimePeriod,
            textInvalidTimePeriodMsg,
          );
          return;
        }
      }
    }

    await provider.setDoNotDisturbEnable(
      isMessageOn: enableMessageOn.value,
      isMotorOn: enableMotorOn.value,
      disturbTimeSwitch: dndEnabled.value,
      fromHr: startTime.value.hour.toString(),
      fromMin: startTime.value.minute.toString(),
      toHour: endTime.value.hour.toString(),
      toMin: endTime.value.minute.toString(),
    );
    if (!context.mounted) return;
    _showStatusDialog();
  }

  void updateDndEnabled(bool enabled) {
    provider.updateOnlyDoNotDisturbEnable(enabled);
    dndEnabled.value = provider.getDndEnabled;
  }

  void _showStatusDialog() {
    final ctx = Get.context;
    if (ctx == null) return;
    GlobalMethods.showAlertDialogWithFunction(
      ctx,
      textDNDStatus,
      textDNDStatusMsg,
      okText,
      () async {},
    );
  }

  void _retryConnection(BuildContext context) {
    GlobalMethods.showAlertDialogWithFunction(
      context,
      deviceDisconnected,
      deviceDisconnectedMsg,
      reconnectText,
      () async {
        await _reconnectVitalsDeviceUseCase(context);
      },
    );
  }
}
