import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../models/inspiration.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';
import '../widgets/inspiration_card.dart';
import 'favorites_screen.dart';
import 'moodboard_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  InspirationCategory? selectedCategory;
  String searchQuery = '';
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    
    List<InspirationItem> filteredItems = provider.items.where((item) {
      final matchesCategory = selectedCategory == null || item.category == selectedCategory;
      final matchesSearch = item.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          item.tags.any((tag) => tag.toLowerCase().contains(searchQuery.toLowerCase()));
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Design Board'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearch(context),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: _selectedIndex == 0 
          ? _buildHomeBody(filteredItems)
          : _selectedIndex == 1 
              ? const FavoritesScreen()
              : const MoodboardScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textLight,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_customize), label: 'Moodboards'),
        ],
      ),
    );
  }

  Widget _buildHomeBody(List<InspirationItem> items) {
    return Column(
      children: [
        _buildCategoryFilter(),
        Expanded(
          child: items.isEmpty
              ? const Center(child: Text('No results found'))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: MasonryGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return InspirationCard(item: items[index]);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _categoryChip(null, 'All'),
          ...InspirationCategory.values.map((cat) {
            String label = cat.toString().split('.').last.replaceAllMapped(
                RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}');
            return _categoryChip(cat, label[0].toUpperCase() + label.substring(1));
          }),
        ],
      ),
    );
  }

  Widget _categoryChip(InspirationCategory? category, String label) {
    bool isSelected = selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (val) => setState(() => selectedCategory = val ? category : null),
        selectedColor: AppColors.primary.withOpacity(0.2),
        checkmarkColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.text,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  void _showSearch(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: AppColors.mainBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search inspiration...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                filled: true,
                fillColor: AppColors.cardBackground,
              ),
              onChanged: (val) => setState(() => searchQuery = val),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  const Text('Recent Searches', style: TextStyle(fontWeight: FontWeight.bold)),
                  const ListTile(title: Text('Minimalist Interior')),
                  const ListTile(title: Text('UI Design')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.mainBackground,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.secondary,
                  child: Icon(Icons.person, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 10),
                Text(
                  'Creative Mind',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                Text(
                  'design.lover@example.com',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('My Themes'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.cloud_upload),
            title: const Text('Upload Inspiration'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Feedback'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
