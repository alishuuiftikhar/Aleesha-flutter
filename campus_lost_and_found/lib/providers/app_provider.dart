import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item.dart';
import '../models/claim.dart';

class AppProvider with ChangeNotifier {
  List<LostFoundItem> _items = [];
  List<ItemClaim> _claims = [];
  List<String> _favoriteIds = [];
  String _currentUserId = "user_123"; // Mock user ID

  List<LostFoundItem> get items => _items;
  List<ItemClaim> get claims => _claims;
  List<String> get favoriteIds => _favoriteIds;
  String get currentUserId => _currentUserId;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AppProvider() {
    loadData();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    
    // Load Items
    final itemsJson = prefs.getString('items');
    if (itemsJson != null) {
      final List<dynamic> decoded = json.decode(itemsJson);
      _items = decoded.map((item) => LostFoundItem.fromJson(item)).toList();
      
      // Migration: Add images to mock items if they are missing or broken
      bool updated = false;
      final mockImages = {
        '1': 'https://images.unsplash.com/photo-1632661674596-df8be070a5c5?w=500&q=80',
        '2': 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=500&q=80',
        '3': 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500&q=80',
        '4': 'https://images.unsplash.com/photo-1632733711679-5292d6863670?w=500&q=80',
      };
      
      for (int i = 0; i < _items.length; i++) {
        final itemId = _items[i].id;
        final currentPath = _items[i].imagePath;
        
        if (mockImages.containsKey(itemId)) {
          bool needsUpdate = currentPath == null || 
                            !currentPath.startsWith('http') || 
                            currentPath.contains('1610411516053') ||
                            currentPath.contains('1589156229687'); // Remove the girl picture
          
          if (needsUpdate) {
            _items[i] = _items[i].copyWith(imagePath: mockImages[itemId]);
            updated = true;
          }
        }
      }
      if (updated) await saveItems();
    } else {
      // Initial mock data if empty
      _items = _generateMockData();
      await saveItems();
    }

    // Load Claims
    final claimsJson = prefs.getString('claims');
    if (claimsJson != null) {
      final List<dynamic> decoded = json.decode(claimsJson);
      _claims = decoded.map((claim) => ItemClaim.fromJson(claim)).toList();
    }

    // Load Favorites
    _favoriteIds = prefs.getStringList('favorites') ?? [];

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final itemsJson = json.encode(_items.map((item) => item.toJson()).toList());
    await prefs.setString('items', itemsJson);
  }

