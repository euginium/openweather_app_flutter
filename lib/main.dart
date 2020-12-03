import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/service.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Service service = new Service();
  double temperature;
  String cityName = 'Kuala Lumpur';
  String cityCondition;

//this function is a must to pass the decoded data and updating the UI
  void updateUI(Future<dynamic> weatherDataFuture) async {
    final weatherData = await weatherDataFuture;
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        cityCondition = 'Error';
        cityName = 'Unable to obtain data';
        return;
      }
      temperature = jsonDecode(weatherData)['main']['temp'];
      cityCondition = jsonDecode(weatherData)['weather'][0]['main'];
      cityName = jsonDecode(weatherData)['name'];
    });
  }

  @override
  void initState() {
    super.initState();
    updateUI(service.getCityWeather(cityName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blueGrey.shade700,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'OpenWeather',
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.orangeAccent.shade100),
        ),
        actions: [
          //search icon with rflutter package used
          Padding(
            padding: EdgeInsets.only(right: 15.0),
            child: IconButton(
              icon: Icon(
                Icons.search_rounded,
                size: 35,
              ),
              onPressed: () {
                //function that searches city weather
                setState(() {
                  Alert(
                      context: context,
                      title: 'Search',
                      desc: 'Search using city name',
                      style: AlertStyle(
                        titleStyle: TextStyle(color: Colors.white),
                        descStyle: TextStyle(color: Colors.white),
                      ),
                      content: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              icon: Icon(Icons.search),
                              hintText: 'e.g Cupertino',
                            ),
                            onChanged: (String value) {
                              setState(() {
                                cityName = value;
                                updateUI(service.getCityWeather(cityName));
                              });
                            },
                          ),
                        ],
                      ),
                      buttons: [
                        DialogButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Search",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          color: Colors.blueAccent,
                        ),
                      ]).show();
                });
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: 500,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      'https://i.pinimg.com/originals/90/7e/6e/907e6e29c547c31d0a445cd7955504b9.gif'),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    //cityName
                    Container(
                      width: 280,
                      child: Text(
                        '$cityName',
                        softWrap: true,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 60,
                        ),
                      ),
                    ),
                    //city Condition
                    Text(
                      '$cityCondition',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 35,
                      ),
                    ),
                    //city temperature
                    Text(
                      '${temperature}°C',
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 35,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
