import 'event.dart';

class Booking {
  final String id;
  final String userId;
  final String eventId;
  final int quantity;
  final double totalPrice;
  final String status;
  final DateTime createdAt;
  final Event? event;

  Booking({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.quantity,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    this.event,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      userId: json['user_id'],
      eventId: json['event_id'],
      quantity: json['quantity'],
      totalPrice: (json['total_price'] as num).toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      event: json['events'] != null ? Event.fromJson(json['events']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'event_id': eventId,
      'quantity': quantity,
      'total_price': totalPrice,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
