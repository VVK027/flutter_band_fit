import 'package:flutter_band_fit_app/core/exports/band_exports.dart';
import 'package:flutter_band_fit_app/core/services/activity_service_provider.dart';
import 'package:flutter_band_fit_app/features/vitals/data/models/band_data_model.dart';
import 'package:flutter_band_fit_app/features/vitals/domain/repositories/vitals_data_repository.dart';

class VitalsDataRepositoryImpl implements VitalsDataRepository {
  VitalsDataRepositoryImpl(this._provider);

  final ActivityServiceProvider _provider;

  @override
  String getOverAllHrData() => _provider.getOverAllHrData;

  @override
  String getOverAllSleepData() => _provider.getOverAllSleepData;

  @override
  String getOverAllStepsData() => _provider.getOverAllStepsData;

  @override
  String getTargetedSteps() => _provider.getTargetedSteps;

  @override
  Future<List<BandHRModel>> getCurrentDayHRData(
      dynamic hr24Data, String calender) {
    return _provider.getCurrentDayHRData(hr24Data, calender);
  }

  @override
  Future<List<SleepMainModel>> getSelectedDaySleepData(
    List<dynamic> overallSleepData,
    String calender,
  ) {
    return _provider.getSelectedDaySleepData(overallSleepData, calender);
  }

  @override
  Future<List<SleepMainModel>> getCurrentDaySleepData(
    List<dynamic> overallSleepData,
    String calender,
  ) {
    return _provider.getCurrentDaySleepData(overallSleepData, calender);
  }

  @override
  Future<List<dynamic>> getSleepDataSelectedRange(
    bool monthly,
    List<dynamic> overallSleepData,
    List<String> calenderList,
    BuildContext context,
  ) {
    return _provider.getSleepDataSelectedRange(
      monthly,
      overallSleepData,
      calenderList,
      context,
    );
  }

  @override
  Future<List<SleepMainModel>> getSleepBySelectedWeek(
    List<dynamic> overallSleepData,
    List<String> calenderList,
  ) {
    return _provider.getSleepBySelectedWeek(overallSleepData, calenderList);
  }

  @override
  Future<List<StepsMainModel>> getSelectedDayStepsData(
    List<dynamic> overallStepsData,
    String calender,
  ) {
    return _provider.getSelectedDayStepsData(overallStepsData, calender);
  }

  @override
  Future<List<StepsMainModel>> getCurrentDaySteps(
    List<dynamic> overallStepsData,
    String calender,
  ) {
    return _provider.getCurrentDaySteps(overallStepsData, calender);
  }

  @override
  Future<List<dynamic>> getSelectedRangeStepsData(
    bool monthly,
    List<dynamic> overallStepsData,
    List<String> calenderList,
    BuildContext context,
    int totalTargetedSteps,
  ) {
    return _provider.getSelectedRangeStepsData(
      monthly,
      overallStepsData,
      calenderList,
      context,
      totalTargetedSteps,
    );
  }

  @override
  Future<List<StepsMainModel>> getStepsBySelectedWeek(
    List<dynamic> overallStepsData,
    List<String> calenderList,
  ) {
    return _provider.getStepsBySelectedWeek(overallStepsData, calenderList);
  }
}
