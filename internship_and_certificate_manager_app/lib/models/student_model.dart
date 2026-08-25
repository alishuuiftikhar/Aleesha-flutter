class Student {
  final int? id;
  final String name;
  final String university;
  final String degree;
  final String semester;
  final String? skills;
  final String? email;
  final String? phone;
  final String? profileImage;

  Student({
    this.id,
    required this.name,
    required this.university,
    required this.degree,
    required this.semester,
    this.skills,
    this.email,
    this.phone,
    this.profileImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'university': university,
      'degree': degree,
      'semester': semester,
      'skills': skills,
      'email': email,
      'phone': phone,
      'profile_image': profileImage,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      university: map['university'],
      degree: map['degree'],
      semester: map['semester'],
      skills: map['skills'],
      email: map['email'],
      phone: map['phone'],
      profileImage: map['profile_image'],
    );
  }
}
