class AstronomyObject {
  final int? id;
  final String name;
  final String category;
  final String image;
  final String description;
  final String? distance;
  final String? size;
  final String? discoveryInfo;
  final List<String> facts;
  final List<String> relatedObjects;
  final bool isFavorite;
  final DateTime? lastViewed;

  AstronomyObject({
    this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.description,
    this.distance,
    this.size,
    this.discoveryInfo,
    this.facts = const [],
    this.relatedObjects = const [],
    this.isFavorite = false,
    this.lastViewed,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'image': image,
      'description': description,
      'distance': distance,
      'size': size,
      'discoveryInfo': discoveryInfo,
      'facts': facts.join('|'),
      'relatedObjects': relatedObjects.join('|'),
      'isFavorite': isFavorite ? 1 : 0,
      'lastViewed': lastViewed?.toIso8601String(),
    };
  }

  factory AstronomyObject.fromMap(Map<String, dynamic> map) {
    return AstronomyObject(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      image: map['image'],
      description: map['description'],
      distance: map['distance'],
      size: map['size'],
      discoveryInfo: map['discoveryInfo'],
      facts: (map['facts'] as String?)?.split('|').where((s) => s.isNotEmpty).toList() ?? [],
      relatedObjects: (map['relatedObjects'] as String?)?.split('|').where((s) => s.isNotEmpty).toList() ?? [],
      isFavorite: map['isFavorite'] == 1,
      lastViewed: map['lastViewed'] != null ? DateTime.parse(map['lastViewed']) : null,
    );
  }

  AstronomyObject copyWith({
    int? id,
    String? name,
    String? category,
    String? image,
    String? description,
    String? distance,
    String? size,
    String? discoveryInfo,
    List<String>? facts,
    List<String>? relatedObjects,
    bool? isFavorite,
    DateTime? lastViewed,
  }) {
    return AstronomyObject(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      image: image ?? this.image,
      description: description ?? this.description,
      distance: distance ?? this.distance,
      size: size ?? this.size,
      discoveryInfo: discoveryInfo ?? this.discoveryInfo,
      facts: facts ?? this.facts,
      relatedObjects: relatedObjects ?? this.relatedObjects,
      isFavorite: isFavorite ?? this.isFavorite,
      lastViewed: lastViewed ?? this.lastViewed,
    );
  }
}
