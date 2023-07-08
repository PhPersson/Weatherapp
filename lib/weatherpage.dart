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
  bool isLoading = true;

  Future<void> fetchWeatherData() async {
    Position position = await fetchGeolocation();
    var apiKey = EnvVariables.apiKey;
    var latitude = position.latitude;
    var longitude = position.longitude;

    var url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';
    await Future.delayed(Duration(seconds: 2));
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var weather = json.decode(response.body);
        setState(() {
          weatherData = weather;
          isLoading = false;
        });
      } else {
        log('Failed to fetch weather data. Error code: ${response.statusCode}');
      }
    } catch (error) {
      log('Failed to fetch weather data: $error ');
    }
  }

  Future<Position> fetchGeolocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: (() {
            if (isLoading) {
              return CircularProgressIndicator(color: Colors.black);
            } else if (weatherData != null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Weather(
                    text:
                        '${weatherData!['name']} ${weatherData!['main']['temp']}°C',
                    icon: Icons.thermostat,
                    textStyle: TextStyle(fontSize: 40),
                  ),
                  _Weather(
                    text: '${weatherData!['weather'][0]['description']}',
                    icon: _getWeatherIcon(weatherData!['weather'][0]['id']),
                    textStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  _Weather(
                    text:
                        'But it feels like: ${weatherData!['main']['feels_like']}',
                    icon: Icons.thermostat,
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _Weather(
                        text: 'Wind: ${weatherData!['wind']['speed']}m/s',
                        textStyle: TextStyle(fontSize: 18),
                        icon: Icons.air,
                      ),
                      _Weather(
                        text: 'Direction: ${weatherData!['wind']['deg']}°',
                        icon: Icons.navigation,
                        iconSize: 24,
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Text(
                    currentTime,
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Failed to fetch weather data',
                  ),
                  ElevatedButton(
                    onPressed: fetchWeatherData,
                    child: Text('Retry'),
                  ),
                ],
              );
            }
          })(),
        ),
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

class _Weather extends StatelessWidget {
  final String text;
  final IconData icon;
  final TextStyle textStyle;
  final double iconSize;

  _Weather({
    required this.text,
    required this.icon,
    required this.textStyle,
    double iconSize = 24,
  }) : iconSize = iconSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: textStyle,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            size: iconSize,
          ),
        ),
      ],
    );
  }
}
