class AppNote {
  final int? id;
  final String title;
  final String content;
  final String category; // 'Visitor', 'Delivery', 'Maintenance', 'General'
  final String createdAt;
  final int? relatedId;

  AppNote({
    this.id,
    required this.title,
    required this.content,
    this.category = 'General',
    required this.createdAt,
    this.relatedId,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'content': content,
      'category': category,
      'created_at': createdAt,
      'related_id': relatedId,
    };
  }

  factory AppNote.fromMap(Map<String, dynamic> map) {
    return AppNote(
      id: map['id'] as int?,
      title: map['title'] as String? ?? '',
      content: map['content'] as String? ?? '',
      category: map['category'] as String? ?? 'General',
      createdAt: map['created_at'] as String? ?? '',
      relatedId: map['related_id'] as int?,
    );
  }

  AppNote copyWith({
    int? id,
    String? title,
    String? content,
    String? category,
    String? createdAt,
    int? relatedId,
  }) {
    return AppNote(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      relatedId: relatedId ?? this.relatedId,
    );
  }
}
