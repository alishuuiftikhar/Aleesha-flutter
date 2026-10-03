import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/inspiration.dart';
import '../models/moodboard.dart';
import '../utils/sample_data.dart';

class AppProvider with ChangeNotifier {
  List<InspirationItem> _items = [];
  List<String> _favoriteIds = [];
  List<Moodboard> _moodboards = [];
  bool _isLoading = true;

  List<InspirationItem> get items => _items;
  List<String> get favoriteIds => _favoriteIds;
  List<Moodboard> get moodboards => _moodboards;
  bool get isLoading => _isLoading;

  AppProvider() {
    loadData();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    final List<dynamic> jsonData = jsonDecode(rawInspirationData);
    _items = jsonData.map((item) => InspirationItem.fromJson(item)).toList();

    final prefs = await SharedPreferences.getInstance();
    
    // Load favorites
    _favoriteIds = prefs.getStringList('favorites') ?? [];

    // Load moodboards
    final mbJson = prefs.getString('moodboards');
    if (mbJson != null) {
      final List<dynamic> mbData = jsonDecode(mbJson);
      _moodboards = mbData.map((mb) => Moodboard.fromJson(mb)).toList();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Favorites
  bool isFavorite(String id) => _favoriteIds.contains(id);

  void toggleFavorite(String id) async {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favoriteIds);
  }

  // Moodboards
  void createMoodboard(String name) async {
    final newMb = Moodboard(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
    );
    _moodboards.add(newMb);
    _saveMoodboards();
  }

  void deleteMoodboard(String id) {
    _moodboards.removeWhere((mb) => mb.id == id);
    _saveMoodboards();
  }

  void renameMoodboard(String id, String newName) {
    final index = _moodboards.indexWhere((mb) => mb.id == id);
    if (index != -1) {
      _moodboards[index].name = newName;
      _saveMoodboards();
    }
  }

  void addToMoodboard(String mbId, String itemId) {
    final index = _moodboards.indexWhere((mb) => mb.id == mbId);
    if (index != -1 && !_moodboards[index].itemIds.contains(itemId)) {
      _moodboards[index].itemIds.add(itemId);
      _saveMoodboards();
    }
  }

  void removeFromMoodboard(String mbId, String itemId) {
    final index = _moodboards.indexWhere((mb) => mb.id == mbId);
    if (index != -1) {
      _moodboards[index].itemIds.remove(itemId);
      _saveMoodboards();
    }
  }

  void updateMoodboardNotes(String mbId, String notes) {
    final index = _moodboards.indexWhere((mb) => mb.id == mbId);
    if (index != -1) {
      _moodboards[index].notes = notes;
      _saveMoodboards();
    }
  }

  Future<void> _saveMoodboards() async {
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(_moodboards.map((mb) => mb.toJson()).toList());
    await prefs.setString('moodboards', jsonStr);
  }

  List<InspirationItem> getMoodboardItems(String mbId) {
    final mb = _moodboards.firstWhere((mb) => mb.id == mbId);
    return _items.where((item) => mb.itemIds.contains(item.id)).toList();
  }

  List<InspirationItem> getFavoriteItems() {
    return _items.where((item) => _favoriteIds.contains(item.id)).toList();
  }
}
