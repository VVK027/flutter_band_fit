part of flutter_band_fit;

class BandSleepModel {
  final String calender;
  final String state; // deep sleep: 0, Light sleep: 1,  awake: 2
  final String startTime;
  final String endTime;
 // final String diffTime;

  final String startTimeNum;
  final String endTimeNum;

  final String startDateTime;
  final String endDateTime;
  //final String diffTimeNum;

  const BandSleepModel({
    required this.calender,
    required this.state,
    required this.startTime,
    required this.endTime,
   // required this.diffTime,
    required this.startTimeNum,
    required this.endTimeNum,
    required this.startDateTime,
    required this.endDateTime,
   // required this.diffTimeNum
  });

  factory BandSleepModel.fromJson(Map<String, dynamic> data) => BandSleepModel(
    calender: data['calender'].toString(),
    state: data['state'].toString(), // deep sleep: 0, Light sleep: 1,  awake: 2
    startTime: data['startTime'].toString(),
    endTime: data['endTime'].toString(),
   // diffTime: data['diffTime'].toString(),
    startTimeNum: data['startTimeNum'].toString(),
    endTimeNum: data['endTimeNum'].toString(),
    startDateTime: data['startDateTime'].toString(),
    endDateTime: data['endDateTime'].toString(),
   // diffTimeNum: data['diffTimeNum'].toString(),
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> formData = <String, dynamic>{};
    formData['calender'] = calender;
    formData['state'] = state;
    formData['startTime'] = startTime;
    formData['endTime'] = endTime;
    //formData['diffTime'] = diffTime;
    formData['startTimeNum'] = startTimeNum;
    formData['endTimeNum'] = endTimeNum;
    formData['startDateTime'] = startDateTime;
    formData['endDateTime'] = endDateTime;
   // formData['diffTimeNum'] = diffTimeNum;
    return formData;
  }

/* @override
  // TODO: implement props
  List<Object> get props => [index, name, alias, address, type, bondState];

  @override
  bool get stringify => false;*/
}