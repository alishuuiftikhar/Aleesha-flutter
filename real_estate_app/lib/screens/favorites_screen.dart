import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/property_provider.dart';
import '../widgets/property_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<PropertyProvider>().fetchFavorites());
  }

  @override
  Widget build(BuildContext context) {
    final propertyProvider = context.watch<PropertyProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('My Favorites')),
      body: propertyProvider.favorites.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_outline, size: 60, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text('No favorite properties yet.', style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          )
        : RefreshIndicator(
            onRefresh: () => propertyProvider.fetchFavorites(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: propertyProvider.favorites.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: PropertyCard(property: propertyProvider.favorites[index]),
              ),
            ),
          ),
    );
  }
}
