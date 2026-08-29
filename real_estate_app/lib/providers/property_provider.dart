import 'package:flutter/material.dart';
import '../models/property.dart';
import '../models/viewing.dart';
import '../services/supabase_service.dart';

class PropertyProvider extends ChangeNotifier {
  final SupabaseService _service;
  
  List<Property> _properties = [];
  List<Property> _favorites = [];
  List<Viewing> _viewings = [];
  List<Property> _compareList = [];
  bool _isLoading = false;

  PropertyProvider(this._service) {
    // Start with professional mock data using VALID UUIDs
    _properties = _getMockProperties('Buy', 'All');
  }

  List<Property> get properties => _properties;
  List<Property> get favorites => _favorites;
  List<Viewing> get viewings => _viewings;
  List<Property> get compareList => _compareList;
  bool get isLoading => _isLoading;

  Future<void> fetchProperties({
    String? type,
    String? category,
    String? city,
    double? minPrice,
    double? maxPrice,
    int? minBedrooms,
    int? minBathrooms,
    String? searchQuery,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _service.getProperties(
        type: type,
        category: category,
        city: city,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minBedrooms: minBedrooms,
        minBathrooms: minBathrooms,
        searchQuery: searchQuery,
      ).timeout(const Duration(seconds: 2));
      
      if (data.isNotEmpty) {
        _properties = data;
      } else {
        _properties = _getMockProperties(type ?? 'Buy', category ?? 'All');
      }
    } catch (e) {
      _properties = _getMockProperties(type ?? 'Buy', category ?? 'All');
    }

    _isLoading = false;
    notifyListeners();
  }

