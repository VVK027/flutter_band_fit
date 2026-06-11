import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_band_fit_app/core/constants/global_constants.dart';
import 'package:flutter_band_fit_app/core/widgets/app_ui_components.dart';

/// On/Off pill shown next to settings row titles (device hub).
class SettingsStatusChip extends StatelessWidget {
  const SettingsStatusChip({
    super.key,
    required this.isOn,
    this.onLabel = 'On',
    this.offLabel = 'Off',
  });

  final bool isOn;
  final String onLabel;
  final String offLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isOn ? AppColors.primaryTeal : theme.colorScheme.outline;
    return Text(
      '(${isOn ? onLabel : offLabel})',
      style: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );
  }
}

/// Tappable settings row: leading icon, title, subtitle, chevron.
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
    final onSurface = theme.colorScheme.onSurface;
    final muted = onSurface.withValues(alpha: 0.62);

    Widget leadingWidget = leading ?? const SizedBox.shrink();
    if (iconAsset != null) {
      leadingWidget = VitalIconBadge(
        assetPath: iconAsset!,
        accentColor: theme.colorScheme.primary,
        size: 44,
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leadingWidget,
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: enabled ? onSurface : theme.disabledColor,
                            ),
                          ),
                        ),
                        if (statusChip != null) ...[
                          const SizedBox(width: 6),
                          statusChip!,
                        ],
                      ],
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: enabled ? muted : theme.disabledColor,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              trailing ??
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 22,
                    color: onSurface.withValues(alpha: 0.38),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Switch row used on DND, monitoring, and reminders screens.
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
    final onSurface = theme.colorScheme.onSurface;
    final muted = onSurface.withValues(alpha: 0.62);

    Widget? lead;
    if (iconAsset != null) {
      lead = VitalIconBadge(
        assetPath: iconAsset!,
        accentColor: theme.colorScheme.primary,
        size: 40,
      );
    } else if (icon != null) {
      lead = Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color:
              (iconColor ?? theme.colorScheme.primary).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child:
            Icon(icon, size: 22, color: iconColor ?? theme.colorScheme.primary),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (lead != null) ...[lead, const SizedBox(width: 12)],
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: enabled ? onSurface : theme.disabledColor,
                      ),
                    ),
                  ),
                  Obx(
                    () => Switch.adaptive(
                      value: value.value,
                      onChanged: enabled ? onChanged : null,
                    ),
                  ),
                ],
              ),
              if (subtitle != null && subtitle!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Padding(
                  padding: EdgeInsets.only(left: lead != null ? 52 : 0),
                  child: Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: enabled ? muted : theme.disabledColor,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Time picker row for DND schedule.
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
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: enabled
                        ? theme.colorScheme.onSurface
                        : theme.disabledColor,
                  ),
                ),
              ),
              Obx(
                () => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: enabled
                        ? theme.colorScheme.primary.withValues(alpha: 0.1)
                        : theme.disabledColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    time.value.format(context),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: enabled
                          ? theme.colorScheme.primary
                          : theme.disabledColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Standard save FAB for settings sub-screens.
class SettingsSaveFab extends StatelessWidget {
  const SettingsSaveFab({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: textSave,
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      elevation: 4,
      child: const Icon(Icons.check_rounded),
    );
  }
}

/// Section title for grouped settings on the device hub.
class SettingsSectionLabel extends StatelessWidget {
  const SettingsSectionLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        label,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.primary,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
