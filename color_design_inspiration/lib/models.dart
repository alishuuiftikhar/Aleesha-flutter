import 'dart:convert';

class Inspiration {
  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final String description;
  final String author;
  final List<String> palette;

  Inspiration({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.description,
    required this.author,
    required this.palette,
  });

  factory Inspiration.fromJson(Map<String, dynamic> json) {
    return Inspiration(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      author: json['author'],
      palette: List<String>.from(json['palette']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'imageUrl': imageUrl,
      'description': description,
      'author': author,
      'palette': palette,
    };
  }
}

class Moodboard {
  final String id;
  String name;
  List<String> inspirationIds;

  Moodboard({
    required this.id,
    required this.name,
    required this.inspirationIds,
  });

  factory Moodboard.fromJson(Map<String, dynamic> json) {
    return Moodboard(
      id: json['id'],
      name: json['name'],
      inspirationIds: List<String>.from(json['inspirationIds']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'inspirationIds': inspirationIds,
    };
  }
}

class Note {
  final String id;
  final String inspirationId;
  String content;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.inspirationId,
    required this.content,
    required this.createdAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      inspirationId: json['inspirationId'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inspirationId': inspirationId,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
