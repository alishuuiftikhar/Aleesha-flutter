class WorkoutSession {
  final String id;
  final String workoutId;
  final String workoutTitle;
  final DateTime date;
  final int durationSeconds;
  final int caloriesBurned;

  WorkoutSession({
    required this.id,
    required this.workoutId,
    required this.workoutTitle,
    required this.date,
    required this.durationSeconds,
    required this.caloriesBurned,
  });

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    return WorkoutSession(
      id: json['id'],
      workoutId: json['workoutId'],
      workoutTitle: json['workoutTitle'],
      date: DateTime.parse(json['date']),
      durationSeconds: json['durationSeconds'],
      caloriesBurned: json['caloriesBurned'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workoutId': workoutId,
      'workoutTitle': workoutTitle,
      'date': date.toIso8601String(),
      'durationSeconds': durationSeconds,
      'caloriesBurned': caloriesBurned,
    };
  }
}
