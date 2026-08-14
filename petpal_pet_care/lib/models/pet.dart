class Pet {
  final int? id;
  final String name;
  final String breed;
  final String age;
  final String distance;
  final String imagePath;
  final String category;
  final String description;
  bool isFavorite;
  bool isAdopted;

  Pet({
    this.id,
    required this.name,
    required this.breed,
    required this.age,
    required this.distance,
    this.imagePath = '',
    required this.category,
    this.description = '',
    this.isFavorite = false,
    this.isAdopted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'breed': breed,
      'age': age,
      'distance': distance,
      'imagePath': imagePath,
      'category': category,
      'description': description,
      'isFavorite': isFavorite ? 1 : 0,
      'isAdopted': isAdopted ? 1 : 0,
    };
  }

  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      id: map['id'],
      name: map['name'],
      breed: map['breed'],
      age: map['age'],
      distance: map['distance'],
      imagePath: map['imagePath'] ?? '',
      category: map['category'],
      description: map['description'] ?? '',
      isFavorite: map['isFavorite'] == 1,
      isAdopted: map['isAdopted'] == 1,
    );
  }

  Pet copyWith({
    int? id,
    String? name,
    String? breed,
    String? age,
    String? distance,
    String? imagePath,
    String? category,
    String? description,
    bool? isFavorite,
    bool? isAdopted,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      distance: distance ?? this.distance,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
      isAdopted: isAdopted ?? this.isAdopted,
    );
  }
}
