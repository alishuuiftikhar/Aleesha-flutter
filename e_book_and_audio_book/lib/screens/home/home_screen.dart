import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/book_provider.dart';
import '../../widgets/book_card.dart';
import '../../models/book_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookProvider>(context, listen: false).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Consumer<BookProvider>(
          builder: (context, provider, child) {
            return RefreshIndicator(
              onRefresh: () => provider.initialize(),
              color: AppTheme.accentColor,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (provider.isOffline) _buildOfflineBanner(),
                    _buildTopBar(),
                    const SizedBox(height: 24),
                    _buildWelcomeSection(),
                    const SizedBox(height: 32),
                    _buildContinueReading(provider),
                    const SizedBox(height: 40),
                    _buildSectionHeader("Popular E-Books"),
                    const SizedBox(height: 20),
                    _buildHorizontalList(provider.getBooksByType(BookType.ebook)),
                    const SizedBox(height: 40),
                    _buildSectionHeader("Trending Audio Books"),
                    const SizedBox(height: 20),
                    _buildAudioList(provider.getBooksByType(BookType.audiobook)),
                    const SizedBox(height: 40),
                    _buildSectionHeader("Explore Categories"),
                    const SizedBox(height: 20),
                    _buildCategoriesGrid(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOfflineBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.9),
        borderRadius: BorderRadius.circular(0),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_rounded, color: Colors.white, size: 16),
          SizedBox(width: 10),
          Text(
            "Offline Mode: Showing Saved Library",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.notes_rounded, color: AppTheme.primaryColor, size: 30),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: const Icon(Icons.search_rounded, color: AppTheme.primaryColor, size: 22),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.05),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1)),
                ),
                child: const Icon(Icons.notifications_none_rounded, color: AppTheme.primaryColor, size: 22),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Good Morning 👋",
            style: TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Discover your next\nfavorite story.",
            style: GoogleFonts.philosopher(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueReading(BookProvider provider) {
    if (provider.books.isEmpty) return const SizedBox.shrink();
    final book = provider.books.first;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.25),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Hero(
              tag: 'continue_${book.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: book.coverUrl,
                  width: 80,
                  height: 115,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "CONTINUE READING",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5), 
                      fontSize: 10, 
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: 0.72,
                          backgroundColor: Colors.white.withOpacity(0.1),
                          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Text(
                        "72%",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.philosopher(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              "See All",
              style: TextStyle(color: AppTheme.accentColor, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalList(List<Book> books) {
    if (books.isEmpty) {
      return Container(
        height: 300,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(color: AppTheme.accentColor),
      );
    }
    return SizedBox(
      height: 310,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 24),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: books.length,
        itemBuilder: (context, index) => BookCard(book: books[index]),
      ),
    );
  }

  Widget _buildAudioList(List<Book> audioBooks) {
    if (audioBooks.isEmpty) {
      return const SizedBox(height: 120, child: Center(child: Text("Fetching audio stories...")));
    }
    return SizedBox(
      height: 180,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 24),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: audioBooks.length,
        itemBuilder: (context, index) {
          final book = audioBooks[index];
          return Container(
            width: 320,
            margin: const EdgeInsets.only(right: 20, bottom: 5),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppTheme.primaryColor.withOpacity(0.04)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 6)),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: CachedNetworkImage(
                    imageUrl: book.coverUrl,
                    width: 90,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        book.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        book.author,
                        style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 13),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppTheme.accentColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.headphones_rounded, color: AppTheme.accentColor, size: 16),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            book.totalDuration ?? "9h 15m",
                            style: const TextStyle(color: AppTheme.accentColor, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.secondaryColor.withOpacity(0.2), width: 2),
                  ),
                  child: Icon(Icons.play_circle_fill_rounded, color: AppTheme.secondaryColor, size: 48),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    final categories = [
      {"name": "Fiction", "icon": Icons.auto_stories_rounded},
      {"name": "Self Development", "icon": Icons.psychology_rounded},
      {"name": "Technology", "icon": Icons.computer_rounded},
      {"name": "Business", "icon": Icons.business_center_rounded},
      {"name": "History", "icon": Icons.history_edu_rounded},
      {"name": "Science", "icon": Icons.science_rounded},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 2.3,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.primaryColor.withOpacity(0.06)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 3)),
              ],
            ),
            child: Row(
              children: [
                Icon(cat['icon'] as IconData, color: AppTheme.secondaryColor, size: 24),
                const SizedBox(width: 14),
                Text(
                  cat['name'] as String,
                  style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
