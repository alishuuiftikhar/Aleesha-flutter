import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/travel_provider.dart';
import '../theme.dart';
import '../models/destination.dart';
import 'destination_details_screen.dart';
import 'package:travel_booking_flutter_app/screens/package_details_screen.dart';
import '../models/travel_package.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TravelProvider>(context);
    List<Destination> destinations = provider.searchDestinations(_searchQuery);

    if (_selectedCategory != 'All') {
      destinations = destinations.where((d) => d.category == _selectedCategory).toList();
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildHeader(),
              const SizedBox(height: 25),
              _buildSearchBox(),
              const SizedBox(height: 25),
              _buildCategories(provider.categories),
              const SizedBox(height: 25),
              _buildSectionTitle('Popular Destinations'),
              const SizedBox(height: 15),
              _buildDestinationsList(destinations),
              const SizedBox(height: 25),
              _buildSectionTitle('Travel Packages'),
              const SizedBox(height: 15),
              _buildPackagesList(provider.packages),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Explorer,',
              style: TextStyle(color: TravelTheme.textSecondary, fontSize: 16),
            ),
            Text(
              'Discover Beauty',
              style: TextStyle(
                color: TravelTheme.textMain,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        CircleAvatar(
          backgroundColor: TravelTheme.accent,
          radius: 25,
          child: const Icon(Icons.person, color: TravelTheme.bgMain),
        ),
      ],
    );
  }

  Widget _buildSearchBox() {
    return Container(
      decoration: BoxDecoration(
        color: TravelTheme.bgSecondary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: TravelTheme.textMain),
        decoration: InputDecoration(
          hintText: 'Search destinations...',
          hintStyle: TextStyle(color: TravelTheme.textSecondary.withOpacity(0.5)),
          prefixIcon: const Icon(Icons.search, color: TravelTheme.primary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
        onChanged: (value) {
          setState(() => _searchQuery = value);
        },
      ),
    );
  }

  Widget _buildCategories(List<Map<String, dynamic>> categories) {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = _selectedCategory == cat['name'];
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat['name']),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? TravelTheme.secondary : TravelTheme.bgSecondary,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                cat['name'],
                style: TextStyle(
                  color: isSelected ? TravelTheme.bgMain : TravelTheme.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: TravelTheme.textMain,
          ),
        ),
        Text(
          'See all',
          style: TextStyle(color: TravelTheme.primary, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildDestinationsList(List<Destination> destinations) {
    if (destinations.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text('No destinations found'),
        ),
      );
    }
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: destinations.length,
        itemBuilder: (context, index) {
          final dest = destinations[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DestinationDetailsScreen(destination: dest)),
            ),
            child: Container(
              width: 200,
              margin: const EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                color: TravelTheme.cardBg,
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(dest.imageUrl),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Consumer<TravelProvider>(
                      builder: (context, provider, _) {
                        final isFav = provider.isFavorite(dest.id);
                        return IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.white,
                          ),
                          onPressed: () => provider.toggleFavorite(dest),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    left: 15,
                    right: 15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dest.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: TravelTheme.accent, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              dest.location,
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
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
        },
      ),
    );
  }

  Widget _buildPackagesList(List<TravelPackage> packages) {
    return Column(
      children: packages.map((pkg) {
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PackageDetailsScreen(package: pkg)),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: TravelTheme.bgSecondary,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    pkg.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pkg.name,
                        style: const TextStyle(
                          color: TravelTheme.textMain,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${pkg.durationDays} Days • \$${pkg.pricePerPerson}',
                        style: const TextStyle(color: TravelTheme.accent, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: TravelTheme.textSecondary, size: 16),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
