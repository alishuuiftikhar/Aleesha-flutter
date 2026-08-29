import 'package:flutter/material.dart';
import '../models/language.dart';
import '../models/lesson.dart';
import '../models/vocabulary.dart';
import '../models/question.dart';
import '../services/data_service.dart';
import '../services/storage_service.dart';

class AppProvider with ChangeNotifier {
  List<Language> _languages = [];
  List<Lesson> _lessons = [];
  List<Vocabulary> _vocabulary = [];
  List<Question> _questions = [];
  
  Language? _selectedLanguage;
  List<String> _completedLessonIds = [];
  List<String> _favoriteWordIds = [];
  int _streak = 0;
  int _dailyGoal = 20;
  int _todayPoints = 0;
  bool _isFirstTime = true;

  List<Language> get languages => _languages;
  List<Lesson> get lessons => _lessons.where((l) => l.languageId == _selectedLanguage?.id).toList();
  List<Vocabulary> get vocabulary => _vocabulary;
  List<Question> get questions => _questions;
  Language? get selectedLanguage => _selectedLanguage;
  List<String> get completedLessonIds => _completedLessonIds;
  List<String> get favoriteWordIds => _favoriteWordIds;
  int get streak => _streak;
  int get dailyGoal => _dailyGoal;
  int get todayPoints => _todayPoints;
  bool get isFirstTime => _isFirstTime;

  Future<void> init() async {
    await StorageService.init();
    _languages = await DataService.loadLanguages();
    _vocabulary = await DataService.loadVocabulary();
    _questions = await DataService.loadQuestions();
    _lessons = await DataService.loadLessons();

    _loadFromStorage();
    notifyListeners();
  }

  void _loadFromStorage() {
    _isFirstTime = StorageService.getBool('isFirstTime', defaultValue: true);
    String? langId = StorageService.getString('selectedLanguageId');
    if (langId != null && _languages.any((l) => l.id == langId)) {
      _selectedLanguage = _languages.firstWhere((l) => l.id == langId);
    }

    _completedLessonIds = StorageService.getList('completedLessons') ?? [];
    _favoriteWordIds = StorageService.getList('favoriteWords') ?? [];
    _streak = StorageService.getInt('streak');
    _dailyGoal = StorageService.getInt('dailyGoal', defaultValue: 20);
    _todayPoints = StorageService.getInt('todayPoints');
  }

  void completeOnboarding() {
    _isFirstTime = false;
    StorageService.saveBool('isFirstTime', false);
    notifyListeners();
  }

  void selectLanguage(Language language) {
    _selectedLanguage = language;
    StorageService.saveString('selectedLanguageId', language.id);
    notifyListeners();
  }

  void completeLesson(String lessonId) {
    if (!_completedLessonIds.contains(lessonId)) {
      _completedLessonIds.add(lessonId);
      StorageService.saveList('completedLessons', _completedLessonIds);
      addPoints(50);
      notifyListeners();
    }
  }

  void toggleFavorite(String wordId) {
    if (_favoriteWordIds.contains(wordId)) {
      _favoriteWordIds.remove(wordId);
    } else {
      _favoriteWordIds.add(wordId);
    }
    StorageService.saveList('favoriteWords', _favoriteWordIds);
    notifyListeners();
  }

  void addPoints(int points) {
    _todayPoints += points;
    StorageService.saveInt('todayPoints', _todayPoints);
    if (_todayPoints >= _dailyGoal && _todayPoints - points < _dailyGoal) {
      _streak += 1;
      StorageService.saveInt('streak', _streak);
    }
    notifyListeners();
  }

  double getProgress() {
    if (lessons.isEmpty) return 0;
    int completed = lessons.where((l) => _completedLessonIds.contains(l.id)).length;
    return completed / lessons.length;
  }
}
