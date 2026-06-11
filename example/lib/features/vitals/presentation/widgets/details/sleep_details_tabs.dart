import 'package:flutter_band_fit_app/core/exports/vitals_imports.dart';
import 'package:flutter_band_fit_app/core/constants/widget_keys.dart';
import 'package:flutter_band_fit_app/core/widgets/fixed_section_list.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/sleep_details_controller.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/widgets/details/sleep_detail_ui.dart';

EdgeInsets sleepListBottomPadding(BuildContext context) =>
    EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom + 12);

class SleepDayTab extends GetView<SleepDetailsController> {
  const SleepDayTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SleepDetailsController>(
      id: SleepDetailsController.chartTabId,
      builder: (_) => FixedSectionListView(
        key: const Key(WidgetKeys.fixedSectionListView),
        padding: sleepListBottomPadding(context),
        sections: [
          SleepDayDateNavigator(
            key: const Key(WidgetKeys.sleepDayDateNavigator),
          ),
          const SizedBox(height: 4),
          SleepDaySummaryHeader(
            key: const Key(WidgetKeys.sleepDaySummaryHeader),
          ),
          const SizedBox(height: 4),
          SleepDayStageBar(
            key: const Key(WidgetKeys.sleepDayStageBar),
          ),
          SleepDayBeginEndRow(
            key: const Key(WidgetKeys.sleepDayBeginEndRow),
          ),
          const SleepDayStageDivider(
            key: Key(WidgetKeys.sleepDayStageDivider),
          ),
          const SizedBox(height: 4),
          SleepDayStageStatsRow(
            key: const Key(WidgetKeys.sleepDayStageStatsRow),
          ),
          const SizedBox(height: 21),
          const SleepDayQualityTitle(
            key: Key(WidgetKeys.sleepDayQualityTitle),
          ),
          const SizedBox(height: 21),
          const SleepDayQualityNotLateSection(
            key: Key(WidgetKeys.sleepDayQualityNotLateSection),
          ),
          const SizedBox(height: 10),
          const SleepDayQualityLackSection(
            key: Key(WidgetKeys.sleepDayQualityLackSection),
          ),
          const SizedBox(height: 10),
          const SleepDayQualityWakeEarlySection(
            key: Key(WidgetKeys.sleepDayQualityWakeEarlySection),
          ),
        ],
      ),
    );
  }
}

class SleepDayDateNavigator extends GetView<SleepDetailsController> {
  const SleepDayDateNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return DetailDateNavigator(
      key: const Key(WidgetKeys.detailDateNavigator),
      dateTitle: controller.dayDateTitle,
      isNextDisabled: controller.dayNextDisable,
      onPrevious: () async {
        final time =
            GlobalMethods.getOneDayBackward(controller.currentDateTime);
        controller.dayNextDisable = false;
        controller.currentDateTime = time;
        controller.notifyChartTab();
        await controller.setCurrentDateTitle(controller.currentDateTime);
      },
      onNext: controller.dayNextDisable
          ? null
          : () async {
              final nextDate =
                  GlobalMethods.getOneDayForward(controller.currentDateTime);
              if (controller.checkNextDayAvailable(
                controller.todayTime,
                nextDate,
              )) {
                controller.dayNextDisable = true;
              }
              controller.currentDateTime = nextDate;
              controller.notifyChartTab();
              await controller.setCurrentDateTitle(controller.currentDateTime);
            },
    );
  }
}

class SleepDaySummaryHeader extends GetView<SleepDetailsController> {
  const SleepDaySummaryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              top: 8.0,
              bottom: 8.0,
              right: 2.0,
            ),
            child: Text(
              controller.dayTotalHours,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 21.0,
              ),
            ),
          ),
          const Text(
            'h',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 4.0,
              top: 8.0,
              bottom: 8.0,
              right: 2.0,
            ),
            child: Text(
              controller.dayTotalMin,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 21.0,
              ),
            ),
          ),
          const Text(
            'm',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}

