part of '../../flutter_band_fit.dart';

class BandDeviceModel {
  final String name;
  final String address;
  final String identifier;

  const BandDeviceModel({
    required this.name,
    required this.address,
    required this.identifier,
  });

  factory BandDeviceModel.fromJson(Map<String, dynamic> data) {
    return BandDeviceModel(
      name: '${data['name']}',
      address: '${data['address']}',
      identifier: '${data['identifier']}',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'address': address,
      'identifier': identifier,
    };
  }
}
