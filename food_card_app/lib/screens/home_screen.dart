import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:google_fonts/google_fonts.dart';
import '../models/food_item.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/food_card.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  final List<String> categories = ['All', 'Burger', 'Pizza', 'Wrap', 'Drinks'];

  final List<FoodItem> foodList = const [
    FoodItem(
      id: '1',
      title: 'Double Cheeseburger',
      description: 'Juicy beef patty with melted cheddar, fresh lettuce, and our secret special sauce on a toasted bun.',
      price: 'Rs. 1,500',
      rating: 4.9,
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&q=80&w=600',
      category: 'Burger',
      waitTime: '20-30 min',
    ),
    FoodItem(
      id: '2',
      title: 'Pepperoni Pizza',
      description: 'Classic pepperoni with gooey mozzarella cheese and our signature tomato sauce on a hand-tossed crust.',
      price: 'Rs. 2,200',
      rating: 4.8,
      imageUrl: 'https://images.unsplash.com/photo-1534308983496-4fabb1a015ee?auto=format&fit=crop&q=80&w=600',
      category: 'Pizza',
      waitTime: '30-40 min',
    ),
    FoodItem(
      id: '3',
      title: 'Crispy Chicken Wrap',
      description: 'Golden fried chicken strips, fresh lettuce, and creamy mayonnaise wrapped in a soft warm tortilla.',
      price: 'Rs. 950',
      rating: 4.7,
      imageUrl: 'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?auto=format&fit=crop&q=80&w=600',
      category: 'Wrap',
      waitTime: '15-20 min',
    ),
    FoodItem(
      id: '4',
      title: 'Hawaiian Pizza',
      description: 'Tropical pineapple and savory ham with lots of mozzarella cheese.',
      price: 'Rs. 1,800',
      rating: 4.5,
      imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&q=80&w=600',
      category: 'Pizza',
      waitTime: '35-45 min',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredList = selectedCategory == 'All'
        ? foodList
        : foodList.where((item) => item.category == selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        title: Column(
          children: [
            Text('Deliver to', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on, size: 14, color: AppTheme.primaryColor),
                Text(' Colombo, LK', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Consumer<CartProvider>(
              builder: (context, cart, child) => badges.Badge(
                position: badges.BadgePosition.topEnd(top: 0, end: 3),
                badgeContent: Text(
                  cart.itemCount.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
                showBadge: cart.itemCount > 0,
                child: IconButton(
                  icon: const Icon(Icons.shopping_bag_outlined),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'What would you like\nto eat today?',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 25),
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: 'Search for food...',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Categories
            SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      selectedColor: AppTheme.primaryColor,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      showCheckmark: false,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 25),
            // Food Grid/List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: FoodCard(foodItem: filteredList[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
