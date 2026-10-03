import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/artist.dart';
import '../services/app_provider.dart';
import '../utils/app_colors.dart';
import 'artwork_details_screen.dart';

class ArtistDetailsScreen extends StatelessWidget {
  final Artist artist;

  const ArtistDetailsScreen({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(artist.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(artist.imageUrl, height: 200, width: 200, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),
            Text(artist.name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            Text(artist.period, style: const TextStyle(fontSize: 18, color: AppColors.accent, fontWeight: FontWeight.w500)),
            const SizedBox(height: 20),
            Text('Biography', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(artist.bio, style: const TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 30),
            Text('Famous Works', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Consumer<AppProvider>(
              builder: (context, provider, child) {
                final artworks = provider.artworks.where((a) => artist.artworkIds.contains(a.id)).toList();
                return Column(
                  children: artworks.map((a) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(a.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                    ),
                    title: Text(a.title),
                    subtitle: Text(a.year),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ArtworkDetailsScreen(artwork: a))),
                  )).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
