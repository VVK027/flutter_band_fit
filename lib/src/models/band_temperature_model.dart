part of '../../flutter_band_fit.dart';

class BandTempModel {
  final String calender;
  final String time;
  final String dateTime;
  final String inCelsius;
  final String inFahrenheit;

  const BandTempModel({
    required this.calender,
    required this.time,
    required this.dateTime,
    required this.inCelsius,
    required this.inFahrenheit,
  });

  factory BandTempModel.fromJson(Map<String, dynamic> data) {
    return BandTempModel(
      calender: '${data['calender']}',
      time: '${data['time']}',
      dateTime: '${data['dateTime']}',
      inCelsius: '${data['inCelsius']}',
      inFahrenheit: '${data['inFahrenheit']}',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'calender': calender,
      'time': time,
      'dateTime': dateTime,
      'inCelsius': inCelsius,
      'inFahrenheit': inFahrenheit,
    };
  }
}
