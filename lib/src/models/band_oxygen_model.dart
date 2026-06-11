part of '../../flutter_band_fit.dart';

/// A single blood-oxygen (SpO2) reading synced from the band.
class BandOxygenModel {
  /// Calendar date label for this reading.
  final String calender;

  /// Time-of-day label for this reading.
  final String time;

  /// SpO2 percentage value as a string.
  final String value;

  /// Creates a blood-oxygen reading with [calender], [time], and [value].
  const BandOxygenModel({
    required this.calender,
    required this.time,
    required this.value,
  });

  /// Parses a blood-oxygen record from native plugin JSON [data].
  factory BandOxygenModel.fromJson(Map<String, dynamic> data) {
    return BandOxygenModel(
      calender: '${data['calender']}',
      time: '${data['time']}',
      value: '${data['value']}',
    );
  }

  /// Converts this reading to a JSON map for storage or transport.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'calender': calender,
      'time': time,
      'value': value,
    };
  }
}
