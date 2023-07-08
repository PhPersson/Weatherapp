import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'env_variables.dart';

class ForecastPage extends StatefulWidget {
  const ForecastPage({super.key});

  @override
  _ForecastPageState createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  List<dynamic> forecastList = [];
  var cityName = '';

  Future<void> fetchForecastData() async {
    Position position = await fetchGeolocation();
    var apiKey = EnvVariables.apiKey;
    var latitude = position.latitude;
    var longitude = position.longitude;
    final url =
        'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      final forecastResponse = json.decode(response.body);

      setState(() {
        forecastList = forecastResponse['list'];
        cityName = forecastResponse['city']['name'];
      });
    } catch (error) {
      log('Error fetching forecast data: $error');
    }
  }

  Future<Position> fetchGeolocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    fetchForecastData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                cityName,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: forecastList.length,
                itemBuilder: (context, index) {
                  var forecast = forecastList[index];
                  return Column(
                    children: [
                      _ForeCast(
                        text: '${forecast['dt_txt']}',
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (forecast['weather'] != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _ForeCast(
                              text: '${forecast['main']['temp']}°C',
                              textStyle:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              icon:
                                  _getWeatherIcon(forecast['weather'][0]['id']),
                            ),
                            _ForeCast(
                              text: '${forecast['weather'][0]['description']}',
                              textStyle:
                                  const TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _ForeCast(
                            text: 'Wind: ${forecast['wind']['speed']}m/s',
                            icon: Icons.air,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

IconData _getWeatherIcon(int weatherId) {
  // The list of what the weather id:s corresponds to can be found at https://openweathermap.org/weather-conditions
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

class _ForeCast extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final IconData? icon;
  final double iconSize;

  _ForeCast({
    required this.text,
    this.icon,
    this.textStyle,
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
