import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/book_provider.dart';
import '../../models/book_model.dart';
import '../book_details/book_details_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          toolbarHeight: 80,
          title: Text(
            "My Library",
            style: GoogleFonts.philosopher(fontWeight: FontWeight.bold, fontSize: 28, color: AppTheme.primaryColor),
          ),
          bottom: TabBar(
            isScrollable: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            indicatorColor: AppTheme.primaryColor,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: AppTheme.textSecondaryColor,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            tabs: const [
              Tab(text: "Everything"),
              Tab(text: "E-Books"),
              Tab(text: "Audio Stories"),
              Tab(text: "My Favorites"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            LibraryList(filter: "All"),
            LibraryList(filter: "E-Book"),
            LibraryList(filter: "Audio"),
            LibraryList(filter: "Favorites"),
          ],
        ),
      ),
    );
  }
}

class LibraryList extends StatelessWidget {
  final String filter;
  const LibraryList({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, provider, child) {
        Future<List<Book>> getFilteredBooks() async {
          if (filter == "E-Book") {
            return provider.getBooksByType(BookType.ebook);
          } else if (filter == "Audio") {
            return provider.getBooksByType(BookType.audiobook);
          } else if (filter == "Favorites") {
            return await provider.getFavorites();
          } else {
            return provider.books;
          }
        }

        return FutureBuilder<List<Book>>(
          future: getFilteredBooks(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_stories_rounded, size: 85, color: AppTheme.primaryColor.withOpacity(0.05)),
                    const SizedBox(height: 20),
                    Text(
                      filter == "Favorites" ? "No favorite stories yet." : "Your library is empty.",
                      style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              );
            }

            final books = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookDetailsScreen(book: book)),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppTheme.primaryColor.withOpacity(0.06)),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CachedNetworkImage(
                            imageUrl: book.coverUrl,
                            width: 65,
                            height: 95,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.title,
                                style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                book.author,
                                style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 13),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: LinearProgressIndicator(
                                      value: 0.45,
                                      backgroundColor: AppTheme.primaryColor.withOpacity(0.05),
                                      valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
                                      minHeight: 5,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  const Text("45%", style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_horiz_rounded, color: AppTheme.textSecondaryColor),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
