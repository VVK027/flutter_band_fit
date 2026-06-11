part of '../../flutter_band_fit.dart';

/// A single heart-rate reading synced from the band.
class BandHRModel {
  /// Calendar date label for this reading.
  final String calender;

  /// Time-of-day label for this reading.
  final String time;

  /// Heart rate in beats per minute as a string.
  final String rate;

  /// Combined date-time stamp for this reading.
  final String dateTime;

  /// Creates a heart-rate reading with the given [calender], [time], [dateTime],
  /// and [rate].
  const BandHRModel({
    required this.calender,
    required this.time,
    required this.dateTime,
    required this.rate,
  });

  /// Parses a heart-rate record from native plugin JSON [data].
  factory BandHRModel.fromJson(Map<String, dynamic> data) {
    return BandHRModel(
      calender: '${data['calender']}',
      time: '${data['time']}',
      dateTime: '${data['dateTime']}',
      rate: '${data['rate']}',
    );
  }

  /// Converts this reading to a JSON map for storage or transport.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'calender': calender,
      'time': time,
      'dateTime': dateTime,
      'rate': rate,
    };
  }
}
