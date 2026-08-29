class TrafficSign {
  final String id;
  final String title;
  final String category;
  final String description;
  final String imageUrl;
  bool isFavorite;

  TrafficSign({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.imageUrl,
    this.isFavorite = false,
  });

  factory TrafficSign.fromJson(Map<String, dynamic> json) {
    return TrafficSign(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}
