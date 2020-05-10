import 'package:flutter/material.dart';
import 'package:flutter_today_weather/components/reuseable_card.dart';
import 'package:flutter_today_weather/search_screen.dart';
import 'package:flutter_today_weather/weather_detail_screen.dart';
import 'package:get/get.dart';
import 'package:weather_icons/weather_icons.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(35, 24, 0, 0),
            //   child: IconButton(
            //     icon: Icon(
            //       Icons.menu,
            //       size: 30,
            //     ),
            //     onPressed: () {},
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 42, 35, 24),
              child: Row(
                children: <Widget>[
                  Text(
                    '오늘의 날씨 정보예요~',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      size: 30,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Get.to(SearchScreen());
                    },
                  ),
                ],
              ),
            ),

            ReuseableCard(
              color: Colors.blue[300],
              onPressed: () {
                Get.to(WeatherDetailScreen());
              },
              cardChild: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Hero(
                        tag: 'day_sunny',
                        child: Icon(
                          WeatherIcons.day_sunny,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text('부산',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
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
                          '22.0',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text('맑음',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
