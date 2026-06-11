part of '../../flutter_band_fit.dart';

/// Metadata for an online watch face available for download to the band.
class BandDialModel {
  /// Unique watch-face identifier.
  final String id;

  /// Display title of the watch face.
  final String title;

  /// Author or publisher of the watch face.
  final String author;

  /// Download URL or resource path for the watch-face package.
  final String resource;

  /// Preview image URL for the watch face.
  final String preview;

  /// Screen DPI requirement for the watch face.
  final String dpi;

  /// Required storage capacity on the band.
  final String capacity;

  /// Number of times the watch face has been downloaded.
  final String downloadNum;

  /// Creates watch-face metadata with the given display and download fields.
  const BandDialModel({
    required this.id,
    required this.title,
    required this.author,
    required this.resource,
    required this.preview,
    required this.dpi,
    required this.capacity,
    required this.downloadNum,
  });

  /// Parses watch-face metadata from native plugin JSON [data].
  factory BandDialModel.fromJson(Map<String, dynamic> data) {
    return BandDialModel(
      id: '${data['id']}',
      title: '${data['title']}',
      author: '${data['author']}',
      resource: '${data['resource']}',
      preview: '${data['preview']}',
      dpi: '${data['dpi']}',
      capacity: '${data['capacity']}',
      downloadNum: '${data['download_num']}',
    );
  }

  /// Converts this watch-face metadata to a JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'author': author,
      'resource': resource,
      'preview': preview,
      'dpi': dpi,
      'capacity': capacity,
      'download_num': downloadNum,
    };
  }
}
