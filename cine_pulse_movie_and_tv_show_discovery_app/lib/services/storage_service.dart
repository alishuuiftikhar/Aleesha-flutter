import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';

class StorageService {
  static const String _recentSearchKey = 'recent_searches';
  static const String _watchlistKey = 'my_watchlist';
  static const String _profilePicKey = 'profile_pic_path';
  static const String _profileNameKey = 'profile_name';
  static const String _profileEmailKey = 'profile_email';

  // Recent Search
  Future<void> saveSearch(Movie movie) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> searches = prefs.getStringList(_recentSearchKey) ?? [];
    
    // Remove if exists to move to top
    searches.removeWhere((item) => Movie.fromJson(json.decode(item)).id == movie.id);
    
    // Add to top
    searches.insert(0, json.encode({
      'id': movie.id,
      'title': movie.title,
      'poster_path': movie.imageUrl.replaceAll('https://image.tmdb.org/t/p/w500', ''),
      'overview': movie.description,
      'vote_average': double.tryParse(movie.rating) ?? 0.0,
      'release_date': movie.releaseYear,
    }));

    if (searches.length > 10) searches.removeLast();
    await prefs.setStringList(_recentSearchKey, searches);
  }

  Future<List<Movie>> getRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> searches = prefs.getStringList(_recentSearchKey) ?? [];
    return searches.map((item) => Movie.fromJson(json.decode(item))).toList();
  }

  // Watchlist
  Future<void> toggleWatchlist(Movie movie) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> watchlist = prefs.getStringList(_watchlistKey) ?? [];
    
    bool exists = watchlist.any((item) => Movie.fromJson(json.decode(item)).id == movie.id);
    
    if (exists) {
      watchlist.removeWhere((item) => Movie.fromJson(json.decode(item)).id == movie.id);
    } else {
      watchlist.add(json.encode({
        'id': movie.id,
        'title': movie.title,
        'poster_path': movie.imageUrl.replaceAll('https://image.tmdb.org/t/p/w500', ''),
        'overview': movie.description,
        'vote_average': double.tryParse(movie.rating) ?? 0.0,
        'release_date': movie.releaseYear,
      }));
    }
    await prefs.setStringList(_watchlistKey, watchlist);
  }

  Future<List<Movie>> getWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> watchlist = prefs.getStringList(_watchlistKey) ?? [];
    return watchlist.map((item) => Movie.fromJson(json.decode(item))).toList();
  }

  Future<bool> isInWatchlist(int id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> watchlist = prefs.getStringList(_watchlistKey) ?? [];
    return watchlist.any((item) => Movie.fromJson(json.decode(item)).id == id);
  }

  // Profile
  Future<void> saveProfilePic(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profilePicKey, path);
  }

  Future<String?> getProfilePic() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_profilePicKey);
  }

  Future<void> saveProfileData(String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileNameKey, name);
    await prefs.setString(_profileEmailKey, email);
  }

  Future<Map<String, String>> getProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_profileNameKey) ?? 'Aleesha Khan',
      'email': prefs.getString(_profileEmailKey) ?? 'aleesha.khan@example.com',
    };
  }
}
