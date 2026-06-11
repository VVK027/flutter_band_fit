part of '../../flutter_band_fit.dart';

/// A single blood-pressure reading synced from the band.
class BandBPModel {
  /// Calendar date label for this reading.
  final String calender;

  /// Time-of-day label for this reading.
  final String time;

  /// Systolic pressure value as a string.
  final String high;

  /// Diastolic pressure value as a string.
  final String low;

  /// Combined date-time stamp for this reading.
  final String dateTime;

  /// Creates a blood-pressure reading with the given [calender], [time],
  /// [dateTime], [high], and [low] values.
  const BandBPModel({
    required this.calender,
    required this.time,
    required this.dateTime,
    required this.high,
    required this.low,
  });

  /// Parses a blood-pressure record from native plugin JSON [data].
  factory BandBPModel.fromJson(Map<String, dynamic> data) {
    return BandBPModel(
      calender: '${data['calender']}',
      time: '${data['time']}',
      dateTime: '${data['dateTime']}',
      high: '${data['high']}',
      low: '${data['low']}',
    );
  }

  /// Converts this reading to a JSON map for storage or transport.
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
