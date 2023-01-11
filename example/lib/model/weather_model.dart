class WeatherMainModel {
  late DateTime date;
  late  var temperature;
  late  int currentWeatherCode;
  late  int humidity;
  late var windSpeed;
  late  double uvIndex;

  late  String currentMainTitle, currentDescription, currentIconUrl, stUVIStatus;

  List<WeatherDailyData> weatherDailyList = [];

  WeatherMainModel(Map<String, dynamic> currentData, List<dynamic> dailyList) {
    date = _unpackWeatherDate(currentData['dt'])!;
    temperature = currentData['temp'];
    humidity = currentData['humidity'];
    windSpeed = currentData['wind_speed'];
    if(currentData['uvi'] > 0 && currentData['uvi'] < 2){
      stUVIStatus = 'Low';
    }else if(currentData['uvi'] > 2 && currentData['uvi'] < 5){
      stUVIStatus = 'Moderate';
    }else if(currentData['uvi'] > 5 && currentData['uvi'] < 7){
      stUVIStatus = 'High';
    }else if(currentData['uvi'] > 7 && currentData['uvi'] < 10){
      stUVIStatus = 'Very high';
    }else if(currentData['uvi'] > 10){
      stUVIStatus = 'Extreme';
    }else{
      stUVIStatus = '';
    }
    if (currentData['weather'] != null) {
      var weather = currentData['weather'];
      WeatherData weatherData = WeatherData(weather[0]);
      currentWeatherCode = weatherData.weatherCode;
      currentMainTitle = weatherData.mainTitle;
      currentDescription = weatherData.description;
      currentIconUrl = weatherData.iconUrl;
      //debugPrint('iconUrl>> ' + this.currentIconUrl);
    }
    weatherDailyList = convertDataToList(dailyList);
  }

  List<WeatherDailyData> convertDataToList(List<dynamic> json) {
    List<WeatherDailyData> dailyList = [];
    if (json.length > 0) {
      json.forEach((element) {
        dailyList.add(WeatherDailyData(element));
      });
    }
    return dailyList;
  }


}


class WeatherDailyData {
  late  DateTime date;
  late TemperatureData temperatureData;
  late double windSpeed;
  late  double uvIndex;
  late  int humidity;
  late int weatherCode;
  late  String mainTitle, description, iconUrl;

  WeatherDailyData(Map<String, dynamic> data){
    date = _unpackWeatherDate(data['dt'])!;
    temperatureData= TemperatureData(data['temp']);
    if (data['weather'] != null) {
      var weather = data['weather'];
      WeatherData weatherData = WeatherData(weather[0]);
      weatherCode = weatherData.weatherCode;
      mainTitle = weatherData.mainTitle;
      description = weatherData.description;
      iconUrl = weatherData.iconUrl;
      //debugPrint('iconUrl>> ' + this.iconUrl);
    }
  }
}

class WeatherData {
  late  int weatherCode;
  late  String mainTitle, description, iconUrl;

  WeatherData(Map<String, dynamic> data) {
    weatherCode = data['id'];
    mainTitle = data['main'].toString();
    description = data['description'].toString();
    iconUrl = _getWeatherIconUrl(data['icon'].toString());
  }
}

class TemperatureData {
  late  double day, min, max;

  TemperatureData(Map<String, dynamic> data) {
   // debugPrint('TemperatureData>> $data');
    day = double.tryParse(data['day'].toString())!;
    min = double.tryParse(data['min'].toString())!;
    max = double.tryParse(data['max'].toString())!;
  }
}

DateTime? _unpackWeatherDate(dynamic dt) {
  if (dt != null) {
    int millis = dt * 1000;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }
  return null;
}

String _getWeatherIconUrl(String iconName) {
  // for example  http://openweathermap.org/img/wn/10d@2x.png
  return 'http://openweathermap.org/img/wn/$iconName@2x.png';
}

