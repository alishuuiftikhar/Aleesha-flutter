import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../widgets/furniture_card.dart';
import '../models/app_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'Modern';
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<FurnitureItem> filteredItems = AppData.allItems.where((item) {
      final matchesCategory = item.category == selectedCategory;
      final matchesSearch = item.title.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return RefreshIndicator(
      onRefresh: _refreshData,
      color: const Color(0xFFF06292),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                'Interior\nCollections',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF06292),
                  letterSpacing: -1,
                  height: 1.1,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Search furniture...',
                  prefixIcon: const Icon(Icons.search, color: Color(0xFFF06292)),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => searchQuery = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.primaryContainer.withAlpha(25),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildBanner(),
            const SizedBox(height: 25),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: ['Modern', 'Classic', 'Minimal', 'Luxury'].map((cat) => _buildCategoryChip(cat)).toList(),
              ),
            ),
            const SizedBox(height: 20),
            
            AnimationLimiter(
              child: filteredItems.isEmpty
                  ? _buildEmptySearchState()
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          columnCount: 2,
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: FurnitureCard(item: filteredItems[index]),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      height: 160,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?q=80&w=1000'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Limited Edition', style: TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 1)),
            const Text('Exclusive Offer', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF06292),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('View Now'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    bool isSelected = selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = label),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF06292) : Theme.of(context).cardColor,
          boxShadow: isSelected ? [BoxShadow(color: const Color(0xFFF06292).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))] : null,
          border: Border.all(color: isSelected ? const Color(0xFFF06292) : const Color(0xFFFCE4EC).withOpacity(0.5)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          label, 
          style: TextStyle(
            color: isSelected ? Colors.white : (Theme.of(context).brightness == Brightness.dark ? Colors.white70 : const Color(0xFFF06292)), 
            fontWeight: FontWeight.bold
          )
        ),
      ),
    );
  }

  Widget _buildEmptySearchState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 60, color: Colors.pink[100]),
          const SizedBox(height: 10),
          const Text('No items found!', style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}
