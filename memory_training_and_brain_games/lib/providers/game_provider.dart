import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/game.dart';
import '../models/score.dart';
import '../services/storage_service.dart';

class GameProvider with ChangeNotifier {
  final StorageService _storage;
  List<GameModel> _games = [];
  List<ScoreModel> _history = [];
  List<String> _favorites = [];
  int _streak = 0;

  GameProvider(this._storage) {
    _loadData();
  }

  List<GameModel> get games => _games;
  List<ScoreModel> get history => _history;
  List<String> get favorites => _favorites;
  int get streak => _streak;

  Future<void> _loadData() async {
    // Load games from JSON
    final String response = await rootBundle.loadString('assets/data/games.json');
    final data = await jsonDecode(response) as List;
    _games = data.map((g) => GameModel.fromJson(g)).toList();

    // Load favorites
    _favorites = _storage.getFavorites();
    
    // Load history
    _history = _storage.getHistory();
    
    // Load streak
    _streak = _storage.getStreak();
    
    _updateGamesWithFavorites();
    notifyListeners();
  }

  void _updateGamesWithFavorites() {
    for (int i = 0; i < _games.length; i++) {
      if (_favorites.contains(_games[i].id)) {
        _games[i] = _games[i].copyWith(isFavorite: true);
      } else {
        _games[i] = _games[i].copyWith(isFavorite: false);
      }
    }
  }

  Future<void> toggleFavorite(String gameId) async {
    await _storage.toggleFavorite(gameId);
    _favorites = _storage.getFavorites();
    _updateGamesWithFavorites();
    notifyListeners();
  }

  Future<void> saveGameResult(String gameId, int score, Difficulty difficulty) async {
    final result = ScoreModel(
      gameId: gameId,
      score: score,
      date: DateTime.now(),
      difficulty: difficulty.toString().split('.').last,
    );
    await _storage.saveScore(result);
    await _storage.addToHistory(result);
    await _storage.updateStreak();
    
    _history = _storage.getHistory();
    _streak = _storage.getStreak();
    notifyListeners();
  }
  
  List<GameModel> searchGames(String query) {
    if (query.isEmpty) return _games;
    return _games.where((g) => g.title.toLowerCase().contains(query.toLowerCase())).toList();
  }

  GameModel? getGameById(String id) {
    try {
      return _games.firstWhere((g) => g.id == id);
    } catch (e) {
      return null;
    }
  }
}
