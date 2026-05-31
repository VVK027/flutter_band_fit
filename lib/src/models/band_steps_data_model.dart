part of '../../flutter_band_fit.dart';

class BandStepsDataModel {
  final String calender;
  final String time;
  final String dateTime;
  final String step;
  final String distance;
  final String calories;

  const BandStepsDataModel({
    required this.calender,
    required this.time,
    required this.dateTime,
    required this.step,
    required this.distance,
    required this.calories,
  });

  factory BandStepsDataModel.fromJson(Map<String, dynamic> data) {
    return BandStepsDataModel(
      calender: '${data['calender']}',
      time: '${data['time']}',
      dateTime: '${data['dateTime']}',
      step: '${data['step']}',
      distance: '${data['distance']}',
      calories: '${data['calories']}',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'calender': calender,
      'time': time,
      'dateTime': dateTime,
      'step': step,
      'distance': distance,
      'calories': calories,
    };
  }
}
