import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:urban_drive_car_rental/models/car.dart';

class SavedService extends ChangeNotifier {
  static final SavedService _instance = SavedService._internal();
  factory SavedService() => _instance;
  SavedService._internal();

  List<String> _savedCarIds = [];
  List<String> get savedCarIds => _savedCarIds;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _savedCarIds = prefs.getStringList('saved_cars') ?? [];
    notifyListeners();
  }

  bool isSaved(String carId) => _savedCarIds.contains(carId);

  Future<void> toggleSave(String carId) async {
    if (_savedCarIds.contains(carId)) {
      _savedCarIds.remove(carId);
    } else {
      _savedCarIds.add(carId);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('saved_cars', _savedCarIds);
    notifyListeners();
  }

  List<Car> getSavedCars() {
    return demoCars.where((car) => _savedCarIds.contains(car.id)).toList();
  }
}
