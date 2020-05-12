import 'dart:async';
import 'package:flutter_today_weather/services/weather.dart';
import 'cityData.dart';

class CityDataBloc {
  CityDataBloc(this.weatherModel);
  final WeatherModel weatherModel;
  StreamController<List<CityData>> ctrl = StreamController();
  Stream<List<CityData>> get results => ctrl.stream;
  void dispose() {
    ctrl.close();
  }

  void getCityData(List<String> cityIds) {
    weatherModel.getCityWeather(cityIds).then((citiesData) {
      ctrl.add(citiesData);
    });
  }
}
