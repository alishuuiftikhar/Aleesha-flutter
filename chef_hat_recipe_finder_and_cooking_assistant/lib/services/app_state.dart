import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../data/dummy_data.dart';

class AppState {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  // Favorites
  final List<String> favoriteRecipeIds = [];
  
  // Shopping List
  final List<Map<String, dynamic>> shoppingItems = [
    {'name': 'Chicken Breast', 'bought': false, 'category': 'Meat'},
    {'name': 'Spinach', 'bought': true, 'category': 'Vegetables'},
  ];

  // Community Likes
  final Set<int> likedPostIndexes = {};

  // History
  final List<String> cookedHistoryIds = [];

  // XP & Leveling
  int userXP = 450; // Starting XP
  String get chefLevel {
    if (userXP < 500) return 'Junior Chef';
    if (userXP < 1500) return 'Executive Chef';
    return 'Master Chef';
  }

  // Private Notes for Recipes
  final Map<String, String> recipeNotes = {};

  // Settings
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;

  void toggleFavorite(String recipeId) {
    if (favoriteRecipeIds.contains(recipeId)) {
      favoriteRecipeIds.remove(recipeId);
    } else {
      favoriteRecipeIds.add(recipeId);
    }
  }

  bool isFavorite(String recipeId) {
    return favoriteRecipeIds.contains(recipeId);
  }

  void addToHistory(String recipeId) {
    if (!cookedHistoryIds.contains(recipeId)) {
      cookedHistoryIds.add(recipeId);
      userXP += 150; // Award XP for cooking
    }
  }

  void saveNote(String recipeId, String note) {
    recipeNotes[recipeId] = note;
  }

  void addShoppingItem(String name, String category) {
    shoppingItems.add({'name': name, 'bought': false, 'category': category});
  }

  void removeShoppingItem(int index) {
    shoppingItems.removeAt(index);
  }

  void toggleShoppingItem(int index) {
    shoppingItems[index]['bought'] = !shoppingItems[index]['bought'];
  }

  List<Recipe> get favoriteRecipes {
    return dummyRecipes.where((r) => favoriteRecipeIds.contains(r.id)).toList();
  }

  List<Recipe> get cookedHistoryRecipes {
    return dummyRecipes.where((r) => cookedHistoryIds.contains(r.id)).toList();
  }
}
