import 'package:flutter_band_fit_app/core/exports/band_exports.dart';
import 'package:flutter_band_fit_app/core/services/activity_service_provider.dart';
import 'package:flutter_band_fit_app/features/vitals/data/models/weather_model.dart';

class WeatherInDetailsController extends GetxController {
  WeatherInDetailsController({required this.weatherModelData});

  ActivityServiceProvider get provider => Get.find<ActivityServiceProvider>();

  final WeatherMainModel weatherModelData;

  late final List<WeatherDailyData> weatherData;

  @override
  void onInit() {
    super.onInit();
    weatherData = weatherModelData.weatherDailyList;
  }
}
