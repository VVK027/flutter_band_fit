import 'package:flutter/material.dart';
import 'package:flutter_band_fit_app/core/constants/global_constants.dart';
import 'package:flutter_band_fit_app/core/utils/global_methods.dart';
import 'package:flutter_band_fit_app/features/vitals/data/models/band_data_model.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/widgets/vitals_chart_styles.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// One sleep stage row in the day/week/month summary grid (deep, light, awake, total).
class SleepDurationStat {
  const SleepDurationStat({
    required this.label,
    required this.hours,
    required this.minutes,
    required this.iconAsset,
  });

  final String label;
  final String hours;
  final String minutes;
  final String iconAsset;
}

/// Two-column grid of [SleepDurationStat] cards for the sleep detail screen.
Widget buildSleepStatSummaryGrid(BuildContext context, List<SleepDurationStat> stats) {
  return Expanded(
    child: GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.fromLTRB(12, 4, 12, MediaQuery.paddingOf(context).bottom + 8),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.55,
      children: stats.map((s) => buildSleepStatCard(context, s)).toList(),
    ),
  );
}

Widget buildSleepStatCard(BuildContext context, SleepDurationStat stat) {
  final theme = Theme.of(context);
  final labelStyle = theme.textTheme.titleSmall?.copyWith(
    fontWeight: FontWeight.w600,
    height: 1.2,
  );
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
                    style: labelStyle,
                  ),
                  const SizedBox(height: 2),
                  sleepDurationValueRow(context, stat.hours, stat.minutes),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget sleepDurationValueRow(BuildContext context, String hours, String minutes) {
  final valueStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w700,
      );
  return Text(
    '${hours}h ${minutes}m',
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: valueStyle,
  );
}

/// Range bar chart for weekly or monthly sleep segments (minutes on Y axis).
Widget buildSleepRangeChart(
  BuildContext context, {
  required List<CartesianSeries<dynamic, dynamic>> series,
  double? categoryInterval,
}) {
  final theme = Theme.of(context);
  final gridColor = theme.dividerColor.withValues(alpha: 0.28);

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    height: 210,
    child: SfCartesianChart(
      key: ValueKey('sleep-range-chart-${theme.brightness}'),
      plotAreaBorderWidth: 0,
      margin: const EdgeInsets.only(top: 8, right: 8, bottom: 4, left: 4),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        majorTickLines: const MajorTickLines(size: 4),
        interval: categoryInterval,
        labelIntersectAction: AxisLabelIntersectAction.rotate45,
        labelStyle: VitalsChartStyles.axisLabel(context),
      ),
      primaryYAxis: NumericAxis(
        majorTickLines: const MajorTickLines(color: Colors.transparent),
        majorGridLines: MajorGridLines(width: 0.5, color: gridColor),
        axisLabelFormatter: (axisLabelRenderArgs) {
          return ChartAxisLabel(
            GlobalMethods.getTimeByIntegerMin(axisLabelRenderArgs.value.toInt()),
            VitalsChartStyles.axisLabel(context),
          );
        },
        minimum: 0,
        maximum: 1440,
        interval: 480,
        axisLine: const AxisLine(width: 0),
      ),
      tooltipBehavior: sleepTooltipBehavior(context),
      trackballBehavior: sleepTrackballBehavior(context),
      series: series,
    ),
  );
}

TooltipBehavior sleepTooltipBehavior(BuildContext context) {
  final theme = Theme.of(context);
  return TooltipBehavior(
    enable: true,
    canShowMarker: true,
    activationMode: ActivationMode.singleTap,
    color: theme.colorScheme.inverseSurface,
    borderColor: theme.dividerColor,
    borderWidth: 1,
    builder: (dynamic data, point, series, pointIndex, seriesIndex) {
      final content = _sleepTooltipLines(data);
      if (content == null) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Text(
          content,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onInverseSurface,
            height: 1.35,
          ),
        ),
      );
    },
  );
}

TrackballBehavior sleepTrackballBehavior(BuildContext context) {
  final theme = Theme.of(context);
  return TrackballBehavior(
    enable: true,
    activationMode: ActivationMode.singleTap,
    hideDelay: 2000,
    tooltipAlignment: ChartAlignment.near,
    tooltipDisplayMode: TrackballDisplayMode.floatAllPoints,
    lineWidth: 0,
    markerSettings: TrackballMarkerSettings(
      markerVisibility: TrackballVisibilityMode.visible,
      height: 8,
      width: 8,
      borderWidth: 1.5,
      borderColor: theme.colorScheme.onSurface,
      color: sleepLightColor,
    ),
    tooltipSettings: InteractiveTooltip(
      enable: true,
      canShowMarker: false,
      color: theme.colorScheme.inverseSurface,
      textStyle: TextStyle(
        color: theme.colorScheme.onInverseSurface,
        fontSize: 11,
      ),
      borderColor: theme.dividerColor,
      borderWidth: 1,
    ),
  );
}

String? _sleepTooltipLines(dynamic data) {
  if (data is WeeklySleepData) {
    return _formatSleepPoint(
      label: data.weekName,
      date: data.startTime,
      startMin: data.startTimeNum,
      endMin: data.endTimeNum,
    );
  }
  if (data is MonthlySleepData) {
    return _formatSleepPoint(
      label: 'Day ${data.dayNumber}',
      date: data.startTime,
      startMin: data.startTimeNum,
      endMin: data.endTimeNum,
    );
  }
  return null;
}

String _formatSleepPoint({
  required String label,
  required DateTime date,
  required int startMin,
  required int endMin,
}) {
  final durationMin = (endMin - startMin).clamp(0, 1440);
  final hours = durationMin ~/ 60;
  final mins = durationMin % 60;
  return '$label\n'
      '${DateFormat('EEE, MMM d').format(date)}\n'
      '${GlobalMethods.getTimeByIntegerMin(startMin)} – ${GlobalMethods.getTimeByIntegerMin(endMin)}\n'
      '${hours}h ${mins.toString().padLeft(2, '0')}m';
}
