import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../widgets/food_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // For now, this is static, but in a real app, this would come from a provider
    final List<FoodItem> favoriteItems = const [
      FoodItem(
        id: '1',
        title: 'Double Cheeseburger',
        description: 'Juicy beef patty with melted cheddar, fresh lettuce, and our secret special sauce on a toasted bun.',
        price: 'Rs. 1,500',
        rating: 4.9,
        imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&q=80&w=600',
        category: 'Burger',
        waitTime: '20-30 min',
        isFavorite: true,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
      ),
      body: favoriteItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 100, color: Colors.grey[300]),
                  const SizedBox(height: 20),
                  const Text('No favorites yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: FoodCard(foodItem: favoriteItems[index]),
                );
              },
            ),
    );
  }
}
