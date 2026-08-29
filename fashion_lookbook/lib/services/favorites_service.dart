import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _lookKey = 'favorite_looks';
  static const String _itemKey = 'favorite_items';

  Future<List<String>> getFavoriteLooks() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_lookKey) ?? [];
  }

  Future<void> toggleLookFavorite(String lookId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_lookKey) ?? [];
    if (favorites.contains(lookId)) {
      favorites.remove(lookId);
    } else {
      favorites.add(lookId);
    }
    await prefs.setStringList(_lookKey, favorites);
  }

  Future<List<String>> getFavoriteItems() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_itemKey) ?? [];
  }

  Future<void> toggleItemFavorite(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_itemKey) ?? [];
    if (favorites.contains(itemId)) {
      favorites.remove(itemId);
    } else {
      favorites.add(itemId);
    }
    await prefs.setStringList(_itemKey, favorites);
  }

  Future<bool> isLookFavorite(String lookId) async {
    final favorites = await getFavoriteLooks();
    return favorites.contains(lookId);
  }

  Future<bool> isItemFavorite(String itemId) async {
    final favorites = await getFavoriteItems();
    return favorites.contains(itemId);
  }
}
