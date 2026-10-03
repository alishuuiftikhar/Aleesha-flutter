import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../database/db_helper.dart';
import '../models/astronomy_object.dart';
import '../models/observation.dart';
import '../models/quiz.dart';
import '../models/checklist_item.dart';
import '../data/initial_data.dart';

class AstronomyProvider with ChangeNotifier {
  List<AstronomyObject> _objects = [];
  List<Observation> _observations = [];
  List<QuizResult> _quizResults = [];
  List<ChecklistItem> _checklist = [];
  List<AstronomyObject> _recentlyViewed = [];

  List<AstronomyObject> get objects => _objects;
  List<Observation> get observations => _observations;
  List<QuizResult> get quizResults => _quizResults;
  List<ChecklistItem> get checklist => _checklist;
  List<AstronomyObject> get recentlyViewed => _recentlyViewed;
  List<AstronomyObject> get favorites => _objects.where((o) => o.isFavorite).toList();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  AstronomyProvider() {
    loadData();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    final db = await DBHelper().database;

    // Refresh initial data to ensure updated image links are applied
    for (var obj in InitialData.objects) {
      final List<Map<String, dynamic>> existing = await db.query(
        'astronomy_objects',
        where: 'name = ?',
        whereArgs: [obj.name],
      );
      
      if (existing.isNotEmpty) {
        // Update fields if they already exist to keep data fresh
        await db.update(
          'astronomy_objects',
          {
            'image': obj.image,
            'description': obj.description,
            'distance': obj.distance,
            'size': obj.size,
            'discoveryInfo': obj.discoveryInfo,
            'facts': obj.facts.join('|'),
            'relatedObjects': obj.relatedObjects.join('|'),
          },
          where: 'name = ?',
          whereArgs: [obj.name],
        );
      } else {
        await db.insert('astronomy_objects', obj.toMap());
      }
    }

    final List<Map<String, dynamic>> objectMaps = await db.query('astronomy_objects');
    _objects = objectMaps.map((m) => AstronomyObject.fromMap(m)).toList();

    final List<Map<String, dynamic>> obsMaps = await db.query('observations', orderBy: 'date DESC');
    _observations = obsMaps.map((m) => Observation.fromMap(m)).toList();

    final List<Map<String, dynamic>> quizMaps = await db.query('quiz_results', orderBy: 'date DESC');
    _quizResults = quizMaps.map((m) => QuizResult.fromMap(m)).toList();

    final List<Map<String, dynamic>> checkMaps = await db.query('checklist_items');
    _checklist = checkMaps.map((m) => ChecklistItem.fromMap(m)).toList();

    _recentlyViewed = _objects
        .where((o) => o.lastViewed != null)
        .toList()
      ..sort((a, b) => b.lastViewed!.compareTo(a.lastViewed!));

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleFavorite(AstronomyObject object) async {
    final db = await DBHelper().database;
    final newValue = !object.isFavorite;
    await db.update(
      'astronomy_objects',
      {'isFavorite': newValue ? 1 : 0},
      where: 'id = ?',
      whereArgs: [object.id],
    );
    
    int index = _objects.indexWhere((o) => o.id == object.id);
    if (index != -1) {
      _objects[index] = _objects[index].copyWith(isFavorite: newValue);
      notifyListeners();
    }
  }

  Future<void> addToRecentlyViewed(AstronomyObject object) async {
    final db = await DBHelper().database;
    final now = DateTime.now();
    await db.update(
      'astronomy_objects',
      {'lastViewed': now.toIso8601String()},
      where: 'id = ?',
      whereArgs: [object.id],
    );
    
    int index = _objects.indexWhere((o) => o.id == object.id);
    if (index != -1) {
      _objects[index] = _objects[index].copyWith(lastViewed: now);
      
      _recentlyViewed = _objects
          .where((o) => o.lastViewed != null)
          .toList()
        ..sort((a, b) => b.lastViewed!.compareTo(a.lastViewed!));
      
      notifyListeners();
    }
  }

  // Observation CRUD
  Future<void> addObservation(Observation obs) async {
    final db = await DBHelper().database;
    await db.insert('observations', obs.toMap());
    await loadData();
  }

  Future<void> updateObservation(Observation obs) async {
    final db = await DBHelper().database;
    await db.update('observations', obs.toMap(), where: 'id = ?', whereArgs: [obs.id]);
    await loadData();
  }

  Future<void> deleteObservation(int id) async {
    final db = await DBHelper().database;
    await db.delete('observations', where: 'id = ?', whereArgs: [id]);
    await loadData();
  }

  // Quiz Results
  Future<void> addQuizResult(QuizResult result) async {
    final db = await DBHelper().database;
    await db.insert('quiz_results', result.toMap());
    await loadData();
  }

  // Checklist toggle
  Future<void> toggleChecklist(ChecklistItem item) async {
    final db = await DBHelper().database;
    final newValue = !item.isCompleted;
    await db.update(
      'checklist_items',
      {'isCompleted': newValue ? 1 : 0},
      where: 'id = ?',
      whereArgs: [item.id],
    );
    
    int index = _checklist.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _checklist[index] = ChecklistItem(id: item.id, title: item.title, isCompleted: newValue);
      notifyListeners();
    }
  }

  Future<List<QuizQuestion>> getQuizQuestions(String difficulty) async {
    final db = await DBHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(
      'quiz_questions',
      where: 'difficulty = ?',
      whereArgs: [difficulty],
    );
    return maps.map((m) => QuizQuestion.fromMap(m)).toList();
  }
}
