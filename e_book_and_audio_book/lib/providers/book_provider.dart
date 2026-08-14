import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../database/database_helper.dart';
import '../models/book_model.dart';
import '../services/api_service.dart';

class BookProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final ApiService _apiService = ApiService();
  
  List<Book> _books = [];
  List<Book> get books => _books;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isOffline = false;
  bool get isOffline => _isOffline;

  final List<Map<String, dynamic>> _targetBooks = [
    {"title": "Atomic Habits", "category": "Self Development"},
    {"title": "The Alchemist", "category": "Fiction"},
    {"title": "The Great Gatsby", "category": "Fiction"},
    {"title": "Pride and Prejudice", "category": "Fiction"},
    {"title": "Alice's Adventures in Wonderland", "category": "Fiction"},
    {"title": "The Little Prince", "category": "Fiction"},
    {"title": "Jane Eyre", "category": "Fiction"},
    {"title": "Frankenstein", "category": "Fiction"},
    {"title": "Dracula", "category": "Fiction"},
    {"title": "The Adventures of Sherlock Holmes", "category": "Mystery"},
    {"title": "Rich Dad Poor Dad", "category": "Business"},
    {"title": "Think and Grow Rich", "category": "Business"},
    {"title": "The 7 Habits of Highly Effective People", "category": "Self Development"},
    {"title": "Ikigai", "category": "Self Development"},
    {"title": "The Power of Now", "category": "Self Development"},
    {"title": "Deep Work", "category": "Technology"},
    {"title": "The Psychology of Money", "category": "Business"},
    {"title": "The Hobbit", "category": "Fiction"},
    {"title": "1984", "category": "Fiction"},
    {"title": "The Book Thief", "category": "Fiction"}
  ];

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    // Check connectivity
    var connectivityResult = await Connectivity().checkConnectivity();
    _isOffline = connectivityResult == ConnectivityResult.none;

    // Load what we have in SQLite first
    _books = await _dbHelper.getAllBooks();
    
    if (_books.isEmpty && !_isOffline) {
      // First time, fetch all targets
      await _fetchInitialBooks();
    } else {
      _isLoading = false;
      notifyListeners();
      
      // Refresh in background if online
      if (!_isOffline) {
        _refreshBooksInBackground();
      }
    }
  }

  Future<void> _fetchInitialBooks() async {
    for (int i = 0; i < _targetBooks.length; i++) {
      final target = _targetBooks[i];
      // Alternate ebook/audiobook for diversity
      BookType type = (i % 4 == 0) ? BookType.audiobook : BookType.ebook;
      
      Book? book = await _apiService.fetchBookByTitle(
        target['title'], 
        category: target['category'],
        type: type
      );
      
      if (book != null) {
        await _dbHelper.insertOrUpdateBook(book);
        // Load partially for better UX
        if (i % 5 == 0) {
          _books = await _dbHelper.getAllBooks();
          notifyListeners();
        }
      }
    }
    _books = await _dbHelper.getAllBooks();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _refreshBooksInBackground() async {
    for (var target in _targetBooks) {
       Book? book = await _apiService.fetchBookByTitle(target['title'], category: target['category']);
       if (book != null) {
         await _dbHelper.insertOrUpdateBook(book);
       }
    }
    _books = await _dbHelper.getAllBooks();
    notifyListeners();
  }

  Future<void> fetchBooks() async {
    _books = await _dbHelper.getAllBooks();
    notifyListeners();
  }

  Future<void> toggleFavorite(int bookId) async {
    await _dbHelper.toggleFavorite(bookId);
    notifyListeners();
  }

  Future<bool> isFavorite(int bookId) async {
    return await _dbHelper.isFavorite(bookId);
  }
  
  Future<List<Book>> getFavorites() async {
    return await _dbHelper.getFavorites();
  }

  List<Book> getBooksByCategory(String category) {
    return _books.where((book) => book.category == category).toList();
  }

  List<Book> getBooksByType(BookType type) {
    return _books.where((book) => book.type == type).toList();
  }

  Future<List<Book>> searchBooks(String query) async {
    if (query.isEmpty) {
      return _books;
    }
    
    // Search SQLite first
    final localResults = _books.where((b) => 
      b.title.toLowerCase().contains(query.toLowerCase()) || 
      b.author.toLowerCase().contains(query.toLowerCase())
    ).toList();

    if (localResults.isNotEmpty || _isOffline) {
      return localResults;
    }

    // Fallback to Online API
    return await _apiService.searchOnline(query);
  }

  Future<void> saveBook(Book book) async {
    await _dbHelper.insertOrUpdateBook(book);
    await fetchBooks();
  }
}
