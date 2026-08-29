import 'dart:convert';

class MeditationSession {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final int durationMinutes;
  final String category;
  final String audioUrl;
  bool isFavorite;

  MeditationSession({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.durationMinutes,
    required this.category,
    required this.audioUrl,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'durationMinutes': durationMinutes,
      'category': category,
      'audioUrl': audioUrl,
      'isFavorite': isFavorite,
    };
  }

  factory MeditationSession.fromMap(Map<String, dynamic> map) {
    return MeditationSession(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      durationMinutes: map['durationMinutes'] ?? 0,
      category: map['category'] ?? '',
      audioUrl: map['audioUrl'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
    );
  }
}

class BreathingExercise {
  final String id;
  final String title;
  final String description;
  final int inhaleSeconds;
  final int holdSeconds;
  final int exhaleSeconds;
  final int restSeconds;

  BreathingExercise({
    required this.id,
    required this.title,
    required this.description,
    required this.inhaleSeconds,
    required this.holdSeconds,
    required this.exhaleSeconds,
    this.restSeconds = 0,
  });
}

class UserStats {
  int totalSessions;
  int totalMinutes;
  int currentStreak;
  List<DateTime> history;
  List<String> favoriteSessionIds;
  List<JournalEntry> journalEntries;

  UserStats({
    this.totalSessions = 0,
    this.totalMinutes = 0,
    this.currentStreak = 0,
    required this.history,
    required this.favoriteSessionIds,
    required this.journalEntries,
  });

  Map<String, dynamic> toMap() {
    return {
      'totalSessions': totalSessions,
      'totalMinutes': totalMinutes,
      'currentStreak': currentStreak,
      'history': history.map((x) => x.toIso8601String()).toList(),
      'favoriteSessionIds': favoriteSessionIds,
      'journalEntries': journalEntries.map((x) => x.toMap()).toList(),
    };
  }

  factory UserStats.fromMap(Map<String, dynamic> map) {
    return UserStats(
      totalSessions: map['totalSessions'] ?? 0,
      totalMinutes: map['totalMinutes'] ?? 0,
      currentStreak: map['currentStreak'] ?? 0,
      history: List<DateTime>.from(
          (map['history'] ?? []).map((x) => DateTime.parse(x))),
      favoriteSessionIds: List<String>.from(map['favoriteSessionIds'] ?? []),
      journalEntries: List<JournalEntry>.from(
          (map['journalEntries'] ?? []).map((x) => JournalEntry.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserStats.fromJson(String source) =>
      UserStats.fromMap(json.decode(source));
}

class JournalEntry {
  final String id;
  final DateTime date;
  final String mood;
  final String content;

  JournalEntry({
    required this.id,
    required this.date,
    required this.mood,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'mood': mood,
      'content': content,
    };
  }

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'] ?? '',
      date: DateTime.parse(map['date']),
      mood: map['mood'] ?? '',
      content: map['content'] ?? '',
    );
  }
}
