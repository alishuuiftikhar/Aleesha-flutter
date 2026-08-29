class Bus {
  final int? id;
  final String name;
  final String type; // AC, Non-AC, Sleeper
  final int totalSeats;
  final String busNumber;

  Bus({
    this.id,
    required this.name,
    required this.type,
    required this.totalSeats,
    required this.busNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'totalSeats': totalSeats,
      'busNumber': busNumber,
    };
  }

  factory Bus.fromMap(Map<String, dynamic> map) {
    return Bus(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      totalSeats: map['totalSeats'],
      busNumber: map['busNumber'],
    );
  }
}
