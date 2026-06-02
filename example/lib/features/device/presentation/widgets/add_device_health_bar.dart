import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:flutter_band_fit_app/core/widgets/theme_toggle_button.dart';
import 'package:flutter_band_fit_app/features/device/presentation/controllers/add_device_controller.dart';

class AddDeviceHealthBar extends GetView<AddDeviceController> {
  const AddDeviceHealthBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            textOR,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w300,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8.0),
          MaterialButton(
            color: theme.cardColor,
            disabledColor: theme.disabledColor.withValues(alpha: 0.12),
            shape: const StadiumBorder(),
            onPressed: controller.openHealthBind,
            elevation: 2.0,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Image.asset(
                      Platform.isIOS
                          ? 'assets/fit/apple_health.png'
                          : 'assets/fit/gfit.png',
                      width: 32.0,
                      height: 32.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      Platform.isIOS ? textLinkAppleHealth : textLinkGoogleFit,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddDeviceAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AddDeviceAppBar({super.key, this.onRefresh});

  final VoidCallback? onRefresh;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 2.0,
      title: const Text(textAddDevice),
      automaticallyImplyLeading: false,
      leading: const IconButton(
        icon: Icon(Icons.arrow_back_ios_outlined),
        onPressed: GlobalMethods.navigatePopBack,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_outlined),
          tooltip: textRefresh,
          onPressed: onRefresh,
        ),
        const ThemeToggleButton(),
      ],
    );
  }
}
