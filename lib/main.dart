import 'package:flutter/material.dart';
import 'package:flutter_today_weather/screens/home_screen.dart';
import 'package:flutter_today_weather/services/cityDataBloc.dart';
import 'package:flutter_today_weather/services/cityDataProvider.dart';
import 'package:flutter_today_weather/services/weather.dart';
import 'package:get/get.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CityDataProvider(
      cityDataBloc: CityDataBloc(WeatherModel()),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Today Weather',
        home: HomeScreen(),
      ),
    );
  }
}
