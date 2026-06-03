/// Safe casts for JSON and platform channel payloads under [strict-casts].
class JsonUtils {
  JsonUtils._();

  static Map<String, dynamic> asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return <String, dynamic>{};
  }

  static List<dynamic> asList(dynamic value) {
    if (value is List) {
      return List<dynamic>.from(value);
    }
    return <dynamic>[];
  }

  static bool asBool(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      return value == 'true' || value == '1';
    }
    return false;
  }

  static String asString(dynamic value, [String fallback = '']) {
    if (value == null) {
      return fallback;
    }
    return value.toString();
  }

  static int asInt(dynamic value, [int fallback = 0]) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value.toString()) ?? fallback;
  }

  static double asDouble(dynamic value, [double fallback = 0]) {
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value.toString()) ?? fallback;
  }
}
