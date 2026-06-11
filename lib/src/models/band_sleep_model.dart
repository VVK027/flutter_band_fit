part of '../../flutter_band_fit.dart';

/// A sleep segment synced from the band.
class BandSleepModel {
  /// Calendar date label for this sleep segment.
  final String calender;

  /// Sleep stage or state label reported by the band.
  final String state;

  /// Human-readable sleep start time.
  final String startTime;

  /// Human-readable sleep end time.
  final String endTime;

  /// Numeric sleep start time representation.
  final String startTimeNum;

  /// Numeric sleep end time representation.
  final String endTimeNum;

  /// Full start date-time stamp for this segment.
  final String startDateTime;

  /// Full end date-time stamp for this segment.
  final String endDateTime;

  /// Creates a sleep segment with the given timing and [state] fields.
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

  /// Parses a sleep record from native plugin JSON [data].
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

  /// Converts this sleep segment to a JSON map for storage or transport.
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
