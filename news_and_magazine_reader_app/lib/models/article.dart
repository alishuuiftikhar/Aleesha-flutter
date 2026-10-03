class Article {
  final String id;
  final String title;
  final String content;
  final String? imageUrl;
  final String authorId;
  final String categoryId;
  final DateTime createdAt;
  final int readingTime;
  final String? authorName;
  final String? categoryName;
  final bool isBookmarked;

  Article({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.authorId,
    required this.categoryId,
    required this.createdAt,
    required this.readingTime,
    this.authorName,
    this.categoryName,
    this.isBookmarked = false,
  });

  factory Article.fromJson(Map<String, dynamic> json, {bool isBookmarked = false}) {
    // Handle joins that might return a list or a map
    String? getJoinValue(dynamic join, String field) {
      if (join == null) return null;
      if (join is List && join.isNotEmpty) {
        return join[0][field]?.toString();
      }
      if (join is Map) {
        return join[field]?.toString();
      }
      return null;
    }

    return Article(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['image_url'],
      authorId: json['author_id']?.toString() ?? '',
      categoryId: json['category_id']?.toString() ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      readingTime: json['reading_time'] ?? 5,
      authorName: getJoinValue(json['authors'], 'name'),
      categoryName: getJoinValue(json['categories'], 'name'),
      isBookmarked: isBookmarked,
    );
  }

  Article copyWith({bool? isBookmarked}) {
    return Article(
      id: id,
      title: title,
      content: content,
      imageUrl: imageUrl,
      authorId: authorId,
      categoryId: categoryId,
      createdAt: createdAt,
      readingTime: readingTime,
      authorName: authorName,
      categoryName: categoryName,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}
