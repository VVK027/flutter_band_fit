import 'package:flutter_band_fit_app/core/exports/vitals_imports.dart';
import 'package:flutter_band_fit_app/core/widgets/scoped_loading_overlay.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/oxygen_detail_controller.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/widgets/vitals_chart_styles.dart';

class OxygenDetailBody extends GetView<OxygenDetailController> {
  const OxygenDetailBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: VitalColoredAppBar(
        title: controller.displayTitle,
        accentColor: oxygenColorDark,
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
          accentColor: oxygenColorDark,
          enabled: !controller.isTestRunning.value,
          onPressed: () => controller.onStartTest(context),
        ),
      ),
      body: Obx(
        () => ScopedLoadingOverlay(
          visible: controller.isTestRunning.value,
          message: textMeasuring,
          subtitle: textMeasuringVitalMsg,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DetailActivityHeader(label: controller.activityLabel),
                Obx(
                  () => DetailDateNavigator(
                    dateTitle: controller.dateTitle.value,
                    isNextDisabled: controller.isNextDisable.value,
                    onPrevious: () =>
                        controller.navigatePrevious(controller.loadDay),
                    onNext: controller.isNextDisable.value
                        ? null
                        : () => controller.navigateNext(controller.loadDay),
                  ),
                ),
                _OxygenChart(controller: controller),
                Obx(
                  () => VitalCurrentReadingRow(
                    iconAsset: 'assets/fit/blood_oxygen.png',
                    value: '${controller.currentOxygen.value} %',
                    accentColor: oxygenColorDark,
                  ),
                ),
                Obx(
                  () => VitalStatCard(
                    items: [
                      VitalStatItem(
                        label: textMinOxygen,
                        value: controller.minOxygenValue.value,
                      ),
                      VitalStatItem(
                        label: textMaxOxygen,
                        value: controller.maxOxygenValue.value,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OxygenChart extends StatelessWidget {
  const _OxygenChart({required this.controller});

  final OxygenDetailController controller;

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
            key: ValueKey('oxy-$pointCount-${day.millisecondsSinceEpoch}'),
            plotAreaBorderWidth: 0,
            primaryXAxis: DateTimeCategoryAxis(
              majorGridLines: const MajorGridLines(width: 0),
              majorTickLines: const MajorTickLines(size: 4),
              minimum: DateTime(day.year, day.month, day.day),
              maximum: DateTime(day.year, day.month, day.day, 24),
              labelIntersectAction: AxisLabelIntersectAction.wrap,
              labelAlignment: LabelAlignment.center,
              intervalType: DateTimeIntervalType.minutes,
              labelStyle: VitalsChartStyles.axisLabel(context),
            ),
            primaryYAxis: NumericAxis(
              majorTickLines: const MajorTickLines(size: 4),
              minimum: 0,
              maximum: 200,
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
