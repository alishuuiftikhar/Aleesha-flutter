import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/artwork.dart';
import '../services/app_provider.dart';
import '../utils/app_colors.dart';

class ArtworkDetailsScreen extends StatelessWidget {
  final Artwork artwork;

  const ArtworkDetailsScreen({super.key, required this.artwork});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Better for artwork viewing
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          Consumer<AppProvider>(
            builder: (context, provider, child) {
              final isFav = provider.isFavorite('artwork', artwork.id);
              return IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : Colors.white),
                onPressed: () => provider.toggleFavorite('artwork', artwork.id),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _showFullScreenImage(context),
              child: Hero(
                tag: artwork.id,
                child: Image.network(artwork.imageUrl, width: double.infinity, fit: BoxFit.contain),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: AppColors.mainBackground,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(artwork.title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    '${artwork.artistName} • ${artwork.year}',
                    style: const TextStyle(fontSize: 18, color: AppColors.secondary, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  Text(artwork.type, style: const TextStyle(fontStyle: FontStyle.italic, color: AppColors.secondary)),
                  const SizedBox(height: 25),
                  Text('Description', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),
                  Text(artwork.description, style: const TextStyle(fontSize: 16, height: 1.6)),
                  const SizedBox(height: 25),
                  Text('Historical Context', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),
                  Text(artwork.historicalContext, style: const TextStyle(fontSize: 16, height: 1.6)),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  child: Image.network(artwork.imageUrl),
                ),
              ),
              Positioned(
                top: 40,
                left: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
