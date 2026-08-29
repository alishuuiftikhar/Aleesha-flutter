import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/destination.dart';
import '../models/travel_package.dart';
import '../models/booking.dart';

class TravelProvider with ChangeNotifier {
  List<Destination> _destinations = [];
  List<TravelPackage> _packages = [];
  List<Destination> _favorites = [];
  List<Booking> _bookings = [];
  List<Map<String, dynamic>> _categories = [];
  
  bool _isLoading = false;

  List<Destination> get destinations => _destinations;
  List<TravelPackage> get packages => _packages;
  List<Destination> get favorites => _favorites;
  List<Booking> get bookings => _bookings;
  List<Map<String, dynamic>> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final destData = await rootBundle.loadString('assets/data/destinations.json');
      final List<dynamic> destJson = json.decode(destData);
      _destinations = destJson.map((j) => Destination.fromJson(j)).toList();

      final packData = await rootBundle.loadString('assets/data/packages.json');
      final List<dynamic> packJson = json.decode(packData);
      _packages = packJson.map((j) => TravelPackage.fromJson(j)).toList();

      final catData = await rootBundle.loadString('assets/data/categories.json');
      _categories = List<Map<String, dynamic>>.from(json.decode(catData));

      await loadFavorites();
      await loadBookings();
    } catch (e) {
      debugPrint('Error loading data: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favIds = prefs.getStringList('favorites') ?? [];
    _favorites = _destinations.where((d) => favIds.contains(d.id)).toList();
    notifyListeners();
  }

  Future<void> toggleFavorite(Destination destination) async {
    final prefs = await SharedPreferences.getInstance();
    final favIds = prefs.getStringList('favorites') ?? [];
    
    if (favIds.contains(destination.id)) {
      favIds.remove(destination.id);
      _favorites.removeWhere((d) => d.id == destination.id);
    } else {
      favIds.add(destination.id);
      _favorites.add(destination);
    }
    
    await prefs.setStringList('favorites', favIds);
    notifyListeners();
  }

  bool isFavorite(String id) {
    return _favorites.any((d) => d.id == id);
  }

  Future<void> loadBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final bookingData = prefs.getStringList('bookings') ?? [];
    _bookings = bookingData.map((b) => Booking.fromJson(json.decode(b))).toList();
    notifyListeners();
  }

  Future<void> addBooking(Booking booking) async {
    final prefs = await SharedPreferences.getInstance();
    _bookings.add(booking);
    final bookingStrings = _bookings.map((b) => json.encode(b.toJson())).toList();
    await prefs.setStringList('bookings', bookingStrings);
    notifyListeners();
  }

  Future<void> cancelBooking(String id) async {
    final prefs = await SharedPreferences.getInstance();
    _bookings.removeWhere((b) => b.id == id);
    final bookingStrings = _bookings.map((b) => json.encode(b.toJson())).toList();
    await prefs.setStringList('bookings', bookingStrings);
    notifyListeners();
  }

  List<Destination> searchDestinations(String query) {
    if (query.isEmpty) return _destinations;
    return _destinations.where((d) => 
      d.name.toLowerCase().contains(query.toLowerCase()) || 
      d.location.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}
