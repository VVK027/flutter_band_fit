import 'package:flutter_band_fit_app/core/exports/vitals_imports.dart';
import 'package:flutter_band_fit_app/features/vitals/domain/repositories/vitals_data_repository.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/mixins/vital_detail_date_mixin.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/mixins/vitals_storage_ready_mixin.dart';

class HeartRateDetailController extends GetxController
    with VitalDetailDateMixin, VitalsStorageReadyMixin {
  HeartRateDetailController({
    required this.displayTitle,
    required this.activityLabel,
  });

  final String displayTitle;
  final String activityLabel;

  final VitalsDataRepository _vitalsDataRepository = Get.find<VitalsDataRepository>();

  late final TooltipBehavior tooltipBehavior;

  dynamic hr24Data;
  final chartPoints = <CommonDataResult>[].obs;

  final avgHeartRate = '--'.obs;
  final maxHeartRate = '--'.obs;
  final minHeartRate = '--'.obs;
  final currentMainHeartRate = '--'.obs;

  @override
  void onInit() {
    super.onInit();
    tooltipBehavior = TooltipBehavior(enable: true, canShowMarker: false);
    syncSelectedDay(todayTime);
    listenForLocalVitalsDataReady(() => loadDay(currentDateTime.value));
  }

  @override
  void onClose() {
    disposeVitalsStorageReadyListener();
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await loadDay(todayTime);
  }

  void _reloadStoredData() {
    final hrData = _vitalsDataRepository.getOverAllHrData();
    if (hrData.isEmpty) {
      hr24Data = null;
      return;
    }
    hr24Data = jsonDecode(hrData.toString());
  }

  Future<void> loadDay(DateTime dateTime) async {
    syncSelectedDay(dateTime);
    _reloadStoredData();
    try {
      final calender = GlobalMethods.convertBandReadableCalender(dateTime);
      if (hr24Data == null) {
        _clearChart();
        return;
      }
      final smartHr24List =
          await _vitalsDataRepository.getCurrentDayHRData(hr24Data, calender);
      if (smartHr24List.isEmpty) {
        _clearChart();
        return;
      }

      final dataRepList = <CommonDataResult>[];
      var sumOfDataPoints = 0.0;
      var largestValue = double.tryParse(smartHr24List[0].rate)!;
      var smallestValue = largestValue;
      final currentValue = smartHr24List.last.rate;

      for (final element in smartHr24List) {
        final times = element.time.split(':');
        final pointTime = DateTime(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          int.tryParse(times[0])!,
          int.tryParse(times[1])!,
        );
        final dataPoint = double.tryParse(element.rate)!;
        if (dataPoint > largestValue) largestValue = dataPoint;
        if (dataPoint < smallestValue) smallestValue = dataPoint;
        sumOfDataPoints += dataPoint;
        dataRepList.add(
          CommonDataResult(
            time: pointTime,
            dataPoint: dataPoint,
            color: heartRateColor,
          ),
        );
      }

      final average = sumOfDataPoints / smartHr24List.length;
      _applyStats(
        currentValue,
        average.toInt().toString(),
        largestValue.toInt().toString(),
        smallestValue.toInt().toString(),
      );
      chartPoints.assignAll(dataRepList);
    } catch (e) {
      debugPrint('HeartRateDetailController.loadDay>> $e');
      _clearChart();
    }
  }

  void _applyStats(
    String current,
    String average,
    String largest,
    String smallest,
  ) {
    currentMainHeartRate.value = current;
    avgHeartRate.value = average;
    maxHeartRate.value = largest;
    minHeartRate.value = smallest;
  }

  void _clearChart() {
    chartPoints.clear();
    _applyStats('--', '--', '--', '--');
  }

  List<LineSeries<CommonDataResult, DateTime>> buildSeries(DateTime day) {
    return [
      LineSeries<CommonDataResult, DateTime>(
        name: day.toString().substring(0, 10),
        dataSource: chartPoints,
        xValueMapper: (CommonDataResult x, _) => x.time,
        yValueMapper: (CommonDataResult sales, _) => sales.dataPoint,
        color: heartRateColor,
      ),
    ];
  }
}
