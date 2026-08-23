import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/note.dart';

class NoteProvider with ChangeNotifier {
  List<Note> _notes = [];
  List<Note> _filteredNotes = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  List<Note> get notes => _searchQuery.isEmpty && _selectedCategory == 'All' ? _notes : _filteredNotes;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;

  final List<String> categories = ['All', 'Personal', 'Work', 'Ideas', 'Important', 'Others'];

  Future<void> fetchNotes() async {
    _isLoading = true;
    notifyListeners();
    _notes = await DBHelper.instance.readAllNotes();
    _applyFilters();
    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredNotes = _notes.where((note) {
      final matchesSearch = note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          note.content.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || note.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
    
    // Maintain pin sorting in filtered list
    _filteredNotes.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.updatedAt.compareTo(a.updatedAt);
    });
  }

  Future<void> addNote(Note note) async {
    await DBHelper.instance.create(note);
    await fetchNotes();
  }

  Future<void> updateNote(Note note) async {
    await DBHelper.instance.update(note);
    await fetchNotes();
  }

  Future<void> deleteNote(int id) async {
    await DBHelper.instance.delete(id);
    await fetchNotes();
  }

  Future<void> togglePin(Note note) async {
    final updatedNote = note.copyWith(isPinned: !note.isPinned, updatedAt: DateTime.now());
    await updateNote(updatedNote);
  }

  Future<void> toggleFavorite(Note note) async {
    final updatedNote = note.copyWith(isFavorite: !note.isFavorite, updatedAt: DateTime.now());
    await updateNote(updatedNote);
  }
}
