import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../services/supabase_service.dart';
import '../data/mock_data.dart';

class EventProvider with ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  List<Event> _events = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  EventProvider() {
    loadEvents();
  }

  bool get isLoading => _isLoading;

  List<Event> get events {
    return _events.where((event) {
      final matchesSearch = event.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || event.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  List<Event> get featuredEvents => _events.take(5).toList();
  List<Event> get favoriteEvents => _events.where((e) => e.isFavorite).toList();

  Future<void> loadEvents() async {
    _isLoading = true;
    notifyListeners();

    // Fetch from Supabase
    final fetchedEvents = await _supabaseService.fetchEvents();
    
    // Combine fetched events with mock data
    // We put real events from Supabase first
    _events = [...fetchedEvents, ...allMockEvents];

    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void toggleFavorite(String id) {
    final index = _events.indexWhere((e) => e.id == id);
    if (index != -1) {
      _events[index].isFavorite = !_events[index].isFavorite;
      notifyListeners();
    }
  }

  Future<void> addEvent(Event event) async {
    await _supabaseService.createEvent(event);
    await loadEvents();
  }
}
