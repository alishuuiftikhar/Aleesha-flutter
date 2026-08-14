class Event {
  final String id;
  final String title;
  final String description;
  final String location;
  final String address;
  final DateTime date;
  final String time;
  final String imageUrl;
  final double price;
  final String category;
  final String organizer;
  final String organizerImage;
  bool isFavorite;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.address,
    required this.date,
    required this.time,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.organizer,
    required this.organizerImage,
    this.isFavorite = false,
  });
}
