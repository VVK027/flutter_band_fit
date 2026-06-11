import 'package:flutter_band_fit_app/common/common_imports.dart';

class VitalMainAddDeviceBanner extends StatelessWidget {
  const VitalMainAddDeviceBanner({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          leading: Image.asset(
            'assets/fit/watch_unselected.png',
            width: 40,
            height: 40,
          ),
          title: const Text(textAddDevice),
          subtitle: const Text(noDeviceFoundMessage),
          trailing: const Icon(Icons.arrow_forward_ios_outlined, size: 18),
          onTap: onTap,
        ),
      ),
    );
  }
}

class VitalMainConnectingBanner extends StatelessWidget {
  const VitalMainConnectingBanner({
    super.key,
    required this.rotation,
  });

  final Animation<double> rotation;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          leading: RotationTransition(
            turns: rotation,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          title: const Text(textConnectingDevice),
          subtitle: const Text(textConnectingDeviceMsg),
        ),
      ),
    );
  }
}

class VitalMainSyncingBanner extends StatelessWidget {
  const VitalMainSyncingBanner({
    super.key,
    required this.rotation,
    required this.onTap,
  });

  final Animation<double> rotation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          onTap: onTap,
          leading: RotationTransition(
            turns: rotation,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          title: const Text(textPleaseWait),
          subtitle: const Text(textSyncingDataMsg),
        ),
      ),
    );
  }
}
