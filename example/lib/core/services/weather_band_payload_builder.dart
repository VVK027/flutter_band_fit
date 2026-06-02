import 'dart:convert';

import 'package:flutter_band_fit_app/core/services/weather_device_code_mapper.dart';
import 'package:flutter_band_fit_app/features/vitals/data/models/weather_model.dart';

/// Builds JSON payloads pushed to the smart band over BLE.
class WeatherBandPayloadBuilder {
  WeatherBandPayloadBuilder._();

  static const int _bandForecastDays = 7;

  static String bandCityPrefix(String cityName) {
    if (cityName.isEmpty) {
      return '';
    }
    if (cityName.length <= 2) {
      return cityName;
    }
    return cityName.substring(0, 3);
  }

  static Map<String, dynamic>? buildBandSevenDayPayload({
    required WeatherMainModel model,
    required String cityName,
  }) {
    final daily = model.weatherDailyList;
    if (daily.length < _bandForecastDays) {
      return null;
    }

    int bandCode(int index) =>
        WeatherDeviceCodeMapper.map(daily[index].weatherCode);

    return <String, dynamic>{
      'cityName': bandCityPrefix(cityName),
      'todayWeatherCode': bandCode(0).toString(),
      'todayTmpCurrent': model.temperature.toInt(),
      'todayTmpMax': daily[0].temperatureData.max.toInt(),
      'todayTmpMin': daily[0].temperatureData.min.toInt(),
      'todayPm25': 0,
      'todayAqi': 0,
      'secondDayWeatherCode': bandCode(1).toString(),
      'secondDayTmpMax': daily[1].temperatureData.max.toInt(),
      'secondDayTmpMin': daily[1].temperatureData.min.toInt(),
      'thirdDayWeatherCode': bandCode(2).toString(),
      'thirdDayTmpMax': daily[2].temperatureData.max.toInt(),
      'thirdDayTmpMin': daily[2].temperatureData.min.toInt(),
      'fourthDayWeatherCode': bandCode(3).toString(),
      'fourthDayTmpMax': daily[3].temperatureData.max.toInt(),
      'fourthDayTmpMin': daily[3].temperatureData.min.toInt(),
      'fifthDayWeatherCode': bandCode(4).toString(),
      'fifthDayTmpMax': daily[4].temperatureData.max.toInt(),
      'fifthDayTmpMin': daily[4].temperatureData.min.toInt(),
      'sixthDayWeatherCode': bandCode(5).toString(),
      'sixthDayTmpMax': daily[5].temperatureData.max.toInt(),
      'sixthDayTmpMin': daily[5].temperatureData.min.toInt(),
      'seventhDayWeatherCode': bandCode(6).toString(),
      'seventhDayTmpMax': daily[6].temperatureData.max.toInt(),
      'seventhDayTmpMin': daily[6].temperatureData.min.toInt(),
    };
  }

  static String encodeBandPayload(Map<String, dynamic> payload) =>
      jsonEncode(payload);
}
