import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:flutter_band_fit_app/model/weather_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WeatherInDetails extends StatefulWidget {
  final WeatherMainModel weatherModelData;
  const WeatherInDetails({Key? key, required this.weatherModelData}) : super(key: key);
  @override
  State<WeatherInDetails> createState() => _WeatherInDetailsState();
}

class _WeatherInDetailsState extends State<WeatherInDetails> {
  // List<Weather> sortedWeekData=[];
  List<int> weatherForcastingDaysList = [];
  List<WeatherDailyData> weatherData = [];
 final  _activityServiceProvider = Get.put(ActivityServiceProvider());
  //late String lang;

  @override
  void initState() {
    weatherData = widget.weatherModelData.weatherDailyList;
  // _activityServiceProvider = Provider.of<ActivityServiceProvider>(context, listen: false);
    super.initState();
   // getMyLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3DBE6E),
        //elevation: 2.0,
        title: const Text(textWeather,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: (weatherData.isNotEmpty)
          ? weatherDetails()
          : const Center(
            child: Text(textSomethingWrong),
          ),
    );
  }

  weatherDetails() {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.48,
          color: const Color(0xFF59DA7E),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_pin,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      _activityServiceProvider.getDeviceCityName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  '$textUpdatedTo ${DateFormat.yMMMMd().format(widget.weatherModelData.date)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white54,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 20),
                child: Text(
                  '${widget.weatherModelData.temperature ?? '0.0'} ${_activityServiceProvider.getIsCelsius ? tempInCelsius : tempInFahrenheit}',
                  style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Center(
                  child: Text(
                    widget.weatherModelData.currentDescription.toUpperCase(),
                    style: const TextStyle(fontSize: 30, color: Colors.white54),
                  )),
              const SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(2.0),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(textHumidity,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                // color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.0,
                                  color: Colors.white54),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/fit/humidity.png',
                                    width: 20.0,
                                    height: 20.0,
                                    fit: BoxFit.fill,
                                    color: Colors.white),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                    widget.weatherModelData.humidity
                                        .toString() +
                                        ' %'.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white54,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40.0,
                    child: VerticalDivider(
                      thickness: 1.0,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(2.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(textWindSpeed,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                // color: Colors.blue,
                                fontWeight: FontWeight.w600,
                                color: Colors.white54,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/fit/wind_speed.png',
                                  width: 20.0,
                                  height: 20.0,
                                  fit: BoxFit.fill,
                                  color: Colors.white54,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                    widget.weatherModelData.windSpeed
                                        .toStringAsFixed(1),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white54,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40.0,
                    child: VerticalDivider(
                      thickness: 1.0,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(2.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(textUVIndex,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                // color: Colors.blue,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.0,
                                color: Colors.white54,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/fit/cloudiness.png',
                                  width: 20.0,
                                  height: 20.0,
                                  fit: BoxFit.fill,
                                  color: Colors.white54,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                    widget.weatherModelData.stUVIStatus,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white54,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: Image.asset(
                  'assets/fit/my_clouds.png',
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,
                ),
              )
            ],
          ),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: weatherData.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              debugPrint('widget.weekData[index].date>> ${weatherData[index].date}');
              bool dateComparision = (weatherData[index].date.day == DateTime.now().day);
              debugPrint('dateComparision>> $dateComparision');
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            (dateComparision)
                                ? textToday
                                : "${DateFormat.E().format(weatherData[index].date)}  ",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            weatherData[index].description.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            '${weatherData[index].temperatureData.min.toStringAsFixed(2)} ${_activityServiceProvider.getIsCelsius ? tempInCelsius : tempInFahrenheit} ~ ${weatherData[index].temperatureData.max.toStringAsFixed(2)} ${_activityServiceProvider.getIsCelsius ? tempInCelsius : tempInFahrenheit}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 0.5,
                  )
                ],
              );
            },
          ),
        )
      ],
    );
  }

}
