import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';
import '../widgets/article_card.dart';
import '../services/supabase_service.dart';
import '../models/article.dart';
import '../models/author.dart';
import 'author_profile_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  final SupabaseService _supabaseService = SupabaseService();
  List<Article> _searchResults = [];
  List<Author> _authorResults = [];
  bool _isSearching = false;
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _performSearch();
  }

  Future<void> _performSearch() async {
    setState(() => _isSearching = true);
    try {
      final results = await _supabaseService.getArticles(
        query: _searchController.text,
        categoryId: _selectedCategoryId,
      );
      
      List<Author> authors = [];
      if (_searchController.text.isNotEmpty) {
        authors = await _supabaseService.getAuthors(query: _searchController.text);
      }

      setState(() {
        _searchResults = results;
        _authorResults = authors;
      });
    } catch (e) {
      debugPrint('Search error: $e');
    } finally {
      setState(() => _isSearching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('EXPLORE', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: AppColors.primary),
              decoration: InputDecoration(
                hintText: 'SEARCH ARTICLES, AUTHORS...',
                hintStyle: TextStyle(color: AppColors.primary.withOpacity(0.3), fontSize: 12, letterSpacing: 2),
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: AppColors.cardBackground,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.secondary, width: 1),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: provider.categories.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildCategoryChip('All News', null);
                }
                final category = provider.categories[index - 1];
                return _buildCategoryChip(category.name, category.id);
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _isSearching
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : _searchResults.isEmpty && _authorResults.isEmpty && _searchController.text.isNotEmpty
                    ? const Center(child: Text('No results found.'))
                    : ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          if (_authorResults.isNotEmpty) ...[
                            _buildSectionHeader('AUTHORS'),
                            SizedBox(
                              height: 120,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _authorResults.length,
                                itemBuilder: (context, index) {
                                  final author = _authorResults[index];
                                  return _buildAuthorCard(author);
                                },
                              ),
                            ),
                            const Divider(height: 40),
                          ],
                          _buildSectionHeader('ARTICLES'),
                          ...(_searchController.text.isEmpty && _selectedCategoryId == null 
                              ? provider.articles 
                              : _searchResults).map((article) => ArticleCard(article: article)).toList(),
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, String? id) {
    final isSelected = _selectedCategoryId == id;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: FilterChip(
        label: Text(label.toUpperCase()),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategoryId = selected ? id : null;
          });
          _performSearch();
        },
        selectedColor: AppColors.primary,
        checkmarkColor: Colors.white,
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.primary,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
        ),
        backgroundColor: AppColors.cardBackground,
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w900,
          color: AppColors.secondary,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildAuthorCard(Author author) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AuthorProfileScreen(authorId: author.id, authorName: author.name),
          ),
        );
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: AppColors.secondary,
              backgroundImage: author.avatarUrl != null ? NetworkImage(author.avatarUrl!) : null,
              child: author.avatarUrl == null ? const Icon(Icons.person, color: Colors.white) : null,
            ),
            const SizedBox(height: 8),
            Text(
              author.name,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
