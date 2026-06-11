import 'package:flutter_band_fit_app/core/exports/vitals_imports.dart';
import 'package:flutter_band_fit_app/core/constants/widget_keys.dart';
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
        key: const Key(WidgetKeys.vitalColoredAppBar),
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
          key: const Key(WidgetKeys.vitalStartButtonBar),
          accentColor: oxygenColorDark,
          enabled: !controller.isTestRunning.value,
          onPressed: () => controller.onStartTest(context),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
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
                _OxygenChart(
                    key: const Key(WidgetKeys.oxygenChart),
                    controller: controller),
                Obx(
                  () => VitalCurrentReadingRow(
                    key: const Key(WidgetKeys.vitalCurrentReadingRow),
                    iconAsset: 'assets/fit/blood_oxygen.png',
                    value: '${controller.currentOxygen.value} %',
                    accentColor: oxygenColorDark,
                  ),
                ),
                Obx(
                  () => VitalStatCard(
                    key: const Key(WidgetKeys.vitalStatCard),
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
          Obx(
            () => ScopedLoadingOverlay(
              key: const Key(WidgetKeys.scopedLoadingOverlay),
              visible: controller.isTestRunning.value,
              message: textMeasuring,
              subtitle: textMeasuringVitalMsg,
              child: const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}

class _OxygenChart extends StatelessWidget {
  const _OxygenChart({super.key, required this.controller});

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
            key: ValueKey(
              VitalsChartStyles.chartDayKey('oxy', day, pointCount),
            ),
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
