class Artist {
  final String id;
  final String name;
  final String bio;
  final String imageUrl;
  final String period;
  final List<String> artworkIds;

  Artist({
    required this.id,
    required this.name,
    required this.bio,
    required this.imageUrl,
    required this.period,
    required this.artworkIds,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      name: json['name'],
      bio: json['bio'],
      imageUrl: json['imageUrl'],
      period: json['period'],
      artworkIds: List<String>.from(json['artworkIds']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'bio': bio,
    'imageUrl': imageUrl,
    'period': period,
    'artworkIds': artworkIds,
  };
}
