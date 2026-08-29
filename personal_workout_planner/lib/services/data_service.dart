import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/exercise.dart';
import '../models/workout.dart';

class DataService {
  List<Exercise> _exercises = [];
  List<Workout> _workouts = [];

  Future<void> init() async {
    await loadExercises();
    await loadWorkouts();
  }

  Future<void> loadExercises() async {
    final String response = await rootBundle.loadString('assets/data/exercises.json');
    final data = await json.decode(response);
    _exercises = (data['exercises'] as List).map((e) => Exercise.fromJson(e)).toList();
  }

  Future<void> loadWorkouts() async {
    final String response = await rootBundle.loadString('assets/data/workouts.json');
    final data = await json.decode(response);
    _workouts = (data['workouts'] as List).map((e) => Workout.fromJson(e)).toList();
  }

  List<Exercise> get exercises => _exercises;
  List<Workout> get workouts => _workouts;

  Exercise? getExerciseById(String id) {
    try {
      return _exercises.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Exercise> searchExercises(String query) {
    return _exercises.where((e) => e.name.toLowerCase().contains(query.toLowerCase())).toList();
  }

  List<Exercise> filterExercisesByCategory(String category) {
    if (category == 'All') return _exercises;
    return _exercises.where((e) => e.category == category).toList();
  }

  Workout? getWorkoutById(String id) {
    try {
      return _workouts.firstWhere((w) => w.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Workout> getWorkoutsByLevel(String level) {
    return _workouts.where((w) => w.level == level).toList();
  }

  List<Workout> getWorkoutsByCategory(String category) {
    return _workouts.where((w) => w.category == category).toList();
  }
}
