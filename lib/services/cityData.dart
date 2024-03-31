class CityData {
  CityData({
    this.main,
    this.weather,
    this.wind,
    this.name,
  });
  List<String>? main = [];
  List<String>? weather = [];
  List<String>? wind = [];
  String? name;
  CityData.fromJson(Map json)
      : main = [
          json["main"]["temp"].toString(),
          json["main"]["feels_like"].toString(),
          json["main"]["temp_min"].toString(),
          json["main"]["temp_max"].toString(),
          json["main"]["pressure"].toString(),
          json["main"]["humidity"].toString(),
        ],
        weather = [
          json["weather"][0]["main"].toString(),
          json["weather"][0]["description"].toString(),
          json["weather"][0]["icon"].toString(),
        ],
        wind = [
          json["wind"]["speed"].toString(),
          json["wind"]["deg"].toString(),
        ];
}
