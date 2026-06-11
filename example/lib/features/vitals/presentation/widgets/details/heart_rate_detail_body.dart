import 'package:flutter_band_fit_app/core/exports/vitals_imports.dart';
import 'package:flutter_band_fit_app/core/constants/widget_keys.dart';
import 'package:flutter_band_fit_app/core/widgets/fixed_section_list.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/heart_rate_detail_controller.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/widgets/vitals_chart_styles.dart';

class HeartRateDetailBody extends GetView<HeartRateDetailController> {
  const HeartRateDetailBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: VitalColoredAppBar(
        key: const Key(WidgetKeys.vitalColoredAppBar),
        title: controller.displayTitle,
        accentColor: heartRateColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () =>
                controller.pickCalendarDay(context, controller.loadDay),
          ),
        ],
      ),
      body: FixedSectionListView(
        key: const Key(WidgetKeys.fixedSectionListView),
        sections: [
          DetailActivityHeader(
              key: const Key(WidgetKeys.detailActivityHeader),
              label: controller.activityLabel),
          Obx(
            () => DetailDateNavigator(
              key: const Key(WidgetKeys.detailDateNavigator),
              dateTitle: controller.dateTitle.value,
              isNextDisabled: controller.isNextDisable.value,
              onPrevious: () => controller.navigatePrevious(controller.loadDay),
              onNext: controller.isNextDisable.value
                  ? null
                  : () => controller.navigateNext(controller.loadDay),
            ),
          ),
          const SizedBox(height: 4),
          _HeartRateChart(
              key: const Key(WidgetKeys.heartRateChart),
              controller: controller),
          const SizedBox(height: 4),
          const _CurrentHeartRateRow(
            key: Key(WidgetKeys.currentHeartRateRow),
          ),
          const SizedBox(height: 4),
          const _HeartRateStatsCard(
            key: Key(WidgetKeys.heartRateStatsCard),
          ),
        ],
      ),
    );
  }
}

class _HeartRateChart extends StatelessWidget {
  const _HeartRateChart({super.key, required this.controller});

  final HeartRateDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final day = controller.currentDateTime.value;
      final pointCount = controller.chartPoints.length;
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        padding: const EdgeInsets.all(4),
        width: double.infinity,
        height: 200,
        child: RepaintBoundary(
          child: SfCartesianChart(
            key: ValueKey(VitalsChartStyles.chartDayKey('hr', day, pointCount)),
            plotAreaBorderWidth: 0,
            primaryXAxis: DateTimeCategoryAxis(
              majorGridLines: const MajorGridLines(width: 0),
              majorTickLines: const MajorTickLines(size: 3),
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

class _CurrentHeartRateRow extends GetView<HeartRateDetailController> {
  const _CurrentHeartRateRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'assets/fit/heart.png',
              width: 40,
              height: 40,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '${controller.currentMainHeartRate.value} $hrTimeMinutes',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _HeartRateStatsCard extends GetView<HeartRateDetailController> {
  const _HeartRateStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatCell(
              key: const Key('${WidgetKeys.heartRateDetailBodyStatCell}_avg'),
              label: textAverageHR,
              value: controller.avgHeartRate.value,
            ),
            const _StatDivider(
              key: Key(WidgetKeys.statDividerAvgMin),
            ),
            _StatCell(
              key: const Key('${WidgetKeys.heartRateDetailBodyStatCell}_min'),
              label: textMinHR,
              value: controller.minHeartRate.value,
            ),
            const _StatDivider(
              key: Key(WidgetKeys.statDividerMinMax),
            ),
            _StatCell(
              key: const Key('${WidgetKeys.heartRateDetailBodyStatCell}_max'),
              label: textMaxHR,
              value: controller.maxHeartRate.value,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 40,
      child: VerticalDivider(thickness: 1, color: Colors.grey),
    );
  }
}
