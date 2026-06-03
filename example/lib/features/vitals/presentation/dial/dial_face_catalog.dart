import 'dart:convert';

import 'package:flutter_band_fit/flutter_band_fit.dart';

const String dialFaceGetWatchesUrl =
    'https://www.ute-tech.com.cn/ci-yc/index.php/api/client/getWatchs';
const String dialFaceYcAppKey = 'dcd05f241b65ec7b6af0bbe6f05145c2';

/// UTE CDN mirrors on AWS — more reliable than *.ute-tech.com.cn in some regions.
const String _s3PreviewBase =
    'https://uteap.s3.ap-south-1.amazonaws.com/watch/all/all/preview/';
const String _s3ResourceBase =
    'https://uteap.s3.ap-south-1.amazonaws.com/watch/all/all/resource/';

const List<BandDialModel> recommendedDialFaces = [
  BandDialModel(
    id: '100947',
    title: 'D2078001',
    author: 'UTE',
    resource: '${_s3ResourceBase}1630920630_7948.bin',
    preview: '${_s3PreviewBase}1630920630_2912.png',
    dpi: '240*280',
    capacity: '364170',
    downloadNum: '51981',
  ),
];

String dialFaceCacheKey({
  required String bleName,
  required String mac,
  required String dpi,
  required String compatible,
  required String shape,
}) {
  return '${bleName}_${mac}_${dpi}_${compatible}_$shape';
}

BandDialModel dialFaceFromApiJson(Map<String, dynamic> raw) {
  final map = Map<String, dynamic>.from(raw);
  final previewBg = map['previewBg']?.toString().trim() ?? '';
  final resourceBg = map['resourceBg']?.toString().trim() ?? '';
  if (previewBg.isNotEmpty) {
    map['preview'] = previewBg;
  }
  if (resourceBg.isNotEmpty) {
    map['resource'] = resourceBg;
  }
  return BandDialModel.fromJson(map);
}

List<BandDialModel> dialFacesFromCachedJson(String json) {
  if (json.trim().isEmpty) {
    return <BandDialModel>[];
  }
  final decoded = jsonDecode(json);
  if (decoded is! List) {
    return <BandDialModel>[];
  }
  return decoded
      .whereType<Map<String, dynamic>>()
      .map(BandDialModel.fromJson)
      .toList();
}

String dialFacesToCachedJson(List<BandDialModel> dials) {
  return jsonEncode(dials.map((d) => d.toJson()).toList());
}

bool isDialFaceNetworkError(Object error) {
  final message = error.toString().toLowerCase();
  return message.contains('socketexception') ||
      message.contains('failed host lookup') ||
      message.contains('network is unreachable') ||
      message.contains('connection refused') ||
      message.contains('connection timed out') ||
      message.contains('clientexception');
}
