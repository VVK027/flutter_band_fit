part of flutter_band_fit;

class BandStepsDataModel {
  final String calender;
  final String time;
  final String dateTime;
  final String step;
  final String distance;
  final String calories;

  const BandStepsDataModel({required this.calender, required this.time, required this.dateTime, required this.step, required this.distance, required this.calories});

  factory BandStepsDataModel.fromJson(Map<String, dynamic> data) => BandStepsDataModel(
    calender: data['calender'].toString(),
    time: data['time'].toString(),
    dateTime: data['dateTime'].toString(),
    step: data['step'].toString(),
    distance: data['distance'].toString(),
    calories: data['calories'].toString(),
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> formData = <String, dynamic>{};
    formData['calender'] = calender;
    formData['time'] = time;
    formData['dateTime'] = dateTime;
    formData['step'] = step;
    formData['distance'] = distance;
    formData['calories'] = calories;
    return formData;
  }
}