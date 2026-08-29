class Subject {
  final int? id;
  final String name;
  final int classId;

  Subject({this.id, required this.name, required this.classId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'class_id': classId,
    };
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'],
      name: map['name'],
      classId: map['class_id'],
    );
  }
}
