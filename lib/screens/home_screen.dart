import 'package:flutter/material.dart';
import 'package:flutter_today_weather/components/reuseable_card.dart';
import 'package:flutter_today_weather/screens/setting_screen.dart';
import 'package:flutter_today_weather/screens/weather_detail_screen.dart';
import 'package:flutter_today_weather/services/cityData.dart';
import 'package:flutter_today_weather/services/cityDataProvider.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_icons/weather_icons.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// List<CityData> weatherDataList = List<CityData>();
List<String> cityUseValues = List<String>();
List<String> cityListTitles = List<String>();
List<String> cityListValues = List<String>();
List<String> cityCheckList = List<String>();
SharedPreferences sharedPrefs;

class _HomeScreenState extends State<HomeScreen> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    prepareUserSetting();
    updateUI();
    getData();
  }

  void updateUI() async {
    sharedPrefs = await SharedPreferences.getInstance();
    cityCheckList = sharedPrefs.getStringList("pref_city_list_check");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cityBloc = CityDataProvider.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 42, 35, 24),
              child: Row(
                children: <Widget>[
                  Text(
                    'Today\'s Weather',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  GestureDetector(
                    onTap: () async {
                      await Get.to(SettingScreen());
                    },
                    child: Icon(
                      Icons.settings,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder(
                stream: cityBloc.results,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data.length == 0) {
                    return Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 235,
                        ),
                        child: Text(
                          'Please setting to show weather',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return _buildListTile(snapshot, index);
                          }),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }

  void getData() async {
    final cityBloc = CityDataProvider.of(context);
    sharedPrefs = await SharedPreferences.getInstance();

    prepareUserSetting();
    cityListValues = sharedPrefs.getStringList("pref_city_list_values");
    cityCheckList = sharedPrefs.getStringList("pref_city_list_check");
    print(cityListValues);
    print(cityCheckList); // 왜 출력하면 내용이 있고 출력안하면 내용이 없지?

    int i = 0;
    cityUseValues.clear();
    for (var isCheck in cityCheckList) {
      if (isCheck == "true") {
        cityUseValues.add(cityListValues[i]);
      }
      i++;
    }
    for (var isCheck in cityCheckList) {
      if (isCheck == "true") {
        cityBloc.getCityData(cityUseValues);
      }
    }
  }
}

Widget _buildListTile(AsyncSnapshot snapshot, int index) {
  var temp = snapshot.data[index].main[0] ?? "Cannot connect from server";
  var cityName = snapshot.data[index].name ?? "Cannot connect from server";
  var weatherName = snapshot.data[index].weather[0] ?? "Cannot connect from server";
  var weatherIcon = snapshot.data[index].weather[2] ?? "Cannot connect from server";
  return CityBox(
    cityName: cityName,
    temp: temp,
    weatherName: weatherName,
    weatherImageUrl: "http://openweathermap.org/img/wn/$weatherIcon@2x.png",
    snapshotData: snapshot.data[index],
  );
}

class CityBox extends StatelessWidget {
  CityBox({this.cityName, this.temp, this.weatherName, this.weatherImageUrl, this.snapshotData});
  String cityName;
  String temp;
  String weatherName;
  String weatherImageUrl;
  CityData snapshotData;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Get.to(WeatherDetailScreen(weatherImageUrl: weatherImageUrl, snapshotData: snapshotData));
      },
      child: ReuseableCard(
        color: Colors.blue[300],
        cardChild: Row(
          children: <Widget>[
            Container(height: 50, child: Image.network(weatherImageUrl)),
            SizedBox(
              width: 20,
            ),
            Text(cityName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(
              width: 10,
            ),
            Column(
              children: <Widget>[
                Icon(
                  WeatherIcons.thermometer_internal,
                  size: 22,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              temp,
              overflow: TextOverflow.fade,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                decoration: TextDecoration.none,
              ),
            ),
            Expanded(child: SizedBox()),
            Text(weatherName,
                overflow: TextOverflow.fade,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                )),
          ],
        ),
      ),
    );
  }
}

Future<void> prepareUserSetting() async {
  sharedPrefs = await SharedPreferences.getInstance();
  try {
    sharedPrefs.getStringList("pref_city_list_values") ?? await sharedPrefs.setStringList("pref_city_list_values", ["1835847", "1835235", "1835327", "1838524"]);
    sharedPrefs.getStringList("pref_city_list_titles") ?? await sharedPrefs.setStringList("pref_city_list_titles", ["Seoul", "Daejeon", "Taegu", "Busan"]);
    sharedPrefs.getStringList("pref_city_list_check") ?? await sharedPrefs.setStringList("pref_city_list_check", ["false", "false", "false", "false"]);
  } catch (e) {
    print(e);
  }
}
