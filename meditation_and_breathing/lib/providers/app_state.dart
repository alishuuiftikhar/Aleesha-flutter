import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class AppState with ChangeNotifier {
  UserStats _stats = UserStats(history: [], favoriteSessionIds: [], journalEntries: []);
  List<MeditationSession> _sessions = [];
  bool _isLoading = true;
  String _selectedMood = '';

  UserStats get stats => _stats;
  List<MeditationSession> get sessions => _sessions;
  bool get isLoading => _isLoading;
  String get selectedMood => _selectedMood;

  AppState() {
    _init();
  }

  void setMood(String mood) {
    _selectedMood = mood;
    notifyListeners();
  }

  void addJournalEntry(String content) {
    final entry = JournalEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      mood: _selectedMood,
      content: content,
    );
    _stats.journalEntries.add(entry);
    _saveStats();
    notifyListeners();
  }

  Future<void> _init() async {
    await _loadStats();
    await _loadSessions();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    final statsJson = prefs.getString('user_stats');
    if (statsJson != null) {
      _stats = UserStats.fromJson(statsJson);
    }
  }

  Future<void> _saveStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_stats', _stats.toJson());
  }

  Future<void> _loadSessions() async {
    try {
      final String response = await rootBundle.loadString('assets/sessions.json');
      final List<dynamic> data = json.decode(response);
      _sessions = data.map((x) => MeditationSession.fromMap(x)).toList();
    } catch (e) {
      debugPrint("Error loading sessions: $e");
      // Fallback data if needed
    }

    for (var session in _sessions) {
      if (_stats.favoriteSessionIds.contains(session.id)) {
        session.isFavorite = true;
      }
    }
  }

  void toggleFavorite(String sessionId) {
    final index = _sessions.indexWhere((s) => s.id == sessionId);
    if (index != -1) {
      _sessions[index].isFavorite = !_sessions[index].isFavorite;
      if (_sessions[index].isFavorite) {
        _stats.favoriteSessionIds.add(sessionId);
      } else {
        _stats.favoriteSessionIds.remove(sessionId);
      }
      _saveStats();
      notifyListeners();
    }
  }

  void completeSession(int minutes) {
    _stats.totalSessions += 1;
    _stats.totalMinutes += minutes;
    _stats.history.add(DateTime.now());
    
    // Simple streak logic: if last session was today or yesterday
    // This is simplified for the demo
    _stats.currentStreak += 1; 
    
    _saveStats();
    notifyListeners();
  }
}
