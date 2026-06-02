import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:flutter_band_fit_app/core/utils/shared_service.dart';
import 'package:flutter_band_fit_app/core/services/activity_service_provider.dart';
import 'package:flutter_band_fit_app/core/widgets/app_ui_components.dart';
import 'package:flutter_band_fit_app/core/widgets/custom/battery_indicator.dart';
import 'package:flutter_band_fit_app/core/widgets/theme_toggle_button.dart';
import 'package:flutter_band_fit_app/features/device/presentation/controllers/device_settings_controller.dart';
import 'package:flutter_band_fit_app/features/device/presentation/views/add_device.dart';
import 'package:flutter_band_fit_app/features/device/presentation/widgets/device_settings_options_section.dart';

/// Band options: connection, profile shortcuts, monitoring, DND, dial face, firmware.
class DeviceSettings extends GetView<DeviceSettingsController> {
  const DeviceSettings({super.key});

  ActivityServiceProvider get _activityServiceProvider =>
      controller.provider;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ActivityServiceProvider>(
        builder: (provider) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop) controller.goDashboardPage();
            },
            child: Scaffold(
              appBar: AppBrandAppBar(
                title: textSetOptions,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                  onPressed: controller.goDashboardPage,
                ),
                actions: const [ThemeToggleButton()],
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.paddingOf(context).bottom + 8,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    (provider.getDeviceConnected)
                        ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const SizedBox(
                            height: 4.0,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                            child: Card(
                              elevation: 2.0,
                              margin: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/fit/watch_selected.png',
                                          width: 44.0,
                                          height: 44.0,
                                          fit: BoxFit.fill,
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(2.0),
                                                      child: Text(provider.getDeviceSWName,
                                                          style: const TextStyle(fontWeight: FontWeight.w500,
                                                              fontSize: 16.0)),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(2.0),
                                                      child: Text(provider.getDeviceMacAddress,
                                                          style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Spacer(),
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Theme.of(context).colorScheme.primary,
                                                ),
                                                onPressed: () async {
                                                  final isDeviceDisconnected =
                                                      await _activityServiceProvider
                                                          .disconnectDevice();
                                                  debugPrint(
                                                    'isDeviceDisconnected>>> $isDeviceDisconnected',
                                                  );
                                                  controller.refreshPage(
                                                    isDeviceDisconnected,
                                                  );
                                                },
                                                child: Text(
                                                  textDisconnect,
                                                  style: TextStyle(
                                                    color: Theme.of(context).colorScheme.primary,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(2.0),
                                          child: Text('$textVersion: ',
                                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              _deviceVersionLabel(provider),
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w500,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withValues(alpha: 0.75),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(2.0),
                                          child: Text('$textBattery: ',
                                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: BatteryIndicator(
                                            batteryFromPhone: false,
                                            style: BatteryIndicatorStyle.skeumorphism,
                                            size: 20.0,
                                            ratio: 2.7,
                                            batteryLevel: provider.batteryPercentage,
                                            showPercentNum: true,
                                            percentNumSize: 12,
                                            colorful: true,
                                            mainColor: Colors.grey.withValues(alpha: 0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                    )
                        : (provider.getHealthConnected)
                        ? Container(
                      margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                      child: Card(
                        elevation: 2.0,
                        margin: const EdgeInsets.all(4.0),
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.asset(Platform.isIOS ? 'assets/fit/apple_health.png': 'assets/fit/gfit.png',
                                  width: 30.0,
                                  height: 30.0,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(Platform.isIOS ? textAppleHealth : textGoogleFit,
                                                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                                (_activityServiceProvider.getDeviceMacAddress.contains('com'))
                                                    ? _activityServiceProvider.getDeviceSWName
                                                    : _activityServiceProvider.getDeviceMacAddress,
                                                style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Theme.of(context).colorScheme.primary,
                                      ),
                                      onPressed: () {
                                        _activityServiceProvider.updateUserDeviceConnection(false, false, '', '');
                                        controller.refreshPage(false);
                                      },
                                      child: Text(
                                        textUnlink,
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                        : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  textNoDevicesConnected,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              GlobalMethods.navigateTo(const AddDevice());
                            },
                            child: Card(
                              elevation: 2.0,
                              margin: const EdgeInsets.all(4.0),
                              child: Container(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/fit/watch.png',
                                      width: 35.0,
                                      height: 35.0,
                                      fit: BoxFit.fill,
                                    ),
                                    const Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(addSmartWatchText),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                            child: Card(
                              elevation: 2.0,
                              margin: const EdgeInsets.all(4.0),
                              child: Container(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Image.asset(
                                        Platform.isIOS ? 'assets/fit/apple_health.png':'assets/fit/gfit.png',
                                        width: 30.0,
                                        height: 30.0,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: Text(Platform.isIOS ? textAppleHealth:textGoogleFit,
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 16.0)),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: Text(provider.getDeviceSWName,
                                                      style: const TextStyle(fontSize: 12.0,
                                                          fontWeight: FontWeight.w300)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              foregroundColor: Theme.of(context).colorScheme.primary,
                                            ),
                                            onPressed: () {
                                              GlobalMethods.openHealthBind();
                                            },
                                            child: Text(
                                              textLink,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    DeviceSettingsOptionsSection(
                      provider: provider,
                      controller: controller,
                    ),
                    const SizedBox(
                      height: 8.0,
                    )
                  ],
                ),
              ),
            ),
          ),
          );
        });
  }
}

String _deviceVersionLabel(ActivityServiceProvider provider) {
  final live = provider.getDeviceVersion.trim();
  if (live.isNotEmpty) return live;
  final cached = sharedService.getDeviceVersionId().trim();
  if (cached.isNotEmpty) return cached;
  return '—';
}
