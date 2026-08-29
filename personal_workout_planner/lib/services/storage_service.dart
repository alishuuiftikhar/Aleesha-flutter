import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout.dart';
import '../models/workout_session.dart';

class StorageService {
  static const String _favExercisesKey = 'favorite_exercises';
  static const String _favWorkoutsKey = 'favorite_workouts';
  static const String _customWorkoutsKey = 'custom_workouts';
  static const String _workoutHistoryKey = 'workout_history';

  // Favorites
  Future<List<String>> getFavoriteExercises() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favExercisesKey) ?? [];
  }

  Future<void> toggleFavoriteExercise(String exerciseId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favs = prefs.getStringList(_favExercisesKey) ?? [];
    if (favs.contains(exerciseId)) {
      favs.remove(exerciseId);
    } else {
      favs.add(exerciseId);
    }
    await prefs.setStringList(_favExercisesKey, favs);
  }

  Future<List<String>> getFavoriteWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favWorkoutsKey) ?? [];
  }

  Future<void> toggleFavoriteWorkout(String workoutId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favs = prefs.getStringList(_favWorkoutsKey) ?? [];
    if (favs.contains(workoutId)) {
      favs.remove(workoutId);
    } else {
      favs.add(workoutId);
    }
    await prefs.setStringList(_favWorkoutsKey, favs);
  }

  // Custom Workouts
  Future<List<Workout>> getCustomWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> data = prefs.getStringList(_customWorkoutsKey) ?? [];
    return data.map((e) => Workout.fromJson(json.decode(e))).toList();
  }

  Future<void> saveCustomWorkout(Workout workout) async {
    final prefs = await SharedPreferences.getInstance();
    List<Workout> workouts = await getCustomWorkouts();
    int index = workouts.indexWhere((w) => w.id == workout.id);
    if (index != -1) {
      workouts[index] = workout;
    } else {
      workouts.add(workout);
    }
    await prefs.setStringList(_customWorkoutsKey, workouts.map((e) => json.encode(e.toJson())).toList());
  }

  Future<void> deleteCustomWorkout(String workoutId) async {
    final prefs = await SharedPreferences.getInstance();
    List<Workout> workouts = await getCustomWorkouts();
    workouts.removeWhere((w) => w.id == workoutId);
    await prefs.setStringList(_customWorkoutsKey, workouts.map((e) => json.encode(e.toJson())).toList());
  }

  // Workout History
  Future<List<WorkoutSession>> getWorkoutHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> data = prefs.getStringList(_workoutHistoryKey) ?? [];
    return data.map((e) => WorkoutSession.fromJson(json.decode(e))).toList();
  }

  Future<void> saveWorkoutSession(WorkoutSession session) async {
    final prefs = await SharedPreferences.getInstance();
    List<WorkoutSession> history = await getWorkoutHistory();
    history.add(session);
    await prefs.setStringList(_workoutHistoryKey, history.map((e) => json.encode(e.toJson())).toList());
  }
}
