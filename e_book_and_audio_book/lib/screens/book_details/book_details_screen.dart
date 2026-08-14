import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../models/book_model.dart';
import '../../providers/book_provider.dart';
import '../../providers/audio_provider.dart';
import '../reader/ebook_reader_screen.dart';
import '../audio/audio_player_screen.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleSection(),
                  const SizedBox(height: 32),
                  _buildInfoCards(),
                  const SizedBox(height: 40),
                  _buildDescriptionSection(),
                  const SizedBox(height: 40),
                  _buildMetadataList(),
                  const SizedBox(height: 120), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomActions(context),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 500,
      pinned: true,
      backgroundColor: AppTheme.backgroundColor,
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: book.coverUrl,
              fit: BoxFit.cover,
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                    AppTheme.backgroundColor.withOpacity(0.5),
                    AppTheme.backgroundColor,
                  ],
                  stops: const [0.0, 0.4, 0.8, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Consumer<BookProvider>(
          builder: (context, provider, child) {
            return FutureBuilder<bool>(
              future: provider.isFavorite(book.id ?? 0),
              builder: (context, snapshot) {
                final isFav = snapshot.data ?? false;
                return Container(
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: isFav ? Colors.redAccent : Colors.white,
                    ),
                    onPressed: () => provider.toggleFavorite(book.id ?? 0),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.secondaryColor.withOpacity(0.3)),
              ),
              child: Text(
                book.category.toUpperCase(),
                style: const TextStyle(color: AppTheme.secondaryColor, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1),
              ),
            ),
            const SizedBox(width: 14),
            Text(
              book.type == BookType.ebook ? "E-BOOK" : "AUDIOBOOK",
              style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          book.title,
          style: GoogleFonts.philosopher(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "by ${book.author}",
          style: TextStyle(
            fontSize: 19,
            color: AppTheme.primaryColor.withOpacity(0.7),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _infoItem("Rating", book.rating > 0 ? book.rating.toString() : "4.5", Icons.star_rounded),
        _infoItem("Pages", book.pages > 0 ? book.pages.toString() : "250", Icons.menu_book_rounded),
        _infoItem("Language", book.language.length > 2 ? book.language.substring(0, 3).toUpperCase() : "ENG", Icons.language_rounded),
        _infoItem("Year", book.publicationYear > 0 ? book.publicationYear.toString() : "2020", Icons.event_rounded),
      ],
    );
  }

  Widget _infoItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      width: 82,
      child: Column(
        children: [
          Icon(icon, color: AppTheme.accentColor, size: 22),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Synopsis",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
        ),
        const SizedBox(height: 14),
        Text(
          book.description,
          style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 16, height: 1.7),
        ),
      ],
    );
  }

  Widget _buildMetadataList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Information",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
        ),
        const SizedBox(height: 20),
        _metaRow("ISBN", book.isbn ?? "N/A"),
        _metaRow("Publisher", book.source ?? "Open Library"),
        _metaRow("Published Year", book.publicationYear.toString()),
        if (book.type == BookType.audiobook) _metaRow("Narrator", book.narrator ?? "LibriVox"),
      ],
    );
  }

  Widget _metaRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 14)),
          Text(value, style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        border: Border(top: BorderSide(color: AppTheme.primaryColor.withOpacity(0.05))),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (book.type == BookType.ebook) {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => EBookReaderScreen(book: book)));
                } else {
                   Provider.of<AudioProvider>(context, listen: false).playBook(book);
                   Navigator.push(context, MaterialPageRoute(builder: (context) => AudioPlayerScreen(book: book)));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 20),
                elevation: 10,
                shadowColor: AppTheme.primaryColor.withOpacity(0.4),
              ),
              child: Text(
                book.type == BookType.ebook ? "Start Reading" : "Listen Now",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
            ),
          ),
          const SizedBox(width: 18),
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1)),
            ),
            child: IconButton(
              icon: const Icon(Icons.bookmark_add_outlined, color: AppTheme.primaryColor),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
