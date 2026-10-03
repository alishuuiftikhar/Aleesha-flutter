import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_provider.dart';
import '../utils/app_colors.dart';
import 'museum_details_screen.dart';
import 'exhibition_details_screen.dart';
import 'artwork_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Favorites'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Museums'),
              Tab(text: 'Exhibitions'),
              Tab(text: 'Artworks'),
            ],
            indicatorColor: AppColors.accent,
            labelColor: AppColors.primary,
          ),
        ),
        body: Consumer<AppProvider>(
          builder: (context, provider, child) {
            return TabBarView(
              children: [
                _buildList(context, provider.favoriteMuseums, 'museum'),
                _buildList(context, provider.favoriteExhibitions, 'exhibition'),
                _buildList(context, provider.favoriteArtworks, 'artwork'),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<dynamic> items, String type) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 60, color: AppColors.secondary.withOpacity(0.3)),
            const SizedBox(height: 10),
            Text('No favorite ${type}s yet.', style: TextStyle(color: AppColors.secondary)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        String title = '';
        String subtitle = '';
        String imageUrl = '';
        VoidCallback onTap = () {};

        if (type == 'museum') {
          title = item.name;
          subtitle = item.location;
          imageUrl = item.imageUrl;
          onTap = () => Navigator.push(context, MaterialPageRoute(builder: (context) => MuseumDetailsScreen(museum: item)));
        } else if (type == 'exhibition') {
          title = item.title;
          subtitle = item.schedule;
          imageUrl = item.imageUrl;
          onTap = () => Navigator.push(context, MaterialPageRoute(builder: (context) => ExhibitionDetailsScreen(exhibition: item)));
        } else if (type == 'artwork') {
          title = item.title;
          subtitle = item.artistName;
          imageUrl = item.imageUrl;
          onTap = () => Navigator.push(context, MaterialPageRoute(builder: (context) => ArtworkDetailsScreen(artwork: item)));
        }

        return Card(
          color: AppColors.cardBackground,
          margin: const EdgeInsets.only(bottom: 15),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover),
            ),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(subtitle),
            trailing: IconButton(
              icon: const Icon(Icons.favorite, color: AppColors.accent),
              onPressed: () {
                Provider.of<AppProvider>(context, listen: false).toggleFavorite(type, item.id);
              },
            ),
            onTap: onTap,
          ),
        );
      },
    );
  }
}
