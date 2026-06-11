part of '../../flutter_band_fit.dart';

/// A single body-temperature reading synced from the band.
class BandTempModel {
  /// Calendar date label for this reading.
  final String calender;

  /// Time-of-day label for this reading.
  final String time;

  /// Combined date-time stamp for this reading.
  final String dateTime;

  /// Temperature in Celsius as a string.
  final String inCelsius;

  /// Temperature in Fahrenheit as a string.
  final String inFahrenheit;

  /// Creates a temperature reading with the given [calender], [time], [dateTime],
  /// [inCelsius], and [inFahrenheit] values.
  const BandTempModel({
    required this.calender,
    required this.time,
    required this.dateTime,
    required this.inCelsius,
    required this.inFahrenheit,
  });

  /// Parses a temperature record from native plugin JSON [data].
  factory BandTempModel.fromJson(Map<String, dynamic> data) {
    return BandTempModel(
      calender: '${data['calender']}',
      time: '${data['time']}',
      dateTime: '${data['dateTime']}',
      inCelsius: '${data['inCelsius']}',
      inFahrenheit: '${data['inFahrenheit']}',
    );
  }

  /// Converts this reading to a JSON map for storage or transport.
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
