enum BookType { ebook, audiobook }

class Book {
  final int? id;
  final String title;
  final String author;
  final String description;
  final String coverUrl;
  final String category;
  final BookType type;
  final int pages;
  final String language;
  final int publicationYear;
  final double rating;
  final String? totalDuration;
  final String? contentPath;
  final String? isbn;
  final String? audioUrl;
  final String? narrator;
  final String? source;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? openLibraryId;

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.coverUrl,
    required this.category,
    required this.type,
    required this.pages,
    required this.language,
    required this.publicationYear,
    required this.rating,
    this.totalDuration,
    this.contentPath,
    this.isbn,
    this.audioUrl,
    this.narrator,
    this.source,
    this.createdAt,
    this.updatedAt,
    this.openLibraryId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'cover_url': coverUrl,
      'category': category,
      'type': type.name,
      'pages': pages,
      'language': language,
      'publication_year': publicationYear,
      'rating': rating,
      'total_duration': totalDuration,
      'content_path': contentPath,
      'isbn': isbn,
      'audio_url': audioUrl,
      'narrator': narrator,
      'source': source,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'open_library_id': openLibraryId,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'] ?? 'Unknown Title',
      author: map['author'] ?? 'Unknown Author',
      description: map['description'] ?? '',
      coverUrl: map['cover_url'] ?? '',
      category: map['category'] ?? 'General',
      type: map['type'] == 'audiobook' ? BookType.audiobook : BookType.ebook,
      pages: map['pages'] ?? 0,
      language: map['language'] ?? 'English',
      publicationYear: map['publication_year'] ?? 0,
      rating: (map['rating'] ?? 0.0).toDouble(),
      totalDuration: map['total_duration'],
      contentPath: map['content_path'],
      isbn: map['isbn'],
      audioUrl: map['audio_url'],
      narrator: map['narrator'],
      source: map['source'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
      openLibraryId: map['open_library_id'],
    );
  }
}
