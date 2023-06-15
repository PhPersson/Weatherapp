import 'package:flutter/material.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  static void setThemeMode(BuildContext context, ThemeMode themeMode) {
    final _WeatherAppState state =
        context.findAncestorStateOfType<_WeatherAppState>()!;
    state.setThemeMode(themeMode);
  }

  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void setThemeMode(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        backgroundColor: Colors.amberAccent,
        title: const Text('Weather App'),
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
      bottomNavigationBar: BottomNavigationBar(
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