  Future<void> saveClaims() async {
    final prefs = await SharedPreferences.getInstance();
    final claimsJson = json.encode(_claims.map((claim) => claim.toJson()).toList());
    await prefs.setString('claims', claimsJson);
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favoriteIds);
  }

  // Item CRUD
  Future<void> addItem(LostFoundItem item) async {
    _items.add(item);
    await saveItems();
    notifyListeners();
  }

  Future<void> updateItem(LostFoundItem updatedItem) async {
    final index = _items.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _items[index] = updatedItem;
      await saveItems();
      notifyListeners();
    }
  }

  Future<void> deleteItem(String id) async {
    _items.removeWhere((item) => item.id == id);
    _claims.removeWhere((claim) => claim.itemId == id);
    _favoriteIds.remove(id);
    await saveItems();
    await saveClaims();
    await saveFavorites();
    notifyListeners();
  }

  // Favorites
  Future<void> toggleFavorite(String itemId) async {
    if (_favoriteIds.contains(itemId)) {
      _favoriteIds.remove(itemId);
    } else {
      _favoriteIds.add(itemId);
    }
    await saveFavorites();
    notifyListeners();
  }

  // Claims
  Future<void> addClaim(ItemClaim claim) async {
    _claims.add(claim);
    
    // Update item status
    final itemIndex = _items.indexWhere((i) => i.id == claim.itemId);
    if (itemIndex != -1) {
      _items[itemIndex] = _items[itemIndex].copyWith(status: ItemStatus.claimRequested);
      await saveItems();
    }
    
    await saveClaims();
    notifyListeners();
  }

  Future<void> updateClaimStatus(String claimId, ClaimStatus status, {String? returnMessage}) async {
    final index = _claims.indexWhere((c) => c.id == claimId);
    if (index != -1) {
      _claims[index] = _claims[index].copyWith(status: status, returnMessage: returnMessage);
      await saveClaims();
      notifyListeners();
    }
  }

  // Search & Filters
  List<LostFoundItem> filterItems({
    String? query,
    ItemCategory? category,
    ReportType? type,
    String? location,
    ItemStatus? status,
  }) {
    return _items.where((item) {
      final matchesQuery = query == null || 
          item.name.toLowerCase().contains(query.toLowerCase()) ||
          item.description.toLowerCase().contains(query.toLowerCase());
      final matchesCategory = category == null || item.category == category;
      final matchesType = type == null || item.type == type;
      final matchesLocation = location == null || 
          item.location.toLowerCase().contains(location.toLowerCase());
      final matchesStatus = status == null || item.status == status;
      
      return matchesQuery && matchesCategory && matchesType && matchesLocation && matchesStatus;
    }).toList();
  }

  // Matching System
  List<LostFoundItem> findMatches(LostFoundItem targetItem) {
    return _items.where((item) {
      // Don't match with itself or items of the same type
      if (item.id == targetItem.id || item.type == targetItem.type) return false;
      
      // Match criteria
      bool categoryMatch = item.category == targetItem.category;
      bool nameMatch = item.name.toLowerCase().split(' ').any((word) => 
        targetItem.name.toLowerCase().contains(word) && word.length > 3);
      bool locationMatch = item.location.toLowerCase() == targetItem.location.toLowerCase();
      
      // Return true if at least two criteria match
      int score = 0;
      if (categoryMatch) score += 2;
      if (nameMatch) score += 1;
      if (locationMatch) score += 1;
      
      return score >= 2;
    }).toList();
  }

  List<LostFoundItem> _generateMockData() {
    return [
      LostFoundItem(
        id: '1',
        name: 'iPhone 13 Pro',
        category: ItemCategory.electronics,
        type: ReportType.found,
        location: 'Library Second Floor',
        dateTime: DateTime.now().subtract(const Duration(days: 1)),
        description: 'Blue iPhone 13 Pro found near the study carrels.',
        identifyingDetails: 'Clear case, lock screen has a cat picture.',
        imagePath: 'https://images.unsplash.com/photo-1632661674596-df8be070a5c5?w=500&q=80',
        reporterId: 'user_999',
      ),
      LostFoundItem(
        id: '2',
        name: 'Calculus Textbook',
        category: ItemCategory.books,
        type: ReportType.lost,
        location: 'Science Building Room 204',
        dateTime: DateTime.now().subtract(const Duration(days: 2)),
        description: 'Stewart Calculus 9th Edition.',
        identifyingDetails: 'Name "Alex" written on the inside cover.',
        imagePath: 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=500&q=80',
        reporterId: _currentUserId,
      ),
      LostFoundItem(
        id: '3',
        name: 'Blue North Face Backpack',
        category: ItemCategory.bags,
        type: ReportType.found,
        location: 'Student Union Cafeteria',
        dateTime: DateTime.now().subtract(const Duration(hours: 5)),
        description: 'Found a blue backpack left on a table.',
        identifyingDetails: 'Contains a laptop and some notebooks.',
        imagePath: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500&q=80',
        reporterId: 'user_888',
      ),
      LostFoundItem(
        id: '4',
        name: 'Student ID Card',
        category: ItemCategory.idCards,
        type: ReportType.found,
        location: 'Gym Entrance',
        dateTime: DateTime.now().subtract(const Duration(days: 3)),
        description: 'Found a student ID card on the floor.',
        identifyingDetails: 'Name starts with "M".',
        imagePath: 'https://images.unsplash.com/photo-1632733711679-5292d6863670?w=500&q=80',
        reporterId: 'user_777',
      ),
      // Add more as needed
    ];
  }
}
