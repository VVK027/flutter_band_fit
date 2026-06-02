import 'package:flutter_band_fit_app/core/exports/vitals_imports.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/sleep_details_controller.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/widgets/details/sleep_detail_ui.dart';

/// Sleep detail screen with day / week / month tabs and stage breakdown charts.
class SleepDetailsBody extends GetView<SleepDetailsController> {
  const SleepDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          foregroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.white),
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  sleepLightColor,
                  Color.lerp(sleepLightColor, const Color(0xFF4338CA), 0.35)!,
                ],
              ),
            ),
          ),
          backgroundColor: sleepLightColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: () => Get.back<void>(),
          ),
          title: Text(
            controller.displayTitle,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: const [
            IconTheme(
              data: IconThemeData(color: Colors.white),
              child: ThemeToggleButton(),
            ),
          ],
          bottom: buildDwmTabBar(
            context,
            tabs: buildDWMTabs(),
            onTap: (value) {
              controller.selectedPage = value;
              controller.update();
            },
          ),
        ),
        body: SafeArea(
          top: false,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            DetailActivityHeader(label: controller.activityLabel),
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: GetBuilder<SleepDetailsController>(
                builder: (_) => TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    dayChartView(context),
                    weekChartView(context),
                    monthlyChartView(context),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 2.0,
            ),

          ],
        ),
        ),
      ),
    );
  }

  Widget monthlyChartView(BuildContext context) {
    return Column(
      children: [
        DetailDateNavigator(
          dateTitle: controller.monthlyDateTitle,
          isNextDisabled: controller.monthNextDisable,
          onPrevious: () async {
            final time = GlobalMethods.getOneDayBackward(controller.currentMonthDateTime[0]);
            final pastNextMonth = await GlobalMethods.getMonthyDatesListByTime(time);
            controller.monthNextDisable = false;
            controller.currentMonthDateTime = pastNextMonth;
            controller.update();
            await controller.setMonthDateTitle(controller.currentMonthDateTime);
          },
          onNext: controller.monthNextDisable
              ? null
              : () async {
                  final time = GlobalMethods.getOneDayForward(
                    controller.currentMonthDateTime[controller.currentMonthDateTime.length - 1],
                  );
                  final nextMonth = await GlobalMethods.getMonthyDatesListByTime(time);
                  controller.currentMonthDateTime = nextMonth;
                  if (controller.checkNextMonthAvailable(
                    controller.todayTime,
                    controller.currentMonthDateTime,
                  )) {
                    controller.monthNextDisable = true;
                  }
                  controller.update();
                  await controller.setMonthDateTitle(controller.currentMonthDateTime);
                },
        ),
        buildSleepRangeChart(
          context,
          categoryInterval: 2,
          series: getMonthlySeriesDataList(controller.currentMonthDateTime),
        ),
        buildSleepStatSummaryGrid(
          context,
          _monthSleepStats(),
        ),
      ],
    );
  }

  List<SleepDurationStat> _monthSleepStats() => [
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

  Widget weekChartView(BuildContext context) {
    return Column(
      children: [
        DetailDateNavigator(
          dateTitle: controller.weekDateTitle,
          isNextDisabled: controller.weekNextDisable,
          onPrevious: () async {
            final time = GlobalMethods.getOneDayBackward(controller.currentWeekDateTime[0]);
            final pastNextWeek = await GlobalMethods.getWeekDatesListByTime(time);
            controller.weekNextDisable = false;
            controller.currentWeekDateTime = pastNextWeek;
            controller.update();
            await controller.setWeekDateTitle(controller.currentWeekDateTime);
          },
          onNext: controller.weekNextDisable
              ? null
              : () async {
                  final time = GlobalMethods.getOneDayForward(
                    controller.currentWeekDateTime[controller.currentWeekDateTime.length - 1],
                  );
                  final nextWeek = await GlobalMethods.getWeekDatesListByTime(time);
                  controller.currentWeekDateTime = nextWeek;
                  if (controller.checkNextWeekAvailable(
                    controller.todayTime,
                    controller.currentWeekDateTime,
                  )) {
                    controller.weekNextDisable = true;
                  }
                  controller.update();
                  await controller.setWeekDateTitle(controller.currentWeekDateTime);
                },
        ),
        buildSleepRangeChart(
          context,
          series: getWeekGradientComparisonSeries(controller.currentWeekDateTime),
        ),
        buildSleepStatSummaryGrid(
          context,
          _weekSleepStats(),
        ),
      ],
    );
  }

  List<SleepDurationStat> _weekSleepStats() => [
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

  Widget dayChartView(BuildContext context) {
    return ListView(
      children: [
        DetailDateNavigator(
          dateTitle: controller.dayDateTitle,
          isNextDisabled: controller.dayNextDisable,
          onPrevious: () async {
            final time = GlobalMethods.getOneDayBackward(controller.currentDateTime);
            controller.dayNextDisable = false;
            controller.currentDateTime = time;
            controller.update();
            await controller.setCurrentDateTitle(controller.currentDateTime);
          },
          onNext: controller.dayNextDisable
              ? null
              : () async {
                  final nextDate = GlobalMethods.getOneDayForward(controller.currentDateTime);
                  if (controller.checkNextDayAvailable(controller.todayTime, nextDate)) {
                    controller.dayNextDisable = true;
                  }
                  controller.currentDateTime = nextDate;
                  controller.update();
                  await controller.setCurrentDateTitle(controller.currentDateTime);
                },
        ),
        const SizedBox(
          height: 4.0,
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0, right: 2.0),
                child: Text(controller.dayTotalHours, textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 21.0)),
              ),
              const Text('h', textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0)),
              Padding(
                padding: const EdgeInsets.only(left: 4.0, top: 8.0, bottom: 8.0, right: 2.0),
                child: Text(controller.dayTotalMin, textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 21.0)),
              ),
              const Text('m', textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0)),
            ],
          ),
        ),
        const SizedBox(
          height: 4.0,
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 12.0,
                child: VerticalDivider(
                  thickness: 1.0,
                  color: Colors.grey,
                ),
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
                child: VerticalDivider(
                  thickness: 1.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(left:6.0),
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(textBegin,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0)),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('${controller.dayBeginHours}:${controller.dayBeginMin}', textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0)),
                          
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right:16.0),
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(textEnd,
                          textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0)),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('${controller.dayEndHours}:${controller.dayEndMin}', textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0)),
                          
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Divider(
            color: Colors.grey[500],
            height: 3.0,
          ),
        ),
        const SizedBox(
          height: 4.0,
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
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
                              decoration: const BoxDecoration(
                                  color: deepColor,
                                  shape: BoxShape.rectangle
                              ),
                              height: 12,
                              width: 12,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Text(textDeep,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0)),
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
                          Text('${controller.dayDeepHours} ', textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
                          const Text('h', textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                          Text('${controller.dayDeepMin} ', textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
                          const Text('m', textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                          
                        ],
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
                              decoration: const BoxDecoration(
                                  color: lightColor,
                                  shape: BoxShape.rectangle
                              ),
                              height: 12,
                              width: 12,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Text(textLight,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0)),
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
                          Text('${controller.dayLightHours} ', textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
                          const Text('h', textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                          Text('${controller.dayLightMin} ', textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
                          const Text('m', textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                          
                        ],
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
                              decoration: const BoxDecoration(
                                  color: awakeColor,
                                  shape: BoxShape.rectangle
                              ),
                              height: 12,
                              width: 12,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Text(textAwake,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14.0)),
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
                          Text('${controller.dayAwakeHours} ', textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
                          const Text('h', textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                          Text('${controller.dayAwakeMin} ', textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
                          const Text('m', textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                          
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 21.0,
        ),
        const Center(
          child: Text(textSleepQualityAnalysis,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18
            ),
          ),
        ),
        const SizedBox(
          height: 21.0,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(textSleepNotLate,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            sleepToLateString,
            textAlign: TextAlign.justify,
            style: TextStyle(
                fontSize: 14
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(textSleepLake,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            sleepLackString,
            textAlign: TextAlign.justify,
            style: TextStyle(
                fontSize: 14
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(textSleepWakeEarly,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            sleepEarlyWakeUpString,
            textAlign: TextAlign.justify,
            style: TextStyle(
                fontSize: 14
            ),
          ),
        ),
        
        SizedBox(height: MediaQuery.paddingOf(Get.context!).bottom + 12),
      ],
    );
  }

  List<RangeColumnSeries<WeeklySleepData, String>> getWeekGradientComparisonSeries(List<DateTime> currentWeekDateTime) {
    return <RangeColumnSeries<WeeklySleepData, String>>[
      RangeColumnSeries<WeeklySleepData, String>(
        dataSource: controller.weekSleepDataList,
        xValueMapper: (WeeklySleepData sales, _) => sales.weekName,
        lowValueMapper: (WeeklySleepData sales, _) => sales.startTimeNum,
        highValueMapper: (WeeklySleepData sales, _) => sales.endTimeNum,
        borderRadius: BorderRadius.circular(8.0),
        color: sleepLightColor,
        width: controller.weekSleepDataList.length <= 4 ? 0.2 : 0.5,
        
        
      )
    ];
  }

  List<RangeColumnSeries<MonthlySleepData, num>> getMonthlySeriesDataList(List<DateTime> currentMonthDateTime) {
    return <RangeColumnSeries<MonthlySleepData, num>>[
      RangeColumnSeries<MonthlySleepData, num>(
          dataSource: controller.monthSleepDataList,
          xValueMapper: (MonthlySleepData sales, _) => sales.dayNumber,
          lowValueMapper: (MonthlySleepData sales, _) => sales.startTimeNum,
          highValueMapper: (MonthlySleepData sales, _) => sales.endTimeNum,
          borderRadius: BorderRadius.circular(8.0),
          pointColorMapper: (MonthlySleepData datum, _) => datum.color,
          width: 0.5
      )
    ];
  }
}
