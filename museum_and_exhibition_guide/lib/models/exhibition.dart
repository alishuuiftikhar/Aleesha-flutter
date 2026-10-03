class Exhibition {
  final String id;
  final String title;
  final String museumId;
  final String description;
  final String schedule;
  final String imageUrl;
  final String type;
  final List<String> artworkIds;

  Exhibition({
    required this.id,
    required this.title,
    required this.museumId,
    required this.description,
    required this.schedule,
    required this.imageUrl,
    required this.type,
    required this.artworkIds,
  });

  factory Exhibition.fromJson(Map<String, dynamic> json) {
    return Exhibition(
      id: json['id'],
      title: json['title'],
      museumId: json['museumId'],
      description: json['description'],
      schedule: json['schedule'],
      imageUrl: json['imageUrl'],
      type: json['type'],
      artworkIds: List<String>.from(json['artworkIds']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'museumId': museumId,
    'description': description,
    'schedule': schedule,
    'imageUrl': imageUrl,
    'type': type,
    'artworkIds': artworkIds,
  };
}
