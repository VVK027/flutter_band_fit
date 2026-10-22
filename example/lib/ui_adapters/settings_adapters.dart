import 'package:vvk_ui_kit/vvk_ui_kit.dart' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_band_fit_app/core/constants/global_constants.dart';
import 'package:flutter_band_fit_app/ui_adapters/display_adapters.dart';

class SettingsStatusChip extends StatelessWidget {
  const SettingsStatusChip({
    super.key,
    required this.isOn,
    this.onLabel = textOn,
    this.offLabel = textOff,
  });

  final bool isOn;
  final String onLabel;
  final String offLabel;

  @override
  Widget build(BuildContext context) {
    return ui.UISettingsStatusChip(
      isOn: isOn,
      onLabel: onLabel,
      offLabel: offLabel,
    );
  }
}

class SettingsNavigationTile extends StatelessWidget {
  const SettingsNavigationTile({
    super.key,
    required this.title,
    this.subtitle,
    this.iconAsset,
    this.leading,
    this.trailing,
    this.statusChip,
    this.onTap,
    this.enabled = true,
  });

  final String title;
  final String? subtitle;
  final String? iconAsset;
  final Widget? leading;
  final Widget? trailing;
  final Widget? statusChip;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget? lead = leading;
    if (iconAsset != null) {
      lead = VitalIconBadge(
        assetPath: iconAsset!,
        accentColor: theme.colorScheme.primary,
        size: 44,
      );
    }

    return ui.UISettingsNavigationTile(
      title: title,
      subtitle: subtitle,
      leading: lead,
      trailing: trailing,
      statusChip: statusChip,
      onTap: onTap,
      enabled: enabled,
    );
  }
}

class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    super.key,
    required this.title,
    this.subtitle,
    this.iconAsset,
    this.icon,
    this.iconColor,
    required this.value,
    required this.onChanged,
    this.onTap,
    this.enabled = true,
  });

  final String title;
  final String? subtitle;
  final String? iconAsset;
  final IconData? icon;
  final Color? iconColor;
  final RxBool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget? lead;
    if (iconAsset != null) {
      lead = VitalIconBadge(
        assetPath: iconAsset!,
        accentColor: theme.colorScheme.primary,
        size: 40,
      );
    } else if (icon != null) {
      lead = ui.UISettingsTiles.materialIconLeading(
        context,
        icon: icon!,
        iconColor: iconColor,
      );
    }

    return Obx(
      () => ui.UISettingsSwitchTile(
        title: title,
        subtitle: subtitle,
        leading: lead,
        value: value.value,
        onChanged: enabled ? onChanged : null,
        onTap: enabled ? onTap : null,
        enabled: enabled,
      ),
    );
  }
}

class SettingsTimeTile extends StatelessWidget {
  const SettingsTimeTile({
    super.key,
    required this.label,
    required this.enabled,
    required this.time,
    required this.onTap,
  });

  final String label;
  final bool enabled;
  final Rx<TimeOfDay> time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ui.UISettingsTimeTile(
        label: label,
        enabled: enabled,
        timeText: time.value.format(context),
        onTap: onTap,
      ),
    );
  }
}

class SettingsSaveFab extends StatelessWidget {
  const SettingsSaveFab({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ui.UISettingsSaveFab(
      onPressed: onPressed,
      tooltip: textSave,
    );
  }
}

class SettingsSectionLabel extends StatelessWidget {
  const SettingsSectionLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ui.UISettingsSectionLabel(label: label);
  }
}

class SettingsSectionCard extends StatelessWidget {
  const SettingsSectionCard({
    super.key,
    required this.children,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
  });

  final List<Widget> children;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return ui.UISettingsSectionCard(
      margin: margin,
      children: children,
    );
  }
}

class DetailInfoBanner extends StatelessWidget {
  const DetailInfoBanner({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return ui.UIDetailInfoBanner(text: text);
  }
}
