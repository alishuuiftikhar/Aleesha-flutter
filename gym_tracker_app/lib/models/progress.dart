class Progress {
  final String id;
  final String userId;
  final DateTime date;
  final double weight;
  final double? bmi;
  final double? bodyFatPercentage;

  Progress({
    required this.id,
    required this.userId,
    required this.date,
    required this.weight,
    this.bmi,
    this.bodyFatPercentage,
  });

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      id: json['id'],
      userId: json['user_id'],
      date: DateTime.parse(json['date']),
      weight: (json['weight'] as num).toDouble(),
      bmi: json['bmi'] != null ? (json['bmi'] as num).toDouble() : null,
      bodyFatPercentage: json['body_fat_percentage'] != null ? (json['body_fat_percentage'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'date': date.toIso8601String(),
      'weight': weight,
      'bmi': bmi,
      'body_fat_percentage': bodyFatPercentage,
    };
  }
}
