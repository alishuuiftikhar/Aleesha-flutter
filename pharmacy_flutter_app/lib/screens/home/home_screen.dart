import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../utils/theme.dart';
import '../../widgets/medicine_card.dart';
import '../../widgets/category_chip.dart';
import '../medicine_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategoryId = 'all';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppProvider>(context, listen: false).loadInitialData();
    });
  }

  void _onSearch(String value) {
    Provider.of<AppProvider>(context, listen: false)
        .fetchMedicines(categoryId: selectedCategoryId, searchQuery: value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacy Store'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: 'Search medicines...',
                prefixIcon: const Icon(Icons.search, color: AppColors.secondaryText),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.secondaryText),
                  onPressed: () {
                    _searchController.clear();
                    _onSearch('');
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: Consumer<AppProvider>(
              builder: (context, provider, child) {
                return ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    CategoryChip(
                      label: 'All',
                      isSelected: selectedCategoryId == 'all',
                      onTap: () {
                        setState(() => selectedCategoryId = 'all');
                        provider.fetchMedicines(categoryId: 'all');
                      },
                    ),
                    ...provider.categories.map((cat) => CategoryChip(
                          label: cat.name,
                          isSelected: selectedCategoryId == cat.id,
                          onTap: () {
                            setState(() => selectedCategoryId = cat.id);
                            provider.fetchMedicines(categoryId: cat.id);
                          },
                        )),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: Consumer<AppProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.medicines.isEmpty) {
                  return const Center(child: Text('No medicines found'));
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: provider.medicines.length,
                  itemBuilder: (context, index) {
                    final medicine = provider.medicines[index];
                    return MedicineCard(
                      medicine: medicine,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MedicineDetailsScreen(medicine: medicine),
                        ),
                      ),
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
}
