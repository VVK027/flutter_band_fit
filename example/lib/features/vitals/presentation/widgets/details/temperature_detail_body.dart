import 'package:flutter_band_fit_app/core/exports/vitals_imports.dart';
import 'package:flutter_band_fit_app/core/constants/widget_keys.dart';
import 'package:flutter_band_fit_app/core/widgets/scoped_loading_overlay.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/temperature_detail_controller.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/widgets/vitals_chart_styles.dart';

class TemperatureDetailBody extends GetView<TemperatureDetailController> {
  const TemperatureDetailBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: VitalColoredAppBar(
        key: const Key(WidgetKeys.vitalColoredAppBar),
        title: controller.displayTitle,
        accentColor: temperatureColor,
        actions: [
          Obx(
            () => IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: controller.isTestRunning.value
                  ? null
                  : () => controller.pickCalendarDay(
                        context,
                        controller.loadDay,
                      ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(
        () => VitalStartButtonBar(
          key: const Key(WidgetKeys.vitalStartButtonBar),
          accentColor: temperatureColor,
          enabled: !controller.isTestRunning.value,
          onPressed: () => controller.onStartTest(context),
        ),
      ),
      body: Obx(
        () => ScopedLoadingOverlay(
          key: const Key(WidgetKeys.scopedLoadingOverlay),
          visible: controller.isTestRunning.value,
          message: textMeasuring,
          subtitle: textMeasuringVitalMsg,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DetailActivityHeader(
                    key: const Key(WidgetKeys.detailActivityHeader),
                    label: controller.activityLabel),
                Obx(
                  () => DetailDateNavigator(
                    key: const Key(WidgetKeys.detailDateNavigator),
                    dateTitle: controller.dateTitle.value,
                    isNextDisabled: controller.isNextDisable.value,
                    onPrevious: () =>
                        controller.navigatePrevious(controller.loadDay),
                    onNext: controller.isNextDisable.value
                        ? null
                        : () => controller.navigateNext(controller.loadDay),
                  ),
                ),
                _TemperatureChart(
                    key: const Key(WidgetKeys.temperatureChart),
                    controller: controller),
                Obx(
                  () => VitalStatCard(
                    key: const Key(WidgetKeys.vitalStatCard),
                    items: [
                      VitalStatItem(
                        label: textMinTemperature,
                        value:
                            '${controller.minTemperature.value} ${controller.tempUnits.value}',
                      ),
                      VitalStatItem(
                        label: textMaxTemperature,
                        value:
                            '${controller.maxTemperature.value} ${controller.tempUnits.value}',
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        textRecentTemperature,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => Text(
                          '${controller.recentTemperature.value} ${controller.tempUnits.value}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      tempString,
                      textAlign: TextAlign.justify,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ),
                Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      tempDisclaimer,
                      textAlign: TextAlign.justify,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TemperatureChart extends StatelessWidget {
  const _TemperatureChart({super.key, required this.controller});

  final TemperatureDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final day = controller.currentDateTime.value;
      final pointCount = controller.chartPoints.length;
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        padding: const EdgeInsets.all(4),
        height: 200,
        child: RepaintBoundary(
          child: SfCartesianChart(
            key: ValueKey('temp-$pointCount-${day.millisecondsSinceEpoch}'),
            plotAreaBorderWidth: 0,
            primaryXAxis: DateTimeCategoryAxis(
              majorGridLines: const MajorGridLines(width: 0),
              majorTickLines: const MajorTickLines(size: 2),
              minimum: DateTime(day.year, day.month, day.day),
              maximum: DateTime(day.year, day.month, day.day, 24),
              labelIntersectAction: AxisLabelIntersectAction.wrap,
              labelAlignment: LabelAlignment.center,
              intervalType: DateTimeIntervalType.minutes,
              labelStyle: VitalsChartStyles.axisLabel(context),
            ),
            primaryYAxis: NumericAxis(
              majorTickLines: const MajorTickLines(size: 2),
              axisLine: const AxisLine(width: 0),
              labelFormat: '{value}',
              labelStyle: VitalsChartStyles.axisLabel(context),
            ),
            series: controller.buildSeries(day),
            tooltipBehavior: controller.tooltipBehavior,
            trackballBehavior: TrackballBehavior(
              enable: true,
              markerSettings: const TrackballMarkerSettings(
                markerVisibility: TrackballVisibilityMode.hidden,
                height: 10,
                width: 10,
                borderWidth: 1,
              ),
              activationMode: ActivationMode.singleTap,
              tooltipAlignment: ChartAlignment.near,
              tooltipDisplayMode: TrackballDisplayMode.floatAllPoints,
              tooltipSettings: const InteractiveTooltip(canShowMarker: false),
              shouldAlwaysShow: false,
              lineWidth: 0,
            ),
          ),
        ),
      );
    });
  }
}
