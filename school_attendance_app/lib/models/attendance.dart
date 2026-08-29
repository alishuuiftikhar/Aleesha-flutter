class Attendance {
  final int? id;
  final int studentId;
  final int subjectId;
  final String date;
  final String status; // Present, Absent, Late
  final String? subjectName;

  Attendance({
    this.id,
    required this.studentId,
    required this.subjectId,
    required this.date,
    required this.status,
    this.subjectName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'student_id': studentId,
      'subject_id': subjectId,
      'date': date,
      'status': status,
    };
  }

  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      id: map['id'],
      studentId: map['student_id'],
      subjectId: map['subject_id'],
      date: map['date'],
      status: map['status'],
      subjectName: map['subject_name'],
    );
  }
}
