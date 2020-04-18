import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class WeatherData {
  final String city;
  final String country;
  final String type;
  final String description;

  final int humidity;
  final int pressure;

  final double temp;
  final double tempMin;
  final double tempMax;
  final double tempFeelsLike;

  WeatherData({this.city, this.country, this.type, this.description, this.temp, this.tempMin, this.tempMax, this.tempFeelsLike, this.humidity, this.pressure});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> main = json['main'];
    return WeatherData(
      city: json['name'],
      country: json['sys']['country'],
      type: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      temp: main['temp'].toDouble(),
      tempMin: main['temp_min'].toDouble(),
      tempMax: main['temp_max'].toDouble(),
      tempFeelsLike: main['feels_like'],
      humidity: main['humidity'],
      pressure: main['pressure']
    );
  }
}

class WeatherApi {
  final String apiKey = '4470552a8e56d137826edb2a80b575d2';
  WeatherData lastData;

  Future<WeatherData> getWeather(String city) async {
    final response = await http.get('https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey');

    final body = json.decode(response.body);

    if (response.statusCode == 200) {
      WeatherData data = WeatherData.fromJson(body);
      lastData = data;
      return data;
    } else {
      Fluttertoast.showToast(
          msg: body['message'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.grey[100],
          textColor: Colors.grey[900],
          fontSize: 20.0
      );
      return lastData;
    }
  }

  Future<WeatherData> getWeatherFromPos(Position pos) async {
    final lat = pos.latitude;
    final lon = pos.longitude;
    final response = await http.get('https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey');

    final body = json.decode(response.body);

    if (response.statusCode == 200) {
      WeatherData data = WeatherData.fromJson(body);
      lastData = data;
      return data;
    } else {
      Fluttertoast.showToast(
          msg: body['message'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.grey[100],
          textColor: Colors.grey[900],
          fontSize: 20.0
      );
      return lastData;
    }
  }
}