import 'package:vvk_ui_kit/vvk_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_band_fit_app/core/constants/global_constants.dart';
import 'package:flutter_band_fit_app/core/constants/widget_keys.dart';
import 'package:flutter_band_fit_app/core/widgets/theme_toggle_button.dart';

List<Widget> bandAppBarActions() {
  return const [
    ThemeToggleButton(key: Key(WidgetKeys.themeToggleButton)),
  ];
}

class VitalIconBadge extends StatelessWidget {
  const VitalIconBadge({
    super.key,
    required this.assetPath,
    required this.accentColor,
    this.size = 48,
  });

  final String assetPath;
  final Color accentColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return UIIconBadge(
      icon: Image.asset(
        assetPath,
        width: size * 0.58,
        height: size * 0.58,
        fit: BoxFit.contain,
      ),
      accentColor: accentColor,
      size: size,
    );
  }
}

class AppBrandAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppBrandAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions = const [],
  });

  final String title;
  final Widget? leading;
  final List<Widget> actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return UIAppBar.brand(
      title: title,
      leading: leading,
      actions: actions,
    );
  }
}

class IconTextWidget extends StatelessWidget {
  const IconTextWidget({
    super.key,
    required this.imagePath,
    required this.mainTitle,
    required this.subMainTitle,
  });

  final String imagePath;
  final String mainTitle;
  final String subMainTitle;

  @override
  Widget build(BuildContext context) {
    return UIIconTextColumn(
      icon: Image.asset(
        imagePath,
        width: 26,
        height: 26,
        fit: BoxFit.contain,
      ),
      mainTitle: mainTitle,
      subTitle: subMainTitle,
    );
  }
}

class VitalDataWidget extends StatelessWidget {
  const VitalDataWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.value,
    required this.units,
    required this.minutes,
    required this.time,
    this.accentColor,
  });

  final String imagePath;
  final String title;
  final String value;
  final String units;
  final String minutes;
  final String time;
  final Color? accentColor;

  String get _valueLine {
    if (minutes.isNotEmpty) {
      return '$value Hrs $minutes Min';
    }
    if (units.trim().isEmpty) return value;
    return '$value $units';
  }

  @override
  Widget build(BuildContext context) {
    return UIMetricListTile(
      icon: Image.asset(
        imagePath,
        width: 28,
        height: 28,
        fit: BoxFit.contain,
      ),
      title: title,
      valueLine: _valueLine,
      trailingText: time,
      accentColor: accentColor,
    );
  }
}

class VitalStatItem {
  const VitalStatItem({required this.label, required this.value});

  final String label;
  final String value;
}

class VitalStatCard extends StatelessWidget {
  const VitalStatCard({super.key, required this.items});

  final List<VitalStatItem> items;

  @override
  Widget build(BuildContext context) {
    return UIStatSummaryCard(
      items: items
          .map(
            (item) => UIStatSummaryItem(label: item.label, value: item.value),
          )
          .toList(),
    );
  }
}

class VitalCurrentReadingRow extends StatelessWidget {
  const VitalCurrentReadingRow({
    super.key,
    required this.iconAsset,
    required this.value,
    this.accentColor,
    this.iconSize = 44,
  });

  final String iconAsset;
  final String value;
  final Color? accentColor;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return UICurrentReadingRow(
      icon: Image.asset(
        iconAsset,
        width: iconSize,
        height: iconSize,
        fit: BoxFit.contain,
      ),
      value: value,
      accentColor: accentColor,
      iconSize: iconSize,
    );
  }
}

class VitalSectionHeader extends StatelessWidget {
  const VitalSectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.iconColor,
  });

  final String title;
  final IconData? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return UISectionHeader(
      title: title,
      icon: icon,
      iconColor: iconColor,
    );
  }
}

class VitalDataTable extends StatelessWidget {
  const VitalDataTable({
    super.key,
    required this.columns,
    required this.rows,
  });

  final List<String> columns;
  final List<List<String>> rows;

  @override
  Widget build(BuildContext context) {
    return UILabeledDataTable(columns: columns, rows: rows);
  }
}

class VitalStartButtonBar extends StatelessWidget {
  const VitalStartButtonBar({
    super.key,
    required this.accentColor,
    required this.onPressed,
    this.label = textStart,
    this.enabled = true,
  });

  final Color accentColor;
  final VoidCallback? onPressed;
  final String label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return UIPrimaryActionBar(
      accentColor: accentColor,
      label: label,
      onPressed: onPressed,
      enabled: enabled,
    );
  }
}

class CircleProgress extends CustomPainter {
  CircleProgress(this.currentProgress);

  final double currentProgress;

  @override
  void paint(Canvas canvas, Size size) {
    UICircleProgressPainter(progress: currentProgress).paint(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CircleProgress oldDelegate) {
    return oldDelegate.currentProgress != currentProgress;
  }
}
