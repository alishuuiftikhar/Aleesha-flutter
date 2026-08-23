class TravelPackage {
  final String id;
  final String name;
  final String destination;
  final String imageUrl;
  final int durationDays;
  final double pricePerPerson;
  final String description;
  final List<String> activities;

  TravelPackage({
    required this.id,
    required this.name,
    required this.destination,
    required this.imageUrl,
    required this.durationDays,
    required this.pricePerPerson,
    required this.description,
    required this.activities,
  });

  factory TravelPackage.fromJson(Map<String, dynamic> json) {
    return TravelPackage(
      id: json['id'],
      name: json['name'],
      destination: json['destination'],
      imageUrl: json['imageUrl'],
      durationDays: json['durationDays'],
      pricePerPerson: json['pricePerPerson'].toDouble(),
      description: json['description'],
      activities: List<String>.from(json['activities']),
    );
  }
}
