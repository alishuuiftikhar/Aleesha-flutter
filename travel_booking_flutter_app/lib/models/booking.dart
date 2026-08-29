import 'destination.dart';

class Booking {
  final String id;
  final Destination destination;
  final DateTime bookingDate;
  final DateTime travelDate;
  final int travelers;
  final double totalPrice;
  final String status;

  Booking({
    required this.id,
    required this.destination,
    required this.bookingDate,
    required this.travelDate,
    required this.travelers,
    required this.totalPrice,
    this.status = 'Confirmed',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'destination': {
        'id': destination.id,
        'name': destination.name,
        'location': destination.location,
        'description': destination.description,
        'category': destination.category,
        'price': destination.price,
        'rating': destination.rating,
        'imageUrl': destination.imageUrl,
        'hotels': [], // Simplified for storage
      },
      'bookingDate': bookingDate.toIso8601String(),
      'travelDate': travelDate.toIso8601String(),
      'travelers': travelers,
      'totalPrice': totalPrice,
      'status': status,
    };
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      destination: Destination(
        id: json['destination']['id'],
        name: json['destination']['name'],
        location: json['destination']['location'],
        description: json['destination']['description'],
        category: json['destination']['category'],
        price: json['destination']['price'].toDouble(),
        rating: json['destination']['rating'].toDouble(),
        imageUrl: json['destination']['imageUrl'],
        hotels: [],
      ),
      bookingDate: DateTime.parse(json['bookingDate']),
      travelDate: DateTime.parse(json['travelDate']),
      travelers: json['travelers'],
      totalPrice: json['totalPrice'].toDouble(),
      status: json['status'],
    );
  }
}
