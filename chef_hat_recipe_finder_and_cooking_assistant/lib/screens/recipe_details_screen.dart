import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import 'cooking_session_screen.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailsScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  final _appState = AppState();
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _noteController.text = _appState.recipeNotes[widget.recipe.id] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    bool isFav = _appState.isFavorite(widget.recipe.id);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            stretch: true,
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: AppTheme.primaryNavy,
            actions: [
              CircleAvatar(
                backgroundColor: Colors.black26,
                child: IconButton(
                  icon: const Icon(Icons.share_rounded, color: Colors.white, size: 20),
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Link copied!'))),
                ),
              ),
              const SizedBox(width: 10),
              CircleAvatar(
                backgroundColor: Colors.black26,
                child: IconButton(
                  icon: Icon(isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: isFav ? Colors.red : Colors.white, size: 20),
                  onPressed: () => setState(() => _appState.toggleFavorite(widget.recipe.id)),
                ),
              ),
              const SizedBox(width: 20),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(tag: widget.recipe.id, child: Image.network(widget.recipe.imageUrl, fit: BoxFit.cover)),
                  Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.center, colors: [Colors.black54, Colors.transparent]))),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: AppTheme.accentAmber.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                        child: Text(widget.recipe.category.toUpperCase(), style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1)),
                      ),
                      Row(children: [const Icon(Icons.star_rounded, color: AppTheme.accentAmber, size: 20), const SizedBox(width: 4), Text('${widget.recipe.rating}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(widget.recipe.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppTheme.textDark, height: 1.1)),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _infoCard(Icons.access_time_filled_rounded, '${widget.recipe.cookingTime}m', 'Time'),
                      _infoCard(Icons.local_fire_department_rounded, '${widget.recipe.calories}', 'Kcal'),
                      _infoCard(Icons.restaurant_rounded, widget.recipe.difficulty, 'Level'),
                    ],
                  ),
                  const SizedBox(height: 35),
                  const Text('Nutrition Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
                  const SizedBox(height: 15),
                  _buildNutritionBox(),
                  const SizedBox(height: 35),
                  const Text('About this recipe', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
                  const SizedBox(height: 10),
                  Text(widget.recipe.description, style: TextStyle(fontSize: 15, color: AppTheme.textLight, height: 1.6)),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Ingredients', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
                      TextButton.icon(
                        onPressed: () {
                          for (var i in widget.recipe.ingredients) { _appState.addShoppingItem(i, widget.recipe.category); }
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to Shopping List!')));
                        },
                        icon: const Icon(Icons.add_shopping_cart_rounded, size: 18, color: AppTheme.accentOrange),
                        label: const Text('Add All', style: TextStyle(color: AppTheme.accentOrange, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  ...widget.recipe.ingredients.map((ing) => _ingredientTile(ing)),
                  const SizedBox(height: 35),
                  const Text('Private Chef Notes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _noteController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Add your secret tips or adjustments here...',
                      fillColor: AppTheme.bgSoftWhite,
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                    ),
                    onChanged: (val) => _appState.saveNote(widget.recipe.id, val),
                  ),
                  const SizedBox(height: 35),
                  const Text('Cooking Steps', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
                  const SizedBox(height: 20),
                  ...widget.recipe.steps.asMap().entries.map((e) => _stepTile(e.key + 1, e.value)),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(25, 15, 25, 30),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))]),
        child: ElevatedButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => CookingSessionScreen(recipe: widget.recipe))),
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryNavy, shadowColor: AppTheme.primaryNavy.withOpacity(0.4)),
          child: const Text('START COOKING MODE'),
        ),
      ),
    );
  }

  Widget _buildNutritionBox() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppTheme.bgSoftWhite, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _nutritionCol('Protein', widget.recipe.protein),
          _nutritionCol('Carbs', widget.recipe.carbs),
          _nutritionCol('Fat', widget.recipe.fat),
        ],
      ),
    );
  }

  Widget _nutritionCol(String label, String value) {
    return Column(children: [Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryNavy)), Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textLight))]);
  }

  Widget _infoCard(IconData icon, String value, String label) {
    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(color: AppTheme.bgSoftWhite, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade100)),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.primaryNavy, size: 24),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text(label, style: TextStyle(color: AppTheme.textLight, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _ingredientTile(String ing) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade100)),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8, color: AppTheme.accentOrange),
          const SizedBox(width: 15),
          Expanded(child: Text(ing, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15))),
          IconButton(icon: const Icon(Icons.add_rounded, color: AppTheme.textLight), onPressed: () => _appState.addShoppingItem(ing, widget.recipe.category)),
        ],
      ),
    );
  }

  Widget _stepTile(int num, String step) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$num.', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.accentOrange)),
          const SizedBox(width: 20),
          Expanded(child: Text(step, style: const TextStyle(fontSize: 16, height: 1.6, color: AppTheme.textDark))),
        ],
      ),
    );
  }
}
