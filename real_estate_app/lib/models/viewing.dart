import 'property.dart';

class Viewing {
  final String id;
  final String propertyId;
  final String userId;
  final DateTime scheduledAt;
  final String status;
  final Property? property;

  Viewing({
    required this.id,
    required this.propertyId,
    required this.userId,
    required this.scheduledAt,
    required this.status,
    this.property,
  });

  factory Viewing.fromJson(Map<String, dynamic> json) {
    return Viewing(
      id: json['id'],
      propertyId: json['property_id'],
      userId: json['user_id'],
      scheduledAt: DateTime.parse(json['scheduled_at']).toLocal(),
      status: json['status'] ?? 'pending',
      property: json['properties'] != null ? Property.fromJson(json['properties']) : null,
    );
  }
}
