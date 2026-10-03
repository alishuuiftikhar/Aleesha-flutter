import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/museum_card.dart';
import '../widgets/exhibition_card.dart';
import 'museum_details_screen.dart';
import 'exhibition_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Museum Guide',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Welcome back, Art Enthusiast',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 20),
                _sectionHeader(context, 'Featured Museums'),
                const SizedBox(height: 10),
                SizedBox(
                  height: 280,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemCount: provider.museums.length,
                    itemBuilder: (context, index) {
                      final museum = provider.museums[index];
                      return MuseumCard(
                        museum: museum,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MuseumDetailsScreen(museum: museum),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
                _sectionHeader(context, 'Popular Exhibitions'),
                const SizedBox(height: 10),
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemCount: provider.exhibitions.length,
                    itemBuilder: (context, index) {
                      final exhibition = provider.exhibitions[index];
                      return ExhibitionCard(
                        exhibition: exhibition,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExhibitionDetailsScreen(exhibition: exhibition),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
                if (provider.favoriteMuseums.isNotEmpty) ...[
                  _sectionHeader(context, 'Your Favorites'),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: AppColors.secondaryBackground),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.favorite, color: AppColors.accent),
                          const SizedBox(width: 15),
                          Text(
                            'You have ${provider.favoriteMuseums.length + provider.favoriteExhibitions.length + provider.favoriteArtworks.length} items saved.',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('See All', style: TextStyle(color: AppColors.accent)),
          ),
        ],
      ),
    );
  }
}
