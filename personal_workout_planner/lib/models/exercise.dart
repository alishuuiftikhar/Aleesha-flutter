class Exercise {
  final String id;
  final String name;
  final String category;
  final String image;
  final String description;
  final List<String> instructions;
  final int duration; // in seconds
  final int defaultSets;
  final int defaultReps;
  final int restTime; // in seconds

  Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.description,
    required this.instructions,
    required this.duration,
    required this.defaultSets,
    required this.defaultReps,
    required this.restTime,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      image: json['image'],
      description: json['description'],
      instructions: List<String>.from(json['instructions']),
      duration: json['duration'],
      defaultSets: json['defaultSets'],
      defaultReps: json['defaultReps'],
      restTime: json['restTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'image': image,
      'description': description,
      'instructions': instructions,
      'duration': duration,
      'defaultSets': defaultSets,
      'defaultReps': defaultReps,
      'restTime': restTime,
    };
  }
}
