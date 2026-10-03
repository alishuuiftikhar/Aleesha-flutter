class Moodboard {
  String id;
  String name;
  List<String> itemIds;
  String notes;

  Moodboard({
    required this.id,
    required this.name,
    List<String>? itemIds,
    this.notes = '',
  }) : itemIds = itemIds ?? [];

  factory Moodboard.fromJson(Map<String, dynamic> json) {
    return Moodboard(
      id: json['id'].toString(),
      name: json['name'] ?? json['title'] ?? '',
      itemIds: List<String>.from(json['itemIds'] ?? json['inspirationIds'] ?? []),
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'itemIds': itemIds,
      'notes': notes,
    };
  }
}

class Note {
  final String id;
  final String content;
  final DateTime date;

  Note({
    required this.id,
    required this.content,
    required this.date,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      content: json['content'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'date': date.toIso8601String(),
    };
  }
}
