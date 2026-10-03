import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../models/article.dart';
import '../models/category.dart';
import '../models/magazine.dart';

class AppProvider with ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  
  List<Article> _articles = [];
  List<Article> get articles => _articles;

  List<Article> _trendingArticles = [];
  List<Article> get trendingArticles => _trendingArticles;

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  List<Article> _bookmarks = [];
  List<Article> get bookmarks => _bookmarks;

  List<Magazine> _magazines = [];
  List<Magazine> get magazines => _magazines;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _supabaseService.getCategories();
      _articles = await _supabaseService.getArticles();
      _trendingArticles = await _supabaseService.getTrendingArticles();
      _bookmarks = await _supabaseService.getBookmarks();
      _magazines = await _supabaseService.getMagazines();
    } catch (e) {
      debugPrint('Error loading data: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleBookmark(Article article) async {
    try {
      await _supabaseService.toggleBookmark(article.id, article.isBookmarked);
      _bookmarks = await _supabaseService.getBookmarks();
      
      // Update article status in lists
      final index = _articles.indexWhere((element) => element.id == article.id);
      if (index != -1) {
        _articles[index] = _articles[index].copyWith(isBookmarked: !article.isBookmarked);
      }
      
      final trendingIndex = _trendingArticles.indexWhere((element) => element.id == article.id);
      if (trendingIndex != -1) {
        _trendingArticles[trendingIndex] = _trendingArticles[trendingIndex].copyWith(isBookmarked: !article.isBookmarked);
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling bookmark: $e');
    }
  }

  Future<void> addToHistory(String articleId) async {
    await _supabaseService.addToHistory(articleId);
  }
}
