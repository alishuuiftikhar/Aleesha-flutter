class CraftProject {
  final String id;
  final String title;
  final String category;
  final String difficulty;
  final String estimatedTime;
  final String description;
  final String imageUrl;
  final List<String> materials;
  final List<String> instructions;
  bool isFavorite;
  bool isCompleted;
  String notes;
  double progress;
  final bool isUserCreated;

  CraftProject({
    required this.id,
    required this.title,
    required this.category,
    required this.difficulty,
    required this.estimatedTime,
    required this.description,
    required this.imageUrl,
    required this.materials,
    required this.instructions,
    this.isFavorite = false,
    this.isCompleted = false,
    this.notes = '',
    this.progress = 0.0,
    this.isUserCreated = false,
  });

  factory CraftProject.fromJson(Map<String, dynamic> json) {
    return CraftProject(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      difficulty: json['difficulty'],
      estimatedTime: json['estimatedTime'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      materials: List<String>.from(json['materials']),
      instructions: List<String>.from(json['instructions']),
      isFavorite: json['isFavorite'] ?? false,
      isCompleted: json['isCompleted'] ?? false,
      notes: json['notes'] ?? '',
      progress: (json['progress'] ?? 0.0).toDouble(),
      isUserCreated: json['isUserCreated'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'difficulty': difficulty,
      'estimatedTime': estimatedTime,
      'description': description,
      'imageUrl': imageUrl,
      'materials': materials,
      'instructions': instructions,
      'isFavorite': isFavorite,
      'isCompleted': isCompleted,
      'notes': notes,
      'progress': progress,
      'isUserCreated': isUserCreated,
    };
  }

  CraftProject copyWith({
    String? title,
    String? category,
    String? difficulty,
    String? estimatedTime,
    String? description,
    String? imageUrl,
    List<String>? materials,
    List<String>? instructions,
    bool? isFavorite,
    bool? isCompleted,
    String? notes,
    double? progress,
  }) {
    return CraftProject(
      id: this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      materials: materials ?? this.materials,
      instructions: instructions ?? this.instructions,
      isFavorite: isFavorite ?? this.isFavorite,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
      progress: progress ?? this.progress,
      isUserCreated: this.isUserCreated,
    );
  }
}
