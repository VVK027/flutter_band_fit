import 'package:flutter/material.dart';
import 'package:flutter_band_fit_app/core/widgets/app_ui_components.dart';

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
    final theme = Theme.of(context);
    final accent = accentColor ?? theme.colorScheme.primary;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              VitalIconBadge(
                assetPath: imagePath,
                accentColor: accent,
                size: 48,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.45,
                          ),
                          size: 22,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _valueLine,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (time.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 108),
                            child: Text(
                              time,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.55,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
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
