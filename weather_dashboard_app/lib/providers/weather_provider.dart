import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

enum TempUnit { celsius, fahrenheit }

class WeatherProvider with ChangeNotifier {
  final WeatherService _service = WeatherService();
  List<WeatherData> _allWeatherData = [];
  WeatherData? _currentWeather;
  bool _isLoading = false;
  TempUnit _unit = TempUnit.celsius;
  List<String> _favorites = [];
  List<String> _recentSearches = [];

  List<WeatherData> get allWeatherData => _allWeatherData;
  WeatherData? get currentWeather => _currentWeather;
  bool get isLoading => _isLoading;
  TempUnit get unit => _unit;
  List<String> get favorites => _favorites;
  List<String> get recentSearches => _recentSearches;

  WeatherProvider() {
    _loadSettings();
    loadInitialData();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _unit = (prefs.getString('unit') == 'fahrenheit')
        ? TempUnit.fahrenheit
        : TempUnit.celsius;
    _favorites = prefs.getStringList('favorites') ?? [];
    _recentSearches = prefs.getStringList('recentSearches') ?? [];
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('unit', _unit == TempUnit.fahrenheit ? 'fahrenheit' : 'celsius');
    await prefs.setStringList('favorites', _favorites);
    await prefs.setStringList('recentSearches', _recentSearches);
  }

  Future<void> loadInitialData() async {
    _isLoading = true;
    notifyListeners();
    try {
      _allWeatherData = await _service.fetchWeatherData();
      if (_allWeatherData.isNotEmpty) {
        _currentWeather = _allWeatherData.first;
      }
    } catch (e) {
      debugPrint('Error loading weather data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCurrentWeather(WeatherData weather) {
    _currentWeather = weather;
    if (!_recentSearches.contains(weather.city)) {
      _recentSearches.insert(0, weather.city);
      if (_recentSearches.length > 5) _recentSearches.removeLast();
      _saveSettings();
    }
    notifyListeners();
  }

  void toggleUnit() {
    _unit = _unit == TempUnit.celsius ? TempUnit.fahrenheit : TempUnit.celsius;
    _saveSettings();
    notifyListeners();
  }

  void toggleFavorite(String cityName) {
    if (_favorites.contains(cityName)) {
      _favorites.remove(cityName);
    } else {
      _favorites.add(cityName);
    }
    _saveSettings();
    notifyListeners();
  }

  bool isFavorite(String cityName) => _favorites.contains(cityName);

  double getConvertedTemp(double celsius) {
    if (_unit == TempUnit.fahrenheit) {
      return (celsius * 9 / 5) + 32;
    }
    return celsius;
  }

  String get tempSuffix => _unit == TempUnit.celsius ? '°C' : '°F';
}
