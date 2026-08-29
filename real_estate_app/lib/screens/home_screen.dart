import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/property_provider.dart';
import '../providers/auth_provider.dart';
import '../core/constants.dart';
import '../widgets/property_card.dart';
import '../widgets/category_selector.dart';
import 'explore_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedType = 'Buy';
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    // Use a small delay to ensure provider is ready
    Future.delayed(Duration.zero, () {
       if (mounted) {
         context.read<PropertyProvider>().fetchProperties(type: _selectedType, category: _selectedCategory == 'All' ? null : _selectedCategory);
       }
    });
  }

  void _onTypeChanged(String type) {
    setState(() => _selectedType = type);
    context.read<PropertyProvider>().fetchProperties(type: _selectedType, category: _selectedCategory == 'All' ? null : _selectedCategory);
  }

  void _onCategoryChanged(String category) {
    setState(() => _selectedCategory = category);
    context.read<PropertyProvider>().fetchProperties(type: _selectedType, category: _selectedCategory == 'All' ? null : _selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final propertyProvider = context.watch<PropertyProvider>();
    final properties = propertyProvider.properties;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => propertyProvider.fetchProperties(type: _selectedType, category: _selectedCategory == 'All' ? null : _selectedCategory),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Find your dream',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
                              ),
                              Text(
                                'Property Today',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: AppColors.secondaryBackground,
                            backgroundImage: authProvider.profile?.avatarUrl != null 
                              ? NetworkImage(authProvider.profile!.avatarUrl!) 
                              : null,
                            child: authProvider.profile?.avatarUrl == null 
                              ? const Icon(Icons.person, color: AppColors.primary) 
                              : null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExploreScreen())),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search, color: Colors.grey),
                              const SizedBox(width: 12),
                              Text('Search properties...', style: TextStyle(color: Colors.grey[400])),
                              const Spacer(),
                              const Icon(Icons.tune, color: AppColors.primary),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          _buildTypeButton('Buy'),
                          const SizedBox(width: 12),
                          _buildTypeButton('Rent'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      CategorySelector(
                        selectedCategory: _selectedCategory,
                        onCategoryChanged: _onCategoryChanged,
                      ),
                      const SizedBox(height: 24),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Featured Properties', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (propertyProvider.isLoading && properties.isEmpty)
                const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
              else if (properties.isEmpty)
                const SliverFillRemaining(child: Center(child: Text('No properties found.')))
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: PropertyCard(property: properties[index]),
                      ),
                      childCount: properties.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeButton(String type) {
    bool isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => _onTypeChanged(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.primary : Colors.grey[300]!),
        ),
        child: Text(
          type,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
