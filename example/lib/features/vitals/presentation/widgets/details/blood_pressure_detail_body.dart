import 'package:flutter_band_fit_app/core/exports/vitals_imports.dart';
import 'package:flutter_band_fit_app/core/constants/widget_keys.dart';
import 'package:flutter_band_fit_app/core/widgets/scoped_loading_overlay.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/blood_pressure_detail_controller.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/widgets/vitals_chart_styles.dart';
import 'package:intl/intl.dart';

class BloodPressureDetailBody extends GetView<BloodPressureDetailController> {
  const BloodPressureDetailBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: VitalColoredAppBar(
        key: const Key(WidgetKeys.vitalColoredAppBar),
        title: controller.displayTitle,
        accentColor: bpColor,
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
          accentColor: bpColor,
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
                _BpChart(
                    key: const Key(WidgetKeys.bpChart), controller: controller),
                Obx(
                  () => VitalStatCard(
                    key: const Key(WidgetKeys.vitalStatCard),
                    items: [
                      VitalStatItem(
                        label: textHighPressure,
                        value: '${controller.highBPValue.value} $bpUnits',
                      ),
                      VitalStatItem(
                        label: textLowPressure,
                        value: '${controller.lowBPValue.value} $bpUnits',
                      ),
                    ],
                  ),
                ),
                const _BpReadingsSection(
                  key: Key(WidgetKeys.bpReadingsSection),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BpReadingsSection extends GetView<BloodPressureDetailController> {
  const _BpReadingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.bpDataList.isEmpty) {
        return const SizedBox.shrink();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitalSectionHeader(
            key: const Key(WidgetKeys.vitalSectionHeader),
            title: '$textTodayData (${controller.bpDataList.length})',
            icon: Icons.auto_graph_outlined,
            iconColor: Colors.amber.shade700,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemExtent: 40,
            itemCount: controller.bpDataList.length,
            itemBuilder: (context, index) {
              final item = controller.bpDataList[index];
              return _BpReadingRow(
                time: DateFormat.jm().format(item.time),
                high: '${item.highPressure} $bpUnits',
                low: '${item.lowPressure} $bpUnits',
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      );
    });
  }
}

class _BpReadingRow extends StatelessWidget {
  const _BpReadingRow({
    required this.time,
    required this.high,
    required this.low,
  });

  final String time;
  final String high;
  final String low;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(time)),
          Expanded(child: Text(high, textAlign: TextAlign.center)),
          Expanded(child: Text(low, textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}

class _BpChart extends StatelessWidget {
  const _BpChart({super.key, required this.controller});

  final BloodPressureDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final day = controller.currentDateTime.value;
      final pointCount = controller.bpDataList.length;
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        padding: const EdgeInsets.all(4),
        height: 200,
        child: RepaintBoundary(
          child: SfCartesianChart(
            key: ValueKey('bp-$pointCount-${day.millisecondsSinceEpoch}'),
            plotAreaBorderWidth: 0,
            primaryXAxis: DateTimeCategoryAxis(
              majorGridLines: const MajorGridLines(width: 0),
              majorTickLines: const MajorTickLines(size: 4, width: 1),
              labelIntersectAction: AxisLabelIntersectAction.wrap,
              minimum: DateTime(day.year, day.month, day.day),
              maximum: DateTime(day.year, day.month, day.day, 24),
              labelAlignment: LabelAlignment.center,
              intervalType: DateTimeIntervalType.minutes,
              labelStyle: VitalsChartStyles.axisLabel(context),
            ),
            primaryYAxis: NumericAxis(
              majorTickLines: const MajorTickLines(size: 0),
              interval: 50,
              minimum: 50,
              maximum: 200,
              axisLine: const AxisLine(width: 0),
              labelFormat: '{value}',
              labelStyle: VitalsChartStyles.axisLabel(context),
            ),
            series: controller.buildSeries(day),
            trackballBehavior: TrackballBehavior(
              enable: true,
              markerSettings: const TrackballMarkerSettings(
                markerVisibility: TrackballVisibilityMode.hidden,
                height: 10,
                width: 10,
                borderWidth: 1,
              ),
              hideDelay: 1000,
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
