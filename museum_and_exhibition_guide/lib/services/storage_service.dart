import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/visit_plan.dart';

class StorageService {
  static const String _favoritesKey = 'favorites_';
  static const String _visitPlansKey = 'visit_plans';
  static const String _recentlyViewedKey = 'recently_viewed';

  Future<void> toggleFavorite(String type, String id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _favoritesKey + type;
    List<String> favorites = prefs.getStringList(key) ?? [];
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    await prefs.setStringList(key, favorites);
  }

  Future<List<String>> getFavorites(String type) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey + type) ?? [];
  }

  Future<void> saveVisitPlan(VisitPlan plan) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> plans = prefs.getStringList(_visitPlansKey) ?? [];
    int index = plans.indexWhere((element) {
      final p = VisitPlan.fromJson(json.decode(element));
      return p.id == plan.id;
    });

    if (index != -1) {
      plans[index] = json.encode(plan.toJson());
    } else {
      plans.add(json.encode(plan.toJson()));
    }
    await prefs.setStringList(_visitPlansKey, plans);
  }

  Future<List<VisitPlan>> getVisitPlans() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> plans = prefs.getStringList(_visitPlansKey) ?? [];
    return plans.map((e) => VisitPlan.fromJson(json.decode(e))).toList();
  }

  Future<void> deleteVisitPlan(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> plans = prefs.getStringList(_visitPlansKey) ?? [];
    plans.removeWhere((element) {
      final p = VisitPlan.fromJson(json.decode(element));
      return p.id == id;
    });
    await prefs.setStringList(_visitPlansKey, plans);
  }

  Future<void> addToRecentlyViewed(String type, String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> recently = prefs.getStringList(_recentlyViewedKey) ?? [];
    String item = '$type:$id';
    recently.remove(item);
    recently.insert(0, item);
    if (recently.length > 10) recently.removeLast();
    await prefs.setStringList(_recentlyViewedKey, recently);
  }

  Future<List<String>> getRecentlyViewed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_recentlyViewedKey) ?? [];
  }
}
