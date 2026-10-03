import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/score.dart';
import '../models/game.dart';

class StorageService {
  static const String _scoresKey = 'high_scores';
  static const String _favoritesKey = 'favorite_games';
  static const String _historyKey = 'game_history';
  static const String _streakKey = 'daily_streak';
  static const String _lastLoginKey = 'last_login';
  static const String _completedLevelsKey = 'completed_levels';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // High Scores
  Future<void> saveScore(ScoreModel score) async {
    final scores = getScores();
    scores.add(score);
    await _prefs.setString(_scoresKey, jsonEncode(scores.map((s) => s.toJson()).toList()));
  }

  List<ScoreModel> getScores() {
    final String? scoresJson = _prefs.getString(_scoresKey);
    if (scoresJson == null) return [];
    final List<dynamic> decoded = jsonDecode(scoresJson);
    return decoded.map((s) => ScoreModel.fromJson(s)).toList();
  }

  // Favorites
  Future<void> toggleFavorite(String gameId) async {
    final favorites = getFavorites();
    if (favorites.contains(gameId)) {
      favorites.remove(gameId);
    } else {
      favorites.add(gameId);
    }
    await _prefs.setStringList(_favoritesKey, favorites);
  }

  List<String> getFavorites() {
    return _prefs.getStringList(_favoritesKey) ?? [];
  }

  // Game History
  Future<void> addToHistory(ScoreModel score) async {
    final history = getHistory();
    history.insert(0, score); // Add to beginning
    if (history.length > 50) history.removeLast();
    await _prefs.setString(_historyKey, jsonEncode(history.map((s) => s.toJson()).toList()));
  }

  List<ScoreModel> getHistory() {
    final String? historyJson = _prefs.getString(_historyKey);
    if (historyJson == null) return [];
    final List<dynamic> decoded = jsonDecode(historyJson);
    return decoded.map((s) => ScoreModel.fromJson(s)).toList();
  }

  // Daily Streak
  int getStreak() {
    final lastLogin = _prefs.getString(_lastLoginKey);
    final streak = _prefs.getInt(_streakKey) ?? 0;
    
    if (lastLogin == null) return 0;
    
    final lastDate = DateTime.parse(lastLogin);
    final now = DateTime.now();
    final difference = now.difference(lastDate).inDays;
    
    if (difference == 1) {
      return streak;
    } else if (difference > 1) {
      return 0;
    }
    return streak;
  }

  Future<void> updateStreak() async {
    final lastLogin = _prefs.getString(_lastLoginKey);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    if (lastLogin == null) {
      await _prefs.setInt(_streakKey, 1);
      await _prefs.setString(_lastLoginKey, today.toIso8601String());
      return;
    }

    final lastDate = DateTime.parse(lastLogin);
    final difference = today.difference(lastDate).inDays;

    if (difference == 1) {
      final newStreak = (await _prefs.getInt(_streakKey) ?? 0) + 1;
      await _prefs.setInt(_streakKey, newStreak);
      await _prefs.setString(_lastLoginKey, today.toIso8601String());
    } else if (difference > 1) {
      await _prefs.setInt(_streakKey, 1);
      await _prefs.setString(_lastLoginKey, today.toIso8601String());
    }
  }

  // Levels
  Future<void> completeLevel(String gameId, int level) async {
    final levels = getCompletedLevels();
    final currentMax = levels[gameId] ?? 0;
    if (level > currentMax) {
      levels[gameId] = level;
      await _prefs.setString(_completedLevelsKey, jsonEncode(levels));
    }
  }

  Map<String, int> getCompletedLevels() {
    final String? levelsJson = _prefs.getString(_completedLevelsKey);
    if (levelsJson == null) return {};
    return Map<String, int>.from(jsonDecode(levelsJson));
  }
}
