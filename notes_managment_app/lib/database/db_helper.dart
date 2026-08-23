import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static const String _key = 'notes';

  DBHelper._init();

  Future<List<Note>> readAllNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesJson = prefs.getString(_key);
    if (notesJson == null) return [];

    final List<dynamic> decoded = jsonDecode(notesJson);
    final notes = decoded.map((item) => Note.fromMap(item)).toList();
    
    // Sort by pin and then updated date
    notes.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.updatedAt.compareTo(a.updatedAt);
    });
    
    return notes;
  }

  Future<int> create(Note note) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Note> notes = await readAllNotes();
    
    // Generate an ID if it's null (simple increment)
    int maxId = 0;
    for (var n in notes) {
      if (n.id != null && n.id! > maxId) maxId = n.id!;
    }
    final newNote = note.copyWith(id: maxId + 1);
    
    notes.add(newNote);
    await _saveNotes(prefs, notes);
    return newNote.id!;
  }

  Future<int> update(Note note) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Note> notes = await readAllNotes();
    
    final index = notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      notes[index] = note;
      await _saveNotes(prefs, notes);
      return 1;
    }
    return 0;
  }

  Future<int> delete(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Note> notes = await readAllNotes();
    
    final initialLength = notes.length;
    notes.removeWhere((n) => n.id == id);
    
    if (notes.length < initialLength) {
      await _saveNotes(prefs, notes);
      return 1;
    }
    return 0;
  }

  Future<void> _saveNotes(SharedPreferences prefs, List<Note> notes) async {
    final String encoded = jsonEncode(notes.map((n) => n.toMap()).toList());
    await prefs.setString(_key, encoded);
  }
}
