import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/car_service.dart';
import '../theme/app_colors.dart';
import '../widgets/car_card.dart';
import '../widgets/category_filter.dart';
import 'car_details_screen.dart';
import 'my_bookings_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'Sedan', 'SUV', 'Luxury', 'Sports', 'Electric'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CarService>(context, listen: false).fetchCars();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.secondaryBackground,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.secondaryText,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_rounded), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.book_online_rounded), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildHome();
      case 1:
        return const FavoritesScreen();
      case 2:
        return const MyBookingsScreen();
      case 3:
        return const ProfileScreen();
      default:
        return _buildHome();
    }
  }

  Widget _buildHome() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 120,
          floating: true,
          pinned: true,
          backgroundColor: AppColors.mainBackground,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            title: const Text('Find Your Dream Car', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            background: Container(color: AppColors.mainBackground),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen())),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    return CategoryFilter(
                      label: _categories[index],
                      isSelected: _selectedCategory == _categories[index],
                      onTap: () => setState(() => _selectedCategory = _categories[index]),
                    );
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text('Available Cars', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.mainText)),
              ),
            ],
          ),
        ),
        Consumer<CarService>(
          builder: (context, carService, child) {
            if (carService.isLoading) {
              return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
            }

            final filteredCars = _selectedCategory == 'All'
                ? carService.cars
                : carService.cars.where((car) => car['type'] == _selectedCategory).toList();

            if (filteredCars.isEmpty) {
              return const SliverFillRemaining(child: Center(child: Text('No cars available in this category')));
            }

            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final car = filteredCars[index];
                    return CarCard(
                      car: car,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CarDetailsScreen(car: car)),
                      ),
                    );
                  },
                  childCount: filteredCars.length,
                ),
              ),
            );
          },
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }
}
