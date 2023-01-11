part of flutter_band_fit;

class BandDialModel {
  late String id, title,author, resource, preview, dpi, capacity, download_num;
  BandDialModel(Map<String, dynamic> data) {
    id = data['id'].toString();
    title = data['title'].toString();
    author = data['author'].toString();
    resource = data['resource'].toString();
    preview = data['preview'].toString();
    dpi = data['dpi'].toString();
    capacity = data['capacity'].toString();
    download_num = data['download_num'].toString();
  }
}