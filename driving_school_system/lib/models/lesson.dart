class Lesson {
  final String id;
  final String title;
  final String content;
  final String category;
  bool isCompleted;

  Lesson({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.isCompleted = false,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      category: json['category'],
    );
  }
}
