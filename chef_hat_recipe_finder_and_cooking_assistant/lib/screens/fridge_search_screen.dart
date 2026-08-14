import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/recipe.dart';
import 'recipe_details_screen.dart';

class FridgeSearchScreen extends StatefulWidget {
  const FridgeSearchScreen({super.key});

  @override
  State<FridgeSearchScreen> createState() => _FridgeSearchScreenState();
}

class _FridgeSearchScreenState extends State<FridgeSearchScreen> {
  final List<String> _allIngredients = [
    'Chicken', 'Tomato', 'Onion', 'Garlic', 'Mushrooms', 'Pasta', 'Cheese', 
    'Bread', 'Eggs', 'Milk', 'Butter', 'Lemon', 'Potatoes', 'Avocado', 'Flour'
  ];
  final List<String> _selectedIngredients = [];

  List<Recipe> get _suggestedRecipes {
    if (_selectedIngredients.isEmpty) return [];
    return dummyRecipes.where((recipe) {
      return _selectedIngredients.any((ing) => 
        recipe.ingredients.any((recipeIng) => recipeIng.toLowerCase().contains(ing.toLowerCase()))
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fridge Search')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.blue.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "What's in your fridge?",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text("Select ingredients you have, and we'll find recipes for you."),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _allIngredients.map((ing) {
                    final isSelected = _selectedIngredients.contains(ing);
                    return FilterChip(
                      label: Text(ing),
                      selected: isSelected,
                      onSelected: (val) {
                        setState(() {
                          if (val) {
                            _selectedIngredients.add(ing);
                          } else {
                            _selectedIngredients.remove(ing);
                          }
                        });
                      },
                      selectedColor: Colors.blue.shade800,
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('Suggested Recipes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: _selectedIngredients.isEmpty
                ? const Center(child: Text('Select ingredients to see suggestions'))
                : ListView.builder(
                    itemCount: _suggestedRecipes.length,
                    itemBuilder: (ctx, index) {
                      final recipe = _suggestedRecipes[index];
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(recipe.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                        ),
                        title: Text(recipe.title),
                        subtitle: Text(recipe.category),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => RecipeDetailsScreen(recipe: recipe))),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
