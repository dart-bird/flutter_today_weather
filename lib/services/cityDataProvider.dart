import 'package:flutter/material.dart';
import 'package:flutter_today_weather/services/cityDataBloc.dart';
import 'package:flutter_today_weather/services/weather.dart';

class CityDataProvider extends InheritedWidget {
  final CityDataBloc cityDataBloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
  static CityDataBloc of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<CityDataProvider>()?.cityDataBloc ?? CityDataBloc(WeatherModel());

  CityDataProvider({super.key, CityDataBloc? cityDataBloc, required child})
      : this.cityDataBloc = cityDataBloc ?? CityDataBloc(WeatherModel()),
        super(child: child);
}
