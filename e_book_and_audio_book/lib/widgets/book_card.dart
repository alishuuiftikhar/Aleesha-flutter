import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/book_model.dart';
import '../core/theme/app_theme.dart';
import '../screens/book_details/book_details_screen.dart';
import '../providers/book_provider.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final double width;

  const BookCard({
    super.key,
    required this.book,
    this.width = 150,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Save to SQLite if it's from search and not yet saved
        if (book.id == null) {
          Provider.of<BookProvider>(context, listen: false).saveBook(book);
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailsScreen(book: book),
          ),
        );
      },
      child: Container(
        width: width,
        margin: const EdgeInsets.only(right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCoverImage(context),
            const SizedBox(height: 12),
            Text(
              book.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              book.author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star_rounded, color: AppTheme.accentColor, size: 18),
                const SizedBox(width: 4),
                Text(
                  book.rating > 0 ? book.rating.toStringAsFixed(1) : "4.5",
                  style: const TextStyle(
                    fontSize: 13, 
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
                const Spacer(),
                _buildTypeBadge(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverImage(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CachedNetworkImage(
          imageUrl: book.coverUrl,
          height: width * 1.5,
          width: width,
          fit: BoxFit.cover,
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: AppTheme.cardColor,
            highlightColor: AppTheme.secondaryColor.withOpacity(0.1),
            child: Container(
              height: width * 1.5,
              width: width,
              color: Colors.white,
            ),
          ),
          errorWidget: (context, url, error) => _buildErrorWidget(),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      height: width * 1.5,
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.menu_book_rounded, size: 40, color: AppTheme.accentColor),
          const SizedBox(height: 8),
          Text(
            'BookNest',
            style: GoogleFonts.philosopher(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeBadge() {
    bool isAudio = book.type == BookType.audiobook;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isAudio ? AppTheme.accentColor.withOpacity(0.2) : AppTheme.secondaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isAudio ? AppTheme.accentColor : AppTheme.secondaryColor,
          width: 1,
        ),
      ),
      child: Text(
        isAudio ? 'AUDIO' : 'E-BOOK',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: isAudio ? AppTheme.accentColor : Colors.white,
        ),
      ),
    );
  }
}
