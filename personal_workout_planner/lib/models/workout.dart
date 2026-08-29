import 'exercise.dart';

class Workout {
  final String id;
  final String title;
  final String description;
  final String image;
  final String level; // Beginner, Intermediate, Advanced
  final String category;
  final List<WorkoutExercise> exercises;
  final bool isCustom;

  Workout({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.level,
    required this.category,
    required this.exercises,
    this.isCustom = false,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      level: json['level'],
      category: json['category'],
      exercises: (json['exercises'] as List)
          .map((e) => WorkoutExercise.fromJson(e))
          .toList(),
      isCustom: json['isCustom'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'level': level,
      'category': category,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'isCustom': isCustom,
    };
  }

  int get totalDuration {
    int total = 0;
    for (var ex in exercises) {
      total += (ex.sets * (ex.reps * 3)) + (ex.sets * ex.restTime); // simple estimation
    }
    return total;
  }
}

class WorkoutExercise {
  final String exerciseId;
  final int sets;
  final int reps;
  final int restTime;
  final Exercise? exercise; // Loaded from DataService

  WorkoutExercise({
    required this.exerciseId,
    required this.sets,
    required this.reps,
    required this.restTime,
    this.exercise,
  });

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    return WorkoutExercise(
      exerciseId: json['exerciseId'],
      sets: json['sets'],
      reps: json['reps'],
      restTime: json['restTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'sets': sets,
      'reps': reps,
      'restTime': restTime,
    };
  }

  WorkoutExercise copyWith({int? sets, int? reps, int? restTime, Exercise? exercise}) {
    return WorkoutExercise(
      exerciseId: exerciseId,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      restTime: restTime ?? this.restTime,
      exercise: exercise ?? this.exercise,
    );
  }
}