class SleepDayStageBar extends GetView<SleepDetailsController> {
  const SleepDayStageBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: 12.0,
            child: VerticalDivider(thickness: 1.0, color: Colors.grey),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return CustomAssetsBar(
                  width: constraints.maxWidth,
                  background: const Color(0xFFCFD8DC),
                  assetsLimit: 100,
                  assets: [
                    BarAsset(
                      size: controller.deepPercentage.toDouble(),
                      color: const Color(0xFF7A58C9),
                    ),
                    BarAsset(
                      size: controller.lightPercentage.toDouble(),
                      color: const Color(0xFFC7A9FE),
                    ),
                    BarAsset(
                      size: controller.awakePercentage.toDouble(),
                      color: const Color(0xFFFF9A42),
                    ),
                  ],
                  radius: 4,
                  order: OrderType.none,
                );
              },
            ),
          ),
          const SizedBox(
            height: 12.0,
            child: VerticalDivider(thickness: 1.0, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class SleepDayBeginEndRow extends GetView<SleepDetailsController> {
  const SleepDayBeginEndRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 6.0),
            padding: const EdgeInsets.all(2.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text(
                    textBegin,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    '${controller.dayBeginHours}:${controller.dayBeginMin}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            padding: const EdgeInsets.all(2.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text(
                    textEnd,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    '${controller.dayEndHours}:${controller.dayEndMin}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SleepDayStageDivider extends StatelessWidget {
  const SleepDayStageDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Divider(color: Colors.grey[500], height: 3.0),
    );
  }
}

class SleepDayStageStatsRow extends GetView<SleepDetailsController> {
  const SleepDayStageStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _SleepDayStageColumn(
            color: deepColor,
            label: textDeep,
            hours: controller.dayDeepHours,
            minutes: controller.dayDeepMin,
          ),
          const SizedBox(
            height: 18.0,
            child: VerticalDivider(thickness: 1.0, color: Colors.grey),
          ),
          _SleepDayStageColumn(
            color: lightColor,
            label: textLight,
            hours: controller.dayLightHours,
            minutes: controller.dayLightMin,
          ),
          const SizedBox(
            height: 18.0,
            child: VerticalDivider(thickness: 1.0, color: Colors.grey),
          ),
          _SleepDayStageColumn(
            color: awakeColor,
            label: textAwake,
            hours: controller.dayAwakeHours,
            minutes: controller.dayAwakeMin,
          ),
        ],
      ),
    );
  }
}

class _SleepDayStageColumn extends StatelessWidget {
  const _SleepDayStageColumn({
    required this.color,
    required this.label,
    required this.hours,
    required this.minutes,
  });

  final Color color;
  final String label;
  final String hours;
  final String minutes;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.rectangle,
                    ),
                    height: 12,
                    width: 12,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$hours ',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                  ),
                ),
                const Text(
                  'h',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0,
                  ),
                ),
                Text(
                  '$minutes ',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                  ),
                ),
                const Text(
                  'm',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SleepDayQualityTitle extends StatelessWidget {
  const SleepDayQualityTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        textSleepQualityAnalysis,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}

class SleepDayQualityNotLateSection extends StatelessWidget {
  const SleepDayQualityNotLateSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            textSleepNotLate,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            sleepToLateString,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}

class SleepDayQualityLackSection extends StatelessWidget {
  const SleepDayQualityLackSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            textSleepLake,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            sleepLackString,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}

class SleepDayQualityWakeEarlySection extends StatelessWidget {
  const SleepDayQualityWakeEarlySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            textSleepWakeEarly,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            sleepEarlyWakeUpString,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}

class SleepWeekTab extends GetView<SleepDetailsController> {
  const SleepWeekTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SleepDetailsController>(
      id: SleepDetailsController.chartTabId,
      builder: (_) => Column(
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
              await controller.setWeekDateTitle(controller.currentWeekDateTime);
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
          SleepRangeChart(
            key: const Key(WidgetKeys.sleepRangeChart),
            series: sleepWeekRangeSeries(controller),
          ),
          SleepStatSummaryGrid(
              key: const Key(WidgetKeys.sleepStatSummaryGrid),
              stats: weekSleepStats(controller)),
        ],
      ),
    );
  }
}

