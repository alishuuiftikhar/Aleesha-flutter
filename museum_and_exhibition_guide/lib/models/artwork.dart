class Artwork {
  final String id;
  final String title;
  final String artistId;
  final String artistName;
  final String year;
  final String type;
  final String museumId;
  final String description;
  final String historicalContext;
  final String imageUrl;

  Artwork({
    required this.id,
    required this.title,
    required this.artistId,
    required this.artistName,
    required this.year,
    required this.type,
    required this.museumId,
    required this.description,
    required this.historicalContext,
    required this.imageUrl,
  });

  factory Artwork.fromJson(Map<String, dynamic> json) {
    return Artwork(
      id: json['id'],
      title: json['title'],
      artistId: json['artistId'],
      artistName: json['artistName'],
      year: json['year'],
      type: json['type'],
      museumId: json['museumId'],
      description: json['description'],
      historicalContext: json['historicalContext'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'artistId': artistId,
    'artistName': artistName,
    'year': year,
    'type': type,
    'museumId': museumId,
    'description': description,
    'historicalContext': historicalContext,
    'imageUrl': imageUrl,
  };
}
