class Workout {
  final String id;
  final String userId;
  final String name;
  final DateTime createdAt;
  final String? description;

  Workout({
    required this.id,
    required this.userId,
    required this.name,
    required this.createdAt,
    this.description,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'description': description,
    };
  }
}
