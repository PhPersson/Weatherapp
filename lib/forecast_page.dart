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
  List<dynamic> forecastData = [];
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
      final jsonData = json.decode(response.body);

      final forecastList = jsonData['list'];

      setState(() {
        forecastData = forecastList;
        cityName = jsonData['city']['name'];
      });
    } catch (error) {
      log('Error fetching forecast data: $error');
    }
  }

  Future<Position> fetchGeolocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
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
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              cityName,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: forecastData.length,
              itemBuilder: (context, index) {
                var forecast = forecastData[index];
                return Column(
                  children: [
                    Text(
                      '${forecast['dt_txt']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (forecast['weather'] != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          _getWeatherIcon(forecast['weather'][0]['id']),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${forecast['main']['temp']}°C',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${forecast['weather'][0]['description']}',
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('${forecast['wind']['speed']}m/s'),
                        ),
                        const Icon(Icons.air),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
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
