import 'package:flutter/material.dart';
import 'currentWeather.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))
        ),
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))
        ),
        textTheme: TextTheme(
          display1: TextStyle(fontSize: 35, fontWeight: FontWeight.w300, color: Colors.white),
          display2: TextStyle(fontSize: 30, fontWeight: FontWeight.w300, color: Colors.white),
          headline: TextStyle(fontSize: 75, fontWeight: FontWeight.w600, color: Colors.white)
        ),
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final cityController = TextEditingController();
  String city;
  Position currentPosition;
  bool useLocation = true;

  getCurrentLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    Position pos = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    setState(() {
      currentPosition = pos;
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: CurrentWeather(city: city, position: currentPosition, useLocation: useLocation)),
      floatingActionButton: Column(mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: FloatingActionButton(
              child: Icon(Icons.search),
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Form(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: 'Search for a city',
                                  border: OutlineInputBorder()
                                ),
                                controller: cityController,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                child: Text('OK', style: TextStyle(color: Colors.white),),
                                onPressed: () {
                                  if(cityController.text != '') {
                                    setState(() {
                                      city = cityController.text;
                                      useLocation = false;
                                    });
                                  }
                                  Navigator.pop(context);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  });
              },
            ),
          ),
          FloatingActionButton(
            child: Icon(Icons.my_location),
            backgroundColor: Colors.green,
            onPressed: () async {
              await getCurrentLocation();
              setState((){
                useLocation = true;
              });
            }
          )
      ])
    );
  }
}