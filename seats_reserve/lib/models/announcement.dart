class Announcement {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String status;
  final DateTime createdAt;

  Announcement({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.status,
    required this.createdAt,
  });

  factory Announcement.fromMap(Map<String, dynamic> map) {
    return Announcement(
      id: map['id'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['image_url'],
      status: map['status'] ?? 'published',
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'status': status,
    };
  }
}
