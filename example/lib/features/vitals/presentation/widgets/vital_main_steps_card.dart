import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:flutter_band_fit_app/core/services/activity_service_provider.dart';
import 'package:flutter_band_fit_app/core/widgets/custom/custom_circle_progress.dart';
import 'package:flutter_band_fit_app/core/widgets/icon_text_widget.dart';

/// Steps ring, weather row, goal, and last-sync row — isolated from parent rebuilds.
class VitalMainStepsCard extends StatelessWidget {
  const VitalMainStepsCard({
    super.key,
    required this.provider,
    required this.onOpenSteps,
    required this.onOpenWeather,
    required this.onSyncNow,
    required this.isSyncBlocked,
  });

  final ActivityServiceProvider provider;
  final VoidCallback onOpenSteps;
  final VoidCallback onOpenWeather;
  final Future<void> Function() onSyncNow;
  final bool Function() isSyncBlocked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    return RepaintBoundary(
      child: Card(
        margin: const EdgeInsets.fromLTRB(12, 4, 12, 8),
        elevation: theme.brightness == Brightness.dark ? 0 : 2,
        shadowColor: primary.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.4)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _WeatherGoalRow(
                    provider: provider,
                    isGoal: false,
                    onTap: onOpenWeather,
                  ),
                  _WeatherGoalRow(
                    provider: provider,
                    isGoal: true,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Center(
                child: RepaintBoundary(
                  child: CustomPaint(
                    foregroundPainter:
                        CircleProgress(provider.getProgressPercentage),
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: GestureDetector(
                        onTap: () {
                          if (!isSyncBlocked()) onOpenSteps();
                        },
                        child: Center(
                          child: Image.asset(
                            'assets/fit/running.png',
                            width: 60,
                            height: 60,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _MetricTap(
                    blocked: isSyncBlocked,
                    onTap: onOpenSteps,
                    child: IconTextWidget(
                      imagePath: 'assets/fit/footsteps.png',
                      mainTitle: provider.getSteps == 0
                          ? '-'
                          : GlobalMethods.formatNumber(provider.getSteps),
                      subMainTitle: textSteps,
                    ),
                  ),
                  SizedBox(
                    height: 36,
                    child: VerticalDivider(
                      thickness: 1,
                      color: theme.dividerColor,
                    ),
                  ),
                  _MetricTap(
                    blocked: isSyncBlocked,
                    onTap: onOpenSteps,
                    child: IconTextWidget(
                      imagePath: 'assets/fit/distance.png',
                      mainTitle: provider.getDistance,
                      subMainTitle: 'Km',
                    ),
                  ),
                  SizedBox(
                    height: 36,
                    child: VerticalDivider(
                      thickness: 1,
                      color: theme.dividerColor,
                    ),
                  ),
                  _MetricTap(
                    blocked: isSyncBlocked,
                    onTap: onOpenSteps,
                    child: IconTextWidget(
                      imagePath: 'assets/fit/kcal.png',
                      mainTitle: provider.getCalories,
                      subMainTitle: 'Kcal',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Visibility(
                visible: !provider.isSyncProgress &&
                    provider.getLastSyncDated.isNotEmpty &&
                    provider.getDeviceConnected,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history_rounded,
                        size: 16,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          provider.getLastSyncDated.isEmpty
                              ? textLastSyncedNoData
                              : '$textLastSynced: ${provider.getLastSyncDated}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: onSyncNow,
                        icon: const Icon(Icons.sync_rounded, size: 18),
                        label: const Text(textSyncNow),
                        style: TextButton.styleFrom(
                          foregroundColor: primary,
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: const Size(0, 32),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeatherGoalRow extends StatelessWidget {
  const _WeatherGoalRow({
    required this.provider,
    required this.isGoal,
    required this.onTap,
  });

  final ActivityServiceProvider provider;
  final bool isGoal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (isGoal) {
      return Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                textGoal,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(
                GlobalMethods.formatNumber(int.parse(provider.targetedSteps)),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(2),
            child: Image.asset('assets/fit/goal_left.png', width: 38, height: 38),
          ),
        ],
      );
    }
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Image.asset('assets/fit/weather.png', width: 38, height: 38),
          Padding(
            padding: const EdgeInsets.all(2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  textToday,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '${provider.getCurrentTemperature} ${provider.getIsCelsius ? tempInCelsius : tempInFahrenheit}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTap extends StatelessWidget {
  const _MetricTap({
    required this.blocked,
    required this.onTap,
    required this.child,
  });

  final bool Function() blocked;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: blocked() ? null : onTap, child: child);
  }
}
