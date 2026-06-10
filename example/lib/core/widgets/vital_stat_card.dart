import 'package:flutter/material.dart';
import 'package:flutter_band_fit_app/core/constants/widget_keys.dart';
import 'package:flutter_band_fit_app/app/theme/app_theme_extension.dart';

class VitalStatItem {
  const VitalStatItem({required this.label, required this.value});

  final String label;
  final String value;
}

/// Two-column (or more) summary card used on vitals detail screens.
class VitalStatCard extends StatelessWidget {
  const VitalStatCard({super.key, required this.items});

  final List<VitalStatItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        child: IntrinsicHeight(
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0)
                  VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: theme.dividerColor,
                  ),
                Expanded(
                  child: _StatCell(
                    key: Key('${WidgetKeys.vitalStatCardStatCell}_$i'),
                    item: items[i],
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

class _StatCell extends StatelessWidget {
  const _StatCell({super.key, required this.item});

  final VitalStatItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitle = context.appTheme.subtitleColor;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
            child: Center(
              child: Text(
                item.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: subtitle,
                  height: 1.2,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 22,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

/// Icon + current reading row below charts.
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
    final theme = Theme.of(context);
    final accent = accentColor ?? theme.colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Container(
            width: iconSize + 8,
            height: iconSize + 8,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              iconAsset,
              width: iconSize,
              height: iconSize,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Section header with optional leading icon.
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
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: iconColor ?? theme.colorScheme.primary, size: 22),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Aligned table for time-series vital readings (e.g. blood pressure list).
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
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.labelMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
    );
    final valueStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w500,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              for (var i = 0; i < columns.length; i++)
                Expanded(
                  flex: i == 0 ? 2 : 3,
                  child: Text(
                    columns[i],
                    textAlign: i == 0 ? TextAlign.start : TextAlign.center,
                    style: labelStyle,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          ...rows.map(
            (row) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  for (var i = 0; i < row.length; i++)
                    Expanded(
                      flex: i == 0 ? 2 : 3,
                      child: Text(
                        row[i],
                        textAlign: i == 0 ? TextAlign.start : TextAlign.center,
                        style: valueStyle,
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
