part of '../../flutter_band_fit.dart';

/// A step-count sample at a specific point in time.
class BandStepsModel {
  /// Time label for this step sample.
  final String time;

  /// Step count value as a string.
  final String step;

  /// Creates a step sample with [step] count at [time].
  const BandStepsModel({required this.step, required this.time});

  /// Parses a step sample from native plugin JSON [data].
  factory BandStepsModel.fromJson(Map<String, dynamic> data) {
    return BandStepsModel(
      step: '${data['step']}',
      time: '${data['time']}',
    );
  }

  /// Converts this step sample to a JSON map for storage or transport.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'step': step,
      'time': time,
    };
  }
}
