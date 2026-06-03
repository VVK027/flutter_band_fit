part of '../../flutter_band_fit.dart';

class BandHRModel {
  final String calender;
  final String time;
  final String rate;
  final String dateTime;

  const BandHRModel({
    required this.calender,
    required this.time,
    required this.dateTime,
    required this.rate,
  });

  factory BandHRModel.fromJson(Map<String, dynamic> data) {
    return BandHRModel(
      calender: '${data['calender']}',
      time: '${data['time']}',
      dateTime: '${data['dateTime']}',
      rate: '${data['rate']}',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'calender': calender,
      'time': time,
      'dateTime': dateTime,
      'rate': rate,
    };
  }
}
