part of '../../flutter_band_fit.dart';

/// A BLE band discovered during scanning or used for connection.
class BandDeviceModel {
  /// Human-readable device name advertised by the band.
  final String name;

  /// MAC address on Android or peripheral identifier on iOS.
  final String address;

  /// Stable device identifier used when reconnecting.
  final String identifier;

  /// Creates a device descriptor with [name], [address], and [identifier].
  const BandDeviceModel({
    required this.name,
    required this.address,
    required this.identifier,
  });

  /// Parses a scanned device from native plugin JSON [data].
  factory BandDeviceModel.fromJson(Map<String, dynamic> data) {
    return BandDeviceModel(
      name: '${data['name']}',
      address: '${data['address']}',
      identifier: '${data['identifier']}',
    );
  }

  /// Converts this device to a JSON map for storage or transport.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'address': address,
      'identifier': identifier,
    };
  }
}
