import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/exercise.dart';
import '../models/workout.dart';
import '../models/workout_exercise.dart';
import '../models/progress.dart';
import '../models/goal.dart';
import '../models/profile.dart';

class DatabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Helper to handle database errors
  String _handleError(dynamic e) {
    if (e is PostgrestException) {
      if (e.code == 'PGRST205') {
        return 'Table not found. Please create the table in Supabase SQL Editor.';
      }
      return e.message;
    }
    return e.toString();
  }

  // Exercises
  Future<List<Exercise>> getExercises() async {
    try {
      final response = await _supabase.from('exercises').select();
      return (response as List).map((json) => Exercise.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> addExercise(String name, String category) async {
    try {
      await _supabase.from('exercises').insert({
        'name': name,
        'category': category,
      });
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Workouts
  Future<List<Workout>> getWorkouts() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw 'User not logged in';
      
      final response = await _supabase.from('workouts').select().eq('user_id', user.id);
      return (response as List).map((json) => Workout.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> createWorkout(String name, String? description) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw 'User not logged in';
      
      await _supabase.from('workouts').insert({
        'user_id': user.id,
        'name': name,
        'description': description,
      });
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteWorkout(String workoutId) async {
    try {
      await _supabase.from('workouts').delete().eq('id', workoutId);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Progress
  Future<List<Progress>> getProgress() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw 'User not logged in';
      
      final response = await _supabase.from('progress')
          .select()
          .eq('user_id', user.id)
          .order('date', ascending: false);
      return (response as List).map((json) => Progress.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> addProgress(Progress progress) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw 'User not logged in';
      
      await _supabase.from('progress').insert({
        'user_id': user.id,
        'date': DateTime.now().toIso8601String(),
        'weight': progress.weight,
        'bmi': progress.bmi,
      });
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Profile
  Future<Profile> getProfile() async {
    try {
      final userId = _supabase.auth.currentUser!.id;
      final response = await _supabase.from('profiles').select().eq('id', userId).single();
      return Profile.fromJson(response);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<List<WorkoutExercise>> getWorkoutExercises(String workoutId) async {
    try {
      final response = await _supabase.from('workout_exercises').select().eq('workout_id', workoutId);
      return (response as List).map((json) => WorkoutExercise.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }
}
