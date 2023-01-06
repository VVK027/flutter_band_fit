part of flutter_band_fit;

class BandTempModel {
  final String calender;
  final String time;
  final String dateTime;
//  final String type;
  final String inCelsius;
  final String inFahrenheit;
  //final String startDate;  //yyyyMMddHHmmss

  const BandTempModel({
    required this.calender,
    required this.time,
    required this.dateTime,
  //  required this.type,
    required this.inCelsius,
    required this.inFahrenheit,
   // required this.startDate,
  });

  factory BandTempModel.fromJson(Map<String, dynamic> data) => BandTempModel(
    calender: data['calender'].toString(),
    time: data['time'].toString(),
    dateTime: data['dateTime'].toString(),
   // type: data['type'].toString(),
    inCelsius: data['inCelsius'].toString(),
    inFahrenheit: data['inFahrenheit'].toString(),
   // startDate: data['startDate'].toString(),
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> formData = <String, dynamic>{};
    formData['calender'] = calender;
    formData['time'] = time;
    formData['dateTime'] = dateTime;
   // formData['type'] = type;
    formData['inCelsius'] = inCelsius;
    formData['inFahrenheit'] = inFahrenheit;
    //formData['startDate'] = startDate;
    return formData;
  }

/* @override
  // TODO: implement props
  List<Object> get props => [index, name, alias, address, type, bondState];

  @override
  bool get stringify => false;*/
}