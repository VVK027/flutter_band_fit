part of flutter_band_fit;

class BandHRModel {
  final String calender;
  final String time;
  final String rate;
  final String dateTime;

  const BandHRModel({
    required this.calender,
    required this.time,
    required this.dateTime,
    required this.rate
  });

  factory BandHRModel.fromJson(Map<String, dynamic> data) => BandHRModel(
    calender: data['calender'].toString(),
    time: data['time'].toString(),
    dateTime: data['dateTime'].toString(),
    rate: data['rate'].toString(),
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> formData = <String, dynamic>{};
    formData['calender'] = calender;
    formData['time'] = time;
    formData['dateTime'] = dateTime;
    formData['rate'] = rate;
    return formData;
  }

/* @override
  // TODO: implement props
  List<Object> get props => [index, name, alias, address, type, bondState];

  @override
  bool get stringify => false;*/
}