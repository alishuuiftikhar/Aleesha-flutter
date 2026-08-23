import 'question.dart';

class Category {
  final String id;
  final String name;
  final String icon;
  final List<Question> questions;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.questions,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      questions: (json['questions'] as List)
          .map((q) => Question.fromJson(q))
          .toList(),
    );
  }
}
