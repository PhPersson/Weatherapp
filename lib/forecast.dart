import 'package:flutter/material.dart';


class ForecastPage extends StatefulWidget {
  const ForecastPage({super.key});

  @override
  _ForecastPageState createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('ForeCast page'),
      ),
    );
  }
}
