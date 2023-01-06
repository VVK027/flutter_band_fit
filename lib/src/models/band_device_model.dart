part of flutter_band_fit;

class BandDeviceModel {
  //final String index;
  final String name;
  final String address;
  final String identifier;
 // final String alias;
 // final String deviceType;


  const BandDeviceModel({
    //required this.index,
    required this.name,
   // required this.rssi,
   // required this.alias,
    required this.address,
    required this.identifier,
   // required this.deviceType,
   // required this.bondState,

  });

  factory BandDeviceModel.fromJson(Map<String, dynamic> data) => BandDeviceModel(
   // index: data['index'].toString(),
    name: data['name'].toString(),
    address: data['address'].toString(),
    identifier: data['identifier'].toString(),
    // rssi: data['rssi'].toString(),
    // alias: data['alias'].toString(),
    // deviceType: data['type'].toString(),
    // bondState: data['bondState'].toString(),
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> formData = <String, dynamic>{};
   // formData['index'] = this.index;
    formData['name'] = name;
    formData['address'] = address;
    formData['identifier'] = identifier;
    // formData['alias'] = this.alias;
    // formData['type'] = this.deviceType;
    // formData['bondState'] = this.bondState;
    // formData['rssi'] = this.rssi;
    return formData;
  }

/* @override
  // TODO: implement props
  List<Object> get props => [index, name, alias, address, type, bondState];

  @override
  bool get stringify => false;*/
}