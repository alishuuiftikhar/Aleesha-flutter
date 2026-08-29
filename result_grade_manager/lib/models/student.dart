class Student {
  final int? id;
  final String name;
  final String rollNumber;
  final String grade; // Current class/grade
  final String? profileImage;

  Student({
    this.id,
    required this.name,
    required this.rollNumber,
    required this.grade,
    this.profileImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'roll_number': rollNumber,
      'grade': grade,
      'profile_image': profileImage,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      rollNumber: map['roll_number'],
      grade: map['grade'],
      profileImage: map['profile_image'],
    );
  }
}
