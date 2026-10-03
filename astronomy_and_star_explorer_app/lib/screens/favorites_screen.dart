import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/astronomy_provider.dart';
import '../utils/constants.dart';
import 'object_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MY FAVORITES')),
      body: Consumer<AstronomyProvider>(
        builder: (context, provider, child) {
          final favorites = provider.favorites;

          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.white24),
                  const SizedBox(height: 16),
                  const Text('No favorites yet', style: TextStyle(color: Colors.white38, fontSize: 18)),
                  const SizedBox(height: 8),
                  const Text('Start exploring and tap the heart icon!', style: TextStyle(color: Colors.white24)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final obj = favorites[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(8),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(obj.image, width: 60, height: 60, fit: BoxFit.cover),
                  ),
                  title: Text(obj.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(obj.category, style: const TextStyle(color: AppColors.primary)),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: AppColors.error),
                    onPressed: () => provider.toggleFavorite(obj),
                  ),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ObjectDetailsScreen(object: obj))),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
