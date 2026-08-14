class Recipe {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final int cookingTime; // in minutes
  final String difficulty;
  final List<String> ingredients;
  final List<String> steps;
  final String category;

  final double rating;
  final int calories;
  final String protein;
  final String carbs;
  final String fat;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.cookingTime,
    required this.difficulty,
    required this.ingredients,
    required this.steps,
    required this.category,
    this.rating = 4.5,
    this.calories = 300,
    this.protein = '20g',
    this.carbs = '35g',
    this.fat = '10g',
  });
}
