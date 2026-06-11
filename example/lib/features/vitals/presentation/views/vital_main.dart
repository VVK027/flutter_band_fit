import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:flutter_band_fit_app/core/services/activity_service_provider.dart';
import 'package:flutter_band_fit_app/core/widgets/app_ui_components.dart';
import 'package:flutter_band_fit_app/core/widgets/theme_toggle_button.dart';
import 'package:flutter_band_fit_app/features/device/presentation/views/add_device.dart';
import 'package:flutter_band_fit_app/features/device/presentation/views/device_settings.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/vital_main_controller.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/widgets/vital_main_status_banners.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/widgets/vital_main_steps_card.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/widgets/vital_main_vital_list.dart';

class VitalMain extends GetView<VitalMainController> {
  const VitalMain({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) controller.goBack();
      },
      child: Scaffold(
        appBar: AppBrandAppBar(
          key: const Key(WidgetKeys.appBrandAppBar),
          title: textBandFit,
          leading: Platform.isIOS
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                  onPressed: controller.goBack,
                )
              : null,
          actions: [
            const ThemeToggleButton(
              key: Key(WidgetKeys.themeToggleButton),
            ),
            IconButton(
              tooltip: textSettings,
              icon: Image.asset(
                'assets/fit/watch_selected.png',
                width: 28,
                height: 28,
              ),
              onPressed: () => GlobalMethods.navigateTo(const DeviceSettings(
                key: Key(WidgetKeys.deviceSettings),
              )),
            ),
            const SizedBox(width: 4),
          ],
        ),
        body: Obx(
          () => controller.isLoadingProgress.value
              ? const Center(
                  child: RepaintBoundary(
                    child: CircularProgressIndicator(),
                  ),
                )
              : const _VitalMainBody(
                  key: Key(WidgetKeys.vitalMainBody),
                ),
        ),
      ),
    );
  }
}

/// Provider-driven dashboard sections — scoped below the app bar so chrome does not rebuild.
class _VitalMainBody extends GetView<VitalMainController> {
  const _VitalMainBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        GetBuilder<ActivityServiceProvider>(
          id: ActivityServiceProvider.dashboardStepsId,
          builder: (provider) => VitalMainStepsCard(
            key: const Key(WidgetKeys.vitalMainStepsCard),
            provider: provider,
            onOpenSteps: openStepsDetail,
            onOpenWeather: openWeatherDetails,
            isSyncBlocked: () => provider.isSyncProgress,
            onSyncNow: () => controller.handleSyncNow(context),
          ),
        ),
        GetBuilder<ActivityServiceProvider>(
          id: ActivityServiceProvider.dashboardBannersId,
          builder: (provider) {
            if (provider.isConnectingProgress) {
              return VitalMainConnectingBanner(
                key: const Key(WidgetKeys.vitalMainConnectingBanner),
                rotation: controller.syncController,
              );
            }
            if (provider.isSyncProgress) {
              return VitalMainSyncingBanner(
                key: const Key(WidgetKeys.vitalMainSyncingBanner),
                rotation: controller.syncController,
                onTap: () => GlobalMethods.navigateTo(const AddDevice(
                  key: Key(WidgetKeys.addDevice),
                )),
              );
            }
            if (!provider.getDeviceConnected &&
                provider.getOverAllStepsData.isEmpty &&
                provider.getSteps <= 0) {
              return VitalMainAddDeviceBanner(
                key: const Key(WidgetKeys.vitalMainAddDeviceBanner),
                onTap: () => GlobalMethods.navigateTo(const AddDevice(
                  key: Key(WidgetKeys.addDevice),
                )),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        GetBuilder<ActivityServiceProvider>(
          id: ActivityServiceProvider.dashboardVitalsId,
          builder: (provider) => VitalMainVitalList(
            key: const Key(WidgetKeys.vitalMainVitalList),
            provider: provider,
            isSyncBlocked: () => provider.isSyncProgress,
            onSyncBlockedTap: controller.showSyncMessage,
          ),
        ),
      ],
    );
  }
}
