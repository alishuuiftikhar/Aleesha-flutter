import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/traffic_sign.dart';
import '../models/quiz.dart';
import '../models/lesson.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  List<TrafficSign> _signs = [];
  List<Quiz> _quizzes = [];
  List<Lesson> _lessons = [];
  
  List<TrafficSign> get signs => _signs;
  List<Quiz> get quizzes => _quizzes;
  List<Lesson> get lessons => _lessons;

  Future<void> init() async {
    await _loadSigns();
    await _loadQuizzes();
    await _loadLessons();
    await _loadUserData();
  }

  Future<void> _loadSigns() async {
    final String response = await rootBundle.loadString('assets/data/traffic_signs.json');
    final List<dynamic> data = json.decode(response);
    _signs = data.map((json) => TrafficSign.fromJson(json)).toList();
  }

  Future<void> _loadQuizzes() async {
    final String response = await rootBundle.loadString('assets/data/quizzes.json');
    final List<dynamic> data = json.decode(response);
    _quizzes = data.map((json) => Quiz.fromJson(json)).toList();
  }

  Future<void> _loadLessons() async {
    final String response = await rootBundle.loadString('assets/data/lessons.json');
    final List<dynamic> data = json.decode(response);
    _lessons = data.map((json) => Lesson.fromJson(json)).toList();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load favorites
    final favorites = prefs.getStringList('favorite_signs') ?? [];
    for (var sign in _signs) {
      sign.isFavorite = favorites.contains(sign.id);
    }

    // Load completed lessons
    final completed = prefs.getStringList('completed_lessons') ?? [];
    for (var lesson in _lessons) {
      lesson.isCompleted = completed.contains(lesson.id);
    }
  }

  Future<void> toggleFavorite(String signId) async {
    final sign = _signs.firstWhere((s) => s.id == signId);
    sign.isFavorite = !sign.isFavorite;
    
    final prefs = await SharedPreferences.getInstance();
    final favorites = _signs.where((s) => s.isFavorite).map((s) => s.id).toList();
    await prefs.setStringList('favorite_signs', favorites);
  }

  Future<void> markLessonCompleted(String lessonId) async {
    final lesson = _lessons.firstWhere((l) => l.id == lessonId);
    lesson.isCompleted = true;

    final prefs = await SharedPreferences.getInstance();
    final completed = _lessons.where((l) => l.isCompleted).map((l) => l.id).toList();
    await prefs.setStringList('completed_lessons', completed);
  }

  Future<void> saveQuizAttempt(String quizId, int score, int total) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('quiz_history') ?? [];
    final attempt = {
      'quizId': quizId,
      'score': score,
      'total': total,
      'date': DateTime.now().toIso8601String(),
    };
    history.add(json.encode(attempt));
    await prefs.setStringList('quiz_history', history);
  }

  Future<List<Map<String, dynamic>>> getQuizHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('quiz_history') ?? [];
    return history.map((h) => json.decode(h) as Map<String, dynamic>).toList();
  }

  Quiz generateMockTest() {
    List<Question> allQuestions = [];
    for (var quiz in _quizzes) {
      allQuestions.addAll(quiz.questions);
    }
    allQuestions.shuffle();
    
    // Pick first 5 questions for a quick mock test (can be increased)
    final selectedQuestions = allQuestions.take(5).toList();
    
    return Quiz(
      id: 'mock_test',
      title: 'Full Mock Exam',
      description: 'A randomized test covering all topics.',
      questions: selectedQuestions,
    );
  }
}
