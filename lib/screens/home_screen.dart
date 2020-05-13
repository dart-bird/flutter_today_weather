import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_today_weather/components/reuseable_card.dart';
import 'package:flutter_today_weather/screens/setting_screen.dart';
import 'package:flutter_today_weather/screens/weather_detail_screen.dart';
import 'package:flutter_today_weather/services/cityData.dart';
import 'package:flutter_today_weather/services/cityDataProvider.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
bool useInternet = true;

class _HomeScreenState extends State<HomeScreen> {
  RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    prepareUserSetting();
    updateUI();
    checkInternetConnection();
    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _refreshController.dispose();
  }

  void updateUI() async {
    sharedPrefs = await SharedPreferences.getInstance();
    cityCheckList = sharedPrefs.getStringList("pref_city_list_check");
    setState(() {});
  }

  void checkInternetConnection() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      setState(() {
        useInternet = false;
      });
    } else {
      setState(() {
        useInternet = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cityBloc = CityDataProvider.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          header: WaterDropMaterialHeader(
            color: Colors.lightBlue,
            backgroundColor: Colors.white,
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 42, 35, 24),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Today Weather',
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
              useInternet == false
                  ? AlertInternetWarning()
                  : StreamBuilder(
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
      ),
    );
  }

  void _onRefresh() async {
    await prepareUserSetting();
    updateUI();
    checkInternetConnection();
    getData();
    _refreshController.refreshCompleted();
  }

  void getData() async {
    final cityBloc = CityDataProvider.of(context);
    sharedPrefs = await SharedPreferences.getInstance();

    await prepareUserSetting();
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

class AlertInternetWarning extends StatelessWidget {
  const AlertInternetWarning({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.lightBlue[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: new Text(
        "OFFLINE",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 25,
        ),
      ),
      content: new Text(
        "Check Internet Connection",
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        new FlatButton(
          child: new Text(
            "Close",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          onPressed: () {
            exit(0);
          },
        ),
      ],
    );
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
// // user defined function
// class _showInternetWarning(BuildContext context) {
//   // flutter defined function
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       // return object of type Dialog
//       return AlertDialog(
//         title: new Text("OFFLINE"),
//         content: new Text(
//           "Check Internet Connection",
//           style: TextStyle(color: Colors.red),
//         ),
//         actions: <Widget>[
//           // usually buttons at the bottom of the dialog
//           new FlatButton(
//             child: new Text("Close"),
//             onPressed: () {
//               exit(0);
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
// }
