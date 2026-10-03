class QuizQuestion {
  final int? id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String difficulty;

  QuizQuestion({
    this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.difficulty,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'options': options.join('|'),
      'correctIndex': correctIndex,
      'difficulty': difficulty,
    };
  }

  factory QuizQuestion.fromMap(Map<String, dynamic> map) {
    return QuizQuestion(
      id: map['id'],
      question: map['question'],
      options: (map['options'] as String).split('|'),
      correctIndex: map['correctIndex'],
      difficulty: map['difficulty'],
    );
  }
}

class QuizResult {
  final int? id;
  final DateTime date;
  final int score;
  final int totalQuestions;
  final String difficulty;

  QuizResult({
    this.id,
    required this.date,
    required this.score,
    required this.totalQuestions,
    required this.difficulty,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'score': score,
      'totalQuestions': totalQuestions,
      'difficulty': difficulty,
    };
  }

  factory QuizResult.fromMap(Map<String, dynamic> map) {
    return QuizResult(
      id: map['id'],
      date: DateTime.parse(map['date']),
      score: map['score'],
      totalQuestions: map['totalQuestions'],
      difficulty: map['difficulty'],
    );
  }
}
