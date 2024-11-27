import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weahter_app/additional_info_item.dart';
import 'package:weahter_app/hourly_forecast_item.dart';
import 'package:http/http.dart' as http;
import 'package:weahter_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  String cityName = 'London';
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKEY'),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'An unexpected error occurred';
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(68, 28, 70, 206),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(43, 23, 22, 112),
        title: const Text(
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            'Weather App'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather = getCurrentWeather();
              });
            },
            icon: const Icon(
              Icons.refresh_rounded,
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }
          var data = snapshot.data!;
          final currentWeatherData = data['list'][0];
          double currentTemp = (currentWeatherData['main']['temp']) - 273.15;

          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentHumidity = currentWeatherData['main']['humidity'];
          final currentWind = currentWeatherData['wind']['speed'];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Main card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    color: const Color.fromARGB(96, 23, 22, 112),
                    elevation: 20,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          16,
                        ),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                  style: const TextStyle(
                                    fontSize: 20,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                  cityName),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  '${currentTemp.toStringAsFixed(1)} °C'),
                              const SizedBox(
                                height: 16,
                              ),
                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 64,
                                color: Colors.lightBlueAccent,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                  currentSky),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 20,
                ),
                //Weather foreacast card
                const Text(
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    'Hourly Forecast'),
                Container(
                  height: 8,
                ),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    itemCount: 35,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final hourlyForecast = data['list'][index + 1];
                      final hourlySky = hourlyForecast['weather'][0]['main'];
                      final hourlyTemp = hourlyForecast['main']['temp'];
                      final time = DateTime.parse(hourlyForecast['dt_txt']);
                      return HourlyforecastItem(
                        icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                            ? Icons.cloud
                            : Icons.sunny,
                        time: DateFormat.jm().format(time),
                        temperature: (hourlyTemp - 273.15),
                      );
                    },
                  ),
                ),
                Container(
                  height: 20,
                ),
                //Additional information
                const Text(
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    'Additional Information'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfo(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: '${currentHumidity.toString()} %',
                      color: Colors.blue,
                    ),
                    AdditionalInfo(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: currentWind.toString(),
                      color: Colors.lightGreen,
                    ),
                    AdditionalInfo(
                      icon: Icons.beach_access_sharp,
                      label: 'Pressure',
                      value: currentPressure.toString(),
                      color: Colors.deepPurpleAccent,
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
