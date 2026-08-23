class Goal {
  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime deadline;
  final bool isCompleted;

  Goal({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.deadline,
    this.isCompleted = false,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      description: json['description'],
      deadline: DateTime.parse(json['deadline']),
      isCompleted: json['is_completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'deadline': deadline.toIso8601String(),
      'is_completed': isCompleted,
    };
  }
}
