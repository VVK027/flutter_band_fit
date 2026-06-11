import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:flutter_band_fit_app/core/services/activity_service_provider.dart';
import 'package:flutter_band_fit_app/core/widgets/app_ui_components.dart';
import 'package:flutter_band_fit_app/core/widgets/theme_toggle_button.dart';
import 'package:flutter_band_fit_app/features/device/presentation/controllers/device_settings_controller.dart';
import 'package:flutter_band_fit_app/features/device/presentation/widgets/device_settings_connection_section.dart';
import 'package:flutter_band_fit_app/features/device/presentation/widgets/device_settings_options_section.dart';

/// Band options: connection, profile shortcuts, monitoring, DND, dial face, firmware.
class DeviceSettings extends GetView<DeviceSettingsController> {
  const DeviceSettings({super.key});

  ActivityServiceProvider get _activityServiceProvider => controller.provider;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) controller.goDashboardPage();
      },
      child: Scaffold(
        appBar: AppBrandAppBar(
          key: const Key(WidgetKeys.appBrandAppBar),
          title: textSetOptions,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: controller.goDashboardPage,
          ),
          actions: const [
            ThemeToggleButton(
              key: Key(WidgetKeys.themeToggleButton),
            )
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.paddingOf(context).bottom + 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GetBuilder<ActivityServiceProvider>(
                  id: ActivityServiceProvider.dashboardVitalsId,
                  builder: (provider) => DeviceSettingsConnectionSection(
                    key: const Key(WidgetKeys.deviceSettingsConnectionSection),
                    provider: provider,
                    controller: controller,
                    activityServiceProvider: _activityServiceProvider,
                  ),
                ),
                GetBuilder<ActivityServiceProvider>(
                  builder: (provider) => DeviceSettingsOptionsSection(
                    key: const Key(WidgetKeys.deviceSettingsOptionsSection),
                    provider: provider,
                    controller: controller,
                  ),
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
