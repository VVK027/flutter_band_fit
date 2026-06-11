part of '../../flutter_band_fit.dart';

/// Daily activity summary including steps, distance, and calories.
class BandStepsDataModel {
  /// Calendar date label for this activity summary.
  final String calender;

  /// Time-of-day label for this summary.
  final String time;

  /// Combined date-time stamp for this summary.
  final String dateTime;

  /// Total step count as a string.
  final String step;

  /// Distance traveled as a string.
  final String distance;

  /// Calories burned as a string.
  final String calories;

  /// Creates an activity summary with the given [calender], [time], [dateTime],
  /// [step], [distance], and [calories] values.
  const BandStepsDataModel({
    required this.calender,
    required this.time,
    required this.dateTime,
    required this.step,
    required this.distance,
    required this.calories,
  });

  /// Parses an activity summary from native plugin JSON [data].
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

  /// Converts this summary to a JSON map for storage or transport.
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
