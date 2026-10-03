class PuzzleGame {
  final String id;
  final String title;
  final String description;
  final String icon;

  PuzzleGame({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });
}

class GameScore {
  final String gameId;
  final int score;
  final String duration;
  final DateTime date;

  GameScore({
    required this.gameId,
    required this.score,
    required this.duration,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'gameId': gameId,
    'score': score,
    'duration': duration,
    'date': date.toIso8601String(),
  };

  factory GameScore.fromJson(Map<String, dynamic> json) => GameScore(
    gameId: json['gameId'],
    score: json['score'],
    duration: json['duration'],
    date: DateTime.parse(json['date']),
  );
}
