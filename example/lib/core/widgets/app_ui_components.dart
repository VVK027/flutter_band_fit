import 'package:flutter/material.dart';
import 'package:flutter_band_fit_app/app/theme/app_theme_extension.dart';

/// Rounded icon container used on home vitals list and detail headers.
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
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accentColor.withValues(alpha: 0.22)),
      ),
      alignment: Alignment.center,
      child: Image.asset(
        assetPath,
        width: size * 0.58,
        height: size * 0.58,
        fit: BoxFit.contain,
      ),
    );
  }
}

/// Branded home screen app bar with primary tint.
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
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 2,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: leading,
      title: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primary.withValues(alpha: 0.08),
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      foregroundColor: theme.colorScheme.onSurface,
      actions: actions,
    );
  }
}

/// Grouped settings / DND section with rounded surface.
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
    final theme = Theme.of(context);
    return Card(
      margin: margin,
      elevation: theme.brightness == Brightness.dark ? 0 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) Divider(height: 1, color: theme.dividerColor),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// Info banner under detail app bars.
class DetailInfoBanner extends StatelessWidget {
  const DetailInfoBanner({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = context.appTheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.12),
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: ext.subtitleColor,
          height: 1.4,
        ),
      ),
    );
  }
}
