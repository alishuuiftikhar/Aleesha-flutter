import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_model.dart';

class StorageService {
  static const String _scoresKey = 'puzzle_scores';

  Future<void> saveScore(GameScore score) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> scoresJson = prefs.getStringList(_scoresKey) ?? [];
    scoresJson.add(jsonEncode(score.toJson()));
    await prefs.setStringList(_scoresKey, scoresJson);
  }

  Future<List<GameScore>> getScores() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> scoresJson = prefs.getStringList(_scoresKey) ?? [];
    return scoresJson.map((s) => GameScore.fromJson(jsonDecode(s))).toList();
  }

  Future<List<GameScore>> getHighScores(String gameId) async {
    final scores = await getScores();
    final gameScores = scores.where((s) => s.gameId == gameId).toList();
    gameScores.sort((a, b) => b.score.compareTo(a.score));
    return gameScores.take(5).toList();
  }
}
