import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/book_model.dart';
import '../../database/database_helper.dart';

class EBookReaderScreen extends StatefulWidget {
  final Book book;
  const EBookReaderScreen({super.key, required this.book});

  @override
  State<EBookReaderScreen> createState() => _EBookReaderScreenState();
}

class _EBookReaderScreenState extends State<EBookReaderScreen> {
  int _currentPage = 1;
  double _fontSize = 18.0;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final progress = await _dbHelper.getReadingProgress(widget.book.id!);
    if (progress != null) {
      setState(() {
        _currentPage = progress['current_page'];
      });
    }
  }

  void _updateProgress(int page) {
    setState(() {
      _currentPage = page;
    });
    _dbHelper.updateReadingProgress(widget.book.id!, _currentPage, widget.book.pages);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.format_size),
            onPressed: _showSettings,
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
               _dbHelper.addBookmark(widget.book.id!, _currentPage, "Bookmarked page $_currentPage");
               ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(content: Text("Bookmark added")),
               );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Text(
                _getMockContent(_currentPage),
                style: TextStyle(
                  fontSize: _fontSize,
                  height: 1.6,
                  color: AppTheme.textColor,
                ),
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(
            value: _currentPage / widget.book.pages,
            backgroundColor: Colors.grey[200],
            color: AppTheme.secondaryColor,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _currentPage > 1 ? () => _updateProgress(_currentPage - 1) : null,
                icon: const Icon(Icons.arrow_back_ios),
              ),
              Text(
                "Page $_currentPage / ${widget.book.pages}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: _currentPage < widget.book.pages ? () => _updateProgress(_currentPage + 1) : null,
                icon: const Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Font Size", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Slider(
                    value: _fontSize,
                    min: 12,
                    max: 30,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (val) {
                      setModalState(() => _fontSize = val);
                      setState(() => _fontSize = val);
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text("Background Theme", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _themeOption(Colors.white, "Light"),
                      const SizedBox(width: 12),
                      _themeOption(const Color(0xFFF5F5DC), "Sepia"),
                      const SizedBox(width: 12),
                      _themeOption(const Color(0xFF2C2C2C), "Dark"),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _themeOption(Color color, String label) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  String _getMockContent(int page) {
    return """
Chapter $page: The Journey Begins

This is a professional university-level Flutter project demonstration. In a real application, this content would be loaded from an EPUB or PDF file.

BookNest provides a premium digital library experience. The goal of this screen is to show how a user can read their favorite e-books with ease.

Effective habit formation is not about willpower, but about designing your environment for success. Every action you take is a vote for the type of person you wish to become.

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
""";
  }
}