class SleepMonthTab extends GetView<SleepDetailsController> {
  const SleepMonthTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SleepDetailsController>(
      id: SleepDetailsController.chartTabId,
      builder: (_) => Column(
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
          SleepRangeChart(
            key: const Key(WidgetKeys.sleepRangeChart),
            categoryInterval: 2,
            series: sleepMonthRangeSeries(controller),
          ),
          SleepStatSummaryGrid(
              key: const Key(WidgetKeys.sleepStatSummaryGrid),
              stats: monthSleepStats(controller)),
        ],
      ),
    );
  }
}

List<SleepDurationStat> weekSleepStats(SleepDetailsController controller) => [
      SleepDurationStat(
        label: textTotalHours,
        hours: controller.weekTotalSleepHours,
        minutes: controller.weekTotalSleepMin,
        iconAsset: 'assets/fit/sleep_duration.png',
      ),
      SleepDurationStat(
        label: textDeepHours,
        hours: controller.weekTotalDeepHours,
        minutes: controller.weekTotalDeepMin,
        iconAsset: 'assets/fit/sleep_deep.png',
      ),
      SleepDurationStat(
        label: textLightHours,
        hours: controller.weekTotalLightHours,
        minutes: controller.weekTotalLightMin,
        iconAsset: 'assets/fit/sleep_light.png',
      ),
      SleepDurationStat(
        label: textAwakeHours,
        hours: controller.weekTotalAwakeHours,
        minutes: controller.weekTotalAwakeMin,
        iconAsset: 'assets/fit/sleep_awake.png',
      ),
    ];

List<SleepDurationStat> monthSleepStats(SleepDetailsController controller) => [
      SleepDurationStat(
        label: textTotalSleepHours,
        hours: controller.monthTotalSleepHours,
        minutes: controller.monthTotalSleepMin,
        iconAsset: 'assets/fit/sleep_duration.png',
      ),
      SleepDurationStat(
        label: textDeepHours,
        hours: controller.monthTotalDeepHours,
        minutes: controller.monthTotalDeepMin,
        iconAsset: 'assets/fit/sleep_deep.png',
      ),
      SleepDurationStat(
        label: textLightHours,
        hours: controller.monthTotalLightHours,
        minutes: controller.monthTotalLightMin,
        iconAsset: 'assets/fit/sleep_light.png',
      ),
      SleepDurationStat(
        label: textAwakeHours,
        hours: controller.monthTotalAwakeHours,
        minutes: controller.monthTotalAwakeMin,
        iconAsset: 'assets/fit/sleep_awake.png',
      ),
    ];

List<RangeColumnSeries<WeeklySleepData, String>> sleepWeekRangeSeries(
  SleepDetailsController controller,
) {
  return <RangeColumnSeries<WeeklySleepData, String>>[
    RangeColumnSeries<WeeklySleepData, String>(
      dataSource: controller.weekSleepDataList,
      xValueMapper: (WeeklySleepData sales, _) => sales.weekName,
      lowValueMapper: (WeeklySleepData sales, _) => sales.startTimeNum,
      highValueMapper: (WeeklySleepData sales, _) => sales.endTimeNum,
      borderRadius: BorderRadius.circular(8.0),
      color: sleepLightColor,
      width: controller.weekSleepDataList.length <= 4 ? 0.2 : 0.5,
    ),
  ];
}

List<RangeColumnSeries<MonthlySleepData, num>> sleepMonthRangeSeries(
  SleepDetailsController controller,
) {
  return <RangeColumnSeries<MonthlySleepData, num>>[
    RangeColumnSeries<MonthlySleepData, num>(
      dataSource: controller.monthSleepDataList,
      xValueMapper: (MonthlySleepData sales, _) => sales.dayNumber,
      lowValueMapper: (MonthlySleepData sales, _) => sales.startTimeNum,
      highValueMapper: (MonthlySleepData sales, _) => sales.endTimeNum,
      borderRadius: BorderRadius.circular(8.0),
      pointColorMapper: (MonthlySleepData datum, _) => datum.color,
      width: 0.5,
    ),
  ];
}
