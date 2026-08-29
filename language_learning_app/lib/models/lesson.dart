class Lesson {
  final String id;
  final String languageId;
  final String title;
  final String description;
  final String level;
  final int order;

  Lesson({
    required this.id,
    required this.languageId,
    required this.title,
    required this.description,
    required this.level,
    required this.order,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      languageId: json['languageId'],
      title: json['title'],
      description: json['description'],
      level: json['level'],
      order: json['order'],
    );
  }
}
