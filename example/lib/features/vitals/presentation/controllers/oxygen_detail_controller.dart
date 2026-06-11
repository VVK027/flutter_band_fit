import 'package:flutter_band_fit_app/core/exports/vitals_imports.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/mixins/ble_test_listener_mixin.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/mixins/vital_detail_date_mixin.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/mixins/vital_measurement_loading_mixin.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/mixins/vital_measurement_result_mixin.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/mixins/vitals_storage_ready_mixin.dart';

class OxygenDetailController extends GetxController
    with
        VitalDetailDateMixin,
        BleTestListenerMixin,
        VitalsStorageReadyMixin,
        VitalMeasurementLoadingMixin,
        VitalMeasurementResultMixin {
  OxygenDetailController({
    required this.displayTitle,
    required this.activityLabel,
  });

  final String displayTitle;
  final String activityLabel;

  late final TooltipBehavior tooltipBehavior;

  dynamic oxygenData;
  final chartPoints = <CommonDataResult>[].obs;

  final maxOxygenValue = '--'.obs;
  final minOxygenValue = '--'.obs;
  final currentOxygen = '--'.obs;

  bool statusReconnected = false;
  Map<String, dynamic> oxyJsonData = <String, dynamic>{};

  @override
  void onInit() {
    super.onInit();
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
    final oxyData = bleProvider.getOverAllOxygenData;
    if (oxyData.isEmpty) {
      oxygenData = null;
      return;
    }
    oxygenData = jsonDecode(oxyData.toString());
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
            await startOxygenTest();
          }
        } else if (result == BandFitConstants.OXYGEN_TEST_FINISHED) {
          endTestLoading();
        } else if (result == BandFitConstants.OXYGEN_TEST_TIME_OUT ||
            result == BandFitConstants.OXYGEN_TEST_ERROR) {
          endTestLoading();
        } else if (result == BandFitConstants.OXYGEN_RESULT) {
          if (status == BandFitConstants.SC_SUCCESS) {
            oxyJsonData = Map<String, dynamic>.from(jsonData as Map);
            await updateOxygenData(oxyJsonData);
          }
        }
      },
      onError: (error) => debugPrintI('receiveOxyListenersError>> $error'),
      onDone: () {},
    );
    bleProvider.resumeBPListeners();
  }

  Future<void> updateOxygenData(dynamic addData) async {
    if (addData is! Map || addData.isEmpty) {
      endTestLoading();
      return;
    }

    final reading = Map<String, dynamic>.from(addData);
    _reloadStoredData();
    oxygenData ??= <dynamic>[];

    if (!mapAlreadyContainsReading(JsonUtils.asList(oxygenData), reading)) {
      oxygenData.add(reading);
    }

    await bleProvider.updateOxygenSyncSDKData(oxygenData);
    await refreshTodayAfterReading(loadDay);
    endTestLoading();
  }

  Future<void> loadDay(DateTime dateTime) async {
    syncSelectedDay(dateTime);
    _reloadStoredData();
    try {
      final calender = GlobalMethods.convertBandReadableCalender(dateTime);
      if (oxygenData == null) {
        _clearChart();
        return;
      }
      final smartOxygenList =
          await bleProvider.getCurrentDayOxygenData(oxygenData, calender);
      if (smartOxygenList.isEmpty) {
        _clearChart();
        return;
      }

      final dataRepList = <CommonDataResult>[];
      //var sumOfDataPoints = 0.0;
      var largestValue = double.parse(smartOxygenList[0].value);
      var smallestValue = largestValue;
      final currentValue = smartOxygenList.last.value;

      for (final element in smartOxygenList) {
        final pointTime = parseVitalPointTime(dateTime, element.time);
        final dataPoint = double.parse(element.value);
        if (dataPoint > largestValue) largestValue = dataPoint;
        if (dataPoint < smallestValue) smallestValue = dataPoint;
        // sumOfDataPoints += dataPoint;
        dataRepList.add(
          CommonDataResult(
            time: pointTime,
            dataPoint: dataPoint,
            color: oxygenColorLight,
          ),
        );
      }

      //final average = sumOfDataPoints / smartOxygenList.length;
      currentOxygen.value = currentValue;
      maxOxygenValue.value = largestValue.toInt().toString();
      minOxygenValue.value = smallestValue.toInt().toString();
      chartPoints.assignAll(dataRepList);
    } catch (e) {
      debugPrintI('OxygenDetailController.loadDay>> $e');
      _clearChart();
    }
  }

  void _clearChart() {
    chartPoints.clear();
    currentOxygen.value = '--';
    maxOxygenValue.value = '--';
    minOxygenValue.value = '--';
  }

  Future<void> startOxygenTest() async {
    beginTestLoading();
    try {
      await bleProvider.startOxygenTest();
    } catch (e) {
      endTestLoading();
      rethrow;
    }
  }

  Future<void> onStartTest(BuildContext context) async {
    final isConnected = await bleProvider.checkIsDeviceConnected();
    if (!context.mounted) return;
    if (isConnected) {
      await startOxygenTest();
    } else {
      retryDeviceConnection(
        (reconnected) => statusReconnected = reconnected,
        onReconnected: startOxygenTest,
      );
    }
  }

  List<LineSeries<CommonDataResult, DateTime>> buildSeries(DateTime day) {
    return [
      LineSeries<CommonDataResult, DateTime>(
        name: day.toString().substring(0, 10),
        dataSource: chartPoints,
        xValueMapper: (CommonDataResult x, _) => x.time,
        yValueMapper: (CommonDataResult sales, _) => sales.dataPoint,
        color: oxygenColorLight,
        markerSettings: const MarkerSettings(isVisible: true),
      ),
    ];
  }
}
