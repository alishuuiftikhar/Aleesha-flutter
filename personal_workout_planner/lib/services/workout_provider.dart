import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../models/workout.dart';
import '../models/workout_session.dart';
import 'data_service.dart';
import 'storage_service.dart';
import 'package:uuid/uuid.dart';

class WorkoutProvider with ChangeNotifier {
  final DataService _dataService = DataService();
  final StorageService _storageService = StorageService();
  
  List<Exercise> _exercises = [];
  List<Workout> _workouts = [];
  List<Workout> _customWorkouts = [];
  List<String> _favoriteExercises = [];
  List<String> _favoriteWorkouts = [];
  List<WorkoutSession> _history = [];
  bool _isLoading = true;

  bool get isLoading => _isLoading;
  List<Exercise> get exercises => _exercises;
  List<Workout> get allWorkouts => [..._workouts, ..._customWorkouts];
  List<Workout> get customWorkouts => _customWorkouts;
  List<String> get favoriteExercises => _favoriteExercises;
  List<String> get favoriteWorkouts => _favoriteWorkouts;
  List<WorkoutSession> get history => _history;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    await _dataService.init();
    _exercises = _dataService.exercises;
    _workouts = _dataService.workouts;

    _customWorkouts = await _storageService.getCustomWorkouts();
    _favoriteExercises = await _storageService.getFavoriteExercises();
    _favoriteWorkouts = await _storageService.getFavoriteWorkouts();
    _history = await _storageService.getWorkoutHistory();

    _isLoading = false;
    notifyListeners();
  }

  // Favorites
  bool isExerciseFavorite(String id) => _favoriteExercises.contains(id);
  bool isWorkoutFavorite(String id) => _favoriteWorkouts.contains(id);

  Future<void> toggleFavoriteExercise(String id) async {
    await _storageService.toggleFavoriteExercise(id);
    _favoriteExercises = await _storageService.getFavoriteExercises();
    notifyListeners();
  }

  Future<void> toggleFavoriteWorkout(String id) async {
    await _storageService.toggleFavoriteWorkout(id);
    _favoriteWorkouts = await _storageService.getFavoriteWorkouts();
    notifyListeners();
  }

  // Custom Workouts
  Future<void> saveCustomWorkout(Workout workout) async {
    await _storageService.saveCustomWorkout(workout);
    _customWorkouts = await _storageService.getCustomWorkouts();
    notifyListeners();
  }

  Future<void> deleteCustomWorkout(String id) async {
    await _storageService.deleteCustomWorkout(id);
    _customWorkouts = await _storageService.getCustomWorkouts();
    notifyListeners();
  }

  // History
  Future<void> completeWorkout(Workout workout, int durationSeconds) async {
    final session = WorkoutSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      workoutId: workout.id,
      workoutTitle: workout.title,
      date: DateTime.now(),
      durationSeconds: durationSeconds,
      caloriesBurned: (durationSeconds / 60 * 7).toInt(), // dummy calc
    );
    await _storageService.saveWorkoutSession(session);
    _history = await _storageService.getWorkoutHistory();
    notifyListeners();
  }

  // Statistics
  int get totalWorkouts => _history.length;
  int get weeklyWorkouts {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    return _history.where((s) => s.date.isAfter(weekAgo)).length;
  }
  
  int get currentStreak {
    if (_history.isEmpty) return 0;
    // Simple streak calculation based on daily completion
    final sortedHistory = [..._history]..sort((a, b) => b.date.compareTo(a.date));
    int streak = 0;
    DateTime lastDate = DateTime.now();
    
    // Normalize date to compare days
    DateTime normalize(DateTime d) => DateTime(d.year, d.month, d.day);
    
    DateTime checkDate = normalize(lastDate);
    
    for (var session in sortedHistory) {
      DateTime sessionDate = normalize(session.date);
      if (sessionDate == checkDate) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else if (sessionDate.isBefore(checkDate)) {
        break;
      }
    }
    return streak;
  }
}
