import 'package:flutter_band_fit_app/core/exports/vitals_imports.dart';
import 'package:flutter_band_fit_app/core/constants/widget_keys.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/activities_details_controller.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/widgets/details/activities_chart_shared.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/widgets/vitals_chart_styles.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/widgets/details/activities_detail_ui.dart';
import 'package:intl/intl.dart';

class ActivitiesDayTab extends GetView<ActivitiesDetailsController> {
  const ActivitiesDayTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ActivitiesDetailsController>(
      id: ActivitiesDetailsController.chartTabId,
      builder: (_) => SingleChildScrollView(
        padding: activitiesListBottomPadding(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            DetailDateNavigator(
              key: const Key(WidgetKeys.detailDateNavigator),
              dateTitle: controller.dayDateTitle,
              isNextDisabled: controller.dayNextDisable,
              onPrevious: () async {
                final time =
                    GlobalMethods.getOneDayBackward(controller.currentDateTime);
                controller.dayNextDisable = false;
                controller.currentDateTime = time;
                controller.notifyChartTab();
                await controller
                    .setCurrentDateTitle(controller.currentDateTime);
              },
              onNext: controller.dayNextDisable
                  ? null
                  : () async {
                      final nextDate = GlobalMethods.getOneDayForward(
                        controller.currentDateTime,
                      );
                      if (controller.checkNextDayAvailable(
                        controller.todayTime,
                        nextDate,
                      )) {
                        controller.dayNextDisable = true;
                      }
                      controller.currentDateTime = nextDate;
                      controller.notifyChartTab();
                      await controller.setCurrentDateTitle(
                        controller.currentDateTime,
                      );
                    },
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
              padding: const EdgeInsets.all(4.0),
              width: double.infinity,
              height: 180,
              child: RepaintBoundary(
                child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  key: ValueKey(
                    VitalsChartStyles.chartDayKey(
                      'steps-day',
                      controller.currentDateTime,
                      controller.stepsDayDataList.length,
                    ),
                  ),
                  onSelectionChanged: (selectionArgs) {
                    debugPrint('selectionArgs>> $selectionArgs');
                  },
                  primaryXAxis: DateTimeCategoryAxis(
                    majorGridLines: const MajorGridLines(width: 0),
                    majorTickLines: const MajorTickLines(size: 2),
                    minimum: DateTime(
                      controller.currentDateTime.year,
                      controller.currentDateTime.month,
                      controller.currentDateTime.day,
                      0,
                      0,
                      0,
                    ),
                    maximum: DateTime(
                      controller.currentDateTime.year,
                      controller.currentDateTime.month,
                      controller.currentDateTime.day,
                      24,
                      0,
                      0,
                    ),
                    intervalType: DateTimeIntervalType.minutes,
                    labelAlignment: LabelAlignment.center,
                    labelStyle: activitiesChartAxisLabelStyle(context),
                  ),
                  primaryYAxis: NumericAxis(
                    majorTickLines: const MajorTickLines(size: 2),
                    minimum: 0,
                    axisLine: const AxisLine(width: 0),
                    labelFormat: '{value}',
                    labelStyle: activitiesChartAxisLabelStyle(context),
                  ),
                  series: activitiesDaySeries(
                      controller, controller.currentDateTime),
                  tooltipBehavior: controller.tooltipDayBehavior,
                  trackballBehavior: TrackballBehavior(
                    enable: true,
                    markerSettings: const TrackballMarkerSettings(
                      markerVisibility: TrackballVisibilityMode.hidden,
                      height: 10,
                      width: 10,
                      borderWidth: 1,
                    ),
                    hideDelay: 1.0 * 1000,
                    activationMode: ActivationMode.singleTap,
                    tooltipAlignment: ChartAlignment.near,
                    tooltipDisplayMode: TrackballDisplayMode.floatAllPoints,
                    tooltipSettings: const InteractiveTooltip(
                      format: null,
                      canShowMarker: false,
                    ),
                    shouldAlwaysShow: false,
                    lineWidth: 0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2.0),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          textSteps,
                          textAlign: TextAlign.center,
                          style: activitiesSummaryLabelStyle(context)
                              .copyWith(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          GlobalMethods.formatNumber(
                            int.tryParse(controller.dayTotalSteps) ?? 0,
                          ),
                          textAlign: TextAlign.center,
                          style: activitiesSummaryValueStyle(context)
                              .copyWith(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 18.0,
                  child: VerticalDivider(
                    thickness: 1.0,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          textDistance,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          '${controller.dayTotalDistance} $textKm',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 18.0,
                  child: VerticalDivider(
                    thickness: 1.0,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          textCalories,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          '${controller.dayTotalCalories} $textKcal',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2.0),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemExtent: 72,
              itemCount: controller.stepsDayDataList.length,
              itemBuilder: (context, index) {
                final item = controller.stepsDayDataList[index];
                return ActivityStepDayTile(
                  stepCount: item.dataPoint,
                  time: item.time,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityStepDayTile extends StatelessWidget {
  const ActivityStepDayTile({
    super.key,
    required this.stepCount,
    required this.time,
  });

  final double stepCount;
  final DateTime time;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Image.asset(
          'assets/fit/footsteps.png',
          width: 35.0,
          height: 35.0,
          fit: BoxFit.fill,
        ),
        title: Text(
          stepCount.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          DateFormat.jm().format(time),
          style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
        ),
      ),
    );
  }
}

class ActivitiesWeekTab extends GetView<ActivitiesDetailsController> {
  const ActivitiesWeekTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ActivitiesDetailsController>(
      id: ActivitiesDetailsController.chartTabId,
      builder: (_) => SingleChildScrollView(
        padding: activitiesListBottomPadding(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            DetailDateNavigator(
              key: const Key(WidgetKeys.detailDateNavigator),
              dateTitle: controller.weekDateTitle,
              isNextDisabled: controller.weekNextDisable,
              onPrevious: () async {
                final time = GlobalMethods.getOneDayBackward(
                  controller.currentWeekDateTime[0],
                );
                final pastNextWeek =
                    await GlobalMethods.getWeekDatesListByTime(time);
                controller.weekNextDisable = false;
                controller.currentWeekDateTime = pastNextWeek;
                controller.notifyChartTab();
                await controller
                    .setWeekDateTitle(controller.currentWeekDateTime);
              },
              onNext: controller.weekNextDisable
                  ? null
                  : () async {
                      final time = GlobalMethods.getOneDayForward(
                        controller.currentWeekDateTime[
                            controller.currentWeekDateTime.length - 1],
                      );
                      final nextWeek =
                          await GlobalMethods.getWeekDatesListByTime(time);
                      controller.currentWeekDateTime = nextWeek;
                      if (controller.checkNextWeekAvailable(
                        controller.todayTime,
                        controller.currentWeekDateTime,
                      )) {
                        controller.weekNextDisable = true;
                      }
                      controller.notifyChartTab();
                      await controller.setWeekDateTitle(
                        controller.currentWeekDateTime,
                      );
                    },
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
              padding: const EdgeInsets.all(4.0),
              width: double.infinity,
              height: 200,
              child: RepaintBoundary(
                child: SfCartesianChart(
                  key: ValueKey('steps-week-${controller.weekDateTitle}'),
                  plotAreaBorderWidth: 0,
                  primaryXAxis: CategoryAxis(
                    majorGridLines: const MajorGridLines(width: 0),
                    majorTickLines: const MajorTickLines(size: 4),
                    labelStyle: activitiesChartAxisLabelStyle(context),
                  ),
                  primaryYAxis: NumericAxis(
                    majorTickLines:
                        const MajorTickLines(color: Colors.transparent),
                    labelFormat: '{value}',
                    minimum: 0,
                    axisLine: const AxisLine(width: 0),
                    labelStyle: activitiesChartAxisLabelStyle(context),
                  ),
                  tooltipBehavior: controller.tooltipWeekBehavior,
                  series: activitiesWeekSeries(
                    context,
                    controller,
                    controller.currentWeekDateTime,
                  ),
                ),
              ),
            ),
            ActivityStatSummaryGrid(
              key: const Key(WidgetKeys.activityStatSummaryGrid),
              stats: [
                ActivitySummaryStat(
                  label: textTotalSteps,
                  value: GlobalMethods.formatNumber(
                    int.tryParse(controller.weekTotalSteps) ?? 0,
                  ),
                  iconAsset: 'assets/fit/footsteps.png',
                ),
                ActivitySummaryStat(
                  label: textDistance,
                  value: '${controller.weekTotalDistance} kms',
                  iconAsset: 'assets/fit/distance.png',
                ),
                ActivitySummaryStat(
                  label: textCalories,
                  value: '${controller.weekTotalCalories} kCal',
                  iconAsset: 'assets/fit/kcal.png',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ActivitiesMonthTab extends GetView<ActivitiesDetailsController> {
  const ActivitiesMonthTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ActivitiesDetailsController>(
      id: ActivitiesDetailsController.chartTabId,
      builder: (_) => SingleChildScrollView(
        padding: activitiesListBottomPadding(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            DetailDateNavigator(
              key: const Key(WidgetKeys.detailDateNavigator),
              dateTitle: controller.monthlyDateTitle,
              isNextDisabled: controller.monthNextDisable,
              onPrevious: () async {
                final time = GlobalMethods.getOneDayBackward(
                  controller.currentMonthDateTime[0],
                );
                final pastNextMonth =
                    await GlobalMethods.getMonthyDatesListByTime(time);
                controller.monthNextDisable = false;
                controller.currentMonthDateTime = pastNextMonth;
                controller.notifyChartTab();
                await controller.setMonthDateTitle(
                  controller.currentMonthDateTime,
                );
              },
              onNext: controller.monthNextDisable
                  ? null
                  : () async {
                      final time = GlobalMethods.getOneDayForward(
                        controller.currentMonthDateTime[
                            controller.currentMonthDateTime.length - 1],
                      );
                      final nextMonth =
                          await GlobalMethods.getMonthyDatesListByTime(time);
                      controller.currentMonthDateTime = nextMonth;
                      if (controller.checkNextMonthAvailable(
                        controller.todayTime,
                        controller.currentMonthDateTime,
                      )) {
                        controller.monthNextDisable = true;
                      }
                      controller.notifyChartTab();
                      await controller.setMonthDateTitle(
                        controller.currentMonthDateTime,
                      );
                    },
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
              padding: const EdgeInsets.all(4.0),
              width: double.infinity,
              height: 180,
              child: RepaintBoundary(
                child: SfCartesianChart(
                  key: ValueKey('steps-month-${controller.monthlyDateTitle}'),
                  plotAreaBorderWidth: 0,
                  onSelectionChanged: (selectionArgs) {
                    debugPrint('selectionArgs>> $selectionArgs');
                  },
                  primaryXAxis: NumericAxis(
                    majorGridLines: const MajorGridLines(width: 0),
                    majorTickLines: const MajorTickLines(size: 4),
                    interval: 2,
                    labelIntersectAction: AxisLabelIntersectAction.rotate90,
                    labelStyle: activitiesChartAxisLabelStyle(context),
                  ),
                  primaryYAxis: NumericAxis(
                    majorTickLines:
                        const MajorTickLines(color: Colors.transparent),
                    minimum: 0,
                    axisLine: const AxisLine(width: 0),
                    labelFormat: '{value}',
                    labelStyle: activitiesChartAxisLabelStyle(context),
                  ),
                  series: activitiesMonthSeries(
                    context,
                    controller,
                    controller.currentMonthDateTime,
                  ),
                  tooltipBehavior: controller.tooltipWeekBehavior,
                  trackballBehavior: TrackballBehavior(
                    enable: true,
                    markerSettings: const TrackballMarkerSettings(
                      markerVisibility: TrackballVisibilityMode.hidden,
                      height: 10,
                      width: 10,
                      borderWidth: 1,
                    ),
                    hideDelay: 1.0 * 1000,
                    activationMode: ActivationMode.singleTap,
                    tooltipAlignment: ChartAlignment.near,
                    tooltipDisplayMode: TrackballDisplayMode.floatAllPoints,
                    tooltipSettings: const InteractiveTooltip(
                      format: null,
                      canShowMarker: false,
                    ),
                    shouldAlwaysShow: false,
                    lineWidth: 0,
                  ),
                ),
              ),
            ),
            ActivityStatSummaryGrid(
              key: const Key(WidgetKeys.activityStatSummaryGrid),
              stats: [
                ActivitySummaryStat(
                  label: textTotalSteps,
                  value: GlobalMethods.formatNumber(
                    int.tryParse(controller.monthTotalSteps) ?? 0,
                  ),
                  iconAsset: 'assets/fit/footsteps.png',
                ),
                ActivitySummaryStat(
                  label: textDistance,
                  value: '${controller.monthTotalDistance} kms',
                  iconAsset: 'assets/fit/distance.png',
                ),
                ActivitySummaryStat(
                  label: textCalories,
                  value: '${controller.monthTotalCalories} kCal',
                  iconAsset: 'assets/fit/kcal.png',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
