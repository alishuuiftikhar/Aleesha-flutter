import 'package:flutter/material.dart';
import '../models/museum.dart';
import '../models/exhibition.dart';
import '../models/artwork.dart';
import '../models/artist.dart';
import '../models/visit_plan.dart';
import 'data_service.dart';
import 'storage_service.dart';

class AppProvider with ChangeNotifier {
  final DataService _dataService = DataService();
  final StorageService _storageService = StorageService();

  List<Museum> _museums = [];
  List<Exhibition> _exhibitions = [];
  List<Artwork> _artworks = [];
  List<Artist> _artists = [];

  List<String> _favoriteMuseumIds = [];
  List<String> _favoriteExhibitionIds = [];
  List<String> _favoriteArtworkIds = [];
  List<VisitPlan> _visitPlans = [];
  List<String> _recentlyViewed = [];

  bool _isLoading = true;

  List<Museum> get museums => _museums;
  List<Exhibition> get exhibitions => _exhibitions;
  List<Artwork> get artworks => _artworks;
  List<Artist> get artists => _artists;
  List<VisitPlan> get visitPlans => _visitPlans;
  bool get isLoading => _isLoading;

  List<Museum> get favoriteMuseums => _museums.where((m) => _favoriteMuseumIds.contains(m.id)).toList();
  List<Exhibition> get favoriteExhibitions => _exhibitions.where((e) => _favoriteExhibitionIds.contains(e.id)).toList();
  List<Artwork> get favoriteArtworks => _artworks.where((a) => _favoriteArtworkIds.contains(a.id)).toList();

  AppProvider() {
    init();
  }

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    _museums = await _dataService.loadMuseums();
    _exhibitions = await _dataService.loadExhibitions();
    _artworks = await _dataService.loadArtworks();
    _artists = await _dataService.loadArtists();

    _favoriteMuseumIds = await _storageService.getFavorites('museum');
    _favoriteExhibitionIds = await _storageService.getFavorites('exhibition');
    _favoriteArtworkIds = await _storageService.getFavorites('artwork');
    _visitPlans = await _storageService.getVisitPlans();
    _recentlyViewed = await _storageService.getRecentlyViewed();

    _isLoading = false;
    notifyListeners();
  }

  bool isFavorite(String type, String id) {
    if (type == 'museum') return _favoriteMuseumIds.contains(id);
    if (type == 'exhibition') return _favoriteExhibitionIds.contains(id);
    if (type == 'artwork') return _favoriteArtworkIds.contains(id);
    return false;
  }

  Future<void> toggleFavorite(String type, String id) async {
    await _storageService.toggleFavorite(type, id);
    if (type == 'museum') {
      if (_favoriteMuseumIds.contains(id)) _favoriteMuseumIds.remove(id);
      else _favoriteMuseumIds.add(id);
    } else if (type == 'exhibition') {
      if (_favoriteExhibitionIds.contains(id)) _favoriteExhibitionIds.remove(id);
      else _favoriteExhibitionIds.add(id);
    } else if (type == 'artwork') {
      if (_favoriteArtworkIds.contains(id)) _favoriteArtworkIds.remove(id);
      else _favoriteArtworkIds.add(id);
    }
    notifyListeners();
  }

  Future<void> addVisitPlan(VisitPlan plan) async {
    await _storageService.saveVisitPlan(plan);
    _visitPlans = await _storageService.getVisitPlans();
    notifyListeners();
  }

  Future<void> deleteVisitPlan(String id) async {
    await _storageService.deleteVisitPlan(id);
    _visitPlans = await _storageService.getVisitPlans();
    notifyListeners();
  }

  Future<void> addToRecentlyViewed(String type, String id) async {
    await _storageService.addToRecentlyViewed(type, id);
    _recentlyViewed = await _storageService.getRecentlyViewed();
    notifyListeners();
  }

  List<dynamic> search(String query) {
    if (query.isEmpty) return [];
    final lowerQuery = query.toLowerCase();
    
    List<dynamic> results = [];
    results.addAll(_museums.where((m) => m.name.toLowerCase().contains(lowerQuery)));
    results.addAll(_exhibitions.where((e) => e.title.toLowerCase().contains(lowerQuery)));
    results.addAll(_artworks.where((a) => a.title.toLowerCase().contains(lowerQuery)));
    results.addAll(_artists.where((a) => a.name.toLowerCase().contains(lowerQuery)));
    
    return results;
  }
}
