part of '../../flutter_band_fit.dart';

class BandOxygenModel {
  final String calender;
  final String time;
  final String value;

  const BandOxygenModel({
    required this.calender,
    required this.time,
    required this.value,
  });

  factory BandOxygenModel.fromJson(Map<String, dynamic> data) {
    return BandOxygenModel(
      calender: '${data['calender']}',
      time: '${data['time']}',
      value: '${data['value']}',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'calender': calender,
      'time': time,
      'value': value,
    };
  }
}
