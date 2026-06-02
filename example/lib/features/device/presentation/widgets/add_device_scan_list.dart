import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:flutter_band_fit_app/features/device/presentation/controllers/add_device_controller.dart';

class AddDeviceScanList extends GetView<AddDeviceController> {
  const AddDeviceScanList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.showProgress.value) {
        return SizedBox(
          width: double.infinity,
          height: MediaQuery.sizeOf(context).height * 0.45,
          child: const _SearchingIndicator(),
        );
      }
      if (controller.smartDevicesList.isEmpty) {
        return _EmptyMessage(message: controller.showMessage.value);
      }
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (_, __) => const Divider(),
        itemCount: controller.smartDevicesList.length,
        itemBuilder: (context, index) => _DeviceListTile(index: index),
      );
    });
  }
}

class _SearchingIndicator extends StatelessWidget {
  const _SearchingIndicator();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$textSearchingDevice...',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyMessage extends StatelessWidget {
  const _EmptyMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 180),
        Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class _DeviceListTile extends GetView<AddDeviceController> {
  const _DeviceListTile({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final device = controller.smartDevicesList[index];
    return Container(
      margin: const EdgeInsets.all(1.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.15),
            blurRadius: 1.0,
            spreadRadius: 0.0,
            offset: const Offset(0.2, 0.2),
          ),
        ],
      ),
      child: ListTile(
        onTap: () => controller.connectDisconnectDevice(index, device),
        leading: Icon(
          Icons.bluetooth_audio_outlined,
          color: theme.colorScheme.onSurface,
        ),
        title: Text(
          device.name,
          style: theme.textTheme.titleSmall,
        ),
        subtitle: Text(
          device.address,
          style: theme.textTheme.bodySmall,
        ),
        trailing: GestureDetector(
          onTap: () => controller.connectDisconnectDevice(index, device),
          child: Obx(
            () => Text(
              controller.actionLabel(index),
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
        ),
      ),
    );
  }
}