  List<Property> _getMockProperties(String type, String category) {
    List<Property> mock = [
      Property(
        id: '00000000-0000-0000-0000-000000000001',
        title: 'Modern Sage Villa',
        description: 'A stunning modern villa with sustainable design, private pool, and smart home features.',
        price: 1250000,
        address: '123 Green Valley Road',
        city: 'Los Angeles',
        type: 'Buy',
        category: 'Villa',
        bedrooms: 4,
        bathrooms: 3,
        area: 3500,
        mainImage: 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?q=80&w=800',
        agentId: '00000000-0000-0000-0000-000000000000',
        images: ['https://images.unsplash.com/photo-1613977252367-a8fe87c4bf24?q=80&w=800'],
      ),
      Property(
        id: '00000000-0000-0000-0000-000000000002',
        title: 'Skyline Penthouse',
        description: 'Luxury penthouse in the heart of Manhattan with panoramic views.',
        price: 4500,
        address: '500 Park Avenue',
        city: 'New York',
        type: 'Rent',
        category: 'Apartment',
        bedrooms: 3,
        bathrooms: 2,
        area: 2200,
        mainImage: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?q=80&w=800',
        agentId: '00000000-0000-0000-0000-000000000000',
      ),
      Property(
        id: '00000000-0000-0000-0000-000000000003',
        title: 'Heritage Oak House',
        description: 'Classic family home with large backyard and newly renovated kitchen.',
        price: 890000,
        address: '789 Oak Way',
        city: 'Austin',
        type: 'Buy',
        category: 'House',
        bedrooms: 5,
        bathrooms: 4,
        area: 4200,
        mainImage: 'https://images.unsplash.com/photo-1568605114967-8130f3a36994?q=80&w=800',
        agentId: '00000000-0000-0000-0000-000000000000',
      ),
      Property(
        id: '00000000-0000-0000-0000-000000000004',
        title: 'Downtown Studio Loft',
        description: 'Chic industrial studio perfect for urban professionals.',
        price: 2200,
        address: '210 Main St',
        city: 'Chicago',
        type: 'Rent',
        category: 'Studio',
        bedrooms: 1,
        bathrooms: 1,
        area: 850,
        mainImage: 'https://images.unsplash.com/photo-1560448204-61dc36dc98c8?q=80&w=800',
        agentId: '00000000-0000-0000-0000-000000000000',
      ),
      Property(
        id: '00000000-0000-0000-0000-000000000005',
        title: 'Emerald Lake Villa',
        description: 'Exquisite lakefront villa with private dock and expansive terrace.',
        price: 2100000,
        address: '44 Lakefront Circle',
        city: 'Seattle',
        type: 'Buy',
        category: 'Villa',
        bedrooms: 6,
        bathrooms: 5,
        area: 5800,
        mainImage: 'https://images.unsplash.com/photo-1600585154340-be6199f7d009?q=80&w=800',
        agentId: '00000000-0000-0000-0000-000000000000',
      ),
      Property(
        id: '00000000-0000-0000-0000-000000000006',
        title: 'Desert Mirage Home',
        description: 'Modern architectural masterpiece in the heart of the desert.',
        price: 1550000,
        address: '88 Sand Dune Lane',
        city: 'Phoenix',
        type: 'Buy',
        category: 'House',
        bedrooms: 4,
        bathrooms: 3,
        area: 3200,
        mainImage: 'https://images.unsplash.com/photo-1512918766674-ed62b979a83f?q=80&w=800',
        agentId: '00000000-0000-0000-0000-000000000000',
      ),
      Property(
        id: '00000000-0000-0000-0000-000000000007',
        title: 'Coastal Breeze Mansion',
        description: 'Oceanfront luxury mansion with direct beach access.',
        price: 5900000,
        address: '1 Ocean Blvd',
        city: 'Miami',
        type: 'Buy',
        category: 'Villa',
        bedrooms: 7,
        bathrooms: 8,
        area: 8500,
        mainImage: 'https://images.unsplash.com/photo-1518780664697-55e3ad937233?q=80&w=800',
        agentId: '00000000-0000-0000-0000-000000000000',
      ),
      Property(
        id: '00000000-0000-0000-0000-000000000008',
        title: 'Urban Garden Apartment',
        description: 'Modern apartment featuring a large private rooftop garden.',
        price: 3800,
        address: '15 Green St',
        city: 'San Francisco',
        type: 'Rent',
        category: 'Apartment',
        bedrooms: 2,
        bathrooms: 2,
        area: 1400,
        mainImage: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?q=80&w=800',
        agentId: '00000000-0000-0000-0000-000000000000',
      ),
    ];

    final filtered = mock.where((p) {
      if (p.type != type) return false;
      if (category != 'All' && p.category != category) return false;
      return true;
    }).toList();
    
    return filtered.isNotEmpty ? filtered : mock.where((p) => p.type == type).toList();
  }

  void toggleCompare(Property property) {
    if (_compareList.any((p) => p.id == property.id)) {
      _compareList.removeWhere((p) => p.id == property.id);
    } else if (_compareList.length < 3) {
      _compareList.add(property);
    }
    notifyListeners();
  }

  Future<void> toggleFavorite(Property property) async {
    property.isFavorite = !property.isFavorite;
    notifyListeners();
    try {
      await _service.toggleFavorite(property.id, property.isFavorite);
    } catch (_) {}
  }

  Future<void> fetchFavorites() async {
    try {
      final data = await _service.getFavorites();
      if (data.isNotEmpty) _favorites = data;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> fetchViewings() async {
    try {
      final data = await _service.getViewings();
      if (data.isNotEmpty) _viewings = data;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> bookViewing(String propertyId, DateTime scheduledAt) async {
    // Note: This will still fail if the API key is incorrect or user is not logged in,
    // but at least the ID format is now correct (UUID).
    try {
        await _service.scheduleViewing(propertyId, scheduledAt);
        await fetchViewings();
    } catch (e) {
        debugPrint('Booking failed: $e');
        rethrow;
    }
  }

  Future<void> cancelViewing(String viewingId) async {
    await _service.cancelViewing(viewingId);
    await fetchViewings();
  }
}
