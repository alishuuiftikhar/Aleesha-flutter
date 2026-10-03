class Museum {
  final String id;
  final String name;
  final String location;
  final String description;
  final String openingHours;
  final String ticketInfo;
  final String visitorTips;
  final String imageUrl;
  final String category;
  final List<String> exhibitionIds;
  final List<String> artworkIds;
  final List<String> galleryImages;

  Museum({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.openingHours,
    required this.ticketInfo,
    required this.visitorTips,
    required this.imageUrl,
    required this.category,
    required this.exhibitionIds,
    required this.artworkIds,
    required this.galleryImages,
  });

  factory Museum.fromJson(Map<String, dynamic> json) {
    return Museum(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      description: json['description'],
      openingHours: json['openingHours'],
      ticketInfo: json['ticketInfo'],
      visitorTips: json['visitorTips'],
      imageUrl: json['imageUrl'],
      category: json['category'],
      exhibitionIds: List<String>.from(json['exhibitionIds']),
      artworkIds: List<String>.from(json['artworkIds']),
      galleryImages: List<String>.from(json['galleryImages']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'location': location,
    'description': description,
    'openingHours': openingHours,
    'ticketInfo': ticketInfo,
    'visitorTips': visitorTips,
    'imageUrl': imageUrl,
    'category': category,
    'exhibitionIds': exhibitionIds,
    'artworkIds': artworkIds,
    'galleryImages': galleryImages,
  };
}
