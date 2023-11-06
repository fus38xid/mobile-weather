import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../models/WeatherModel.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async{
    final response = await http.get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if(response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error fetching weather data');
    }
  }

  Future<String> getCurrentCity() async {
    //get Perms
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    //get Location
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    //convert Location to placemarks list of objects
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    //get city name from first placemark
    String? city = placemarks[0].locality;

    return city ?? "";

  }
}
