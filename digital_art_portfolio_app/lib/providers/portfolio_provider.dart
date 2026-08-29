import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/portfolio_model.dart';

class PortfolioProvider with ChangeNotifier {
  PortfolioData? _data;
  List<Artwork> _filteredArtworks = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  List<String> _favoriteIds = [];

  PortfolioData? get data => _data;
  List<Artwork> get artworks => _filteredArtworks;
  String get selectedCategory => _selectedCategory;
  List<String> get favorites => _favoriteIds;

  Future<void> loadData() async {
    final String response = await rootBundle.loadString('assets/data/portfolio.json');
    final data = await json.decode(response);
    _data = PortfolioData.fromJson(data);
    
    await _loadFavorites();
    _filterArtworks();
    notifyListeners();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favoriteIds = prefs.getStringList('favorites') ?? [];
    
    if (_data != null) {
      for (var artwork in _data!.artworks) {
        artwork.isFavorite = _favoriteIds.contains(artwork.id);
      }
    }
  }

  void _filterArtworks() {
    if (_data == null) return;

    _filteredArtworks = _data!.artworks.where((artwork) {
      final matchesCategory = _selectedCategory == 'All' || artwork.category == _selectedCategory;
      final matchesSearch = artwork.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          artwork.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _filterArtworks();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _filterArtworks();
    notifyListeners();
  }

  Future<void> toggleFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    await prefs.setStringList('favorites', _favoriteIds);
    
    if (_data != null) {
      final artwork = _data!.artworks.firstWhere((a) => a.id == id);
      artwork.isFavorite = _favoriteIds.contains(id);
    }
    _filterArtworks();
    notifyListeners();
  }

  bool isFavorite(String id) => _favoriteIds.contains(id);
}
