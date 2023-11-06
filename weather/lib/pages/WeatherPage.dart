import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/models/WeatherModel.dart';
import 'package:weather/services/WeatherService.dart';


class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  //api key
  final _weatherService = WeatherService('a1dacdac2e30b69efc76dc9d17a18125');
  Weather? _weather;

  //Fetch weather
  _fetchWeather() async {

    //get current city
    String cityName = await _weatherService.getCurrentCity();


    //get current weather
    try {
    final weather = await _weatherService.getWeather(cityName);
    setState(() {
      _weather = weather;
    });
  }

    //any errors
    catch(e) {
      print(e);
    }
  }
  

  //weather animations
  String getWeatherAnimation(String? mainCondition){
    if (mainCondition == null) return 'assets/sunny.json'; // default is sunny

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }

  }

  //init state
  @override
  void initState(){
    super.initState();

    //fetch weather
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 229, 229, 229),
      body: Center(
        child: Column( 
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        //city name
        Text(_weather?.cityName ?? "Loading...City"),

        //animation
        Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

        //temperature
        Text('${_weather?.temperature.round()}°C'),

        //Weather condition
        Text(_weather?.mainCondition ?? "")
      ],
      ),
    ),
    );
  }
}