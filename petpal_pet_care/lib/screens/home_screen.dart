import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import '../theme_constants.dart';
import '../widgets/pet_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PetProvider>();
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Welcome back,', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            Text(
              provider.userName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: AppColors.surface, 
              shape: BoxShape.circle, 
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications_none, color: AppColors.primary), 
              onPressed: () {}
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Search
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: TextField(
                onChanged: (value) => context.read<PetProvider>().setSearchQuery(value),
                decoration: const InputDecoration(
                  hintText: 'Search your favorite pet...',
                  icon: Icon(Icons.search, color: AppColors.primary),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 25),
            
            // Banner
            Container(
              height: 160,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary], 
                  begin: Alignment.topLeft, 
                  end: Alignment.bottomRight
                ),
                borderRadius: BorderRadius.circular(30),
                image: const DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1548191265-cc70d3d45ba1?q=80&w=600'),
                  fit: BoxFit.cover,
                  opacity: 0.3,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Adopt Pets',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)
                  ),
                  SizedBox(height: 8),
                  Text(
                    '100+ pets are waiting for you!', 
                    style: TextStyle(color: Colors.white, fontSize: 14)
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Categories
            const Text('Categories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildCategoryChip(context, 'All Pets', provider.selectedCategory == 'All Pets', Icons.grid_view),
                  _buildCategoryChip(context, 'Dogs', provider.selectedCategory == 'Dogs', Icons.pets),
                  _buildCategoryChip(context, 'Cats', provider.selectedCategory == 'Cats', Icons.wb_sunny_outlined),
                  _buildCategoryChip(context, 'Birds', provider.selectedCategory == 'Birds', Icons.flutter_dash),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Pets Grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  provider.selectedCategory,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                TextButton(onPressed: () {}, child: const Text('View All', style: TextStyle(color: AppColors.primary))),
              ],
            ),
            const SizedBox(height: 10),

            provider.filteredPets.isEmpty 
              ? const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('No pets found.')))
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.05, // Compact ratio
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: provider.filteredPets.length,
                  itemBuilder: (context, index) => PetCard(pet: provider.filteredPets[index]),
                ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext context, String label, bool isSelected, IconData icon) {
    return GestureDetector(
      onTap: () => context.read<PetProvider>().setCategory(label),
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isSelected ? AppColors.primary.withOpacity(0.3) : Colors.black.withOpacity(0.05), 
              blurRadius: 10
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: isSelected ? Colors.white : AppColors.primary),
            const SizedBox(width: 8),
            Text(
              label, 
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary, 
                fontWeight: FontWeight.bold
              )
            ),
          ],
        ),
      ),
    );
  }
}
