import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/habit.dart';
import '../services/storage_service.dart';

class HabitProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  List<Habit> _habits = [];
  bool _isLoading = true;

  List<Habit> get habits => _habits;
  bool get isLoading => _isLoading;

  HabitProvider() {
    loadHabits();
  }

  Future<void> loadHabits() async {
    _isLoading = true;
    notifyListeners();
    _habits = await _storageService.loadHabits();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addHabit(String title, String category, Frequency frequency, TimeOfDay? reminderTime, int colorValue) async {
    final newHabit = Habit(
      id: const Uuid().v4(),
      title: title,
      category: category,
      frequency: frequency,
      reminderTime: reminderTime,
      completedDays: [],
      createdAt: DateTime.now(),
      colorValue: colorValue,
    );
    _habits.add(newHabit);
    await _storageService.saveHabits(_habits);
    notifyListeners();
  }

  Future<void> updateHabit(Habit updatedHabit) async {
    final index = _habits.indexWhere((h) => h.id == updatedHabit.id);
    if (index != -1) {
      _habits[index] = updatedHabit;
      await _storageService.saveHabits(_habits);
      notifyListeners();
    }
  }

  Future<void> deleteHabit(String id) async {
    _habits.removeWhere((h) => h.id == id);
    await _storageService.saveHabits(_habits);
    notifyListeners();
  }

  Future<void> toggleHabitCompletion(String id, DateTime date) async {
    final index = _habits.indexWhere((h) => h.id == id);
    if (index != -1) {
      final habit = _habits[index];
      final normalizedDate = DateTime(date.year, date.month, date.day);
      
      List<DateTime> updatedDays = List.from(habit.completedDays);
      bool alreadyCompleted = updatedDays.any((d) => 
        d.year == normalizedDate.year && 
        d.month == normalizedDate.month && 
        d.day == normalizedDate.day
      );

      if (alreadyCompleted) {
        updatedDays.removeWhere((d) => 
          d.year == normalizedDate.year && 
          d.month == normalizedDate.month && 
          d.day == normalizedDate.day
        );
      } else {
        updatedDays.add(normalizedDate);
      }

      _habits[index] = habit.copyWith(completedDays: updatedDays);
      await _storageService.saveHabits(_habits);
      notifyListeners();
    }
  }

  List<Habit> getHabitsForDate(DateTime date) {
    // For now, return all habits if frequency matches
    // In a more complex app, we might check frequency (e.g. weekly habits on specific days)
    return _habits;
  }

  double getCompletionPercentage(DateTime date) {
    final habitsForDate = getHabitsForDate(date);
    if (habitsForDate.isEmpty) return 0.0;
    
    int completedCount = habitsForDate.where((h) => 
      h.completedDays.any((d) => 
        d.year == date.year && d.month == date.month && d.day == date.day
      )
    ).length;
    
    return completedCount / habitsForDate.length;
  }
}
