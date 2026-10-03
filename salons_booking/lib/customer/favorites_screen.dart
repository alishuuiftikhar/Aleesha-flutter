import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.veryLightPink,
      appBar: AppBar(
        title: const Text('My Favorites'),
        backgroundColor: Colors.white,
      ),
      body: _buildEmptyState(), // For now, show empty state or dummy favorites
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: AppTheme.softRose),
          const SizedBox(height: 20),
          Text(
            'Nothing here yet ✨',
            style: TextStyle(fontSize: 20, color: AppTheme.deepRose, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Save the services and experts you love!',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
