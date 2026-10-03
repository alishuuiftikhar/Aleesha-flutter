import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models.dart';
import 'storage_service.dart';

class AppProvider with ChangeNotifier {
  final StorageService _storage = StorageService();
  
  List<Inspiration> _allInspirations = [];
  List<Inspiration> get allInspirations => _allInspirations;
  
  List<String> _favoriteIds = [];
  List<String> get favoriteIds => _favoriteIds;
  
  List<Moodboard> _moodboards = [];
  List<Moodboard> get moodboards => _moodboards;
  
  List<Note> _notes = [];
  List<Note> get notes => _notes;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  AppProvider() {
    _init();
  }

  Future<void> _init() async {
    await loadInspirations();
    _favoriteIds = await _storage.getFavorites();
    _moodboards = await _storage.getMoodboards();
    _notes = await _storage.getNotes();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadInspirations() async {
    try {
      final String response = await rootBundle.loadString('assets/data/inspirations.json');
      final data = await json.decode(response) as List;
      _allInspirations = data.map((i) => Inspiration.fromJson(i)).toList();
    } catch (e) {
      debugPrint("Error loading inspirations: $e");
    }
  }

  // Favorites
  bool isFavorite(String id) => _favoriteIds.contains(id);

  void toggleFavorite(String id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    _storage.saveFavorites(_favoriteIds);
    notifyListeners();
  }

  List<Inspiration> get favoriteInspirations {
    return _allInspirations.where((i) => _favoriteIds.contains(i.id)).toList();
  }

  // Moodboards
  void createMoodboard(String name) {
    final newMoodboard = Moodboard(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      inspirationIds: [],
    );
    _moodboards.add(newMoodboard);
    _storage.saveMoodboards(_moodboards);
    notifyListeners();
  }

  void renameMoodboard(String id, String newName) {
    final index = _moodboards.indexWhere((m) => m.id == id);
    if (index != -1) {
      _moodboards[index].name = newName;
      _storage.saveMoodboards(_moodboards);
      notifyListeners();
    }
  }

  void deleteMoodboard(String id) {
    _moodboards.removeWhere((m) => m.id == id);
    _storage.saveMoodboards(_moodboards);
    notifyListeners();
  }

  void addToMoodboard(String moodboardId, String inspirationId) {
    final moodboard = _moodboards.firstWhere((m) => m.id == moodboardId);
    if (!moodboard.inspirationIds.contains(inspirationId)) {
      moodboard.inspirationIds.add(inspirationId);
      _storage.saveMoodboards(_moodboards);
      notifyListeners();
    }
  }

  void removeFromMoodboard(String moodboardId, String inspirationId) {
    final moodboard = _moodboards.firstWhere((m) => m.id == moodboardId);
    moodboard.inspirationIds.remove(inspirationId);
    _storage.saveMoodboards(_moodboards);
    notifyListeners();
  }

  List<Inspiration> getInspirationsForMoodboard(String moodboardId) {
    final moodboard = _moodboards.firstWhere((m) => m.id == moodboardId);
    return _allInspirations.where((i) => moodboard.inspirationIds.contains(i.id)).toList();
  }

  // Notes
  void addNote(String inspirationId, String content) {
    final newNote = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      inspirationId: inspirationId,
      content: content,
      createdAt: DateTime.now(),
    );
    _notes.add(newNote);
    _storage.saveNotes(_notes);
    notifyListeners();
  }

  void updateNote(String id, String content) {
    final index = _notes.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notes[index].content = content;
      _storage.saveNotes(_notes);
      notifyListeners();
    }
  }

  void deleteNote(String id) {
    _notes.removeWhere((n) => n.id == id);
    _storage.saveNotes(_notes);
    notifyListeners();
  }

  List<Note> getNotesForInspiration(String inspirationId) {
    return _notes.where((n) => n.inspirationId == inspirationId).toList();
  }
}
