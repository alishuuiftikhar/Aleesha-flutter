import 'package:flutter/material.dart';

enum Frequency { daily, weekly }

class Habit {
  final String id;
  final String title;
  final String category;
  final Frequency frequency;
  final TimeOfDay? reminderTime;
  final List<DateTime> completedDays;
  final bool isFavorite;
  final DateTime createdAt;
  final int colorValue;

  Habit({
    required this.id,
    required this.title,
    required this.category,
    required this.frequency,
    this.reminderTime,
    required this.completedDays,
    this.isFavorite = false,
    required this.createdAt,
    required this.colorValue,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'frequency': frequency.index,
      'reminderTime': reminderTime != null ? '${reminderTime!.hour}:${reminderTime!.minute}' : null,
      'completedDays': completedDays.map((d) => d.toIso8601String()).toList(),
      'isFavorite': isFavorite,
      'createdAt': createdAt.toIso8601String(),
      'colorValue': colorValue,
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    TimeOfDay? reminder;
    if (json['reminderTime'] != null) {
      final parts = (json['reminderTime'] as String).split(':');
      reminder = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }

    return Habit(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      frequency: Frequency.values[json['frequency']],
      reminderTime: reminder,
      completedDays: (json['completedDays'] as List).map((d) => DateTime.parse(d)).toList(),
      isFavorite: json['isFavorite'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      colorValue: json['colorValue'],
    );
  }

  Habit copyWith({
    String? title,
    String? category,
    Frequency? frequency,
    TimeOfDay? reminderTime,
    List<DateTime>? completedDays,
    bool? isFavorite,
    int? colorValue,
  }) {
    return Habit(
      id: id,
      title: title ?? this.title,
      category: category ?? this.category,
      frequency: frequency ?? this.frequency,
      reminderTime: reminderTime ?? this.reminderTime,
      completedDays: completedDays ?? this.completedDays,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt,
      colorValue: colorValue ?? this.colorValue,
    );
  }

  int get currentStreak {
    if (completedDays.isEmpty) return 0;
    
    final sortedDays = List<DateTime>.from(completedDays)..sort((a, b) => b.compareTo(a));
    int streak = 0;
    DateTime today = DateTime.now();
    DateTime checkDate = DateTime(today.year, today.month, today.day);
    
    // Check if today is completed or yesterday was the last completion
    bool foundToday = sortedDays.any((d) => _isSameDay(d, checkDate));
    if (!foundToday) {
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    for (var i = 0; i < sortedDays.length; i++) {
      if (_isSameDay(sortedDays[i], checkDate)) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else if (sortedDays[i].isBefore(checkDate)) {
        break;
      }
    }
    return streak;
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  double getCompletionRate(DateTime start, DateTime end) {
    int totalDays = end.difference(start).inDays + 1;
    if (totalDays <= 0) return 0.0;
    
    int completedCount = completedDays.where((d) => d.isAfter(start.subtract(const Duration(seconds: 1))) && d.isBefore(end.add(const Duration(days: 1)))).length;
    
    return (completedCount / totalDays).clamp(0.0, 1.0);
  }
}
