import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';
import '../widgets/project_card.dart';
import '../theme/app_theme.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorite Crafts'),
      ),
      body: Consumer<ProjectProvider>(
        builder: (context, provider, child) {
          final favorites = provider.favorites;

          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: AppColors.secondary.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  const Text(
                    'No favorites yet!',
                    style: TextStyle(fontSize: 18, color: AppColors.primary),
                  ),
                  const SizedBox(height: 8),
                  const Text('Start adding some projects to your list.'),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                return ProjectCard(project: favorites[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
