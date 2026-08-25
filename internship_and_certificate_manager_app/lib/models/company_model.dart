class Company {
  final int? id;
  final String name;
  final String? location;
  final String? website;

  Company({
    this.id,
    required this.name,
    this.location,
    this.website,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'website': website,
    };
  }

  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      website: map['website'],
    );
  }
}
