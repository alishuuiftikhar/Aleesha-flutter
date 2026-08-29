import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/vocabulary.dart';
import '../constants/colors.dart';
import '../providers/app_provider.dart';

class WordDetailsScreen extends StatelessWidget {
  final Vocabulary vocabulary;

  const WordDetailsScreen({super.key, required this.vocabulary});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final isFavorite = provider.favoriteWordIds.contains(vocabulary.id);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? AppColors.accent : null,
            ),
            onPressed: () => provider.toggleFavorite(vocabulary.id),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              vocabulary.word,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.volume_up, color: AppColors.secondary),
                const SizedBox(width: 8),
                Text(
                  "[ ${vocabulary.pronunciation} ]",
                  style: const TextStyle(fontSize: 18, color: AppColors.textLight, fontStyle: FontStyle.italic),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 40),
            _buildInfoSection(context, "Translation", vocabulary.translation),
            const SizedBox(height: 30),
            _buildInfoSection(context, "Example", vocabulary.example),
            Text(
              vocabulary.exampleTranslation,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textLight, fontStyle: FontStyle.italic),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("Got it!"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, String title, String content) {
    return Column(
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: AppColors.secondary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
