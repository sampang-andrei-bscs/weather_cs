import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:get_storage/get_storage.dart';
import 'settings.dart';
import 'icon_color_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  runApp(
    ChangeNotifierProvider(
      create: (context) => IconColorProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String location = "Arayat";
  String temp = "";
  IconData? weatherStatus;
  String weather = "";
  String humidity = "";
  String windSpeed = "";

  Future<void> getWeatherData() async {
    try {
      String apiKey = "71d4a365d488f44341a160cdbf0e97fa";
      String link = "https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey";

      final response = await http.get(Uri.parse(link));
      Map<String, dynamic> weatherData = jsonDecode(response.body);

      if (weatherData["cod"] == 200) {
        setState(() {
          temp = (weatherData["main"]["temp"] - 273.15).toStringAsFixed(0) + "°";
          weather = weatherData["weather"][0]["description"];
          humidity = "${weatherData["main"]["humidity"]}%";
          windSpeed = "${weatherData["wind"]["speed"]} kph";

          if (weather.contains("clear")) {
            weatherStatus = CupertinoIcons.sun_max;
          } else if (weather.contains("cloud")) {
            weatherStatus = CupertinoIcons.cloud;
          } else if (weather.contains("haze")) {
            weatherStatus = CupertinoIcons.sun_haze;
          }
        });
      } else {
        _showErrorDialog("City Not Found");
      }
    } catch (e) {
      _showErrorDialog("No Internet Connection");
    }
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Message'),
          content: Text(message),
          actions: [
            CupertinoButton(
              child: Text('Close', style: TextStyle(color: CupertinoColors.destructiveRed)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CupertinoButton(
              child: Text('Retry', style: TextStyle(color: CupertinoColors.systemGreen)),
              onPressed: () {
                Navigator.pop(context);
                getWeatherData();
              },
            ),
          ],
        );
      },
    );
  }

  void _openSettings() async {
    final result = await Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => SettingsPage(initialLocation: location)),
    );

    if (result != null) {
      setState(() {
        location = result;
        getWeatherData();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = Provider.of<IconColorProvider>(context).color;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("iWeather"),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.settings),
          onPressed: _openSettings,
        ),
      ),
      child: SafeArea(
        child: temp != ""
            ? Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              Text("My Location", style: TextStyle(fontSize: 35)),
              SizedBox(height: 10),
              Text(location),
              SizedBox(height: 10),
              Text(temp, style: TextStyle(fontSize: 80)),
              SizedBox(height: 10),
              Icon(weatherStatus, color: iconColor, size: 100),
              SizedBox(height: 10),
              Text(weather),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('H: $humidity'),
                  SizedBox(width: 10),
                  Text('W: $windSpeed'),
                ],
              ),
            ],
          ),
        )
            : Center(child: CupertinoActivityIndicator()),
      ),
    );
  }
}