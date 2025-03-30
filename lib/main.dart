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
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Added key parameter

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key}); // Added key parameter

  @override
  MainPageState createState() => MainPageState(); // Removed underscore to make it public
}

class MainPageState extends State<MainPage> { // Class is now public
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
          temp = "${(weatherData["main"]["temp"] - 273.15).toStringAsFixed(0)}°";
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
          title: const Text('Message'),
          content: Text(message),
          actions: [
            CupertinoButton(
              child: const Text('Close', style: TextStyle(color: CupertinoColors.destructiveRed)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CupertinoButton(
              child: const Text('Retry', style: TextStyle(color: CupertinoColors.systemGreen)),
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
        middle: const Text("iWeather"),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _openSettings,
          child: const Icon(CupertinoIcons.settings),
        ),
      ),
      child: SafeArea(
        child: temp.isNotEmpty
            ? Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text("My Location", style: TextStyle(fontSize: 35)),
              const SizedBox(height: 10),
              Text(location),
              const SizedBox(height: 10),
              Text(temp, style: const TextStyle(fontSize: 80)),
              const SizedBox(height: 10),
              Icon(weatherStatus, color: iconColor, size: 100),
              const SizedBox(height: 10),
              Text(weather),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('H: $humidity'),
                  const SizedBox(width: 10),
                  Text('W: $windSpeed'),
                ],
              ),
            ],
          ),
        )
            : const Center(child: CupertinoActivityIndicator()),
      ),
    );
  }
}
