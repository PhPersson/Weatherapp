import 'package:flutter/material.dart';
import 'package:weatherapp/forecast.dart';
import 'main.dart';
import 'weatherpage.dart';
import 'about.dart';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentPage = 0;

  final List<Widget> _pages = [
    WeatherPage(),
    const ForecastPage(),
    const AboutPage(),
  ];

  void _onBottomNavbarTabbed(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _toggleTheme(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      WeatherApp.setThemeMode(context, ThemeMode.light);
    } else {
      WeatherApp.setThemeMode(context, ThemeMode.dark);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('WeatherApp'),
        actions: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline),
              Switch(
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: (_) => _toggleTheme(context),
              ),
              const Icon(Icons.nightlight_round),
            ],
          ),
        ],
      ),
      body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: _onBottomNavbarTabbed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'Forecast',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
      ),
    );
  }
}
