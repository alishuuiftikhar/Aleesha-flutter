import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

class StorageService {
  static const String _favoritesKey = 'favorites';
  static const String _moodboardsKey = 'moodboards';
  static const String _notesKey = 'notes';

  Future<void> saveFavorites(List<String> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, favorites);
  }

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  Future<void> saveMoodboards(List<Moodboard> moodboards) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> data = moodboards.map((m) => jsonEncode(m.toJson())).toList();
    await prefs.setStringList(_moodboardsKey, data);
  }

  Future<List<Moodboard>> getMoodboards() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? data = prefs.getStringList(_moodboardsKey);
    if (data == null) return [];
    return data.map((item) => Moodboard.fromJson(jsonDecode(item))).toList();
  }

  Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> data = notes.map((n) => jsonEncode(n.toJson())).toList();
    await prefs.setStringList(_notesKey, data);
  }

  Future<List<Note>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? data = prefs.getStringList(_notesKey);
    if (data == null) return [];
    return data.map((item) => Note.fromJson(jsonDecode(item))).toList();
  }
}
