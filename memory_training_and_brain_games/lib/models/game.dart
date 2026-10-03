enum GameType {
  memoryCard,
  patternMemory,
  numberMemory,
  wordMemory,
  sequence,
  spatialNavigation,
  speedSearch,
  mathLogic,
  colorMatch,
  logicPuzzle,
}

enum Difficulty {
  easy,
  medium,
  hard,
}

class GameModel {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String image;
  final GameType type;
  final Difficulty difficulty;
  final bool isFavorite;

  GameModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.image,
    required this.type,
    this.difficulty = Difficulty.easy,
    this.isFavorite = false,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: json['icon'],
      image: json['image'] ?? 'https://images.unsplash.com/photo-1546776310-eef45dd6d63c?w=500&q=80',
      type: GameType.values.firstWhere((e) => e.toString() == 'GameType.${json['type']}'),
      difficulty: Difficulty.values.firstWhere((e) => e.toString() == 'Difficulty.${json['difficulty']}', orElse: () => Difficulty.easy),
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'icon': icon,
    'image': image,
    'type': type.toString().split('.').last,
    'difficulty': difficulty.toString().split('.').last,
    'isFavorite': isFavorite,
  };

  GameModel copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    String? image,
    GameType? type,
    Difficulty? difficulty,
    bool? isFavorite,
  }) {
    return GameModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      image: image ?? this.image,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
