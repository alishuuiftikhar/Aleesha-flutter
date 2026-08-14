import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/plant_data.dart';
import '../models/plant.dart';
import '../services/app_state.dart';
import 'plant_detail_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Indoor', 'Outdoor', 'Succulents', 'Flowers'];

  @override
  Widget build(BuildContext context) {
    final filteredPlants = dummyPlants.where((p) => 
      _selectedCategory == 'All' || p.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            expandedHeight: 120,
            backgroundColor: AppTheme.background,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Good Morning,', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                        Text('Aleesha', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28, height: 1.2)),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen())),
                      icon: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                        ),
                        child: const Icon(Icons.notifications_none_rounded, color: AppTheme.primaryGreen),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildScanBanner(),
                  const SizedBox(height: 30),
                  _buildSectionHeader('Categories'),
                  const SizedBox(height: 15),
                  _buildCategoryList(),
                  const SizedBox(height: 30),
                  _buildSectionHeader('Plant Care Tips'),
                  const SizedBox(height: 15),
                  _buildTipsList(),
                  const SizedBox(height: 30),
                  _buildSectionHeader('Top Picks'),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 0.65,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => PremiumPlantCard(plant: filteredPlants[index]),
                childCount: filteredPlants.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 150)),
        ],
      ),
    );
  }

  Widget _buildScanBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.softGreen,
        borderRadius: BorderRadius.circular(25),
        image: const DecorationImage(
          alignment: Alignment(1.1, 0.0),
          image: NetworkImage('https://images.unsplash.com/photo-1591123120675-6f7f1aae0e5b?auto=format&fit=crop&q=80&w=800'),
          fit: BoxFit.none,
          scale: 10,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Identify your plant', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
          const SizedBox(height: 5),
          const Text('Scan now to get care tips', style: TextStyle(color: AppTheme.primaryGreen)),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
              minimumSize: const Size(120, 40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Scan Now'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 22)),
        TextButton(onPressed: () {}, child: const Text('View All', style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold))),
      ],
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedCategory == _categories[index];
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = _categories[index]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryGreen : Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: isSelected ? AppTheme.primaryGreen : Colors.grey[200]!),
                boxShadow: isSelected ? [BoxShadow(color: AppTheme.primaryGreen.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))] : [],
              ),
              alignment: Alignment.center,
              child: Text(
                _categories[index],
                style: TextStyle(color: isSelected ? Colors.white : Colors.grey[600], fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTipsList() {
    final tips = [
      {'title': 'Watering 101', 'color': const Color(0xFFE8F5E9), 'icon': Icons.water_drop_outlined},
      {'title': 'Sunlight Needs', 'color': const Color(0xFFFFF3E0), 'icon': Icons.wb_sunny_outlined},
      {'title': 'Soil Types', 'color': const Color(0xFFF3E5F5), 'icon': Icons.landscape_outlined},
    ];
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tips.length,
        itemBuilder: (context, index) {
          return Container(
            width: 150,
            margin: const EdgeInsets.only(right: 15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: tips[index]['color'] as Color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(tips[index]['icon'] as IconData, size: 24, color: Colors.black87),
                const SizedBox(height: 8),
                Text(tips[index]['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PremiumPlantCard extends StatelessWidget {
  final Plant plant;
  const PremiumPlantCard({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PlantDetailScreen(plant: plant))),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                    child: Hero(
                      tag: 'plant-${plant.id}',
                      child: Image.network(
                        plant.imageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[100],
                            child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryGreen)),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: AppTheme.softGreen,
                          child: const Center(child: Icon(Icons.broken_image, color: AppTheme.primaryGreen)),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: ListenableBuilder(
                      listenable: AppState(),
                      builder: (context, _) {
                        bool isFav = AppState().isFavorite(plant);
                        return GestureDetector(
                          onTap: () => AppState().toggleFavorite(plant),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                            ),
                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border, 
                              color: isFav ? Colors.red : AppTheme.primaryGreen, 
                              size: 18
                            ),
                          ),
                        );
                      }
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plant.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(plant.species, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(plant.price, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryGreen, fontSize: 15)),
                      GestureDetector(
                        onTap: () {
                          AppState().addToCart(plant);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${plant.name} added to cart!'),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 1),
                            )
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: AppTheme.primaryGreen, borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.add, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
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
