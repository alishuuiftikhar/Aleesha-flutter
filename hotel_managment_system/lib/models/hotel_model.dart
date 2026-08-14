// HOTEL MODEL
class Hotel {
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final double rating;
  final String? imageUrl;

  Hotel({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.rating,
    this.imageUrl,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      imageUrl: json['image_url'],
    );
  }
}

// ROOM MODEL
class Room {
  final String id;
  final String hotelId;
  final String roomNumber;
  final String roomType;
  final double pricePerNight;
  final int capacity;
  final bool isAvailable;

  Room({
    required this.id,
    required this.hotelId,
    required this.roomNumber,
    required this.roomType,
    required this.pricePerNight,
    required this.capacity,
    required this.isAvailable,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      hotelId: json['hotel_id'],
      roomNumber: json['room_number'] ?? '',
      roomType: json['room_type'] ?? 'Single',
      pricePerNight: (json['price_per_night'] as num).toDouble(),
      capacity: json['capacity'] ?? 2,
      isAvailable: json['is_available'] ?? true,
    );
  }
}

// BOOKING MODEL
class Booking {
  final String id;
  final String hotelName;
  final String roomNumber;
  final String roomType;
  final DateTime checkIn;
  final DateTime checkOut;
  final double totalPrice;
  final String status;

  Booking({
    required this.id,
    required this.hotelName,
    required this.roomNumber,
    required this.roomType,
    required this.checkIn,
    required this.checkOut,
    required this.totalPrice,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    final room = json['rooms'] as Map<String, dynamic>? ?? {};
    final hotel = room['hotels'] as Map<String, dynamic>? ?? {};

    return Booking(
      id: json['id'],
      hotelName: hotel['name'] ?? 'Hotel',
      roomNumber: room['room_number'] ?? '',
      roomType: room['room_type'] ?? '',
      checkIn: DateTime.parse(json['check_in']),
      checkOut: DateTime.parse(json['check_out']),
      totalPrice: (json['total_price'] as num).toDouble(),
      status: json['status'] ?? 'pending',
    );
  }
}