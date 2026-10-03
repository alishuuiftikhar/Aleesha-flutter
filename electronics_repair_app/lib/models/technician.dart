class Technician {
  final int? id;
  final String name;
  final String specialization;

  Technician({
    this.id,
    required this.name,
    required this.specialization,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
    };
  }

  factory Technician.fromMap(Map<String, dynamic> map) {
    return Technician(
      id: map['id'],
      name: map['name'],
      specialization: map['specialization'],
    );
  }
}
