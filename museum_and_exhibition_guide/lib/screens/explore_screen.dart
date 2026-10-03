import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_provider.dart';
import '../utils/app_colors.dart';
import '../models/museum.dart';
import '../models/exhibition.dart';
import '../models/artwork.dart';
import '../models/artist.dart';
import 'museum_details_screen.dart';
import 'exhibition_details_screen.dart';
import 'artwork_details_screen.dart';
import 'artist_details_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Art Museum', 'Modern Art', 'Historical', 'Science'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search museums, artworks...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.cardBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedCategory = category);
                    },
                    selectedColor: AppColors.accent,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.text,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Consumer<AppProvider>(
              builder: (context, provider, child) {
                List<dynamic> results = [];
                if (_searchQuery.isNotEmpty) {
                  results = provider.search(_searchQuery);
                } else {
                  results = provider.museums.where((m) {
                    return _selectedCategory == 'All' || m.category == _selectedCategory;
                  }).toList();
                }

                if (results.isEmpty) {
                  return const Center(
                    child: Text('No results found.'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final item = results[index];
                    if (item is Museum) {
                      return _buildResultTile(
                        context,
                        item.name,
                        item.location,
                        item.imageUrl,
                        'Museum',
                        () => Navigator.push(context, MaterialPageRoute(builder: (context) => MuseumDetailsScreen(museum: item))),
                      );
                    } else if (item is Exhibition) {
                      return _buildResultTile(
                        context,
                        item.title,
                        item.schedule,
                        item.imageUrl,
                        'Exhibition',
                        () => Navigator.push(context, MaterialPageRoute(builder: (context) => ExhibitionDetailsScreen(exhibition: item))),
                      );
                    } else if (item is Artwork) {
                      return _buildResultTile(
                        context,
                        item.title,
                        item.artistName,
                        item.imageUrl,
                        'Artwork',
                        () => Navigator.push(context, MaterialPageRoute(builder: (context) => ArtworkDetailsScreen(artwork: item))),
                      );
                    } else if (item is Artist) {
                      return _buildResultTile(
                        context,
                        item.name,
                        item.period,
                        item.imageUrl,
                        'Artist',
                        () => Navigator.push(context, MaterialPageRoute(builder: (context) => ArtistDetailsScreen(artist: item))),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultTile(BuildContext context, String title, String subtitle, String imageUrl, String type, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.secondaryBackground,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(type, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
