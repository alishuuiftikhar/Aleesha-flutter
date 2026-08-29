import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../constants/colors.dart';
import '../word_details_screen.dart';

class VocabularyTab extends StatefulWidget {
  const VocabularyTab({super.key});

  @override
  State<VocabularyTab> createState() => _VocabularyTabState();
}

class _VocabularyTabState extends State<VocabularyTab> {
  String _searchQuery = "";
  bool _showFavoritesOnly = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final vocabList = provider.vocabulary.where((v) {
      final matchesSearch = v.word.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          v.translation.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFavorite = !_showFavoritesOnly || provider.favoriteWordIds.contains(v.id);
      return matchesSearch && matchesFavorite;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulary'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: "Search words...",
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text("All"),
                  selected: !_showFavoritesOnly,
                  onSelected: (val) => setState(() => _showFavoritesOnly = false),
                  selectedColor: AppColors.secondary,
                  labelStyle: TextStyle(color: !_showFavoritesOnly ? Colors.white : AppColors.text),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text("Favorites"),
                  selected: _showFavoritesOnly,
                  onSelected: (val) => setState(() => _showFavoritesOnly = true),
                  selectedColor: AppColors.secondary,
                  labelStyle: TextStyle(color: _showFavoritesOnly ? Colors.white : AppColors.text),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: vocabList.length,
              itemBuilder: (context, index) {
                final vocab = vocabList[index];
                final isFavorite = provider.favoriteWordIds.contains(vocab.id);
                return Card(
                  color: AppColors.cardBackground,
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(color: AppColors.secondaryBackground),
                  ),
                  child: ListTile(
                    title: Text(vocab.word, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(vocab.translation),
                    trailing: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? AppColors.accent : null,
                      ),
                      onPressed: () => provider.toggleFavorite(vocab.id),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => WordDetailsScreen(vocabulary: vocab)),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
