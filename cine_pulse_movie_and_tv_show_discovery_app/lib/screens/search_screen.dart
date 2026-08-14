import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../widgets/movie_card.dart';
import 'movie_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  final TextEditingController _searchController = TextEditingController();
  
  List<Movie> _searchResults = [];
  List<Movie> _recentSearches = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    final results = await _storageService.getRecentSearches();
    setState(() => _recentSearches = results);
  }

  Future<void> _onSearch(String query) async {
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }
    setState(() => _isLoading = true);
    final results = await _apiService.searchMovies(query);
    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Search', 
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900)
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _searchController,
                onChanged: _onSearch,
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                decoration: InputDecoration(
                  hintText: 'Movies, Actors...',
                  hintStyle: const TextStyle(color: Color(0xFFC4B5FD)),
                  prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFFC4B5FD)),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF18181B) : Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              if (_searchResults.isEmpty && !_isLoading) ...[
                const Text(
                  'Recent Searches', 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: 20),
                Expanded(child: _buildRecentList()),
              ] else if (_isLoading) ...[
                const Center(child: CircularProgressIndicator(color: Color(0xFF8B5CF6))),
              ] else ...[
                Expanded(child: _buildResultsGrid()),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentList() {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    if (_recentSearches.isEmpty) {
      return const Center(child: Text('No recent searches', style: TextStyle(color: Color(0xFFC4B5FD))));
    }
    return ListView.builder(
      itemCount: _recentSearches.length,
      itemBuilder: (context, index) {
        final movie = _recentSearches[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF18181B) : Colors.grey[100],
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(movie.imageUrl, width: 50, height: 75, fit: BoxFit.cover),
            ),
            title: Text(movie.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFFC4B5FD)),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailScreen(movie: movie)));
            },
          ),
        );
      },
    );
  }

  Widget _buildResultsGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.68,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final movie = _searchResults[index];
        return GestureDetector(
          onTap: () async {
            await _storageService.saveSearch(movie);
            _loadRecentSearches();
            Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailScreen(movie: movie)));
          },
          child: MovieCard(movie: movie),
        );
      },
    );
  }
}
