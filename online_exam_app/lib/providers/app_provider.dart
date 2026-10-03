import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../services/database_service.dart';

class AppProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;

  List<Exam> _exams = [];
  List<Exam> get exams => _exams;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    _currentUser = await _db.loginUser(email, password);
    _isLoading = false;
    notifyListeners();
    return _currentUser != null;
  }

  Future<bool> register(String name, String email, String password, String role) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _db.registerUser(AppUser(name: name, email: email, password: password, role: role));
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  Future<void> fetchExams({bool onlyPublished = false}) async {
    _isLoading = true;
    notifyListeners();
    _exams = await _db.getExams(onlyPublished: onlyPublished);
    _isLoading = false;
    notifyListeners();
  }

  // Admin Exam Management
  Future<void> addExam(Exam exam) async {
    await _db.insertExam(exam);
    await fetchExams();
  }

  Future<void> updateExam(Exam exam) async {
    await _db.updateExam(exam);
    await fetchExams();
  }

  Future<void> deleteExam(int id) async {
    await _db.deleteExam(id);
    await fetchExams();
  }

  // Question Management
  Future<void> addQuestion(Question question, List<QuestionOption> options) async {
    int questionId = await _db.insertQuestion(question);
    for (var option in options) {
      await _db.insertOption(QuestionOption(
        questionId: questionId,
        optionText: option.optionText,
        isCorrect: option.isCorrect,
      ));
    }
  }

  Future<List<Question>> getQuestions(int examId) async {
    return await _db.getQuestionsForExam(examId);
  }

  Future<List<QuestionOption>> getOptions(int questionId) async {
    return await _db.getOptionsForQuestion(questionId);
  }

  // Attempt Management
  Future<int> startExam(int examId) async {
    final attempt = ExamAttempt(
      userId: _currentUser!.id!,
      examId: examId,
      startTime: DateTime.now().toIso8601String(),
    );
    return await _db.startAttempt(attempt);
  }

  Future<void> submitExam(int attemptId, Map<int, int> selectedOptions, List<Question> questions) async {
    int score = 0;
    for (var question in questions) {
      int? selectedOptionId = selectedOptions[question.id];
      if (selectedOptionId != null) {
        await _db.submitAnswer(UserAnswer(
          attemptId: attemptId,
          questionId: question.id!,
          selectedOptionId: selectedOptionId,
        ));

        // Check if correct
        final options = await _db.getOptionsForQuestion(question.id!);
        final correctOption = options.firstWhere((o) => o.isCorrect == 1);
        if (correctOption.id == selectedOptionId) {
          score += question.marks;
        }
      }
    }
    await _db.completeAttempt(attemptId, score, DateTime.now().toIso8601String());
  }

  Future<List<ExamAttempt>> getMyHistory() async {
    if (_currentUser == null) return [];
    return await _db.getUserAttempts(_currentUser!.id!);
  }
}
