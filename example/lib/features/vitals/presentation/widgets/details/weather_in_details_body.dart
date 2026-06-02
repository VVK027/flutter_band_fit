import 'package:flutter_band_fit_app/core/exports/band_exports.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/weather_in_details_controller.dart';
import 'package:intl/intl.dart';

class WeatherInDetailsBody extends GetView<WeatherInDetailsController> {
  const WeatherInDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3DBE6E),
        title: const Text(
          textWeather,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: controller.weatherData.isEmpty
          ? const Center(child: Text(textSomethingWrong))
          : _WeatherContent(controller: controller),
    );
  }
}

class _WeatherContent extends StatelessWidget {
  const _WeatherContent({required this.controller});

  final WeatherInDetailsController controller;

  @override
  Widget build(BuildContext context) {
    final provider = controller.provider;
    final model = controller.weatherModelData;
    final unit = provider.getIsCelsius ? tempInCelsius : tempInFahrenheit;

    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.48,
          color: const Color(0xFF59DA7E),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    const Icon(Icons.location_pin, color: Colors.white),
                    const SizedBox(width: 5),
                    Text(
                      provider.getDeviceCityName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  '$textUpdatedTo ${DateFormat.yMMMMd().format(model.date)}',
                  style: const TextStyle(fontSize: 14, color: Colors.white54),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 20),
                child: Text(
                  '${model.temperature} $unit',
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: Text(
                  model.currentDescription.toUpperCase(),
                  style: const TextStyle(fontSize: 30, color: Colors.white54),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _MetricColumn(
                    label: textHumidity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/fit/humidity.png',
                          width: 20,
                          height: 20,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${model.humidity} %',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const _VerticalDivider(),
                  _MetricColumn(
                    label: textWindSpeed,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/fit/wind_speed.png',
                          width: 20,
                          height: 20,
                          color: Colors.white54,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          model.windSpeed.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const _VerticalDivider(),
                  _MetricColumn(
                    label: textUVIndex,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/fit/cloudiness.png',
                          width: 20,
                          height: 20,
                          color: Colors.white54,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          model.stUVIStatus,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Expanded(
                child: Image.asset(
                  'assets/fit/my_clouds.png',
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: controller.weatherData.length,
            itemBuilder: (context, index) {
              final day = controller.weatherData[index];
              final isToday = day.date.day == DateTime.now().day;
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          isToday
                              ? textToday
                              : DateFormat.E().format(day.date),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          day.description.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${day.temperatureData.min.toStringAsFixed(2)} $unit ~ ${day.temperatureData.max.toStringAsFixed(2)} $unit',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 0.5),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MetricColumn extends StatelessWidget {
  const _MetricColumn({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: Colors.white54,
            ),
          ),
          Padding(padding: const EdgeInsets.all(4), child: child),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 40,
      child: VerticalDivider(thickness: 1, color: Colors.grey),
    );
  }
}
