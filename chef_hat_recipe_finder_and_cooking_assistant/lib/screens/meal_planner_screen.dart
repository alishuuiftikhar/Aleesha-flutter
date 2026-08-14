import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import 'recipe_details_screen.dart';

class MealPlannerScreen extends StatelessWidget {
  const MealPlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Meal Planner'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: days.length,
        itemBuilder: (context, index) {
          // Assign random recipes for demo
          final breakfast = dummyRecipes[index % dummyRecipes.length];
          final lunch = dummyRecipes[(index + 5) % dummyRecipes.length];
          final dinner = dummyRecipes[(index + 10) % dummyRecipes.length];

          return Container(
            margin: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  days[index],
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                const SizedBox(height: 12),
                _buildMealCard(context, 'Breakfast', breakfast),
                _buildMealCard(context, 'Lunch', lunch),
                _buildMealCard(context, 'Dinner', dinner),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMealCard(BuildContext context, String mealType, dynamic recipe) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => RecipeDetailsScreen(recipe: recipe))),
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(image: NetworkImage(recipe.imageUrl), fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mealType, style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text(recipe.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
