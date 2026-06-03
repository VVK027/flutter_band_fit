part of '../../flutter_band_fit.dart';

class BandStepsModel {
  final String time;
  final String step;

  const BandStepsModel({required this.step, required this.time});

  factory BandStepsModel.fromJson(Map<String, dynamic> data) {
    return BandStepsModel(
      step: '${data['step']}',
      time: '${data['time']}',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'step': step,
      'time': time,
    };
  }
}
