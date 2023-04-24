// To parse this JSON data, do
//
//     final hourlyWeatherData = hourlyWeatherDataFromJson(jsonString);

import 'dart:convert';

HourlyWeatherData hourlyWeatherDataFromJson(String str) => HourlyWeatherData.fromJson(json.decode(str));

class HourlyWeatherData {
  HourlyWeatherData({
    required this.cod,
    required this.message,
    required this.cnt,
    required this.list,
    required this.city,
  });

  String cod;
  int message;
  int cnt;
  List<ListElement> list;
  City city;

  factory HourlyWeatherData.fromJson(Map<String, dynamic> json) => HourlyWeatherData(
    cod: json["cod"],
    message: json["message"],
    cnt: json["cnt"],
    list: List<ListElement>.from(json["list"].map((x) => ListElement.fromJson(x))),
    city: City.fromJson(json["city"]),
  );

}

class City {
  City({
    required this.name,
    required this.coord,
    required this.country,
  });

  String name;
  Coord coord;
  String country;

  factory City.fromJson(Map<String, dynamic> json) => City(
    name: json["name"],
    coord: Coord.fromJson(json["coord"]),
    country: json["country"],
  );

}

class Coord {
  Coord({
    required this.lat,
    required this.lon,
  });

  double lat;
  double lon;

  factory Coord.fromJson(Map<String, dynamic> json) => Coord(
    lat: json["lat"].toDouble(),
    lon: json["lon"].toDouble(),
  );

}

class ListElement {
  ListElement({
    required this.dt,
    required this.main,
    required this.weather,
    required this.clouds,
    required this.wind,
    required this.dtTxt,
  });

  int dt;
  MainClass main;
  List<Weather> weather;
  Clouds clouds;
  Wind wind;
  DateTime dtTxt;

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
    dt: json["dt"],
    main: MainClass.fromJson(json["main"]),
    weather: List<Weather>.from(json["weather"].map((x) => Weather.fromJson(x))),
    clouds: Clouds.fromJson(json["clouds"]),
    wind: Wind.fromJson(json["wind"]),
    dtTxt: DateTime.parse(json["dt_txt"]),
  );

}

class Clouds {
  Clouds({
    required this.all,
  });

  int all;

  factory Clouds.fromJson(Map<String, dynamic> json) => Clouds(
    all: json["all"],
  );
}

class MainClass {
  MainClass({
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
  });

  double temp;
  double tempMin;
  double tempMax;
  int humidity;

  factory MainClass.fromJson(Map<String, dynamic> json) => MainClass(
    temp: json["temp"].toDouble(),
    tempMin: json["temp_min"].toDouble(),
    tempMax: json["temp_max"].toDouble(),
    humidity: json["humidity"],
  );

}

class Weather {
  Weather({
    required this.id,
    required this.icon,
  });

  int id;
  String icon;

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
    id: json["id"],
    icon: json["icon"],
  );
}

class Wind {
  Wind({
    required this.speed,
    required this.deg,
  });

  double speed;
  int deg;

  factory Wind.fromJson(Map<String, dynamic> json) => Wind(
    speed: json["speed"].toDouble(),
    deg: json["deg"],
  );
}

