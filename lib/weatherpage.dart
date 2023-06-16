import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'env_variables.dart';
import 'package:intl/intl.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Map<String, dynamic>? weatherData;

  // Method to fetch weather data
  Future<void> fetchWeatherData() async {
    const apiKey = EnvVariables.apiKey;
    const latitude = '55.60587';
    const longitude = "13.00073";

    const url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          weatherData = jsonData;
        });
      } else {
        log('Failed to fetch weather data. Error code: ${response.statusCode}');
      }
    } catch (e) {
      log('Failed to fetch weather data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    const rainBlueLight = Color(0xFF4480C6);
    const rainBlueDark = Color.fromARGB(255, 75, 97, 207);
    const rainGradient = [rainBlueLight, rainBlueDark];
    final currentTime = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: rainGradient,
            ),
          ),
          child: weatherData != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${weatherData!['name']} ${weatherData!['main']['temp']}°C',
                          style: const TextStyle(fontSize: 40),
                        ),
                        const Icon(
                          Icons.thermostat,
                          size: 30,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(
                          _getWeatherIcon(weatherData!['weather'][0]['id']),
                          size: 60,
                        ),
                        Text(
                          '${weatherData!['weather'][0]['description']}',
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'But it feels like: ${weatherData!['main']['feels_like']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const Icon(Icons.thermostat)
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Wind: ${weatherData!['wind']['speed']}m/s',
                              style: const TextStyle(fontSize: 18),
                            ),
                            const Icon(Icons.air),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Direction: ${weatherData!['wind']['deg']}',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            const Icon(
                              Icons.navigation,
                              size: 24,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      currentTime,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }

  IconData _getWeatherIcon(int weatherId) {
    weatherId = 800;
    if (weatherId >= 500 && weatherId <= 504) {
      return Icons.grain;
    } else if (weatherId >= 701 && weatherId <= 781) {
      return Icons.foggy;
    } else if (weatherId == 800) {
      return Icons.sunny;
    } else if (weatherId >= 801 && weatherId <= 804) {
      return Icons.wb_cloudy;
    }
    return Icons.error;
  }
}
