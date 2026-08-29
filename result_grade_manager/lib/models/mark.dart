class Mark {
  final int? id;
  final int studentId;
  final int subjectId;
  final int semesterId;
  final double marksObtained;
  final double maxMarks;

  Mark({
    this.id,
    required this.studentId,
    required this.subjectId,
    required this.semesterId,
    required this.marksObtained,
    required this.maxMarks,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'student_id': studentId,
      'subject_id': subjectId,
      'semester_id': semesterId,
      'marks_obtained': marksObtained,
      'max_marks': maxMarks,
    };
  }

  factory Mark.fromMap(Map<String, dynamic> map) {
    return Mark(
      id: map['id'],
      studentId: map['student_id'],
      subjectId: map['subject_id'],
      semesterId: map['semester_id'],
      marksObtained: map['marks_obtained'],
      maxMarks: map['max_marks'],
    );
  }
}
