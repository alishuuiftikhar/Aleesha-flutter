class Hotel {
  final String id;
  final String name;
  final String city;
  final String address;
  final String? description;
  final String? imageUrl;
  final double rating;

  Hotel({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
    this.description,
    this.imageUrl,
    this.rating = 4.5,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      description: json['description'],
      imageUrl: json['image_url'],
      rating: (json['rating'] != null) ? (json['rating'] as num).toDouble() : 4.5,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'address': address,
      'description': description,
      'image_url': imageUrl,
      'rating': rating,
    };
  }
}

// Admin Booking Model
class AdminBooking {
  final String id;
  final String checkIn;
  final String checkOut;
  final double totalPrice;
  final String status;
  final String customerName;
  final String customerPhone;
  final String roomNumber;
  final String roomType;
  final String hotelName;

  AdminBooking({
    required this.id,
    required this.checkIn,
    required this.checkOut,
    required this.totalPrice,
    required this.status,
    required this.customerName,
    required this.customerPhone,
    required this.roomNumber,
    required this.roomType,
    required this.hotelName,
  });

  factory AdminBooking.fromJson(Map<String, dynamic> json) {
    final profile = json['profiles'] as Map<String, dynamic>?;
    final room = json['rooms'] as Map<String, dynamic>?;
    final hotel = room != null ? room['hotels'] as Map<String, dynamic>? : null;

    return AdminBooking(
      id: json['id']?.toString() ?? '',
      checkIn: json['check_in'] ?? '',
      checkOut: json['check_out'] ?? '',
      totalPrice: (json['total_price'] != null) ? (json['total_price'] as num).toDouble() : 0.0,
      status: json['status'] ?? 'Pending',
      customerName: profile?['full_name'] ?? 'Guest User',
      customerPhone: profile?['phone'] ?? 'N/A',
      roomNumber: room?['room_number'] ?? 'Not Assigned',
      roomType: room?['room_type'] ?? 'Standard',
      hotelName: hotel?['name'] ?? 'Hotel',
    );
  }
}

// Room Model (Red Line Fix)
class RoomModel {
  final String id;
  final String hotelId;
  final String roomNumber;
  final String roomType;
  final double pricePerNight;
  final bool isAvailable;

  RoomModel({
    required this.id,
    required this.hotelId,
    required this.roomNumber,
    required this.roomType,
    required this.pricePerNight,
    required this.isAvailable,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id']?.toString() ?? '',
      hotelId: json['hotel_id']?.toString() ?? '',
      roomNumber: json['room_number'] ?? '',
      roomType: json['room_type'] ?? 'Standard',
      pricePerNight: (json['price_per_night'] != null)
          ? (json['price_per_night'] as num).toDouble()
          : 0.0,
      isAvailable: json['is_available'] ?? true,
    );
  }
}