import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/property_provider.dart';
import '../widgets/property_card.dart';
import '../core/constants.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _searchController = TextEditingController();
  String? _selectedCity;
  double? _minPrice;
  double? _maxPrice;
  int? _bedrooms;
  int? _bathrooms;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<PropertyProvider>().fetchProperties());
  }

  void _applyFilters() {
    context.read<PropertyProvider>().fetchProperties(
      searchQuery: _searchController.text,
      city: _selectedCity,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      minBedrooms: _bedrooms,
      minBathrooms: _bathrooms,
    );
  }

  @override
  Widget build(BuildContext context) {
    final propertyProvider = context.watch<PropertyProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Properties'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => _applyFilters(),
              decoration: InputDecoration(
                hintText: 'Search by title, city or address...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty 
                  ? IconButton(icon: const Icon(Icons.clear), onPressed: () { _searchController.clear(); _applyFilters(); }) 
                  : null,
              ),
            ),
          ),
          Expanded(
            child: propertyProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : propertyProvider.properties.isEmpty
                ? const Center(child: Text('No results found.'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: propertyProvider.properties.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: PropertyCard(property: propertyProvider.properties[index]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Filters', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text('City', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      onChanged: (val) => setSheetState(() => _selectedCity = val),
                      decoration: const InputDecoration(hintText: 'Enter city'),
                    ),
                    const SizedBox(height: 24),
                    const Text('Price Range', style: TextStyle(fontWeight: FontWeight.bold)),
                    RangeSlider(
                      values: RangeValues(_minPrice ?? 0, _maxPrice ?? 1000000),
                      min: 0,
                      max: 1000000,
                      divisions: 100,
                      activeColor: AppColors.primary,
                      inactiveColor: AppColors.secondaryBackground,
                      labels: RangeLabels('\$${(_minPrice ?? 0).toInt()}', '\$${(_maxPrice ?? 1000000).toInt()}'),
                      onChanged: (values) {
                        setSheetState(() {
                          _minPrice = values.start;
                          _maxPrice = values.end;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    const Text('Bedrooms', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(5, (index) {
                        int val = index + 1;
                        bool isSelected = _bedrooms == val;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text('$val+'),
                            selected: isSelected,
                            onSelected: (s) => setSheetState(() => _bedrooms = s ? val : null),
                            selectedColor: AppColors.primary,
                            labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                    const Text('Bathrooms', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(5, (index) {
                        int val = index + 1;
                        bool isSelected = _bathrooms == val;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text('$val+'),
                            selected: isSelected,
                            onSelected: (s) => setSheetState(() => _bathrooms = s ? val : null),
                            selectedColor: AppColors.primary,
                            labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        _applyFilters();
                        Navigator.pop(context);
                      },
                      child: const Text('Apply Filters'),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          setSheetState(() {
                            _selectedCity = null;
                            _minPrice = null;
                            _maxPrice = null;
                            _bedrooms = null;
                            _bathrooms = null;
                          });
                          _applyFilters();
                        },
                        child: const Text('Reset All', style: TextStyle(color: Colors.red)),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
