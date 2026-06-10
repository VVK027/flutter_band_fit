import 'package:flutter_band_fit_app/core/exports/vitals_imports.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/mixins/ble_test_listener_mixin.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/mixins/vital_detail_date_mixin.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/mixins/vital_measurement_loading_mixin.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/mixins/vital_measurement_result_mixin.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/mixins/vitals_storage_ready_mixin.dart';

class TemperatureDetailController extends GetxController
    with
        VitalDetailDateMixin,
        BleTestListenerMixin,
        VitalsStorageReadyMixin,
        VitalMeasurementLoadingMixin,
        VitalMeasurementResultMixin {
  TemperatureDetailController({
    required this.displayTitle,
    required this.activityLabel,
  });

  final String displayTitle;
  final String activityLabel;

  late final TooltipBehavior tooltipBehavior;

  List<dynamic> temperatureData = [];
  final chartPoints = <CommonDataResult>[].obs;

  final avgTemperature = '--'.obs;
  final maxTemperature = '--'.obs;
  final minTemperature = '--'.obs;
  final recentTemperature = '--'.obs;

  final tempUnits = ''.obs;
  bool isTempCelsius = false;
  bool statusReconnected = false;

  @override
  void onInit() {
    super.onInit();
    isTempCelsius = bleProvider.getIsCelsius;
    tempUnits.value = isTempCelsius ? tempInCelsius : tempInFahrenheit;
    tooltipBehavior = TooltipBehavior(enable: true, canShowMarker: false);
    _listenResults();
    syncSelectedDay(todayTime);
    listenForLocalVitalsDataReady(() => loadDay(currentDateTime.value));
  }

  @override
  void onClose() {
    endTestLoading();
    disposeVitalsStorageReadyListener();
    bleProvider.cancelBPEvents();
    bleProvider.resumeEventListeners();
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
    final tempData = bleProvider.getOverAllTempData;
    if (tempData.isEmpty) {
      temperatureData = [];
      return;
    }
    temperatureData = jsonDecode(tempData.toString()) as List;
  }

  void _listenResults() {
    bleProvider.pauseEventListeners();
    bleProvider.receiveBPListeners(
      onDataUpdate: (data) async {
        final eventData = JsonUtils.asMap(jsonDecode(data as String));
        final result = eventData['result'].toString();
        final status = eventData['status'].toString();
        final jsonData = eventData['data'];

        if (result == BandFitConstants.DEVICE_CONNECTED) {
          if (status == BandFitConstants.SC_SUCCESS && statusReconnected) {
            GlobalMethods.navigatePopBack();
            await startTemperatureTest();
          }
        } else if (result == BandFitConstants.TEMP_RESULT) {
          if (status == BandFitConstants.SC_SUCCESS && jsonData != null) {
            await updateTemperatureData(jsonData);
          }
        } else if (result == BandFitConstants.TEMP_TEST_TIME_OUT) {
          if (status == BandFitConstants.SC_SUCCESS) {
            endTestLoading();
          }
        }
      },
      onError: (error) => debugPrintI('receiveTemperatureListenersError>> $error'),
      onDone: () {},
    );
    bleProvider.resumeBPListeners();
  }

  Future<void> loadDay(DateTime inputDateTime) async {
    syncSelectedDay(inputDateTime);
    _reloadStoredData();
    try {
      final calender = GlobalMethods.convertBandReadableCalender(inputDateTime);
      final smartTempList = await bleProvider.getCurrentDayTemperatureData(
        temperatureData,
        calender,
      );
      if (smartTempList.isEmpty) {
        _clearChart();
        return;
      }

      final dataRepList = <CommonDataResult>[];
      var sumOfDataPoints = 0.0;
      var largestValue = isTempCelsius
          ? double.tryParse(smartTempList[0].inCelsius)!
          : double.tryParse(smartTempList[0].inFahrenheit)!;
      var smallestValue = largestValue;
      final currentValue = isTempCelsius
          ? smartTempList.last.inCelsius
          : smartTempList.last.inFahrenheit;

      for (final element in smartTempList) {
        final pointTime = parseVitalPointTime(inputDateTime, element.time);
        final dataPoint = isTempCelsius
            ? double.tryParse(element.inCelsius)!
            : double.tryParse(element.inFahrenheit)!;
        if (dataPoint > largestValue) largestValue = dataPoint;
        if (dataPoint < smallestValue) smallestValue = dataPoint;
        sumOfDataPoints += dataPoint;
        dataRepList.add(
          CommonDataResult(
            time: pointTime,
            dataPoint: dataPoint,
            color: temperatureColor,
          ),
        );
      }

      final average = sumOfDataPoints / smartTempList.length;
      chartPoints.assignAll(dataRepList);
      recentTemperature.value = double.tryParse(currentValue)!.toStringAsFixed(1);
      avgTemperature.value = average.toStringAsFixed(1);
      minTemperature.value = smallestValue.toStringAsFixed(1);
      maxTemperature.value = largestValue.toStringAsFixed(1);
    } catch (e) {
      debugPrintI('TemperatureDetailController.loadDay>> $e');
      _clearChart();
    }
  }

  void _clearChart() {
    chartPoints.clear();
    recentTemperature.value = '--';
    avgTemperature.value = '--';
    minTemperature.value = '--';
    maxTemperature.value = '--';
  }

  Future<void> updateTemperatureData(dynamic jsonData) async {
    if (jsonData == null) {
      endTestLoading();
      return;
    }

    final reading = Map<String, dynamic>.from(jsonData as Map);
    _reloadStoredData();
    if (!mapAlreadyContainsReading(temperatureData, reading)) {
      temperatureData.add(reading);
    }
    await bleProvider.updateTemperatureWithData(
      reading,
      temperatureData,
      DateTime.now(),
    );
    await refreshTodayAfterReading(loadDay);
    endTestLoading();
  }

  Future<void> startTemperatureTest() async {
    beginTestLoading();
    try {
      final status = await bleProvider.startTestTempData();
      final ctx = Get.context;
      if (ctx == null) {
        endTestLoading();
        return;
      }
      if (status == BandFitConstants.SC_NOT_SUPPORTED) {
        endTestLoading();
        if(ctx.mounted) {
          temperatureNotSupported(ctx);
        }
      }
    } catch (e) {
      endTestLoading();
      rethrow;
    }
  }

  void temperatureNotSupported(BuildContext context) {
    GlobalMethods.showAlertDialogWithFunction(
      context,
      textTempNotSupported,
      textTempNotSupportedMsg,
      okText,
      () async {},
    );
  }

  Future<void> onStartTest(BuildContext context) async {
    final isConnected = await bleProvider.checkIsDeviceConnected();
    if (!context.mounted) return;
    if (isConnected) {
      await startTemperatureTest();
    } else {
      retryDeviceConnection(
        (reconnected) => statusReconnected = reconnected,
        onReconnected: startTemperatureTest,
      );
    }
  }

  List<ColumnSeries<CommonDataResult, DateTime>> buildSeries(DateTime day) {
    return [
      ColumnSeries<CommonDataResult, DateTime>(
        name: day.toString().substring(0, 10),
        dataSource: chartPoints,
        xValueMapper: (CommonDataResult x, _) => x.time,
        yValueMapper: (CommonDataResult sales, _) => sales.dataPoint,
        color: temperatureColor,
        width: 0.03,
      ),
    ];
  }
}
