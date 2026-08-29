class Vocabulary {
  final String id;
  final String lessonId;
  final String word;
  final String translation;
  final String pronunciation;
  final String example;
  final String exampleTranslation;
  bool isFavorite;

  Vocabulary({
    required this.id,
    required this.lessonId,
    required this.word,
    required this.translation,
    required this.pronunciation,
    required this.example,
    required this.exampleTranslation,
    this.isFavorite = false,
  });

  factory Vocabulary.fromJson(Map<String, dynamic> json) {
    return Vocabulary(
      id: json['id'],
      lessonId: json['lessonId'],
      word: json['word'],
      translation: json['translation'],
      pronunciation: json['pronunciation'],
      example: json['example'],
      exampleTranslation: json['exampleTranslation'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lessonId': lessonId,
      'word': word,
      'translation': translation,
      'pronunciation': pronunciation,
      'example': example,
      'exampleTranslation': exampleTranslation,
      'isFavorite': isFavorite,
    };
  }
}
