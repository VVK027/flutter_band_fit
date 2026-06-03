import 'package:flutter/material.dart';
import 'package:flutter_band_fit_app/features/vitals/data/models/weather_model.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/weather_in_details_controller.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/widgets/details/weather_in_details_body.dart';
import 'package:get/get.dart';

class WeatherInDetails extends StatelessWidget {
  const WeatherInDetails({super.key, required this.weatherModelData});

  final WeatherMainModel weatherModelData;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WeatherInDetailsController>(
      init: WeatherInDetailsController(weatherModelData: weatherModelData),
      builder: (_) => const WeatherInDetailsBody(),
    );
  }
}
