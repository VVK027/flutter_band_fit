import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:flutter_band_fit_app/core/widgets/loading_overlay.dart';
import 'package:flutter_band_fit_app/features/device/presentation/controllers/add_device_controller.dart';
import 'package:flutter_band_fit_app/features/device/presentation/widgets/add_device_health_bar.dart';
import 'package:flutter_band_fit_app/features/device/presentation/widgets/add_device_scan_list.dart';

class AddDevice extends GetView<AddDeviceController> {
  const AddDevice({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlay(
        visible: controller.isConnecting.value,
        message: textConnectingDevice,
        subtitle: textConnectingDeviceMsg,
        child: Scaffold(
          appBar: AddDeviceAppBar(
            onRefresh: controller.isConnecting.value ? null : controller.refreshScan,
          ),
          bottomNavigationBar: const SafeArea(
            top: false,
            child: AddDeviceHealthBar(),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _AddDeviceHeader(),
                  const SizedBox(height: 8.0),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: AddDeviceScanList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AddDeviceHeader extends StatelessWidget {
  const _AddDeviceHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                textChooseSmartBand,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              textChooseSmartBandMsg,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
