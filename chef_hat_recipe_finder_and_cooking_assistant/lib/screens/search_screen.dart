import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/recipe.dart';
import 'recipe_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Recipe> filteredRecipes = dummyRecipes;

  void _filterRecipes(String query) {
    setState(() {
      filteredRecipes = dummyRecipes
          .where((recipe) =>
              recipe.title.toLowerCase().contains(query.toLowerCase()) ||
              recipe.category.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search Recipes...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onChanged: _filterRecipes,
        ),
      ),
      body: ListView.builder(
        itemCount: filteredRecipes.length,
        itemBuilder: (ctx, index) {
          final recipe = filteredRecipes[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                recipe.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(recipe.title),
            subtitle: Text(recipe.category),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => RecipeDetailsScreen(recipe: recipe),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
