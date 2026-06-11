import 'package:flutter_band_fit_app/core/exports/vitals_controller_imports.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/mixins/ble_test_listener_mixin.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/mixins/vital_detail_date_mixin.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/mixins/vital_measurement_loading_mixin.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/mixins/vital_measurement_result_mixin.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/mixins/vitals_storage_ready_mixin.dart';

class BloodPressureDetailController extends GetxController
    with
        VitalDetailDateMixin,
        BleTestListenerMixin,
        VitalsStorageReadyMixin,
        VitalMeasurementLoadingMixin,
        VitalMeasurementResultMixin {
  BloodPressureDetailController({
    required this.displayTitle,
    required this.activityLabel,
  });

  final String displayTitle;
  final String activityLabel;

  final bpDataList = <BPData>[].obs;
  final highBPValue = '--'.obs;
  final lowBPValue = '--'.obs;

  List<dynamic> overAllBPData = [];
  bool statusReconnected = false;
  Map<String, dynamic>? _pendingBpReading;

  @override
  void onInit() {
    super.onInit();
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
    final bpData = bleProvider.getOverAllBPData;
    if (bpData.isEmpty) {
      overAllBPData = [];
      return;
    }
    overAllBPData = jsonDecode(bpData.toString()) as List;
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
            await startBPTest();
          }
        } else if (result == BandFitConstants.BP_TEST_FINISHED) {
          await _finalizeBpTest();
        } else if (result == BandFitConstants.BP_TEST_TIME_OUT ||
            result == BandFitConstants.BP_TEST_ERROR) {
          _pendingBpReading = null;
          endTestLoading();
        } else if (result == BandFitConstants.BP_RESULT) {
          if (status == BandFitConstants.SC_SUCCESS && jsonData != null) {
            final dataMap = JsonUtils.asMap(jsonData as Map);
            final high = dataMap['high']?.toString() ?? '';
            final low = dataMap['low']?.toString() ?? '';
            final time = dataMap['time']?.toString() ?? '';
            if (isTestRunning.value) {
              _handleLiveBpReading(high, low, time);
              if (_isFinalBpResult(dataMap)) {
                await _finalizeBpTest();
              }
            } else {
              await persistBpReading(high, low, time);
            }
          }
        }
      },
      onError: (error) => debugPrintI('receiveBPListenersError>> $error'),
      onDone: () {},
    );
    bleProvider.resumeBPListeners();
  }

  /// Android reports status `4` on [BandFitConstants.BP_RESULT] when the live
  /// test completes; iOS still relies on [BandFitConstants.BP_TEST_FINISHED].
  bool _isFinalBpResult(Map<String, dynamic> data) {
    return data['status']?.toString() == BandFitConstants.BP_RESULT_STATUS_COMPLETE;
  }

  void _handleLiveBpReading(String high, String low, String time) {
    if (!isValidBpReading(high, low)) {
      return;
    }
    _pendingBpReading = {
      'high': high,
      'low': low,
      'time': time,
    };
    if (highBPValue.value != high) {
      highBPValue.value = high;
    }
    if (lowBPValue.value != low) {
      lowBPValue.value = low;
    }
  }

  Future<void> _finalizeBpTest() async {
    if (_pendingBpReading != null) {
      final reading = _pendingBpReading!;
      _pendingBpReading = null;
      await persistBpReading(
        reading['high']!.toString(),
        reading['low']!.toString(),
        reading['time']?.toString() ?? '',
      );
    } else {
      await refreshTodayAfterReading(loadDay);
    }
    endTestLoading();
  }

  Future<void> loadDay(DateTime dateTime) async {
    syncSelectedDay(dateTime);
    _reloadStoredData();
    try {
      final calender = GlobalMethods.convertBandReadableCalender(dateTime);
      final smartBPModelList =
          await bleProvider.getCurrentDayBPData(overAllBPData, calender);
      if (smartBPModelList.isEmpty) {
        bpDataList.clear();
        highBPValue.value = '--';
        lowBPValue.value = '--';
        return;
      }

      final highPressure = smartBPModelList.last.high;
      final lowPressure = smartBPModelList.last.low;
      final bpDataRepList = <BPData>[];

      for (final element in smartBPModelList) {
        final pointTime = parseVitalPointTime(dateTime, element.time);
        bpDataRepList.add(
          BPData(
            highPressure: element.high,
            lowPressure: element.low,
            time: pointTime,
          ),
        );
      }

      bpDataList.assignAll(bpDataRepList);
      highBPValue.value = highPressure;
      lowBPValue.value = lowPressure;
    } catch (e) {
      debugPrintI('BloodPressureDetailController.loadDay>> $e');
      bpDataList.clear();
      highBPValue.value = '--';
      lowBPValue.value = '--';
    }
  }

  Future<void> persistBpReading(String high, String low, String time) async {
    if (!isValidBpReading(high, low)) {
      return;
    }

    final dateTime = DateTime.now();
    final calender = GlobalMethods.convertBandReadableCalender(dateTime);
    final timeMin = time.isNotEmpty
        ? time
        : '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';

    final addData = {
      'calender': calender,
      'time': Platform.isAndroid ? timeMin : time,
      'high': high,
      'low': low,
    };

    _reloadStoredData();
    if (mapAlreadyContainsReading(overAllBPData, addData)) {
      return;
    }

    overAllBPData.add(addData);
    await bleProvider.updateBPressureData(
      high,
      low,
      calender,
      timeMin,
      overAllBPData,
    );
    await refreshTodayAfterReading(loadDay);
  }

  Future<void> startBPTest() async {
    _pendingBpReading = null;
    beginTestLoading();
    try {
      await bleProvider.startBloodPressure();
    } catch (e) {
      endTestLoading();
      rethrow;
    }
  }

  Future<void> onStartTest(BuildContext context) async {
    final isConnected = await bleProvider.checkIsDeviceConnected();
    if (!context.mounted) return;
    if (isConnected) {
      await startBPTest();
    } else {
      retryDeviceConnection(
        (reconnected) => statusReconnected = reconnected,
        onReconnected: startBPTest,
      );
    }
  }

  List<RangeColumnSeries<BPData, DateTime>> buildSeries(DateTime day) {
    return [
      RangeColumnSeries<BPData, DateTime>(
        dataSource: bpDataList,
        xValueMapper: (BPData datum, _) => datum.time,
        lowValueMapper: (BPData datum, _) => int.parse(datum.lowPressure),
        highValueMapper: (BPData datum, _) => int.parse(datum.highPressure),
        color: bpColor,
        markerSettings: const MarkerSettings(color: Colors.black, width: 1),
        width: 0.1,
      ),
    ];
  }
}
