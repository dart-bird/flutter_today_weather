import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UpdateUI();
  }

  void UpdateUI() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // print(sharedPreferences.getStringList("pref_city_list_values"));
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
