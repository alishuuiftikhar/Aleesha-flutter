import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/lookbook_model.dart';
import '../theme/app_theme.dart';
import '../widgets/look_card.dart';
import 'look_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  LookbookData? _data;
  List<Look> _filteredLooks = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final String response = await rootBundle.loadString('assets/data/lookbook.json');
    final data = await json.decode(response);
    setState(() {
      _data = LookbookData.fromJson(data);
      _filteredLooks = _data!.featuredLooks;
    });
  }

  void _filterResults() {
    if (_data == null) return;
    setState(() {
      _filteredLooks = _data!.featuredLooks.where((look) {
        final matchesQuery = look.title.toLowerCase().contains(_searchQuery.trim().toLowerCase()) ||
            look.description.toLowerCase().contains(_searchQuery.trim().toLowerCase());
        
        final matchesCategory = _selectedCategory == 'All' || 
            look.category.toLowerCase() == _selectedCategory.toLowerCase();

        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EXPLORE'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(130),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withAlpha(25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for modest styles...',
                      prefixIcon: const Icon(Icons.search, color: AppTheme.primary),
                      filled: true,
                      fillColor: AppTheme.cardBackground,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      _searchQuery = value;
                      _filterResults();
                    },
                  ),
                ),
              ),
              if (_data != null)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      _buildFilterChip('All'),
                      ..._data!.categories.map((cat) => _buildFilterChip(cat)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      body: _data == null
          ? const Center(child: CircularProgressIndicator())
          : _searchQuery.isEmpty && _selectedCategory == 'All'
              ? _buildDiscoveryView()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Text(
                        '${_filteredLooks.length} results for "$_selectedCategory"',
                        style: const TextStyle(
                          color: AppTheme.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: _filteredLooks.isEmpty
                          ? const Center(child: Text('No looks found matching your criteria.'))
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              itemCount: _filteredLooks.length,
                              itemBuilder: (context, index) {
                                final look = _filteredLooks[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 24),
                                  child: LookCard(
                                    look: look,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LookDetailsScreen(
                                            look: look,
                                            allItems: _data!.items,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildDiscoveryView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Discover Collections', style: Theme.of(context).textTheme.headlineMedium),
                TextButton(
                  onPressed: () {},
                  child: const Text('See All', style: TextStyle(color: AppTheme.primary)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _data!.collections.length,
              itemBuilder: (context, index) {
                final col = _data!.collections[index];
                return Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: NetworkImage(col.image),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(Colors.black.withAlpha(51), BlendMode.darken),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      col.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
            child: Text('Popular Looks', style: Theme.of(context).textTheme.headlineMedium),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.65,
            ),
            itemCount: _data!.featuredLooks.length,
            itemBuilder: (context, index) {
              final look = _data!.featuredLooks[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LookDetailsScreen(
                        look: look,
                        allItems: _data!.items,
                      ),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          look.image,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      look.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      look.category,
                      style: TextStyle(color: AppTheme.secondary, fontSize: 12),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedCategory == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = label;
            _filterResults();
          });
        },
        selectedColor: AppTheme.primary.withAlpha(51),
        checkmarkColor: AppTheme.primary,
        labelStyle: TextStyle(
          color: isSelected ? AppTheme.primary : AppTheme.text,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
