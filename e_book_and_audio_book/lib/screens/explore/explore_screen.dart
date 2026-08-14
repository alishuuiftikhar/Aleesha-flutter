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
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Text(
                "Discover",
                style: GoogleFonts.philosopher(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildSearchBar(),
            ),
            const SizedBox(height: 24),
            _buildFilterList(),
            const SizedBox(height: 16),
            Expanded(
              child: _isSearching 
                ? const Center(child: CircularProgressIndicator(color: AppTheme.accentColor))
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearch,
        style: const TextStyle(color: AppTheme.primaryColor),
        decoration: InputDecoration(
          icon: const Icon(Icons.search_rounded, color: AppTheme.secondaryColor),
          hintText: "Search titles, authors, ISBN...",
          hintStyle: TextStyle(color: AppTheme.textSecondaryColor.withOpacity(0.7)),
          border: InputBorder.none,
          suffixIcon: _searchController.text.isNotEmpty 
            ? IconButton(
                icon: const Icon(Icons.clear_rounded, color: AppTheme.textSecondaryColor),
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
      height: 44,
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
                padding: const EdgeInsets.symmetric(horizontal: 22),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected ? AppTheme.primaryColor : AppTheme.primaryColor.withOpacity(0.08)
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
            Icon(Icons.search_off_rounded, size: 80, color: AppTheme.primaryColor.withOpacity(0.1)),
            const SizedBox(height: 20),
            Text(
              "No stories found.",
              style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.58,
        crossAxisSpacing: 20,
        mainAxisSpacing: 30,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return BookCard(book: _searchResults[index], width: double.infinity);
      },
    );
  }
}
