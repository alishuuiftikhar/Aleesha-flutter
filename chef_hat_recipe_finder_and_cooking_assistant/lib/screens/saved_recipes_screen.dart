import 'package:flutter/material.dart';
import '../services/app_state.dart';
import 'recipe_details_screen.dart';

class SavedRecipesScreen extends StatefulWidget {
  const SavedRecipesScreen({super.key});

  @override
  State<SavedRecipesScreen> createState() => _SavedRecipesScreenState();
}

class _SavedRecipesScreenState extends State<SavedRecipesScreen> {
  final _appState = AppState();

  @override
  Widget build(BuildContext context) {
    final savedRecipes = _appState.favoriteRecipes;

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Recipes')),
      body: savedRecipes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text('No saved recipes yet!', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 10),
                  const Text('Heart your favorite recipes to see them here.', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: savedRecipes.length,
              itemBuilder: (context, index) {
                final recipe = savedRecipes[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(recipe.imageUrl, width: 80, height: 80, fit: BoxFit.cover),
                    ),
                    title: Text(recipe.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${recipe.category} • ${recipe.cookingTime} min'),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _appState.toggleFavorite(recipe.id);
                        });
                      },
                    ),
                    onTap: () async {
                      await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => RecipeDetailsScreen(recipe: recipe)));
                      setState(() {}); // Refresh list on back
                    },
                  ),
                );
              },
            ),
    );
  }
}
