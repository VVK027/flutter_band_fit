part of flutter_band_fit;

class BandOxygenModel {
  final String calender;
  final String time;
  final String value;
  //final String startDate;  //yyyyMMddHHmmss

  const BandOxygenModel({
    required this.calender,
    required this.time,
    required this.value,
   // required this.startDate,
  });

  factory BandOxygenModel.fromJson(Map<String, dynamic> data) => BandOxygenModel(
    calender: data['calender'].toString(),
    time: data['time'].toString(),
    value: data['value'].toString(),
    //startDate: data['startDate'].toString(),
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> formData = <String, dynamic>{};
    formData['calender'] = calender;
    formData['time'] = time;
    formData['value'] = value;
   // formData['startDate'] = this.startDate;
    return formData;
  }

/* @override
  // TODO: implement props
  List<Object> get props => [index, name, alias, address, type, bondState];

  @override
  bool get stringify => false;*/
}