class InternshipNote {
  final int? id;
  final int internshipId;
  final String content;
  final DateTime createdAt;

  InternshipNote({
    this.id,
    required this.internshipId,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'internship_id': internshipId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory InternshipNote.fromMap(Map<String, dynamic> map) {
    return InternshipNote(
      id: map['id'],
      internshipId: map['internship_id'],
      content: map['content'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
