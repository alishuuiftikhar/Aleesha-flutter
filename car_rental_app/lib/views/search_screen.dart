import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/car_service.dart';
import '../theme/app_colors.dart';
import '../widgets/car_card.dart';
import 'car_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  double _maxPrice = 1000;
  String? _selectedBrand;
  String? _selectedType;

  final List<String> _brands = ['Tesla', 'BMW', 'Mercedes', 'Audi', 'Porsche', 'Ferrari', 'Lamborghini'];
  final List<String> _types = ['Sedan', 'SUV', 'Luxury', 'Sports', 'Electric'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Cars')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search by car name...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.tune_rounded, color: AppColors.primary),
                  onPressed: () => _showFilterSheet(),
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<CarService>(
              builder: (context, carService, child) {
                final filteredCars = carService.cars.where((car) {
                  final matchesName = car['name'].toString().toLowerCase().contains(_searchController.text.toLowerCase());
                  final matchesBrand = _selectedBrand == null || car['brand'] == _selectedBrand;
                  final matchesType = _selectedType == null || car['type'] == _selectedType;
                  final matchesPrice = (car['price_per_day'] as int) <= _maxPrice;
                  return matchesName && matchesBrand && matchesType && matchesPrice;
                }).toList();

                if (filteredCars.isEmpty) {
                  return const Center(child: Text('No cars found matching your criteria'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredCars.length,
                  itemBuilder: (context, index) {
                    final car = filteredCars[index];
                    return CarCard(
                      car: car,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CarDetailsScreen(car: car))),
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

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.secondaryBackground,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Filters', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  const Text('Max Price per Day', style: TextStyle(fontWeight: FontWeight.bold)),
                  Slider(
                    value: _maxPrice,
                    min: 50,
                    max: 2000,
                    divisions: 39,
                    label: '\$${_maxPrice.round()}',
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setModalState(() => _maxPrice = val);
                      setState(() => _maxPrice = val);
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('Brand', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _brands.map((brand) {
                        final isSelected = _selectedBrand == brand;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(brand),
                            selected: isSelected,
                            onSelected: (val) {
                              setModalState(() => _selectedBrand = val ? brand : null);
                              setState(() => _selectedBrand = val ? brand : null);
                            },
                            selectedColor: AppColors.primary,
                            labelStyle: TextStyle(color: isSelected ? AppColors.mainBackground : AppColors.mainText),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Type', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _types.map((type) {
                        final isSelected = _selectedType == type;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(type),
                            selected: isSelected,
                            onSelected: (val) {
                              setModalState(() => _selectedType = val ? type : null);
                              setState(() => _selectedType = val ? type : null);
                            },
                            selectedColor: AppColors.primary,
                            labelStyle: TextStyle(color: isSelected ? AppColors.mainBackground : AppColors.mainText),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                    child: const Text('APPLY FILTERS'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
