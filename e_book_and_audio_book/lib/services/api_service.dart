import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';

class ApiService {
  static const String _baseUrl = 'https://openlibrary.org/search.json';
  static const String _coverBaseUrl = 'https://covers.openlibrary.org/b/id/';

  Future<Book?> fetchBookByTitle(String title, {String category = 'General', BookType type = BookType.ebook}) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl?title=${Uri.encodeComponent(title)}&limit=1'));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['docs'] != null && data['docs'].isNotEmpty) {
          final doc = data['docs'][0];
          
          final String author = (doc['author_name'] != null && doc['author_name'].isNotEmpty) 
              ? doc['author_name'][0] 
              : 'Unknown Author';
          
          final int? coverId = doc['cover_i'];
          final String coverUrl = coverId != null 
              ? '$_coverBaseUrl$coverId-L.jpg' 
              : 'https://via.placeholder.com/400x600.png?text=No+Cover';
          
          final String isbn = (doc['isbn'] != null && doc['isbn'].isNotEmpty) 
              ? doc['isbn'][0] 
              : 'N/A';
              
          final int pages = doc['number_of_pages_median'] ?? doc['number_of_pages'] ?? 0;
          final int pubYear = doc['first_publish_year'] ?? 0;
          final double rating = (doc['ratings_average'] ?? 0.0).toDouble();
          final String olId = doc['key']?.toString().replaceAll('/works/', '') ?? '';

          return Book(
            title: title,
            author: author,
            description: 'Discover the depth of $title by $author. A significant piece of literature first published in $pubYear.',
            coverUrl: coverUrl,
            category: category,
            type: type,
            pages: pages == 0 ? 250 : pages,
            language: (doc['language'] != null && doc['language'].isNotEmpty) ? doc['language'][0] : 'English',
            publicationYear: pubYear,
            rating: rating == 0 ? 4.5 : rating,
            isbn: isbn,
            source: 'Open Library',
            openLibraryId: olId,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            totalDuration: type == BookType.audiobook ? '9h 15m' : null,
            audioUrl: type == BookType.audiobook 
                ? 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3' 
                : null,
            narrator: type == BookType.audiobook ? 'LibriVox Reader' : null,
          );
        }
      }
    } catch (e) {
      print('ApiService Error: $e');
    }
    return null;
  }

  Future<List<Book>> searchOnline(String query) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl?q=${Uri.encodeComponent(query)}&limit=10'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<Book> results = [];
        for (var doc in data['docs']) {
          final String title = doc['title'] ?? 'Unknown';
          final String author = (doc['author_name'] != null && doc['author_name'].isNotEmpty) 
              ? doc['author_name'][0] 
              : 'Unknown Author';
          final int? coverId = doc['cover_i'];
          final String coverUrl = coverId != null 
              ? '$_coverBaseUrl$coverId-L.jpg' 
              : 'https://via.placeholder.com/400x600.png?text=No+Cover';
          
          results.add(Book(
            title: title,
            author: author,
            description: '',
            coverUrl: coverUrl,
            category: 'Discover',
            type: BookType.ebook,
            pages: doc['number_of_pages_median'] ?? 0,
            language: 'English',
            publicationYear: doc['first_publish_year'] ?? 0,
            rating: 0.0,
            isbn: (doc['isbn'] != null && doc['isbn'].isNotEmpty) ? doc['isbn'][0] : '',
            openLibraryId: doc['key']?.toString().replaceAll('/works/', '') ?? '',
          ));
        }
        return results;
      }
    } catch (e) {
      print('ApiService Search Error: $e');
    }
    return [];
  }
}
