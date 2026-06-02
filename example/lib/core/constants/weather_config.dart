/// OpenWeather configuration for the example app.
///
/// Pass your key at build/run time:
/// `flutter run --dart-define=OPEN_WEATHER_API_KEY=your_key`
class WeatherConfig {
  WeatherConfig._();

  static const String openWeatherApiKey = String.fromEnvironment(
    'OPEN_WEATHER_API_KEY',
    defaultValue: '',
  );

  /// Skip a new network call when coords match and data is newer than this.
  static const Duration fetchCacheTtl = Duration(hours: 2);
}
