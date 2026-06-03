part of '../../flutter_band_fit.dart';

class BandDialModel {
  final String id;
  final String title;
  final String author;
  final String resource;
  final String preview;
  final String dpi;
  final String capacity;
  final String downloadNum;

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
