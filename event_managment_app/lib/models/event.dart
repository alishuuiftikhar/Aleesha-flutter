import 'category.dart';
import 'organizer.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String location;
  final String imageUrl;
  final List<String> gallery;
  final double price;
  final int capacity;
  final int remainingCapacity;
  final String categoryId;
  final String organizerId;
  final EventCategory? category;
  final Organizer? organizer;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.location,
    required this.imageUrl,
    required this.gallery,
    required this.price,
    required this.capacity,
    required this.remainingCapacity,
    required this.categoryId,
    required this.organizerId,
    this.category,
    this.organizer,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dateTime: DateTime.parse(json['date_time']),
      location: json['location'],
      imageUrl: json['image_url'],
      gallery: List<String>.from(json['gallery'] ?? []),
      price: (json['price'] as num).toDouble(),
      capacity: json['capacity'],
      remainingCapacity: json['remaining_capacity'],
      categoryId: json['category_id'],
      organizerId: json['organizer_id'],
      category: json['event_categories'] != null 
          ? EventCategory.fromJson(json['event_categories']) 
          : null,
      organizer: json['organizers'] != null 
          ? Organizer.fromJson(json['organizers']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date_time': dateTime.toIso8601String(),
      'location': location,
      'image_url': imageUrl,
      'gallery': gallery,
      'price': price,
      'capacity': capacity,
      'remaining_capacity': remainingCapacity,
      'category_id': categoryId,
      'organizer_id': organizerId,
    };
  }
}
