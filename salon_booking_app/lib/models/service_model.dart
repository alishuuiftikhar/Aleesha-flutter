class Service {
  final String id;
  final String salonId;
  final String name;
  final String category;
  final String description;
  final double price;
  final int durationMinutes;
  final String? imageUrl;
  final bool isActive;

  Service({
    required this.id,
    required this.salonId,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.durationMinutes,
    this.imageUrl,
    this.isActive = true,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      salonId: json['salon_id'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      price: (json['price'] ?? 0.0).toDouble(),
      durationMinutes: json['duration_minutes'],
      imageUrl: json['image_url'],
      isActive: json['is_active'] ?? true,
    );
  }
}
