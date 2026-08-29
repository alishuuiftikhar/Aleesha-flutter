class Semester {
  final int? id;
  final String name; // e.g., Fall 2023, Semester 1

  Semester({
    this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Semester.fromMap(Map<String, dynamic> map) {
    return Semester(
      id: map['id'],
      name: map['name'],
    );
  }
}
