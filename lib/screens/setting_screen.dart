import 'package:flutter/material.dart';
import 'package:flutter_today_weather/components/reuseable_card.dart';
import 'package:flutter_today_weather/screens/home_screen.dart';
import 'package:flutter_today_weather/services/cityDataProvider.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  SharedPreferences? sharedPrefs;
  List<String> cityCheckList = [];
  List<String> cityListTitles = [];
  @override
  void initState() {
    super.initState();
    updating();
  }

  void updating() async {
    sharedPrefs = await SharedPreferences.getInstance();

    List<String> cityUseValues = [];
    cityCheckList = [];
    cityListTitles = [];
    cityCheckList = sharedPrefs?.getStringList("pref_city_list_check") ?? [];
    cityListTitles = sharedPrefs?.getStringList("pref_city_list_titles") ?? [];
    print(cityListTitles);
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cityBloc = CityDataProvider.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 30,
                ),
                onPressed: () {
                  print(cityCheckList);
                  cityBloc.getCityData(cityUseValues);
                  setState(() {});
                  Get.back();
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Select city to show on',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: cityCheckList.length,
                  itemBuilder: (context, index) {
                    return ReuseableCard(
                      onPressed: () async {
                        cityUseValues.clear();
                        sharedPrefs = await SharedPreferences.getInstance();
                        cityCheckList[index] == "false" ? cityCheckList[index] = "true" : cityCheckList[index] = "false";
                        await sharedPrefs?.setStringList("pref_city_list_check", cityCheckList);
                        setState(() {});
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
                            print('작동');
                            cityBloc.getCityData(cityUseValues);
                          }
                        }
                        setState(() {});
                        // setState(() {});
                      },
                      color: cityCheckList[index] == "true" ? Colors.lightBlue.shade200 : Colors.grey.shade200,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.fromLTRB(16, 20, 16, 25),
                      cardChild: Text(cityListTitles[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
