import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/audio_provider.dart';
import '../core/theme/app_theme.dart';
import '../screens/audio/audio_player_screen.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(
      builder: (context, audioProvider, child) {
        final book = audioProvider.currentBook;
        if (book == null) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AudioPlayerScreen(book: book),
              ),
            );
          },
          child: Container(
            height: 75,
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3), 
                  blurRadius: 15, 
                  offset: const Offset(0, 8)
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: book.coverUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => const Icon(Icons.headphones_rounded, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        book.author,
                        style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                StreamBuilder<bool>(
                  stream: audioProvider.player.playingStream,
                  builder: (context, snapshot) {
                    final isPlaying = snapshot.data ?? false;
                    return IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                      onPressed: audioProvider.togglePlayPause,
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: Colors.white.withOpacity(0.4), size: 20),
                  onPressed: () {
                    // Logic to clear/stop could be added to provider
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
