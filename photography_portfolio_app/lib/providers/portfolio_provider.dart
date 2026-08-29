import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/portfolio_model.dart';

class PortfolioProvider with ChangeNotifier {
  PortfolioData? _data;
  List<String> _favorites = [];
  bool _isLoading = true;

  PortfolioData? get data => _data;
  List<String> get favorites => _favorites;
  bool get isLoading => _isLoading;

  List<PhotoItem> get favoriteItems {
    if (_data == null) return [];
    return _data!.portfolio.where((item) => _favorites.contains(item.id)).toList();
  }

  PortfolioProvider() {
    loadData();
    loadFavorites();
  }

  Future<void> loadData() async {
    try {
      final String response = await rootBundle.loadString('assets/data/portfolio.json');
      final data = await json.decode(response);
      _data = PortfolioData.fromJson(data);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print("Error loading portfolio data: $e");
      }
    }
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favorites = prefs.getStringList('favorites') ?? [];
    notifyListeners();
  }

  Future<void> toggleFavorite(String id) async {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favorites);
    notifyListeners();
  }

  bool isFavorite(String id) {
    return _favorites.contains(id);
  }
}
