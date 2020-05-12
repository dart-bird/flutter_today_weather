import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_icons/weather_icons.dart';

import 'cityData.dart';
import 'networking.dart';

const apiKey = '7723b145638825f5ac932ecab49666e7';
const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherModel {
  Future<List<CityData>> getCityWeather(List<String> cityIds) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    List<CityData> cityDataList = List<CityData>();
    List<String> cityListTitle = List<String>();
    List<String> cityListValue = List<String>();
    try {
      cityDataList.clear();
      print(cityIds.length);
      print(cityIds);
      cityListTitle = sharedPrefs.getStringList("pref_city_list_titles");
      cityListValue = sharedPrefs.getStringList("pref_city_list_values");
      int i = 0;
      for (var cityId in cityIds) {
        i = 0;
        for (var item in cityListValue) {
          if (item == cityId) {
            var url = '$openWeatherMapURL?id=$cityId&appid=$apiKey&units=metric';
            NetWorkHelper netWorkHelper = NetWorkHelper(url);
            var weatherData = await netWorkHelper.getData();
            final _weatherDataMain = weatherData["main"];
            final _weatherDataWeather = weatherData["weather"][0];
            final _weatherDataWind = weatherData["wind"];
            CityData cityData = CityData(
              main: [
                _weatherDataMain["temp"].toString(),
                _weatherDataMain["feels_like"].toString(),
                _weatherDataMain["temp_min"].toString(),
                _weatherDataMain["temp_max"].toString(),
                _weatherDataMain["pressure"].toString(),
                _weatherDataMain["humidity"].toString(),
              ],
              weather: [
                _weatherDataWeather["main"].toString(),
                _weatherDataWeather["description"].toString(),
                _weatherDataWeather["icon"].toString(),
              ],
              wind: [
                _weatherDataWind["speed"].toString(),
                _weatherDataWind["deg"].toString(),
              ],
              name: cityListTitle[i],
            );
            cityDataList.add(cityData);
          }
          i++;
        }
      }
      return cityDataList;
      // for (var cityId in cityIds) {
      //   var url = '$openWeatherMapURL?id=$cityId&appid=$apiKey&units=metric';
      //   NetWorkHelper netWorkHelper = NetWorkHelper(url);
      //   var weatherData = await netWorkHelper.getData();
      //   final _weatherDataMain = weatherData["main"];
      //   final _weatherDataWeather = weatherData["weather"][0];
      //   final _weatherDataWind = weatherData["wind"];
      //   CityData cityData = CityData(
      //     main: [
      //       _weatherDataMain["temp"].toString(),
      //       _weatherDataMain["feels_like"].toString(),
      //       _weatherDataMain["temp_min"].toString(),
      //       _weatherDataMain["temp_max"].toString(),
      //       _weatherDataMain["pressure"].toString(),
      //       _weatherDataMain["humidity"].toString(),
      //     ],
      //     weather: [
      //       _weatherDataWeather["main"].toString(),
      //       _weatherDataWeather["description"].toString(),
      //     ],
      //     wind: [
      //       _weatherDataWind["speed"].toString(),
      //       _weatherDataWind["deg"].toString(),
      //     ],
      //     name: cityListTitle[i],
      //   );
      //   cityDataList.add(cityData);
      //   i++;
      // }
    } catch (e) {
      print(e);
    }

    return cityDataList;
  }

  dynamic getWeatherIcon(int condition) {
    if (condition < 300) {
      return WeatherIcons.lightning;
    } else if (condition < 400) {
      return WeatherIcons.rain;
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
