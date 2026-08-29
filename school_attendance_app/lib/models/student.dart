class Student {
  final int? id;
  final String name;
  final String rollNumber;
  final int classId;
  final String? className;

  Student({
    this.id,
    required this.name,
    required this.rollNumber,
    required this.classId,
    this.className,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'roll_number': rollNumber,
      'class_id': classId,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      rollNumber: map['roll_number'],
      classId: map['class_id'],
      className: map['classes'] != null ? map['classes']['name'] : map['class_name'],
    );
  }
}
