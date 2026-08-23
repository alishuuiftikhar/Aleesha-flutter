import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history.dart';

class StorageService {
  static const String _historyKey = 'quiz_history';
  static const String _highScoreKey = 'high_scores';

  Future<void> saveHistory(QuizHistory history) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> historyList = prefs.getStringList(_historyKey) ?? [];
    historyList.add(jsonEncode(history.toJson()));
    await prefs.setStringList(_historyKey, historyList);
    
    // Update high score for category
    await _updateHighScore(history.categoryName, history.score);
  }

  Future<List<QuizHistory>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> historyList = prefs.getStringList(_historyKey) ?? [];
    return historyList
        .map((item) => QuizHistory.fromJson(jsonDecode(item)))
        .toList()
        .reversed
        .toList();
  }

  Future<void> _updateHighScore(String categoryName, int score) async {
    final prefs = await SharedPreferences.getInstance();
    final String key = '${_highScoreKey}_$categoryName';
    final int currentHighScore = prefs.getInt(key) ?? 0;
    if (score > currentHighScore) {
      await prefs.setInt(key, score);
    }
  }

  Future<int> getHighScore(String categoryName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('${_highScoreKey}_$categoryName') ?? 0;
  }
}
