import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'About',
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Project Weather',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'This is an weather app thats developed as a project for the course IDV535 using Flutter and the OpenWeatherMap API.',
                  style: TextStyle(fontSize: 18.0),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Developed by Philip Persson \n phpersson@github',
                  style: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
