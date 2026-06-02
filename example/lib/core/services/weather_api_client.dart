import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_band_fit_app/core/constants/weather_config.dart';
import 'package:http/http.dart' as http;

/// Shared HTTP client for OpenWeather One Call API.
class WeatherApiClient {
  WeatherApiClient._();

  static final WeatherApiClient instance = WeatherApiClient._();

  static final http.Client _client = http.Client();

  Future<Map<String, dynamic>?> fetchOneCall({
    required double lat,
    required double lon,
    required bool useMetricUnits,
    required String lang,
  }) async {
    final apiKey = WeatherConfig.openWeatherApiKey;
    if (apiKey.isEmpty) {
      debugPrint(
        'WeatherApiClient: set OPEN_WEATHER_API_KEY via --dart-define=OPEN_WEATHER_API_KEY=...',
      );
      return null;
    }

    final uri = Uri.https(
      'api.openweathermap.org',
      '/data/2.5/onecall',
      <String, String>{
        'lat': lat.toString(),
        'lon': lon.toString(),
        'units': useMetricUnits ? 'metric' : 'imperial',
        'exclude': 'hourly,minutely,alerts',
        'appid': apiKey,
        'lang': lang,
      },
    );

    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        debugPrint('WeatherApiClient: HTTP ${response.statusCode}');
        return null;
      }
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }
      return decoded;
    } catch (e, st) {
      debugPrint('WeatherApiClient: $e\n$st');
      return null;
    }
  }
}
