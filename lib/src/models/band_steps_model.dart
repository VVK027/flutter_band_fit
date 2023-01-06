part of flutter_band_fit;

class BandStepsModel {
  final String time;
  final String step;

  const BandStepsModel({required this.step, required this.time});

  factory BandStepsModel.fromJson(Map<String, dynamic> data) => BandStepsModel(
    step: data['step'].toString(),
    time: data['time'].toString(),
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> formData = <String, dynamic>{};
    formData['step'] = step;
    formData['time'] = time;
    return formData;
  }

/* @override
  // TODO: implement props
  List<Object> get props => [index, name, alias, address, type, bondState];

  @override
  bool get stringify => false;*/
}