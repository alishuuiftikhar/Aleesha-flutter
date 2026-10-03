enum ShotType { closeUp, mediumShot, longShot, wideShot, overTheShoulder, pointOfView, insert }
enum CameraAngle { eyeLevel, highAngle, lowAngle, dutchAngle, birdsEye, wormsEye }
enum CameraMovement { static, pan, tilt, zoom, dolly, crane, handheld, tracking }
enum SceneStatus { planned, inProgress, completed, cancelled }

class Shot {
  final String id;
  String title;
  ShotType type;
  CameraAngle angle;
  CameraMovement movement;
  String lens;
  String description;
  bool isCompleted;

  Shot({
    required this.id,
    required this.title,
    this.type = ShotType.mediumShot,
    this.angle = CameraAngle.eyeLevel,
    this.movement = CameraMovement.static,
    this.lens = "",
    this.description = "",
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'type': type.index,
    'angle': angle.index,
    'movement': movement.index,
    'lens': lens,
    'description': description,
    'isCompleted': isCompleted,
  };

  factory Shot.fromJson(Map<String, dynamic> json) => Shot(
    id: json['id'],
    title: json['title'],
    type: ShotType.values[json['type']],
    angle: CameraAngle.values[json['angle']],
    movement: CameraMovement.values[json['movement']],
    lens: json['lens'] ?? "",
    description: json['description'] ?? "",
    isCompleted: json['isCompleted'] ?? false,
  );
}

class Scene {
  final String id;
  String title;
  String location;
  SceneStatus status;
  List<Shot> shots;
  List<String> characters;
  List<String> props;
  String notes;

  Scene({
    required this.id,
    required this.title,
    this.location = "",
    this.status = SceneStatus.planned,
    List<Shot>? shots,
    List<String>? characters,
    List<String>? props,
    this.notes = "",
  }) : shots = shots ?? [],
       characters = characters ?? [],
       props = props ?? [];

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'location': location,
    'status': status.index,
    'shots': shots.map((s) => s.toJson()).toList(),
    'characters': characters,
    'props': props,
    'notes': notes,
  };

  factory Scene.fromJson(Map<String, dynamic> json) => Scene(
    id: json['id'],
    title: json['title'],
    location: json['location'] ?? "",
    status: SceneStatus.values[json['status']],
    shots: (json['shots'] as List).map((s) => Shot.fromJson(s)).toList(),
    characters: List<String>.from(json['characters'] ?? []),
    props: List<String>.from(json['props'] ?? []),
    notes: json['notes'] ?? "",
  );
  
  double get completionPercentage {
    if (shots.isEmpty) return 0.0;
    int completed = shots.where((s) => s.isCompleted).length;
    return completed / shots.length;
  }
}

class Project {
  final String id;
  String name;
  String description;
  DateTime createdAt;
  List<Scene> scenes;
  bool isFavorite;
  String productionNotes;

  Project({
    required this.id,
    required this.name,
    this.description = "",
    DateTime? createdAt,
    List<Scene>? scenes,
    this.isFavorite = false,
    this.productionNotes = "",
  }) : createdAt = createdAt ?? DateTime.now(),
       scenes = scenes ?? [];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'createdAt': createdAt.toIso8601String(),
    'scenes': scenes.map((s) => s.toJson()).toList(),
    'isFavorite': isFavorite,
    'productionNotes': productionNotes,
  };

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    id: json['id'],
    name: json['name'],
    description: json['description'] ?? "",
    createdAt: DateTime.parse(json['createdAt']),
    scenes: (json['scenes'] as List).map((s) => Scene.fromJson(s)).toList(),
    isFavorite: json['isFavorite'] ?? false,
    productionNotes: json['productionNotes'] ?? "",
  );

  double get progress {
    if (scenes.isEmpty) return 0.0;
    int totalShots = 0;
    int completedShots = 0;
    for (var scene in scenes) {
      totalShots += scene.shots.length;
      completedShots += scene.shots.where((s) => s.isCompleted).length;
    }
    if (totalShots == 0) return 0.0;
    return completedShots / totalShots;
  }
  
  int get totalShots {
    return scenes.fold(0, (sum, scene) => sum + scene.shots.length);
  }

  int get completedShots {
    return scenes.fold(0, (sum, scene) => sum + scene.shots.where((s) => s.isCompleted).length);
  }
}
