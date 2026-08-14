import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../widgets/event_card.dart';
import '../theme/app_theme.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<EventProvider>().favoriteEvents;

    return Scaffold(
      appBar: AppBar(title: const Text('My Favorites')),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border,
                      size: 80, color: AppTheme.secondaryText.withAlpha(51)),
                  const SizedBox(height: 16),
                  const Text('No favorite events yet',
                      style: TextStyle(color: AppTheme.secondaryText)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                      onPressed: () {}, child: const Text('Explore Events')),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: favorites.length,
              itemBuilder: (context, index) =>
                  EventCard(event: favorites[index]),
            ),
    );
  }
}
