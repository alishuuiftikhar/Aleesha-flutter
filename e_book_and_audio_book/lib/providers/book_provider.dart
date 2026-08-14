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

  // Expanded list of 30 iconic books for automatic fetching
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
    {"title": "The Book Thief", "category": "Fiction"},
    {"title": "Sapiens: A Brief History of Humankind", "category": "History"},
    {"title": "The 48 Laws of Power", "category": "Self Development"},
    {"title": "Man's Search for Meaning", "category": "Philosophy"},
    {"title": "Zero to One", "category": "Business"},
    {"title": "The Silent Patient", "category": "Mystery"},
    {"title": "Educated", "category": "Education"},
    {"title": "Becoming", "category": "Biography"},
    {"title": "Steve Jobs", "category": "Technology"},
    {"title": "Dune", "category": "Science"},
    {"title": "The Art of War", "category": "History"}
  ];

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    // Check connectivity
    var connectivityResult = await Connectivity().checkConnectivity();
    _isOffline = connectivityResult == ConnectivityResult.none;

    // Load existing books immediately
    _books = await _dbHelper.getAllBooks();
    
    if (_books.isEmpty && !_isOffline) {
      // First run: fetch all 30 books
      await _fetchInitialBooks();
    } else {
      _isLoading = false;
      notifyListeners();
      
      // Refresh logic in background if online to ensure latest covers
      if (!_isOffline) {
        _refreshBooksInBackground();
      }
    }
  }

  Future<void> _fetchInitialBooks() async {
    for (int i = 0; i < _targetBooks.length; i++) {
      final target = _targetBooks[i];
      // Distribute types: every 3rd book is an audiobook
      BookType type = (i % 3 == 0) ? BookType.audiobook : BookType.ebook;
      
      try {
        Book? book = await _apiService.fetchBookByTitle(
          target['title'], 
          category: target['category'],
          type: type
        );
        
        if (book != null) {
          await _dbHelper.insertOrUpdateBook(book);
          // UI update every 3 books for smooth feeling
          if (i % 3 == 0) {
            _books = await _dbHelper.getAllBooks();
            notifyListeners();
          }
        }
      } catch (e) {
        debugPrint("Error fetching book ${target['title']}: $e");
      }
    }
    _books = await _dbHelper.getAllBooks();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _refreshBooksInBackground() async {
    // Silently update metadata without showing loader
    for (var target in _targetBooks) {
       try {
         Book? book = await _apiService.fetchBookByTitle(target['title'], category: target['category']);
         if (book != null) {
           await _dbHelper.insertOrUpdateBook(book);
         }
       } catch (e) {
         debugPrint("Background sync failed for ${target['title']}");
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
    
    // 1. Search locally first
    final localResults = _books.where((b) => 
      b.title.toLowerCase().contains(query.toLowerCase()) || 
      b.author.toLowerCase().contains(query.toLowerCase())
    ).toList();

    // 2. If no local results and online, fetch from API
    if (localResults.isEmpty && !_isOffline) {
      return await _apiService.searchOnline(query);
    }

    return localResults;
  }

  Future<void> saveBook(Book book) async {
    await _dbHelper.insertOrUpdateBook(book);
    await fetchBooks();
  }
}
