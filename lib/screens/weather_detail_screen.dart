import 'package:flutter/material.dart';
import 'package:flutter_today_weather/components/constants.dart';
import 'package:flutter_today_weather/services/cityData.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherDetailScreen extends StatefulWidget {
  WeatherDetailScreen({this.weatherImageUrl, this.snapshotData});
  final String? weatherImageUrl;
  final CityData? snapshotData;
  // WeatherDetailScreen({
  //   this.weatherDataList,
  // });
  // final weatherDataList;
  @override
  _WeatherDetailScreenState createState() => _WeatherDetailScreenState();
}

class _WeatherDetailScreenState extends State<WeatherDetailScreen> {
  String? cityName;
  String? temp;
  String? feels_like;
  String? temp_min;
  String? temp_max;
  String? pressure;
  String? humidity;
  String? weather;
  String? weather_description;
  String? wind_speed;
  String? wind_deg;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateUI();
    print(pressure);
    print(humidity);
  }

  void updateUI() {
    setState(() {
      var _snapMain = widget.snapshotData?.main;
      var _snapWeather = widget.snapshotData?.weather;
      var _snapWind = widget.snapshotData?.wind;
      cityName = widget.snapshotData?.name;
      if (_snapMain != null) {
        temp = _snapMain[0];
        feels_like = _snapMain[1];
        temp_min = _snapMain[2];
        temp_max = _snapMain[3];
        pressure = _snapMain[4];
        humidity = _snapMain[5];
      }

      if (_snapWeather != null) {
        weather = _snapWeather[0];
        weather_description = _snapWeather[1];
      }

      if (_snapWind != null) {
        wind_speed = _snapWind[0];
        wind_deg = _snapWind[1];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    widget.weatherImageUrl != null ? Image.network(widget.weatherImageUrl!) : SizedBox.shrink(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        double.parse(temp ?? '').round().toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(16.0, 32.0, 0, 16.0),
                  child: Text(
                    "${weather_description}\nHave a nice day.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    TempWidget(
                      temp: temp_min ?? '-',
                      temp_label: "MIN",
                    ),
                    TempWidget(
                      temp: temp_max ?? '-',
                      temp_label: "MAX",
                    ),
                    TempWidget(
                      temp: feels_like ?? '-',
                      temp_label: "FEEL",
                    ),
                  ],
                ),
                LinearBar(
                  title: "PRESSURE",
                  value: (double.parse(pressure ?? '') / 1013.25),
                ),
                LinearBar(
                  title: "HUMIDITY",
                  value: (double.parse(humidity ?? '') / 100.0),
                ),
                Padding(
                  padding: const EdgeInsets.all(128.0),
                  child: Center(child: WindWidget(double.parse(wind_speed ?? ''), 65.0, Colors.white)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget WindWidget(double wind_speed, double size, Color color) {
  if (wind_speed >= 0 && wind_speed <= 0.2)
    return Icon(
      WeatherIcons.wind_beaufort_0,
      size: size,
      color: color,
    );
  else if (wind_speed >= 0.3 && wind_speed <= 1.5)
    return Icon(
      WeatherIcons.wind_beaufort_1,
      size: size,
      color: color,
    );
  else if (wind_speed >= 1.6 && wind_speed <= 3.3)
    return Icon(
      WeatherIcons.wind_beaufort_2,
      size: size,
      color: color,
    );
  else if (wind_speed >= 3.4 && wind_speed <= 5.4)
    return Icon(
      WeatherIcons.wind_beaufort_3,
      size: size,
      color: color,
    );
  else if (wind_speed >= 3.4 && wind_speed <= 5.4)
    return Icon(
      WeatherIcons.wind_beaufort_4,
      size: size,
      color: color,
    );
  else if (wind_speed >= 5.5 && wind_speed <= 7.9)
    return Icon(
      WeatherIcons.wind_beaufort_6,
      size: size,
      color: color,
    );
  else if (wind_speed >= 8.0 && wind_speed <= 10.7)
    return Icon(
      WeatherIcons.wind_beaufort_7,
      size: size,
      color: color,
    );
  else if (wind_speed >= 10.8 && wind_speed <= 13.8)
    return Icon(
      WeatherIcons.wind_beaufort_8,
      size: size,
      color: color,
    );
  else if (wind_speed >= 13.9 && wind_speed <= 17.1)
    return Icon(
      WeatherIcons.wind_beaufort_9,
      size: size,
      color: color,
    );
  else
    return Icon(
      WeatherIcons.wind_beaufort_10,
      size: size,
      color: color,
    );
}

class LinearBar extends StatelessWidget {
  const LinearBar({
    super.key,
    @required this.title,
    @required this.value,
  });

  final String? title;
  final double? value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title ?? '-',
              style: TextStyle(color: Colors.white),
            ),
          ),
          LinearPercentIndicator(
            width: MediaQuery.of(context).size.width - 100,
            animation: true,
            lineHeight: 20.0,
            animationDuration: 2500,
            percent: value != null
                ? value! >= 1.0
                    ? 1.0
                    : value!
                : 0.0,
            center: title == "PRESSURE" ? Text((value)!.roundToDouble().toString() + " atm") : Text((value ?? 0 * 100).round().toString() + "%"),
            linearStrokeCap: LinearStrokeCap.roundAll,
            progressColor: Colors.white,
            backgroundColor: Colors.lightBlueAccent,
          ),
        ],
      ),
    );
  }
}

class TempWidget extends StatelessWidget {
  const TempWidget({
    super.key,
    required this.temp,
    required this.temp_label,
  });

  final String temp;
  final String temp_label;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32.0),
          child: Text(temp_label, style: kTextTempStyle),
        ),
        Row(
          children: <Widget>[
            Icon(
              WeatherIcons.thermometer,
              color: Colors.white,
            ),
            Text(
              temp,
              style: TextStyle(color: Colors.white, fontSize: 18),
            )
          ],
        ),
      ],
    );
  }
}
