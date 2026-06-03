import 'package:flutter_band_fit_app/core/utils/json_utils.dart';

class WeatherMainModel {
  late DateTime date;
  late num temperature;
  late int currentWeatherCode;
  late int humidity;
  late num windSpeed;
  late double uvIndex;

  late String currentMainTitle, currentDescription, currentIconUrl, stUVIStatus;

  List<WeatherDailyData> weatherDailyList = [];

  WeatherMainModel(Map<String, dynamic> currentData, List<dynamic> dailyList) {
    date = _unpackWeatherDate(currentData['dt'])!;
    temperature = JsonUtils.asDouble(currentData['temp']);
    humidity = JsonUtils.asInt(currentData['humidity']);
    windSpeed = JsonUtils.asDouble(currentData['wind_speed']);
    final uvi = JsonUtils.asDouble(currentData['uvi']);
    uvIndex = uvi;
    if (uvi > 0 && uvi < 2) {
      stUVIStatus = 'Low';
    } else if (uvi > 2 && uvi < 5) {
      stUVIStatus = 'Moderate';
    } else if (uvi > 5 && uvi < 7) {
      stUVIStatus = 'High';
    } else if (uvi > 7 && uvi < 10) {
      stUVIStatus = 'Very high';
    } else if (uvi >= 10) {
      stUVIStatus = 'Extreme';
    } else {
      stUVIStatus = '';
    }
    if (currentData['weather'] != null) {
      final weather = JsonUtils.asList(currentData['weather']);
      if (weather.isNotEmpty) {
        final weatherData = WeatherData(JsonUtils.asMap(weather[0]));
        currentWeatherCode = weatherData.weatherCode;
        currentMainTitle = weatherData.mainTitle;
        currentDescription = weatherData.description;
        currentIconUrl = weatherData.iconUrl;
      }
    }
    weatherDailyList = convertDataToList(dailyList);
  }

  List<WeatherDailyData> convertDataToList(List<dynamic> json) {
    final dailyList = <WeatherDailyData>[];
    if (json.isNotEmpty) {
      for (final element in json) {
        dailyList.add(WeatherDailyData(JsonUtils.asMap(element)));
      }
    }
    return dailyList;
  }
}

class WeatherDailyData {
  late DateTime date;
  late TemperatureData temperatureData;
  late double windSpeed;
  late double uvIndex;
  late int humidity;
  late int weatherCode;
  late String mainTitle, description, iconUrl;

  WeatherDailyData(Map<String, dynamic> data) {
    date = _unpackWeatherDate(data['dt'])!;
    temperatureData = TemperatureData(JsonUtils.asMap(data['temp']));
    if (data['weather'] != null) {
      final weather = JsonUtils.asList(data['weather']);
      if (weather.isNotEmpty) {
        final weatherData = WeatherData(JsonUtils.asMap(weather[0]));
        weatherCode = weatherData.weatherCode;
        mainTitle = weatherData.mainTitle;
        description = weatherData.description;
        iconUrl = weatherData.iconUrl;
      }
    }
  }
}

class WeatherData {
  late int weatherCode;
  late String mainTitle, description, iconUrl;

  WeatherData(Map<String, dynamic> data) {
    weatherCode = JsonUtils.asInt(data['id']);
    mainTitle = data['main'].toString();
    description = data['description'].toString();
    iconUrl = _getWeatherIconUrl(data['icon'].toString());
  }
}

class TemperatureData {
  late double day, min, max;

  TemperatureData(Map<String, dynamic> data) {
    day = double.tryParse(data['day'].toString())!;
    min = double.tryParse(data['min'].toString())!;
    max = double.tryParse(data['max'].toString())!;
  }
}

DateTime? _unpackWeatherDate(dynamic dt) {
  if (dt != null) {
    final millis = JsonUtils.asInt(dt) * 1000;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }
  return null;
}

String _getWeatherIconUrl(String iconName) {
  return 'http://openweathermap.org/img/wn/$iconName@2x.png';
}
