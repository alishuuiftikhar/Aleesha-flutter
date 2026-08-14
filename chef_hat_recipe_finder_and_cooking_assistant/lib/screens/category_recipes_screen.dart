import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/recipe.dart';
import 'recipe_details_screen.dart';

class CategoryRecipesScreen extends StatelessWidget {
  final String category;
  const CategoryRecipesScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final recipes = category == 'All' || category == 'Discover Recipes' || category == 'Trending Now 🔥'
        ? dummyRecipes
        : dummyRecipes.where((r) => r.category == category).toList();

    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: recipes.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemBuilder: (ctx, index) {
          final recipe = recipes[index];
          return GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => RecipeDetailsScreen(recipe: recipe))),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Image.network(recipe.imageUrl, width: double.infinity, fit: BoxFit.cover)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(recipe.title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(recipe.category, style: TextStyle(color: Colors.blue.shade800, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
