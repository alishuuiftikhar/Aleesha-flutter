import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/article.dart';
import '../models/author.dart';
import '../models/category.dart';
import '../models/magazine.dart';
import '../models/profile.dart';

class SupabaseService {
  SupabaseClient get _client {
    try {
      return Supabase.instance.client;
    } catch (e) {
      throw 'Supabase not initialized. Call Supabase.initialize() first.';
    }
  }
  GoTrueClient get _auth => _client.auth;

  // Auth
  Future<AuthResponse> signUp(String email, String password) async {
    return await _auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signIn(String email, String password) async {
    return await _auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _auth.resetPasswordForEmail(email);
  }

  User? get currentUser => _auth.currentUser;

  // Profile
  Future<Profile?> getProfile(String userId) async {
    final response = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();
    return Profile.fromJson(response);
  }

  // Articles
  Future<List<Article>> getArticles({String? categoryId, String? query, String? authorId}) async {
    var request = _client.from('articles').select('*, authors(name), categories(name)');

    if (categoryId != null) {
      request = request.eq('category_id', categoryId);
    }
    if (authorId != null) {
      request = request.eq('author_id', authorId);
    }
    if (query != null && query.isNotEmpty) {
      request = request.or('title.ilike.%$query%,content.ilike.%$query%');
    }

    final List<dynamic> response = await request.order('created_at', ascending: false);
    
    // Check bookmarks for current user
    final bookmarks = await getBookmarks();
    final bookmarkIds = bookmarks.map((e) => e.id).toSet();

    return response.map((json) => Article.fromJson(json, isBookmarked: bookmarkIds.contains(json['id'].toString()))).toList();
  }

  Future<List<Article>> getTrendingArticles() async {
    final List<dynamic> response = await _client
        .from('articles')
        .select('*, authors(name), categories(name)')
        .limit(5); // In a real app, maybe join with a view that counts views
    
    final bookmarks = await getBookmarks();
    final bookmarkIds = bookmarks.map((e) => e.id).toSet();

    return response.map((json) => Article.fromJson(json, isBookmarked: bookmarkIds.contains(json['id'].toString()))).toList();
  }

  // Categories
  Future<List<Category>> getCategories() async {
    final List<dynamic> response = await _client.from('categories').select();
    return response.map((json) => Category.fromJson(json)).toList();
  }

  // Authors
  Future<List<Author>> getAuthors({String? query}) async {
    var request = _client.from('authors').select();
    if (query != null && query.isNotEmpty) {
      request = request.ilike('name', '%$query%');
    }
    final List<dynamic> response = await request;
    return response.map((json) => Author.fromJson(json)).toList();
  }

  // Bookmarks
  Future<List<Article>> getBookmarks() async {
    final user = currentUser;
    if (user == null) return [];

    final List<dynamic> response = await _client
        .from('bookmarks')
        .select('article_id, articles(*, authors(name), categories(name))')
        .eq('user_id', user.id);

    return response.map((json) => Article.fromJson(json['articles'], isBookmarked: true)).toList();
  }

  Future<void> toggleBookmark(String articleId, bool isBookmarked) async {
    final user = currentUser;
    if (user == null) return;

    if (isBookmarked) {
      await _client.from('bookmarks').delete().match({'user_id': user.id, 'article_id': articleId});
    } else {
      await _client.from('bookmarks').insert({'user_id': user.id, 'article_id': articleId});
    }
  }

  // Reading History
  Future<void> addToHistory(String articleId) async {
    final user = currentUser;
    if (user == null) return;

    await _client.from('reading_history').upsert({
      'user_id': user.id,
      'article_id': articleId,
      'last_viewed_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Article>> getReadingHistory() async {
    final user = currentUser;
    if (user == null) return [];

    final List<dynamic> response = await _client
        .from('reading_history')
        .select('article_id, last_viewed_at, articles(*, authors(name), categories(name))')
        .eq('user_id', user.id)
        .order('last_viewed_at', ascending: false);

    final bookmarks = await getBookmarks();
    final bookmarkIds = bookmarks.map((e) => e.id).toSet();

    return response.map((json) => Article.fromJson(json['articles'], isBookmarked: bookmarkIds.contains(json['articles']['id'].toString()))).toList();
  }

  // Magazines
  Future<List<Magazine>> getMagazines() async {
    final List<dynamic> response = await _client.from('magazines').select().order('issue_date', ascending: false);
    return response.map((json) => Magazine.fromJson(json)).toList();
  }

  // Notifications
  Future<List<Map<String, dynamic>>> getNotifications() async {
    final user = currentUser;
    if (user == null) return [];
    return await _client.from('notifications').select().eq('user_id', user.id).order('created_at', ascending: false);
  }
}
