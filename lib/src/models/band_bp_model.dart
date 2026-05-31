part of '../../flutter_band_fit.dart';

class BandBPModel {
  final String calender;
  final String time;
  final String high;
  final String low;
  final String dateTime;

  const BandBPModel({
    required this.calender,
    required this.time,
    required this.dateTime,
    required this.high,
    required this.low,
  });

  factory BandBPModel.fromJson(Map<String, dynamic> data) {
    return BandBPModel(
      calender: '${data['calender']}',
      time: '${data['time']}',
      dateTime: '${data['dateTime']}',
      high: '${data['high']}',
      low: '${data['low']}',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'calender': calender,
      'time': time,
      'dateTime': dateTime,
      'high': high,
      'low': low,
    };
  }
}
