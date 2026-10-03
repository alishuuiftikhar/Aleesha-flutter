import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exhibition.dart';
import '../services/app_provider.dart';
import '../utils/app_colors.dart';
import 'artwork_details_screen.dart';

class ExhibitionDetailsScreen extends StatelessWidget {
  final Exhibition exhibition;

  const ExhibitionDetailsScreen({super.key, required this.exhibition});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(exhibition.imageUrl, fit: BoxFit.cover),
            ),
            actions: [
              Consumer<AppProvider>(
                builder: (context, provider, child) {
                  final isFav = provider.isFavorite('exhibition', exhibition.id);
                  return IconButton(
                    icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : Colors.white),
                    onPressed: () => provider.toggleFavorite('exhibition', exhibition.id),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(exhibition.type, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),
                  Text(exhibition.title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(exhibition.schedule, style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 20),
                  Text('Description', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(exhibition.description, style: const TextStyle(fontSize: 16, height: 1.5)),
                  const SizedBox(height: 30),
                  Text('Artworks in this Exhibition', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),
                  Consumer<AppProvider>(
                    builder: (context, provider, child) {
                      final artworks = provider.artworks.where((a) => exhibition.artworkIds.contains(a.id)).toList();
                      if (artworks.isEmpty) return const Text('No artworks listed.');
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: artworks.length,
                        itemBuilder: (context, index) {
                          final artwork = artworks[index];
                          return GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ArtworkDetailsScreen(artwork: artwork))),
                            child: Card(
                              color: AppColors.cardBackground,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                      child: Image.network(artwork.imageUrl, width: double.infinity, fit: BoxFit.cover),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(artwork.title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                                        Text(artwork.artistName, style: const TextStyle(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
