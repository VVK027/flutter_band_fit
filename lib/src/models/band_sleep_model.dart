part of '../../flutter_band_fit.dart';

class BandSleepModel {
  final String calender;
  final String state;
  final String startTime;
  final String endTime;
  final String startTimeNum;
  final String endTimeNum;
  final String startDateTime;
  final String endDateTime;

  const BandSleepModel({
    required this.calender,
    required this.state,
    required this.startTime,
    required this.endTime,
    required this.startTimeNum,
    required this.endTimeNum,
    required this.startDateTime,
    required this.endDateTime,
  });

  factory BandSleepModel.fromJson(Map<String, dynamic> data) {
    return BandSleepModel(
      calender: '${data['calender']}',
      state: '${data['state']}',
      startTime: '${data['startTime']}',
      endTime: '${data['endTime']}',
      startTimeNum: '${data['startTimeNum']}',
      endTimeNum: '${data['endTimeNum']}',
      startDateTime: '${data['startDateTime']}',
      endDateTime: '${data['endDateTime']}',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'calender': calender,
      'state': state,
      'startTime': startTime,
      'endTime': endTime,
      'startTimeNum': startTimeNum,
      'endTimeNum': endTimeNum,
      'startDateTime': startDateTime,
      'endDateTime': endDateTime,
    };
  }
}
