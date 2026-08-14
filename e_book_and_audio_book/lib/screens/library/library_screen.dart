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
        appBar: AppBar(
          title: Text(
            "My Library",
            style: GoogleFonts.philosopher(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: AppTheme.secondaryColor,
            labelColor: AppTheme.secondaryColor,
            unselectedLabelColor: AppTheme.textSecondaryColor,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: "All Books"),
              Tab(text: "E-Books"),
              Tab(text: "Audio"),
              Tab(text: "Favorites"),
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
                    Icon(Icons.library_books_rounded, size: 80, color: AppTheme.cardColor),
                    const SizedBox(height: 16),
                    Text(
                      filter == "Favorites" ? "No favorites yet." : "Your library is empty.",
                      style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            final books = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(24),
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
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: book.coverUrl,
                            width: 60,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.title,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                book.author,
                                style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 13),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: LinearProgressIndicator(
                                      value: 0.45,
                                      backgroundColor: Colors.white10,
                                      valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.secondaryColor),
                                      minHeight: 4,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text("45%", style: TextStyle(color: Colors.white70, fontSize: 11)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert_rounded, color: AppTheme.textSecondaryColor),
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
