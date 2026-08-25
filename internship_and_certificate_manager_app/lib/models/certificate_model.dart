class Certificate {
  final int? id;
  final String title;
  final String organization;
  final DateTime issueDate;
  final String? certificateId;
  final String category;
  final String? description;
  final String? imagePath;
  final String status;
  final bool isFavorite;

  Certificate({
    this.id,
    required this.title,
    required this.organization,
    required this.issueDate,
    this.certificateId,
    required this.category,
    this.description,
    this.imagePath,
    required this.status,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'organization': organization,
      'issue_date': issueDate.toIso8601String(),
      'certificate_id': certificateId,
      'category': category,
      'description': description,
      'image_path': imagePath,
      'status': status,
      'is_favorite': isFavorite ? 1 : 0,
    };
  }

  factory Certificate.fromMap(Map<String, dynamic> map) {
    return Certificate(
      id: map['id'],
      title: map['title'],
      organization: map['organization'],
      issueDate: DateTime.parse(map['issue_date']),
      certificateId: map['certificate_id'],
      category: map['category'],
      description: map['description'],
      imagePath: map['image_path'],
      status: map['status'],
      isFavorite: map['is_favorite'] == 1,
    );
  }
}
