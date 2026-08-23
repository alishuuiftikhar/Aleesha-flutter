class Exercise {
  final String id;
  final String name;
  final String category;
  final String? description;
  final String? imageUrl;
  final String? bodyPart;

  Exercise({
    required this.id,
    required this.name,
    required this.category,
    this.description,
    this.imageUrl,
    this.bodyPart,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      imageUrl: json['image_url'],
      bodyPart: json['body_part'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'image_url': imageUrl,
      'body_part': bodyPart,
    };
  }
}
