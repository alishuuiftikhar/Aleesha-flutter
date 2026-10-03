class Salon {
  final String id;
  final String name;
  final String? logoUrl;
  final String? coverImageUrl;
  final String description;
  final String address;
  final double rating;
  final int reviewCount;
  final Map<String, dynamic>? facilities;
  final List<String>? gallery;

  Salon({
    required this.id,
    required this.name,
    this.logoUrl,
    this.coverImageUrl,
    required this.description,
    required this.address,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.facilities,
    this.gallery,
  });

  factory Salon.fromJson(Map<String, dynamic> json) {
    return Salon(
      id: json['id'],
      name: json['name'],
      logoUrl: json['logo_url'],
      coverImageUrl: json['cover_image_url'],
      description: json['description'],
      address: json['address'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      facilities: json['facilities'],
      gallery: json['gallery'] != null ? List<String>.from(json['gallery']) : null,
    );
  }
}
