import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/book_provider.dart';
import '../../models/book_model.dart';

class AudioScreen extends StatelessWidget {
  const AudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Audio Books"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, "Recently Played"),
            const SizedBox(height: 16),
            _buildRecentlyPlayed(context),
            const SizedBox(height: 32),
            _buildSectionHeader(context, "Popular Audio Books"),
            const SizedBox(height: 16),
            _buildAudioGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildRecentlyPlayed(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, provider, child) {
        final audioBooks = provider.getBooksByType(BookType.audiobook);
        if (audioBooks.isEmpty) return const SizedBox.shrink();
        final book = audioBooks.first;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.secondaryColor.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: book.coverUrl,
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(color: Colors.grey, child: const Icon(Icons.headphones)),
                    ),
                  ),
                  const Icon(Icons.play_circle_outline, color: Colors.white, size: 40),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(book.author, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                    const SizedBox(height: 8),
                    Text(
                      "12:35 / ${book.totalDuration ?? '8:30:00'}", 
                      style: const TextStyle(color: AppTheme.secondaryColor, fontSize: 12)
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAudioGrid(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, provider, child) {
        final audioBooks = provider.getBooksByType(BookType.audiobook);
        if (audioBooks.isEmpty) return const Center(child: Text("No audio books found"));
        
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: audioBooks.length,
          itemBuilder: (context, index) {
            final book = audioBooks[index];
            return GestureDetector(
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: book.coverUrl,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            right: 8,
                            bottom: 8,
                            child: CircleAvatar(
                              backgroundColor: AppTheme.primaryColor,
                              radius: 18,
                              child: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    book.author,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
