import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../models/app_data.dart';
import '../widgets/furniture_card.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            'Saved Designs',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFFF06292)),
          ),
          const Text('Your wishlist updated in real-time', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          AppData.wishlist.isEmpty
              ? Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(30),
                          decoration: const BoxDecoration(color: Color(0xFFFFF1F5), shape: BoxShape.circle),
                          child: const Icon(Icons.favorite_rounded, size: 60, color: Color(0xFFF06292)),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Your wishlist is empty', 
                          style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w500)
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Add items you love to see them here!', 
                          style: TextStyle(color: Colors.grey, fontSize: 14)
                        ),
                      ],
                    ),
                  ),
                )
              : Expanded(
                  child: AnimationLimiter(
                    // Key helps Flutter identify when the list changes
                    key: ValueKey(AppData.wishlist.length),
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: AppData.wishlist.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          columnCount: 2,
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: FurnitureCard(
                                item: AppData.wishlist[index],
                                onWishlistChanged: () {
                                  setState(() {}); // Refresh list when item is un-hearted
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
