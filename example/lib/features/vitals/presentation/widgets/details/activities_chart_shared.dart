import 'package:flutter_band_fit_app/core/exports/vitals_imports.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/activities_details_controller.dart';

TextStyle activitiesChartAxisLabelStyle(BuildContext context) => TextStyle(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: 12,
    );

DataLabelSettings activitiesChartDataLabelSettings(BuildContext context) =>
    DataLabelSettings(
      isVisible: true,
      offset: const Offset(0, -5),
      textStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
    );

TextStyle activitiesSummaryLabelStyle(BuildContext context) =>
    Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ) ??
    const TextStyle(fontWeight: FontWeight.w600, fontSize: 18);

TextStyle activitiesSummaryValueStyle(BuildContext context) =>
    Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ) ??
    const TextStyle(fontWeight: FontWeight.w400, fontSize: 16);

EdgeInsets activitiesListBottomPadding(BuildContext context) =>
    EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom + 12);

List<ColumnSeries<CommonDataResult, DateTime>> activitiesDaySeries(
  ActivitiesDetailsController controller,
  DateTime currentDateTime,
) {
  return [
    ColumnSeries<CommonDataResult, DateTime>(
      name: currentDateTime.toString().substring(0, 10),
      dataSource: controller.stepsDayDataList,
      xValueMapper: (CommonDataResult x, int xx) => x.time,
      yValueMapper: (CommonDataResult sales, _) => sales.dataPoint,
      color: darkStepsColor,
      width: controller.stepsDayDataList.length <= 4 ? 0.15 : 0.5,
    ),
  ];
}

List<CartesianSeries<WeekStepsData, String>> activitiesWeekSeries(
  BuildContext context,
  ActivitiesDetailsController controller,
  List<DateTime> currentWeekDateTime,
) {
  return <CartesianSeries<WeekStepsData, String>>[
    ColumnSeries<WeekStepsData, String>(
      xValueMapper: (WeekStepsData sales, _) => sales.weekName,
      yValueMapper: (WeekStepsData sales, _) => sales.dataPoint,
      dataLabelMapper: (datum, index) =>
          '${datum.dateTime.day.toString().padLeft(2, '0')}-${datum.dateTime.month.toString().padLeft(2, '0')}',
      width: controller.weekStepsDataList.length <= 4 ? 0.2 : 0.5,
      dataSource: controller.weekStepsDataList,
      color: darkStepsColor,
      dataLabelSettings: activitiesChartDataLabelSettings(context),
    ),
  ];
}

List<ColumnSeries<MonthStepsData, num>> activitiesMonthSeries(
  BuildContext context,
  ActivitiesDetailsController controller,
  List<DateTime> currentMonthDateTime,
) {
  return <ColumnSeries<MonthStepsData, num>>[
    ColumnSeries<MonthStepsData, num>(
      dataSource: controller.monthStepsDataList,
      xValueMapper: (MonthStepsData sales, _) => sales.dayNumber,
      yValueMapper: (MonthStepsData sales, _) => sales.dataPoint,
      pointColorMapper: (MonthStepsData datum, _) => datum.color,
      width: 0.5,
    ),
  ];
}
