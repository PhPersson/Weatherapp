import 'package:flutter/material.dart';
import 'main.dart';
import 'weatherpage.dart';
import 'about.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  void _toggleTheme(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      WeatherApp.setThemeMode(context, ThemeMode.light);
    } else {
      WeatherApp.setThemeMode(context, ThemeMode.dark);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color appBarColor =  Color(0xFF4480C6); 
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  appBarColor,
        title: const Text('WeatherApp'),
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.info),
                      title: const Text('About'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const AboutPage()));

                      },
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Darkmode'),
                      Row(
                        children: [
                          const Icon(Icons.lightbulb_outline),
                          Switch(
                            value:
                                Theme.of(context).brightness == Brightness.dark,
                            onChanged: (_) => _toggleTheme(context),
                          ),
                          const Icon(Icons.nightlight_round),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: WeatherPage(),
    );
  }
}
