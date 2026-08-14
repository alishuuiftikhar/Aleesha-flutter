import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/book_provider.dart';
import '../../widgets/book_card.dart';
import '../../models/book_model.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _selectedFilter = "All";
  final List<String> _filters = ["All", "Fiction", "Self Development", "Business", "Technology", "History", "Science"];
  
  List<Book> _searchResults = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _searchResults = Provider.of<BookProvider>(context, listen: false).books;
      });
    });
  }

  void _onSearch(String query) async {
    setState(() => _isSearching = true);
    final results = await Provider.of<BookProvider>(context, listen: false).searchBooks(query);
    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                "Explore",
                style: GoogleFonts.philosopher(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildSearchBar(),
            ),
            const SizedBox(height: 24),
            _buildFilterList(),
            const SizedBox(height: 12),
            Expanded(
              child: _isSearching 
                ? const Center(child: CircularProgressIndicator(color: AppTheme.secondaryColor))
                : _buildBookGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearch,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          icon: const Icon(Icons.search_rounded, color: AppTheme.textSecondaryColor),
          hintText: "Search books, authors or ISBN...",
          hintStyle: const TextStyle(color: AppTheme.textSecondaryColor),
          border: InputBorder.none,
          suffixIcon: _searchController.text.isNotEmpty 
            ? IconButton(
                icon: const Icon(Icons.clear, color: AppTheme.textSecondaryColor),
                onPressed: () {
                  _searchController.clear();
                  _onSearch("");
                },
              )
            : null,
        ),
      ),
    );
  }

  Widget _buildFilterList() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = filter;
                  final allBooks = Provider.of<BookProvider>(context, listen: false).books;
                  if (filter == "All") {
                    _searchResults = allBooks;
                  } else {
                    _searchResults = allBooks.where((b) => b.category == filter).toList();
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.secondaryColor : AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppTheme.secondaryColor : Colors.white.withOpacity(0.05)
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textSecondaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookGrid() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: AppTheme.cardColor),
            const SizedBox(height: 16),
            const Text(
              "No books found matching your search.",
              style: TextStyle(color: AppTheme.textSecondaryColor),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.55,
        crossAxisSpacing: 20,
        mainAxisSpacing: 24,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return BookCard(book: _searchResults[index], width: double.infinity);
      },
    );
  }
}
