import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/weather_data_model.dart';

const String _apiKey = 'c23d6b16f649e92cc3446e80e5ec6c0d';

class Service {
  var response;

  Future<dynamic> getCityWeather(String cityName) async {
    http.Response response = await http.get(
        'http://api.openweathermap.org/data/2.5/weather?q=$cityName&units=metric&appid=${_apiKey}&units=metric');
    var weatherData = response.body;
    var name = jsonDecode(weatherData)['name'];
    var temp = jsonDecode(weatherData)['main']['temp'];
    var cond = jsonDecode(weatherData)['weather'][0]['main'];
    print('$name $temp $cond');
    return weatherData;
  }

  buildWeatherData() async {
    var results = await response.body;
    var cityName = jsonDecode(results)['name'];
    var cityTemp = jsonDecode(results)['main']['temp'];
    var cityCond = jsonDecode(results)['weather'][0]['main'];
    WeatherDataModel weatherData = WeatherDataModel(
      name: cityName,
      temp: cityTemp,
      conditon: cityCond,
    );
  }
}
