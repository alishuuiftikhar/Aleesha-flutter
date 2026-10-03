import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/astronomy_object.dart';
import '../services/astronomy_provider.dart';
import '../utils/constants.dart';
import 'object_details_screen.dart';
import 'compare_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  final List<String> _categories = [
    'All', 'Favorites', 'Recent', 'Planets', 'Stars', 'Galaxies', 'Constellations', 'Moons', 'Space Missions'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EXPLORE UNIVERSE'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search planets, stars, missions...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                    filled: true,
                    fillColor: AppColors.secondaryBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),
              TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: AppColors.accent,
                labelColor: AppColors.accent,
                unselectedLabelColor: Colors.white70,
                tabs: _categories.map((c) => Tab(text: c)).toList(),
                onTap: (_) => setState(() {}),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.compare_arrows),
            tooltip: 'Compare Objects',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CompareScreen())),
          ),
        ],
      ),
      body: Consumer<AstronomyProvider>(
        builder: (context, provider, child) {
          final selectedCategory = _categories[_tabController.index];
          
          final filteredList = provider.objects.where((obj) {
            bool matchesCategory = false;
            if (selectedCategory == 'All') {
              matchesCategory = true;
            } else if (selectedCategory == 'Favorites') {
              matchesCategory = obj.isFavorite;
            } else if (selectedCategory == 'Recent') {
              matchesCategory = obj.lastViewed != null;
            } else {
              matchesCategory = obj.category == selectedCategory;
            }

            final matchesSearch = obj.name.toLowerCase().contains(_searchQuery) || 
                                 obj.description.toLowerCase().contains(_searchQuery) ||
                                 obj.category.toLowerCase().contains(_searchQuery);
            return matchesCategory && matchesSearch;
          }).toList();

          if (filteredList.isEmpty) {
            return const Center(child: Text('No objects found.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              final obj = filteredList[index];
              return _buildObjectCard(context, obj);
            },
          );
        },
      ),
    );
  }

  Widget _buildObjectCard(BuildContext context, AstronomyObject obj) {
    return GestureDetector(
      onTap: () {
        Provider.of<AstronomyProvider>(context, listen: false).addToRecentlyViewed(obj);
        Navigator.push(context, MaterialPageRoute(builder: (_) => ObjectDetailsScreen(object: obj)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Hero(
                  tag: 'img_${obj.id}',
                  child: Image.network(
                    obj.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    obj.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    obj.category,
                    style: const TextStyle(color: AppColors.primary, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
