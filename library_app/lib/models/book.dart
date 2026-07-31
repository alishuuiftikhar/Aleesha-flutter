class Book {
  final String title;
  final String author;
  final String category;
  bool isBorrowed;

  Book({
    required this.title,
    required this.author,
    required this.category,
    this.isBorrowed = false,
  });
}