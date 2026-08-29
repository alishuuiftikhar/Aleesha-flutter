import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/weather_model.dart';

class WeatherService {
  Future<List<WeatherData>> fetchWeatherData() async {
    final String response = await rootBundle.loadString('assets/data/weather.json');
    final data = await json.decode(response);
    return (data as List).map((i) => WeatherData.fromJson(i)).toList();
  }
}
