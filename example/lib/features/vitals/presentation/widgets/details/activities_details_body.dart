import 'package:flutter_band_fit_app/core/exports/vitals_imports.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/activities_details_controller.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/widgets/details/activities_detail_ui.dart';
import 'package:intl/intl.dart';

class ActivitiesDetailsBody extends GetView<ActivitiesDetailsController> {
  const ActivitiesDetailsBody({super.key});

  TextStyle _chartAxisLabelStyle(BuildContext context) => TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 12,
      );

  DataLabelSettings _chartDataLabelSettings(BuildContext context) =>
      DataLabelSettings(
        isVisible: true,
        offset: const Offset(0, -5),
        textStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      );

  TextStyle _summaryLabelStyle(BuildContext context) =>
      Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ) ??
      const TextStyle(fontWeight: FontWeight.w600, fontSize: 18);

  TextStyle _summaryValueStyle(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ) ??
      const TextStyle(fontWeight: FontWeight.w400, fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return VitalTabDetailScaffold(
      title: textPhysicalActivities,
      accentColor: darkStepsColor,
      onBack: () => Get.back<void>(),
      onTabTap: (index) {
        controller.selectedPage = index;
        controller.update();
      },
      tabs: buildDWMTabs(),
      tabViewPhysics: const NeverScrollableScrollPhysics(),
      header: DetailActivityHeader(label: controller.activityLabel),
      tabViews: [
        dayChartView(context),
        weekChartView(context),
        monthlyChartView(context),
      ],
    );
  }

  EdgeInsets _listBottomPadding(BuildContext context) =>
      EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom + 12);

  Widget monthlyChartView(BuildContext context) {
    return SingleChildScrollView(
      padding: _listBottomPadding(Get.context!),
      child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 18,
                onPressed: () async {
                  // debugPrint('date time>> ${controller.currentMonthDateTime[0]}');
                  // Utils.showWaiting(context, false);
                  DateTime time = GlobalMethods.getOneDayBackward(controller.currentMonthDateTime[0]);
                  List<DateTime> pastNextMonth = await GlobalMethods.getMonthyDatesListByTime(time);

                  controller.monthNextDisable = false;
                    controller.currentMonthDateTime = pastNextMonth;
    controller.update();
                  await controller.setMonthDateTitle(controller.currentMonthDateTime);
                  // GlobalMethods.navigatePopBack();
                },
                icon: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    controller.monthlyDateTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              IconButton(
                iconSize: 18,
                onPressed: controller.monthNextDisable ? null : () async {
                  //Utils.showWaiting(context, false);
                  DateTime time = GlobalMethods.getOneDayForward(controller.currentMonthDateTime[controller.currentMonthDateTime.length-1]);
                  List<DateTime> nextMonth = await GlobalMethods.getMonthyDatesListByTime(time);

                  controller.currentMonthDateTime = nextMonth;
                    // if the today time is in the list then disable.
                    if(controller.checkNextMonthAvailable(controller.todayTime, controller.currentMonthDateTime))
                    {
                      controller.monthNextDisable = true;
                    }
    controller.update();                  await controller.setMonthDateTitle(controller.currentMonthDateTime);
                  //Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: controller.monthNextDisable
                      ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.35)
                      : Theme.of(context).colorScheme.onSurface,
                ),
              )
            ],
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
          padding: const EdgeInsets.all(4.0),
          width: double.infinity,
          height: 180,
          child: SfCartesianChart(
            key: ValueKey(
              'steps-month-${controller.monthStepsDataList.length}-'
              '${controller.monthTotalSteps}',
            ),
            plotAreaBorderWidth: 0,
            onSelectionChanged: (selectionArgs) {
              debugPrint('selectionArgs>> $selectionArgs');
            },
            primaryXAxis: CategoryAxis(
              majorGridLines: const MajorGridLines(width: 0),
              majorTickLines: const MajorTickLines(size: 4),
              interval: 2,
              labelIntersectAction: AxisLabelIntersectAction.rotate90,
              labelStyle: _chartAxisLabelStyle(context),
            ),
            /* primaryXAxis: NumericAxis(
              majorGridLines: const MajorGridLines(width: 0),
              interval: 1
            ),*/
            /* primaryXAxis: DateTimeCategoryAxis(
              majorGridLines: const MajorGridLines(width: 0),
              majorTickLines: const MajorTickLines(size: 4),
              dateFormat: DateFormat('dd'),
             interval: 1
             // labelIntersectAction: AxisLabelIntersectAction.wrap,

            ),*/
            primaryYAxis: NumericAxis(
              majorTickLines: const MajorTickLines(color: Colors.transparent),
              minimum: 0,
              axisLine: const AxisLine(width: 0),
              labelFormat: '{value}',
              labelStyle: _chartAxisLabelStyle(context),
            ),

            series: getMonthlySeriesDataList(context, controller.currentMonthDateTime),
            tooltipBehavior: controller.tooltipWeekBehavior,
            trackballBehavior: TrackballBehavior(
                enable: true,
                markerSettings: const TrackballMarkerSettings(
                  markerVisibility: TrackballVisibilityMode.hidden,
                  // markerVisibility: _showMarker
                  //     ? TrackballVisibilityMode.visible // to show always
                  //     : TrackballVisibilityMode.hidden,
                  height: 10,
                  width: 10,
                  borderWidth: 1,
                ),
                hideDelay: 1.0 * 1000,
                // hide delay 2 secs
                activationMode: ActivationMode.singleTap,
                tooltipAlignment: ChartAlignment.near,
                tooltipDisplayMode: TrackballDisplayMode.floatAllPoints,
                tooltipSettings: const InteractiveTooltip(
                    format: null,
                    // format: _mode != TrackballDisplayMode.groupAllPoints
                    //     ? 'series.name : point.y'
                    //     : null,
                    canShowMarker: false),
                shouldAlwaysShow: false,
                lineWidth: 0
            ),
          ),
        ),
        buildActivityStatSummaryGrid(
          context,
          [
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
    );
  }

  Widget weekChartView(BuildContext context) {
    return SingleChildScrollView(
      padding: _listBottomPadding(Get.context!),
      child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 18,
                onPressed: () async {
                  // debugPrint('date time>> ${controller.currentWeekDateTime[0]}');
                  //Utils.showWaiting(context, false);
                  DateTime time = GlobalMethods.getOneDayBackward(controller.currentWeekDateTime[0]);
                  List<DateTime> pastNextWeek = await GlobalMethods.getWeekDatesListByTime(time);

                  controller.weekNextDisable = false;
                  controller.currentWeekDateTime = pastNextWeek;
                  controller.update();
                  await controller.setWeekDateTitle(controller.currentWeekDateTime);
                  // GlobalMethods.navigatePopBack();
                },
                icon: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    controller.weekDateTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              IconButton(
                iconSize: 18,
                onPressed: controller.weekNextDisable ? null : () async {

                  //Utils.showWaiting(context, false);
                  DateTime time = GlobalMethods.getOneDayForward(controller.currentWeekDateTime[controller.currentWeekDateTime.length-1]);
                  List<DateTime> nextWeek = await GlobalMethods.getWeekDatesListByTime(time);

                  controller.currentWeekDateTime = nextWeek;
                    // if the today time is in the list then disable.
                    if(controller.checkNextWeekAvailable(controller.todayTime, controller.currentWeekDateTime))
                    {
                      controller.weekNextDisable = true;
                    }
    controller.update();                  await controller.setWeekDateTitle(controller.currentWeekDateTime);
                  // GlobalMethods.navigatePopBack();
                },
                icon: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: controller.weekNextDisable
                      ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.35)
                      : Theme.of(context).colorScheme.onSurface,
                ),
              )
            ],
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
          padding: const EdgeInsets.all(4.0),
          width: double.infinity,
          height: 200,
          child: SfCartesianChart(
            key: ValueKey(
              'steps-week-${controller.weekStepsDataList.length}-'
              '${controller.weekTotalSteps}',
            ),
            plotAreaBorderWidth: 0,
            primaryXAxis: CategoryAxis(
              majorGridLines: const MajorGridLines(width: 0),
              majorTickLines: const MajorTickLines(size: 4),
              labelStyle: _chartAxisLabelStyle(context),
            ),
            primaryYAxis: NumericAxis(
              majorTickLines: const MajorTickLines(color: Colors.transparent),
              labelFormat: '{value}',
              minimum: 0,
              axisLine: const AxisLine(width: 0),
              labelStyle: _chartAxisLabelStyle(context),
            ),
            tooltipBehavior: controller.tooltipWeekBehavior,
            series: getWeekGradientComparisonSeries(context, controller.currentWeekDateTime),
          ),
        ),
        buildActivityStatSummaryGrid(
          context,
          [
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
    );
  }

  Widget dayChartView(BuildContext context) {
    return SingleChildScrollView(
      padding: _listBottomPadding(Get.context!),
      child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          //margin: EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
          padding: const EdgeInsets.all(2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 18,
                onPressed: () async {
                  // debugPrint('date time>> ${currentDayDateTime[0]}');
                  //Utils.showWaiting(context, false);
                  DateTime time = GlobalMethods.getOneDayBackward(controller.currentDateTime);
                  controller.dayNextDisable = false;
                  controller.currentDateTime = time;
                  await controller.setCurrentDateTitle(controller.currentDateTime);
                  controller.update();
                  // GlobalMethods.navigatePopBack();
                },
                icon: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    controller.dayDateTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              IconButton(
                iconSize: 18,
                onPressed: controller.dayNextDisable
                    ? null
                    : () async {
                  //Utils.showWaiting(context, false);
                  DateTime nextDate =
                  GlobalMethods.getOneDayForward(controller.currentDateTime);
                  if (controller.checkNextDayAvailable(controller.todayTime, nextDate)) {
                      controller.dayNextDisable = true;
                    }
                  controller.currentDateTime = nextDate;
                  await controller.setCurrentDateTitle(controller.currentDateTime);
                  controller.update();
                  // GlobalMethods.navigatePopBack();
                },
                icon: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: controller.dayNextDisable
                      ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.35)
                      : Theme.of(context).colorScheme.onSurface,
                ),
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
          padding: const EdgeInsets.all(4.0),
          width: double.infinity,
          height: 180,
          child: SfCartesianChart(
            plotAreaBorderWidth: 0,
            key: ValueKey(
              'steps-day-${controller.stepsDayDataList.length}-'
              '${controller.currentDateTime.millisecondsSinceEpoch}',
            ),
            onSelectionChanged: (selectionArgs) {
              debugPrint('selectionArgs>> $selectionArgs');
            },
            primaryXAxis: DateTimeCategoryAxis(
              majorGridLines: const MajorGridLines(width: 0),
              majorTickLines: const MajorTickLines(size: 2),
              // dateFormat: DateFormat('''h:mm\na'''),
              minimum: DateTime(controller.currentDateTime.year, controller.currentDateTime.month, controller.currentDateTime.day, 0, 0, 0),
              maximum: DateTime(controller.currentDateTime.year, controller.currentDateTime.month, controller.currentDateTime.day, 24, 0, 0),
              // labelIntersectAction: AxisLabelIntersectAction.wrap,
              // labelAlignment: LabelAlignment.center,
              // intervalType: DateTimeIntervalType.minutes,
              //labelIntersectAction: AxisLabelIntersectAction.wrap,
              intervalType: DateTimeIntervalType.minutes,
              labelAlignment: LabelAlignment.center,
              labelStyle: _chartAxisLabelStyle(context),
            ),
            primaryYAxis: NumericAxis(
              majorTickLines: const MajorTickLines(size: 2),
              minimum: 0,
              axisLine: const AxisLine(width: 0),
              labelFormat: '{value}',
              labelStyle: _chartAxisLabelStyle(context),
            ),
            series: getDaySeriesDataList(controller.currentDateTime),

            // for the default tool tip behaviour
            tooltipBehavior: controller.tooltipDayBehavior,

            /// To set the track ball as true and customized trackball behaviour.
            trackballBehavior: TrackballBehavior(
                enable: true,
                markerSettings: const TrackballMarkerSettings(
                  markerVisibility: TrackballVisibilityMode.hidden,
                  // markerVisibility: _showMarker
                  //     ? TrackballVisibilityMode.visible // to show always
                  //     : TrackballVisibilityMode.hidden,
                  height: 10,
                  width: 10,
                  borderWidth: 1,
                ),
                hideDelay: 1.0 * 1000,
                // hide delay 2 secs
                activationMode: ActivationMode.singleTap,
                tooltipAlignment: ChartAlignment.near,
                tooltipDisplayMode: TrackballDisplayMode.floatAllPoints,
                tooltipSettings: const InteractiveTooltip(
                    format: null,
                    // format: _mode != TrackballDisplayMode.groupAllPoints
                    //     ? 'series.name : point.y'
                    //     : null,
                    canShowMarker: false),
                shouldAlwaysShow: false,
                lineWidth: 0),
          ),
        ),
        const SizedBox(
          height: 2.0,
        ),
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
                      style: _summaryLabelStyle(context).copyWith(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      GlobalMethods.formatNumber(int.tryParse(controller.dayTotalSteps) ?? 0),
                      textAlign: TextAlign.center,
                      style: _summaryValueStyle(context).copyWith(fontSize: 14),
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
                    child: Text(textDistance,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16.0)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text('${controller.dayTotalDistance} km',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14.0)),
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
                    child: Text(textCalories,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16.0)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text('${controller.dayTotalCalories} kCal',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14.0)),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 2.0,
        ),
        /*Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text('Total Data (${controller.stepsDayDataList.length})'),
        ),
        SizedBox(
          height: 2.0,
        ),*/
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.stepsDayDataList.length,
            itemBuilder: (context, index) {
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
                    controller.stepsDayDataList[index].dataPoint.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(DateFormat.jm().format(controller.stepsDayDataList[index].time),
                      style: const TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 12)),
                ),
                /*child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: ListTile(
                        leading: Image.asset(
                          'assets/fit/footsteps.png',
                          width: 35.0,
                          height: 35.0,
                          fit: BoxFit.fill,
                        ),
                        title: Text(controller.stepsDayDataList[index].dataPoint.toString(),style: TextStyle(
                            fontWeight: FontWeight.bold,fontSize: 16
                        ),),
                        subtitle: Text(controller.stepsDayDataList[index].time.toString(),style: TextStyle(
                            fontWeight: FontWeight.normal,fontSize: 12)
                        ),
                      ),
                    ),
                  ],
                ),*/
              );
            },
          ),
        SizedBox(height: MediaQuery.paddingOf(Get.context!).bottom + 12),
      ],
      ),
    );
  }

  List<ColumnSeries<CommonDataResult, DateTime>> getDaySeriesDataList(DateTime currentDateTime) {
    return [
      ColumnSeries<CommonDataResult, DateTime>(
          name: currentDateTime.toString().substring(0, 10),
          dataSource: controller.stepsDayDataList,
          xValueMapper: (CommonDataResult x, int xx) => x.time,
          yValueMapper: (CommonDataResult sales, _) => sales.dataPoint,
          color: darkStepsColor,
          width: controller.stepsDayDataList.length <= 4 ? 0.15 : 0.5
        //pointColorMapper: (datum, index) =>  datum.color,
        // markerSettings: const MarkerSettings(isVisible: true),
      )
    ];
  }

  List<CartesianSeries<WeekStepsData, String>> getWeekGradientComparisonSeries(
    BuildContext context,
    List<DateTime> currentWeekDateTime,
  ) {
    return <CartesianSeries<WeekStepsData, String>>[
      ColumnSeries<WeekStepsData, String>(
        //name: currentDateTime.toString().substring(0,10),
        xValueMapper:  (WeekStepsData sales, _) => sales.weekName,
        yValueMapper:(WeekStepsData sales, _) => sales.dataPoint,
        // dataLabelMapper: (datum, index) => datum.dateTime.toString().substring(0,10),
        dataLabelMapper: (datum, index) => '${datum.dateTime.day.toString().padLeft(2,'0')}-${datum.dateTime.month.toString().padLeft(2,'0')}',
        /*onCreateShader: (ShaderDetails details) {
          return ui.Gradient.linear(
              details.rect.topCenter,
              details.rect.bottomCenter,
              const <Color>[Colors.red, Colors.orange, Colors.yellow],
              <double>[0.3, 0.6, 0.9]);
        },*/
        width: controller.weekStepsDataList.length <= 4 ? 0.2 : 0.5,
        dataSource: controller.weekStepsDataList,
        color: darkStepsColor,
        //color: ,
        dataLabelSettings: _chartDataLabelSettings(context),
      )
    ];
  }

  List<ColumnSeries<MonthStepsData, num>> getMonthlySeriesDataList(
    BuildContext context,
    List<DateTime> currentMonthDateTime,
  ) {
    return <ColumnSeries<MonthStepsData, num>>[
      ColumnSeries<MonthStepsData, num>(
        // name: tempCalenderMonth[controller.currentMonthDateTime[0].month - 1].toString().substring(0, 3),
          dataSource: controller.monthStepsDataList,
          xValueMapper: (MonthStepsData sales,  _) => sales.dayNumber,
          yValueMapper: (MonthStepsData sales, _) => sales.dataPoint,
          // color: inCompletedColor,
          pointColorMapper: (MonthStepsData datum, _) =>  datum.color,
          width: 0.5
        // markerSettings: const MarkerSettings(isVisible: true),
      )
    ];
  }

}

/*
class DayDataRep {
  final DateTime time;
  final int dataPoint;
  final Color color;
  DayDataRep({required this.time, required this.dataPoint, required this.color});
}

class WeekStepsData {
  final String weekName;
  final DateTime dateTime;
  final int dataPoint;
  final Color color;
  WeekStepsData({required this.weekName, required this.dateTime,required this.dataPoint, required this.color});
}

class MonthStepsData {
  // final String monthDateName;
  final int dayNumber;
  final int dataPoint;
  final Color color;
  MonthStepsData({required this.dayNumber, required this.dataPoint, required this.color});
}*/
