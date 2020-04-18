import 'package:flutter/material.dart';
import 'weather.dart';
import 'package:geolocator/geolocator.dart';

class CurrentWeather extends StatefulWidget {
  final String city;
  final Position position;
  final bool useLocation;

  CurrentWeather({this.city, this.position, this.useLocation});

  @override
  CurrentWeatherState createState() => CurrentWeatherState();
}

class CurrentWeatherState extends State<CurrentWeather> {
  WeatherApi api = new WeatherApi();
  Future<WeatherData> weather;
  String lastCity;
  String weatherType = 'Clear';

  @override
  void initState() {
    super.initState();
  }

  void update(String city) async {
    weather = api.getWeather(city);
    WeatherData w = await weather;
    if(w != null) {
      setState((){
        weatherType = w.type;
      });
    }
  }

  void updateFromPos(Position position) async {
    weather = api.getWeatherFromPos(position);
    WeatherData w = await weather;
    if(w != null) {
      setState((){
        weatherType = w.type;
      });
    }
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.useLocation) {
      updateFromPos(widget.position);
      setState(() {
        lastCity = null;
      });
    } else if(widget.city != lastCity) {
      update(widget.city);
      setState(() {
        lastCity = widget.city;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('images/$weatherType.jpg'), fit: BoxFit.cover),
      ),
      child: Column(children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          FutureBuilder(
            future: weather, 
            builder:(BuildContext context, AsyncSnapshot<WeatherData> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('Select a city to start', style: Theme.of(context).textTheme.display1);
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                case ConnectionState.active:
                  return Text('');
                case ConnectionState.done:
                  if (snapshot.hasError || snapshot.data == null) {
                    print(snapshot.error);
                    return Text(
                      'Not found',
                      style: Theme.of(context).textTheme.display1,
                    );
                  } else {
                    print(snapshot.data.description);
                    return Column(children: <Widget>[
                      Text('${snapshot.data.city} (${snapshot.data.country})', style: Theme.of(context).textTheme.display1),
                      Text(snapshot.data.temp.round().toString() + '°C', style: Theme.of(context).textTheme.headline),
                      Text(snapshot.data.description, style: Theme.of(context).textTheme.display2)
                    ],);
                  }
              }
            }),
        ])]
      )
    );
  }
}