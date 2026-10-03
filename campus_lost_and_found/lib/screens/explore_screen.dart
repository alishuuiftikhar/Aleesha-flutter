import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../models/item.dart';
import '../widgets/item_card.dart';
import 'item_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _searchQuery = '';
  ItemCategory? _selectedCategory;
  ReportType? _selectedType;
  ItemStatus? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Items'),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(),
          Expanded(
            child: Consumer<AppProvider>(
              builder: (context, provider, child) {
                final filteredItems = provider.filterItems(
                  query: _searchQuery,
                  category: _selectedCategory,
                  type: _selectedType,
                  status: _selectedStatus,
                );

                if (filteredItems.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 64, color: AppColors.secondary),
                        SizedBox(height: 16),
                        Text('No items found matching your criteria'),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    return ItemCard(
                      item: filteredItems[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ItemDetailScreen(item: filteredItems[index]),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Search by name, location, etc...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() => _searchQuery = ''),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Type Filter
          _buildFilterChip(
            label: _selectedType == null ? 'All Types' : (_selectedType == ReportType.lost ? 'Lost' : 'Found'),
            isSelected: _selectedType != null,
            onTap: () => _showTypePicker(),
          ),
          const SizedBox(width: 8),
          // Category Filter
          _buildFilterChip(
            label: _selectedCategory == null ? 'All Categories' : _selectedCategory!.name.toUpperCase(),
            isSelected: _selectedCategory != null,
            onTap: () => _showCategoryPicker(),
          ),
          const SizedBox(width: 8),
          // Status Filter
          _buildFilterChip(
            label: _selectedStatus == null ? 'All Status' : _selectedStatus!.name.toUpperCase(),
            isSelected: _selectedStatus != null,
            onTap: () => _showStatusPicker(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({required String label, required bool isSelected, required VoidCallback onTap}) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.text,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  void _showTypePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('All Types'),
                onTap: () {
                  setState(() => _selectedType = null);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Lost Items'),
                onTap: () {
                  setState(() => _selectedType = ReportType.lost);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Found Items'),
                onTap: () {
                  setState(() => _selectedType = ReportType.found);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => ListView(
          controller: scrollController,
          children: [
            ListTile(
              title: const Text('All Categories'),
              onTap: () {
                setState(() => _selectedCategory = null);
                Navigator.pop(context);
              },
            ),
            ...ItemCategory.values.map((cat) => ListTile(
                  title: Text(cat.name.toUpperCase()),
                  onTap: () {
                    setState(() => _selectedCategory = cat);
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showStatusPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('All Status'),
                onTap: () {
                  setState(() => _selectedStatus = null);
                  Navigator.pop(context);
                },
              ),
              ...ItemStatus.values.map((status) => ListTile(
                    title: Text(status.name.toUpperCase()),
                    onTap: () {
                      setState(() => _selectedStatus = status);
                      Navigator.pop(context);
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
