import 'package:flutter_band_fit_app/core/exports/band_exports.dart';
import 'package:flutter_band_fit_app/features/vitals/data/models/band_data_model.dart';

abstract class VitalsDataRepository {
  String getOverAllHrData();

  String getOverAllSleepData();

  String getOverAllStepsData();

  String getTargetedSteps();

  Future<List<BandHRModel>> getCurrentDayHRData(
    dynamic hr24Data,
    String calender,
  );

  Future<List<SleepMainModel>> getSelectedDaySleepData(
    List<dynamic> overallSleepData,
    String calender,
  );

  Future<List<SleepMainModel>> getCurrentDaySleepData(
    List<dynamic> overallSleepData,
    String calender,
  );

  Future<List<dynamic>> getSleepDataSelectedRange(
    bool monthly,
    List<dynamic> overallSleepData,
    List<String> calenderList,
    BuildContext context,
  );

  Future<List<SleepMainModel>> getSleepBySelectedWeek(
    List<dynamic> overallSleepData,
    List<String> calenderList,
  );

  Future<List<StepsMainModel>> getSelectedDayStepsData(
    List<dynamic> overallStepsData,
    String calender,
  );

  Future<List<StepsMainModel>> getCurrentDaySteps(
    List<dynamic> overallStepsData,
    String calender,
  );

  Future<List<dynamic>> getSelectedRangeStepsData(
    bool monthly,
    List<dynamic> overallStepsData,
    List<String> calenderList,
    BuildContext context,
    int totalTargetedSteps,
  );

  Future<List<StepsMainModel>> getStepsBySelectedWeek(
    List<dynamic> overallStepsData,
    List<String> calenderList,
  );
}
