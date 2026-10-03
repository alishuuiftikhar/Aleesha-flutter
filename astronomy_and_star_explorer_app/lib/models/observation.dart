class Observation {
  final int? id;
  final String objectName;
  final DateTime date;
  final String time;
  final String location;
  final String equipment;
  final String notes;
  final double rating;

  Observation({
    this.id,
    required this.objectName,
    required this.date,
    required this.time,
    required this.location,
    required this.equipment,
    required this.notes,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'objectName': objectName,
      'date': date.toIso8601String(),
      'time': time,
      'location': location,
      'equipment': equipment,
      'notes': notes,
      'rating': rating,
    };
  }

  factory Observation.fromMap(Map<String, dynamic> map) {
    return Observation(
      id: map['id'],
      objectName: map['objectName'],
      date: DateTime.parse(map['date']),
      time: map['time'],
      location: map['location'],
      equipment: map['equipment'],
      notes: map['notes'],
      rating: map['rating'],
    );
  }
}
