class QuizHistory {
  final String categoryName;
  final int score;
  final int totalQuestions;
  final DateTime date;

  QuizHistory({
    required this.categoryName,
    required this.score,
    required this.totalQuestions,
    required this.date,
  });

  factory QuizHistory.fromJson(Map<String, dynamic> json) {
    return QuizHistory(
      categoryName: json['categoryName'],
      score: json['score'],
      totalQuestions: json['totalQuestions'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryName': categoryName,
      'score': score,
      'totalQuestions': totalQuestions,
      'date': date.toIso8601String(),
    };
  }
}
