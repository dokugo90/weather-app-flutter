import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather Spectra',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Weather Spectra'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  dynamic country = "City";
  dynamic city = "";
  dynamic units = "metric";
  dynamic temperature = "Temperature at day";
  dynamic temperature_night = "Temperature at night";
  dynamic temperature_morning = "Temperature at morning";
  dynamic wind_speed = "Wind Speed";
  dynamic humidity = "Humidity";
  dynamic feels_like = "Feels Like";
  dynamic chance = "Chance of rain";
  dynamic wind_gust = "Wind Gust";
  dynamic description = "Description";
  dynamic uploaded = Icon(Icons.wifi);
  var currentWeather = Icon(Icons.cloud);
  var data;
  int limit = 1;

  loader() {
    setState(() {
      uploaded = CircularProgressIndicator(color: Colors.white,);
    });
  }

  getWeather() async {
    try {
      country = city;
      var locationReq = await http.get(Uri.parse(
          "https://api.openweathermap.org/geo/1.0/direct?q=$country&limit=1&appid=28fe7b5f9a78838c639143fc517e4343"));
      if (locationReq.statusCode == 200) {
        var locationRes = jsonDecode(locationReq.body);
        //print(locationRes[0]["lat"]);
        dynamic lat = locationRes[0]["lat"];
        dynamic lon = locationRes[0]["lon"];
        var weatherReq = await http.get(Uri.parse(
            "https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&units=$units&appid=28fe7b5f9a78838c639143fc517e4343"));
        var weatherRes = jsonDecode(weatherReq.body);
        //print(weatherRes["daily"]);
        setState(() {
          uploaded = Icon(Icons.cloud_done);
          country = locationRes[0]["name"].toString() +
              ", " +
              locationRes[0]["country"].toString();
          temperature = weatherRes["current"]["temp"];
          temperature_night = weatherRes["daily"][0]["temp"]["night"];
          temperature_morning = weatherRes["daily"][0]["temp"]["morn"];
          wind_speed = weatherRes["current"]["wind_speed"];
          humidity = weatherRes["current"]["humidity"];
          feels_like = weatherRes["current"]["feels_like"];
          description = weatherRes["current"]["weather"][0]["description"];
          if (weatherRes["current"]["weather"][0]["description"] ==
              "clear sky") {
            currentWeather = Icon(Icons.sunny);
          } else if (weatherRes["current"]["weather"][0]["description"]
                  .contains("haze") ||
              weatherRes["current"]["weather"][0]["description"]
                  .contains("fog")) {
            currentWeather = Icon(Icons.foggy);
          } else if (weatherRes["current"]["weather"][0]["description"]
                  .contains("rain") ||
              weatherRes["current"]["weather"][0]["description"]
                  .contains("drizzle")) {
            currentWeather = Icon(Icons.cloudy_snowing);
          } else if (weatherRes["current"]["weather"][0]["description"]
              .contains("snow")) {
            currentWeather = Icon(Icons.snowing);
          } else if (weatherRes["current"]["weather"][0]["description"]
              .contains("cloud")) {
            currentWeather = Icon(Icons.cloud);
          } else {
            currentWeather = Icon(Icons.sunny);
          }
          chance = weatherRes["hourly"][45]["pop"] * 100;
          if (weatherRes["current"]["wind_gust"] != null) {
            wind_gust = weatherRes["current"]["wind_gust"];
          } else {
            wind_gust = "0";
          }
        });
      }
    } catch (err) {
      setState(() {
        country = "Enter valid city";
        uploaded = Icon(Icons.wifi_off);
        temperature = "Temperature at day";
       temperature_night = "Temperature at night";
      temperature_morning = "Temperature at morning";
  wind_speed = "Wind Speed";
  humidity = "Humidity";
  feels_like = "Feels Like";
  chance = "Chance of rain";
  wind_gust = "Wind Gust";
  description = "Description";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: (MediaQuery.of(context).size.height),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.pink,
            Colors.purple,
            Colors.lightBlue,
          ])),
          child: ListView(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 16)),
              Text(
                "Weather Spectra",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 25),
              ),
              Padding(padding: EdgeInsets.only(top: 16)),
              TextField(
                onChanged: (value) {
                  setState(() {
                    city = value;
                  });
                },
                keyboardType: TextInputType.text,
                obscureText: false,
                cursorColor: Colors.white,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                maxLength: 30,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    hintText: "Enter City",
                    alignLabelWithHint: true,
                    hintStyle: TextStyle(color: Colors.white),
                    labelStyle: TextStyle(color: Colors.white)),
                textAlign: TextAlign.center,
              ),
              Text(
                "Weather Info Today",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18),
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              ListTile(
                onTap: () {},
                title: Text('$country',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900)),
                leading: Icon(Icons.flag_circle),
                trailing: uploaded,
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              ListTile(
                onTap: () {},
                title: Text("$temperature °C",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900)),
                leading: Icon(Icons.sunny),
                trailing: uploaded,
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              ListTile(
                onTap: () {},
                title: Text("$temperature_night °C",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900)),
                leading: Icon(Icons.dark_mode),
                trailing: uploaded,
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              ListTile(
                onTap: () {},
                title: Text("$temperature_morning °C",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900)),
                leading: Icon(Icons.cloud),
                trailing: uploaded,
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              ListTile(
                onTap: () {},
                title: Text(
                  "$wind_speed mph",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900),
                ),
                leading: Icon(Icons.speed_rounded),
                trailing: uploaded,
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              ListTile(
                onTap: () {},
                title: Text("$humidity %",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900)),
                leading: Icon(Icons.water_drop),
                trailing: uploaded,
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              ListTile(
                  onTap: () {},
                  title: Text("$feels_like °C",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900)),
                  leading: Icon(Icons.thermostat),
                  trailing: uploaded),
              Padding(padding: EdgeInsets.all(8.0)),
              ListTile(
                onTap: () {},
                title: Text("$chance %",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900)),
                leading: Icon(Icons.cloudy_snowing),
                trailing: uploaded,
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              ListTile(
                onTap: () {},
                title: Text("$wind_gust m/s",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900)),
                leading: Icon(Icons.foggy),
                trailing: uploaded,
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              ListTile(
                onTap: () {},
                title: Text("$description",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900)),
                leading: currentWeather,
                trailing: uploaded,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          loader();
          getWeather();
        },
        tooltip: "Get Weather",
        child: Icon(Icons.search),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }
}
