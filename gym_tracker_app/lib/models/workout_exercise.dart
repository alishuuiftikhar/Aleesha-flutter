class WorkoutExercise {
  final String id;
  final String workoutId;
  final String exerciseId;
  final int sets;
  final int reps;
  final double weight;

  WorkoutExercise({
    required this.id,
    required this.workoutId,
    required this.exerciseId,
    required this.sets,
    required this.reps,
    required this.weight,
  });

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    return WorkoutExercise(
      id: json['id'],
      workoutId: json['workout_id'],
      exerciseId: json['exercise_id'],
      sets: json['sets'],
      reps: json['reps'],
      weight: (json['weight'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workout_id': workoutId,
      'exercise_id': exerciseId,
      'sets': sets,
      'reps': reps,
      'weight': weight,
    };
  }
}
