class Magazine {
  final String id;
  final String title;
  final String? description;
  final String? coverUrl;
  final DateTime issueDate;

  Magazine({
    required this.id,
    required this.title,
    this.description,
    this.coverUrl,
    required this.issueDate,
  });

  factory Magazine.fromJson(Map<String, dynamic> json) {
    return Magazine(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'],
      coverUrl: json['cover_url'],
      issueDate: DateTime.parse(json['issue_date']),
    );
  }
}
