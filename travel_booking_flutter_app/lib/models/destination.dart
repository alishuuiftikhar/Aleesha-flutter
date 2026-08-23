class Destination {
  final String id;
  final String name;
  final String location;
  final String description;
  final String category;
  final double price;
  final double rating;
  final String imageUrl;
  final List<Hotel> hotels;

  Destination({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.category,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.hotels,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      description: json['description'],
      category: json['category'],
      price: json['price'].toDouble(),
      rating: json['rating'].toDouble(),
      imageUrl: json['imageUrl'],
      hotels: (json['hotels'] as List).map((h) => Hotel.fromJson(h)).toList(),
    );
  }
}

class Hotel {
  final String name;
  final double rating;
  final double price;

  Hotel({
    required this.name,
    required this.rating,
    required this.price,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      name: json['name'],
      rating: json['rating'].toDouble(),
      price: json['price'].toDouble(),
    );
  }
}
