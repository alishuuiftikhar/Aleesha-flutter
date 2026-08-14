import 'package:flutter/material.dart';
import '../services/app_state.dart';
import 'recipe_details_screen.dart';

class CookingHistoryScreen extends StatelessWidget {
  const CookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = AppState().cookedHistoryRecipes;

    return Scaffold(
      appBar: AppBar(title: const Text('Cooking History')),
      body: history.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text('No history yet!', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  const Text('Complete a cooking session to see it here.', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final recipe = history[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(recipe.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                    ),
                    title: Text(recipe.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Cooked successfully! 🎉'),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => RecipeDetailsScreen(recipe: recipe))),
                  ),
                );
              },
            ),
    );
  }
}
