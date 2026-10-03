class ScoreModel {
  final String gameId;
  final int score;
  final DateTime date;
  final String difficulty;

  ScoreModel({
    required this.gameId,
    required this.score,
    required this.date,
    required this.difficulty,
  });

  factory ScoreModel.fromJson(Map<String, dynamic> json) {
    return ScoreModel(
      gameId: json['gameId'],
      score: json['score'],
      date: DateTime.parse(json['date']),
      difficulty: json['difficulty'],
    );
  }

  Map<String, dynamic> toJson() => {
    'gameId': gameId,
    'score': score,
    'date': date.toIso8601String(),
    'difficulty': difficulty,
  };
}
