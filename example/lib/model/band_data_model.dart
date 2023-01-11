import 'package:flutter_band_fit_app/common/common_imports.dart';

class CommonBandModel {
  final DateTime time;
  final int dataPoint;
  final Color color;
  CommonBandModel({required this.time, required this.dataPoint, required this.color});
}

class CommonDataResult {
  final DateTime time;
  final double dataPoint;
  final Color color;
  CommonDataResult({required this.time, required this.dataPoint, required this.color});
}

class WeekStepsData {
  final String weekName;
  final DateTime dateTime;
  final int dataPoint;
  final Color color;
  WeekStepsData({required this.weekName, required this.dateTime, required this.dataPoint, required this.color});
}

class MonthStepsData {
  // final String monthDateName;
  final int dayNumber;
  final int dataPoint;
  final Color color;
  MonthStepsData({required this.dayNumber, required this.dataPoint, required this.color});
}

class BPData {
  final String highPressure;
  final String lowPressure;
  final DateTime time;
  BPData({required this.highPressure, required this.lowPressure, required this.time});
}

class WeeklySleepData {
  final String weekName;
  final DateTime startTime;
  final DateTime endTime;
  final int startTimeNum;
  final int endTimeNum;
  final Color color;
  WeeklySleepData({required this.weekName, required this.startTime, required this.endTime, required this.startTimeNum, required this.endTimeNum, required this.color});
}

class MonthlySleepData {
  // final String monthDateName;
  final int dayNumber;
  final DateTime startTime;
  final DateTime endTime;
  final int startTimeNum;
  final int endTimeNum;
  final Color color;
  MonthlySleepData({required this.dayNumber, required this.startTime, required this.endTime, required this.startTimeNum, required this.endTimeNum, required this.color});
}

class StepsMainModel {
  final String steps;
  final String distance;
  final String calories;
  final String calender;
  final List<BandStepsModel> dataList;

  const StepsMainModel({required this.calender,required this.steps,required this.distance,required this.calories,required this.dataList});

  factory StepsMainModel.fromJson(Map<String, dynamic> data) {
    final List<BandStepsModel> stepsList = [];
    if (data['data'] != null) {
      for (var element in (data['data'] as List<dynamic>)) {
        stepsList.add(BandStepsModel.fromJson(element));
      }
    }

    return StepsMainModel(
      steps: data['steps'].toString() ?? '0',
      distance: data['distance'].toString(),
      calories: data['calories'].toString(),
      calender: data['calender'].toString(),
      dataList: stepsList,
    );
  }

/*List<BandStepsModel> convertDataToList(List<dynamic> json) {
    List<BandStepsModel> smartList = [];
    if (json.isNotEmpty) {
      for (var element in json) {
        smartList.add(BandStepsModel.fromJson(element));
      }
    }
    return smartList;
  }*/
}

class SleepMainModel {
  final String calender;
  final String total;
  final String light;
  final String deep;
  final String awake;
  final String beginTime;
  final String endTime;

  final String totalNum;
  final String lightNum;
  final String deepNum;
  final String awakeNum;
  final String beginTimeNum;
  final String endTimeNum;

  final List<BandSleepModel> dataList;

  const SleepMainModel(
      {required this.calender,
        required  this.total,
        required  this.light,
        required  this.deep,
        required this.awake,
        required this.beginTime,
        required this.endTime,
        required this.totalNum,
        required this.lightNum,
        required this.deepNum,
        required this.awakeNum,
        required this.beginTimeNum,
        required this.endTimeNum,
        required this.dataList});

  factory SleepMainModel.fromJson(Map<String, dynamic> data) {
    final List<BandSleepModel> sleepDataList = [];
    if (data['data'] != null) {
      for (var element in (data['data'] as List<dynamic>)) {
        sleepDataList.add(BandSleepModel.fromJson(element));
      }
    }

    return SleepMainModel(
        calender: data['calender'].toString(),
        total: data['total'].toString(),
        light: data['light'].toString(),
        deep: data['deep'].toString(),
        awake: data['awake'].toString(),
        beginTime: data['beginTime'].toString(),
        endTime: data['endTime'].toString(),
        totalNum: data['totalNum'].toString(),
        lightNum: data['lightNum'].toString(),
        deepNum: data['deepNum'].toString(),
        awakeNum: data['awakeNum'].toString(),
        beginTimeNum: data['beginTimeNum'].toString(),
        endTimeNum: data['endTimeNum'].toString(),
        dataList: sleepDataList);
  }
}
