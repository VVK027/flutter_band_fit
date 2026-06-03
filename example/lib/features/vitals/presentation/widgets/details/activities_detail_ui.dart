import 'package:flutter/material.dart';

class ActivitySummaryStat {
  const ActivitySummaryStat({
    required this.label,
    required this.value,
    required this.iconAsset,
  });

  final String label;
  final String value;
  final String iconAsset;
}

/// Compact 2-column summary grid for steps / distance / calories.
Widget buildActivityStatSummaryGrid(
  BuildContext context,
  List<ActivitySummaryStat> stats,
) {
  return Padding(
    padding: EdgeInsets.fromLTRB(
      12,
      4,
      12,
      MediaQuery.paddingOf(context).bottom + 8,
    ),
    child: GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.55,
      children: stats.map((s) => _ActivityStatCard(stat: s)).toList(),
    ),
  );
}

class _ActivityStatCard extends StatelessWidget {
  const _ActivityStatCard({required this.stat});

  final ActivitySummaryStat stat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: theme.brightness == Brightness.dark ? 0 : 1,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.6)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 36,
                height: 36,
                child: Image.asset(
                  stat.iconAsset,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      stat.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      stat.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
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
