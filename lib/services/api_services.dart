import 'package:http/http.dart' as http; //for network call
import 'package:weather/consts/strings.dart';
import 'package:weather/models/current_weather_model.dart';
import 'package:weather/models/hourly_weather_model.dart';

//var Currentlink = "https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}";
//var currentLink = "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric";
//var hourlyLink = "https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric";

getCurrentWeather(lat,long) async{
  var currentLink = "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=$apiKey&units=metric";
  var res = await http.get(Uri.parse(currentLink));
  if(res.statusCode == 200){
    var data = currentWeatherDataFromJson(res.body.toString());
    print("Current Data is received");
    return data;
  }
}

getHourlyWeather(lat,long) async{
  var hourlyLink = "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$long&appid=$apiKey&units=metric";
  var res = await http.get(Uri.parse(hourlyLink));
  if(res.statusCode == 200){
    var data = hourlyWeatherDataFromJson(res.body.toString());
    print("Hourly Data is received");
    return data;
  }
}