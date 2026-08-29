class Vehicle {
  final int? id;
  final String name;
  final String model;
  final String make;
  final int year;
  final String licensePlate;
  final int currentMileage;
  final String? imageUrl;

  Vehicle({
    this.id,
    required this.name,
    required this.model,
    required this.make,
    required this.year,
    required this.licensePlate,
    required this.currentMileage,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'model': model,
      'make': make,
      'year': year,
      'licensePlate': licensePlate,
      'currentMileage': currentMileage,
      'imageUrl': imageUrl,
    };
  }

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map['id'],
      name: map['name'],
      model: map['model'],
      make: map['make'],
      year: map['year'],
      licensePlate: map['licensePlate'],
      currentMileage: map['currentMileage'],
      imageUrl: map['imageUrl'],
    );
  }
}
