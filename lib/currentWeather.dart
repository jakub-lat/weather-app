import 'package:flutter/material.dart';
import 'weather.dart';

class CurrentWeather extends StatefulWidget {
  final String city;

  CurrentWeather({this.city});

  @override
  CurrentWeatherState createState() => CurrentWeatherState();
}

class CurrentWeatherState extends State<CurrentWeather> {
  WeatherApi api = new WeatherApi();
  Future<WeatherData> weather;

  @override
  void initState() {
    super.initState();
  }

  void update(String city) {
    weather = api.getWeather(city);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          FutureBuilder(
            future: weather, 
            builder:(BuildContext context, AsyncSnapshot<WeatherData> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return new Text('Select a city to start');
                case ConnectionState.waiting:
                  return new Center(child: new CircularProgressIndicator());
                case ConnectionState.active:
                  return new Text('');
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return new Text(
                      '${snapshot.error}',
                      style: TextStyle(color: Colors.red),
                    );
                  } else {
                    return new Row(children: <Widget>[
                      Text(snapshot.data.city)
                    ],);
                  }
              }
            })
        ],
      )
    );
  }
}