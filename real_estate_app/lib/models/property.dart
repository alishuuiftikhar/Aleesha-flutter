import 'agent.dart';

class Property {
  final String id;
  final String title;
  final String description;
  final double price;
  final String address;
  final String city;
  final String type; // 'Buy' or 'Rent'
  final String category; // 'House', 'Apartment', 'Villa', etc.
  final int bedrooms;
  final int bathrooms;
  final double area;
  final String? mainImage;
  final String agentId;
  final Agent? agent;
  final List<String> images;
  bool isFavorite;

  Property({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.address,
    required this.city,
    required this.type,
    required this.category,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    this.mainImage,
    required this.agentId,
    this.agent,
    this.images = const [],
    this.isFavorite = false,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      type: json['type'] ?? 'Buy',
      category: json['category'] ?? 'House',
      bedrooms: json['bedrooms'] ?? 0,
      bathrooms: json['bathrooms'] ?? 0,
      area: (json['area'] as num?)?.toDouble() ?? 0.0,
      mainImage: json['main_image'],
      agentId: json['agent_id'],
      agent: json['agents'] != null ? Agent.fromJson(json['agents']) : null,
      images: json['property_images'] != null 
        ? (json['property_images'] as List).map((i) => i['url'] as String).toList() 
        : [],
    );
  }
}
