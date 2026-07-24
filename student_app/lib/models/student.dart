class Student {
  int? id;
  String name;
  String rollNo;
  String department;
  String semester;
  double cgpa;
  String phone;

  Student({
    this.id,
    required this.name,
    required this.rollNo,
    required this.department,
    required this.semester,
    required this.cgpa,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'rollNo': rollNo,
      'department': department,
      'semester': semester,
      'cgpa': cgpa,
      'phone': phone,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      rollNo: map['rollNo'],
      department: map['department'],
      semester: map['semester'],
      cgpa: map['cgpa'],
      phone: map['phone'],
    );
  }
}