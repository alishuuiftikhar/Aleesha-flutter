import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/recipe.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import 'recipe_details_screen.dart';
import 'search_screen.dart';
import 'profile_screen.dart';
import 'notifications_screen.dart';
import 'saved_recipes_screen.dart';
import 'category_recipes_screen.dart';
import 'shopping_list_screen.dart';
import 'meal_planner_screen.dart';
import 'fridge_search_screen.dart';
import 'community_feed_screen.dart';
import 'achievements_screen.dart';
import 'unit_converter_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _pages = [
    const HomeContent(),
    const SearchScreen(),
    const CommunityFeedScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: AppTheme.accentOrange,
          unselectedItemColor: AppTheme.textLight,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          elevation: 0,
          backgroundColor: Colors.white,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.auto_awesome_mosaic_rounded), label: 'Feed'),
            BottomNavigationBarItem(icon: Icon(Icons.person_2_rounded), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final appState = AppState();
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
            color: AppTheme.primaryNavy,
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage('https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80'),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Chef Aleesha', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Level: ${appState.chefLevel}', style: TextStyle(color: AppTheme.accentAmber.withOpacity(0.8), fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _drawerItem(Icons.calendar_today_rounded, 'Meal Planner', () => _navTo(context, const MealPlannerScreen())),
          _drawerItem(Icons.kitchen_rounded, 'Fridge Explorer', () => _navTo(context, const FridgeSearchScreen())),
          _drawerItem(Icons.shopping_basket_rounded, 'Shopping List', () => _navTo(context, const ShoppingListScreen())),
          _drawerItem(Icons.calculate_outlined, 'Kitchen Tools', () => _navTo(context, const UnitConverterScreen())),
          _drawerItem(Icons.emoji_events_rounded, 'Achievements', () => _navTo(context, const AchievementsScreen())),
          const Divider(indent: 20, endIndent: 20, height: 40),
          _drawerItem(Icons.favorite_rounded, 'Saved Recipes', () => _navTo(context, const SavedRecipesScreen())),
          _drawerItem(Icons.star_rounded, 'Go Premium', () => {}),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('Chef Hat v2.1.0', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryNavy, size: 22),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 25),
    );
  }

  void _navTo(BuildContext context, Widget screen) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (ctx) => screen));
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String selectedCategory = 'All';
  final _appState = AppState();
  
  final List<String> categoriesList = ['All', 'Breakfast', 'Lunch', 'Dinner', 'Indian', 'Italian', 'Healthy', 'Desserts'];

  @override
  Widget build(BuildContext context) {
    final trending = dummyRecipes.where((r) => r.rating >= 4.9).toList();
    final filtered = selectedCategory == 'All' ? dummyRecipes : dummyRecipes.where((r) => r.category == selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppTheme.bgSoftWhite,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildQuickActions(context),
                _buildXPProgress(),
                _buildSectionHeader('Popular Categories', null),
                _buildCategories(),
                _buildSectionHeader('Top Rated Recipes ✨', () => _navToCategory('Trending Now 🔥')),
                _buildTrendingList(trending),
                _buildSectionHeader(selectedCategory == 'All' ? 'Discover Something New' : '$selectedCategory Specials', () => _navToCategory(selectedCategory)),
                _buildVerticalGrid(filtered),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 180,
      floating: false,
      pinned: true,
      backgroundColor: AppTheme.primaryNavy,
      elevation: 0,
      leading: Builder(builder: (context) => IconButton(icon: const Icon(Icons.menu_rounded, color: Colors.white), onPressed: () => Scaffold.of(context).openDrawer())),
      actions: [
        IconButton(icon: const Icon(Icons.notifications_none_rounded, color: Colors.white), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const NotificationsScreen()))),
        const SizedBox(width: 10),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            Positioned.fill(child: Container(color: AppTheme.primaryNavy)),
            Positioned(right: -50, top: -50, child: CircleAvatar(radius: 100, backgroundColor: Colors.white.withOpacity(0.05))),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Healthy & Tasty', style: TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.5)),
                  const Text('Chef Aleesha,', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
                  Text('Ready to cook today?', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Transform.translate(
          offset: const Offset(0, 30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const SearchScreen())),
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppTheme.softShadow,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, color: AppTheme.primaryNavy),
                    const SizedBox(width: 15),
                    Text('Search for recipes, ingredients...', style: TextStyle(color: Colors.grey.shade400, fontSize: 15)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildXPProgress() {
    double progress = (_appState.userXP % 1000) / 1000;
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryNavy,
        borderRadius: BorderRadius.circular(25),
        boxShadow: AppTheme.intenseShadow,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Experience Progress', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text('${_appState.userXP} XP', style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 15),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white12,
            color: AppTheme.accentAmber,
            minHeight: 8,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 10),
          Text(
            'Keep cooking to reach Executive Chef!', 
            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback? onSeeAll) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 45, 20, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              child: const Text('See All', style: TextStyle(color: AppTheme.accentOrange, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _quickActionItem(context, Icons.kitchen_rounded, 'Fridge', AppTheme.bgSoftWhite, () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const FridgeSearchScreen()))),
          _quickActionItem(context, Icons.calendar_month_rounded, 'Planner', AppTheme.bgSoftWhite, () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const MealPlannerScreen()))),
          _quickActionItem(context, Icons.shopping_bag_rounded, 'Cart', AppTheme.bgSoftWhite, () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const ShoppingListScreen()))),
          _quickActionItem(context, Icons.emoji_events_rounded, 'Awards', AppTheme.bgSoftWhite, () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const AchievementsScreen()))),
        ],
      ),
    );
  }

  Widget _quickActionItem(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), boxShadow: AppTheme.softShadow),
            child: Icon(icon, color: AppTheme.primaryNavy, size: 28),
          ),
        ),
        const SizedBox(height: 10),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
      ],
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categoriesList.length,
        itemBuilder: (ctx, index) {
          final cat = categoriesList[index];
          final selected = selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ChoiceChip(
              label: Text(cat),
              selected: selected,
              onSelected: (val) => setState(() => selectedCategory = cat),
              selectedColor: AppTheme.primaryNavy,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(color: selected ? Colors.white : AppTheme.textDark, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              side: BorderSide(color: selected ? AppTheme.primaryNavy : Colors.grey.shade100),
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrendingList(List<Recipe> recipes) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: recipes.length,
        itemBuilder: (ctx, index) {
          final recipe = recipes[index];
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => RecipeDetailsScreen(recipe: recipe))),
            child: Container(
              width: 240,
              margin: const EdgeInsets.only(right: 16, bottom: 20),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(32), boxShadow: AppTheme.softShadow),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Stack(
                  children: [
                    Image.network(recipe.imageUrl, width: double.infinity, height: double.infinity, fit: BoxFit.cover),
                    Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.8)]))),
                    Positioned(
                      top: 15,
                      right: 15,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                        child: Row(children: [const Icon(Icons.star_rounded, color: AppTheme.accentAmber, size: 18), const SizedBox(width: 4), Text('${recipe.rating}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(recipe.category.toUpperCase(), style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1.5)),
                          const SizedBox(height: 5),
                          Text(recipe.title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, height: 1.2)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVerticalGrid(List<Recipe> recipes) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: recipes.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemBuilder: (ctx, index) {
          final recipe = recipes[index];
          final isFav = _appState.isFavorite(recipe.id);
          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => RecipeDetailsScreen(recipe: recipe)));
              setState(() {});
            },
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28), boxShadow: AppTheme.softShadow),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(28)), child: Image.network(recipe.imageUrl, width: double.infinity, height: double.infinity, fit: BoxFit.cover)),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: GestureDetector(
                            onTap: () => setState(() => _appState.toggleFavorite(recipe.id)),
                            child: CircleAvatar(radius: 16, backgroundColor: Colors.white.withOpacity(0.9), child: Icon(isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded, size: 18, color: Colors.red)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(recipe.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textDark), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.access_time_filled_rounded, size: 14, color: AppTheme.accentOrange),
                            const SizedBox(width: 5),
                            Text('${recipe.cookingTime}m', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textLight)),
                            const Spacer(),
                            Text('${recipe.calories} kcal', style: TextStyle(fontSize: 11, color: AppTheme.textLight.withOpacity(0.7))),
                          ],
                        ),
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

  void _navToCategory(String cat) {
    Navigator.push(context, MaterialPageRoute(builder: (ctx) => CategoryRecipesScreen(category: cat)));
  }
}
