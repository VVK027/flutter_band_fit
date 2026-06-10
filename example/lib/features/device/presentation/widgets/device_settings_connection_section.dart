import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:flutter_band_fit_app/core/utils/shared_service.dart';
import 'package:flutter_band_fit_app/core/services/activity_service_provider.dart';
import 'package:flutter_band_fit_app/core/widgets/custom/battery_indicator.dart';
import 'package:flutter_band_fit_app/features/device/presentation/controllers/device_settings_controller.dart';
import 'package:flutter_band_fit_app/features/device/presentation/views/add_device.dart';

/// Connection status card(s) on device settings — isolated from the options list.
class DeviceSettingsConnectionSection extends StatelessWidget {
  const DeviceSettingsConnectionSection({
    super.key,
    required this.provider,
    required this.controller,
    required this.activityServiceProvider,
  });

  final ActivityServiceProvider provider;
  final DeviceSettingsController controller;
  final ActivityServiceProvider activityServiceProvider;

  @override
  Widget build(BuildContext context) {
    if (provider.getDeviceConnected) {
      return _ConnectedBandCard(
        provider: provider,
        controller: controller,
        activityServiceProvider: activityServiceProvider,
      );
    }
    if (provider.getHealthConnected) {
      return _LinkedHealthCard(
        provider: provider,
        controller: controller,
        activityServiceProvider: activityServiceProvider,
      );
    }
    return _NoDeviceConnectedSection(provider: provider);
  }
}

class _ConnectedBandCard extends StatelessWidget {
  const _ConnectedBandCard({
    required this.provider,
    required this.controller,
    required this.activityServiceProvider,
  });

  final ActivityServiceProvider provider;
  final DeviceSettingsController controller;
  final ActivityServiceProvider activityServiceProvider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4.0),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
          child: Card(
            elevation: 2.0,
            margin: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/fit/watch_selected.png',
                        width: 44.0,
                        height: 44.0,
                        fit: BoxFit.fill,
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      provider.getDeviceSWName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      provider.getDeviceMacAddress,
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: theme.colorScheme.primary,
                              ),
                              onPressed: () async {
                                final isDeviceDisconnected =
                                    await activityServiceProvider.disconnectDevice();
                                debugPrintI(
                                  'isDeviceDisconnected>>> $isDeviceDisconnected',
                                );
                                controller.refreshPage(isDeviceDisconnected);
                              },
                              child: Text(
                                textDisconnect,
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
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
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          '$textVersion: ',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            _deviceVersionLabel(provider),
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.75,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          '$textBattery: ',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: RepaintBoundary(
                          child: BatteryIndicator(
                            key: WidgetKeys.batteryIndicator,
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LinkedHealthCard extends StatelessWidget {
  const _LinkedHealthCard({
    required this.provider,
    required this.controller,
    required this.activityServiceProvider,
  });

  final ActivityServiceProvider provider;
  final DeviceSettingsController controller;
  final ActivityServiceProvider activityServiceProvider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
      child: Card(
        elevation: 2.0,
        margin: const EdgeInsets.all(4.0),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.asset(
                  Platform.isIOS
                      ? 'assets/fit/apple_health.png'
                      : 'assets/fit/gfit.png',
                  width: 30.0,
                  height: 30.0,
                  fit: BoxFit.fill,
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              Platform.isIOS ? textAppleHealth : textGoogleFit,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              activityServiceProvider.getDeviceMacAddress
                                      .contains('com')
                                  ? activityServiceProvider.getDeviceSWName
                                  : activityServiceProvider.getDeviceMacAddress,
                              style: const TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.primary,
                      ),
                      onPressed: () {
                        activityServiceProvider.updateUserDeviceConnection(
                          false,
                          false,
                          '',
                          '',
                        );
                        controller.refreshPage(false);
                      },
                      child: Text(
                        textUnlink,
                        style: TextStyle(
                          color: theme.colorScheme.primary,
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
    );
  }
}

class _NoDeviceConnectedSection extends StatelessWidget {
  const _NoDeviceConnectedSection({required this.provider});

  final ActivityServiceProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                textNoDevicesConnected,
                style: TextStyle(color: theme.colorScheme.onSurface),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => GlobalMethods.navigateTo(const AddDevice()),
          child: Card(
            elevation: 2.0,
            margin: const EdgeInsets.all(4.0),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      Platform.isIOS
                          ? 'assets/fit/apple_health.png'
                          : 'assets/fit/gfit.png',
                      width: 30.0,
                      height: 30.0,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  Platform.isIOS
                                      ? textAppleHealth
                                      : textGoogleFit,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  provider.getDeviceSWName,
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: theme.colorScheme.primary,
                          ),
                          onPressed: GlobalMethods.openHealthBind,
                          child: Text(
                            textLink,
                            style: TextStyle(
                              color: theme.colorScheme.primary,
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
        ),
      ],
    );
  }
}

String _deviceVersionLabel(ActivityServiceProvider provider) {
  final live = provider.getDeviceVersion.trim();
  if (live.isNotEmpty) return live;
  final cached = sharedService.getDeviceVersionId().trim();
  if (cached.isNotEmpty) return cached;
  return '—';
}
