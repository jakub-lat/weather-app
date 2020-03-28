import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class WeatherData {
  final String city;
  final String icon;

  final int humidity;
  final int pressure;

  final double temp;
  final double tempMin;
  final double tempMax;
  final double tempFeelsLike;

  WeatherData({this.city, this.icon, this.temp, this.tempMin, this.tempMax, this.tempFeelsLike, this.humidity, this.pressure});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> main = json['main'];
    return WeatherData(
      city: json['name'],
      icon: json['icon'],
      temp: double.parse(main['temp']),
      tempMin: double.parse(main['temp_min']),
      tempMax: double.parse(main['temp_max']),
      tempFeelsLike: main['feels_like'],
      humidity: main['humidity'],
      pressure: main['pressure']
    );
  }
}

class WeatherApi {
  final String apiKey = '4470552a8e56d137826edb2a80b575d2';

  Future<WeatherData> getWeather(String city) async {
    final response = await http.get('https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey');

    if (response.statusCode == 200) {
      return WeatherData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get weather');
    }
  }
}