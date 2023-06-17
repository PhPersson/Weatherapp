import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'env_variables.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quickalert/quickalert.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Map<String, dynamic>? weatherData;

  Future<void> fetchWeatherData() async {
    Position position =
        await fetchGeolocation(); //The variable of position needs to wait for the method to get the users location first
    var apiKey = EnvVariables.apiKey;
    var latitude = position.latitude;
    var longitude = position.longitude;

    var url =
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
    } catch (error) {
      log('Failed to fetch weather data: $error');
    }
  }

Future<Position> fetchGeolocation() async {
  LocationPermission permission = await Geolocator.checkPermission();
  permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Could not get your position!',
        text: 'It seems like location permissions are denied for this app!',
      );
      permission = await Geolocator.requestPermission();
    } 
  return await Geolocator.getCurrentPosition();
}


  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    final currentTime = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return Scaffold(
      body: Center(
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
                              'Direction: ${weatherData!['wind']['deg']}°',
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
    );
  }

  IconData _getWeatherIcon(int weatherId) {
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
