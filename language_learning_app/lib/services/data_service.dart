import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/language.dart';
import '../models/lesson.dart';
import '../models/vocabulary.dart';
import '../models/question.dart';

class DataService {
  static Future<List<Language>> loadLanguages() async {
    final String response = await rootBundle.loadString('assets/data/languages.json');
    final List<dynamic> data = json.decode(response);
    return data.map((e) => Language.fromJson(e)).toList();
  }

  static Future<List<Lesson>> loadLessons() async {
    final String response = await rootBundle.loadString('assets/data/lessons.json');
    final List<dynamic> data = json.decode(response);
    return data.map((e) => Lesson.fromJson(e)).toList();
  }

  static Future<List<Vocabulary>> loadVocabulary() async {
    final String response = await rootBundle.loadString('assets/data/vocabulary.json');
    final List<dynamic> data = json.decode(response);
    return data.map((e) => Vocabulary.fromJson(e)).toList();
  }

  static Future<List<Question>> loadQuestions() async {
    final String response = await rootBundle.loadString('assets/data/questions.json');
    final List<dynamic> data = json.decode(response);
    return data.map((e) => Question.fromJson(e)).toList();
  }
}
