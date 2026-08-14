import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import 'order_success_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            backgroundColor: AppTheme.background,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
                child: Text('My Cart', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 32)),
              ),
            ),
          ),
          ListenableBuilder(
            listenable: AppState(),
            builder: (context, child) {
              final cartItems = AppState().cart;
              if (cartItems.isEmpty) {
                return const SliverFillRemaining(child: _EmptyCartState());
              }
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final plant = cartItems[index];
                      return _CartItem(plant: plant);
                    },
                    childCount: cartItems.length,
                  ),
                ),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 250)),
        ],
      ),
      bottomSheet: ListenableBuilder(
        listenable: AppState(),
        builder: (context, _) {
          if (AppState().cart.isEmpty) return const SizedBox.shrink();
          return _CheckoutSection(context: context);
        }
      ),
    );
  }
}

class _EmptyCartState extends StatelessWidget {
  const _EmptyCartState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 20),
          const Text('Your cart is empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey)),
        ],
      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  final dynamic plant;
  const _CartItem({required this.plant});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              plant.imageUrl, 
              width: 80, 
              height: 80, 
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(width: 80, height: 80, color: Colors.grey[100], child: const Center(child: CircularProgressIndicator(strokeWidth: 2)));
              },
              errorBuilder: (context, error, stackTrace) => Container(width: 80, height: 80, color: AppTheme.softGreen, child: const Icon(Icons.broken_image)),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plant.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                const SizedBox(height: 4),
                Text(plant.price, style: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
          IconButton(
            onPressed: () => AppState().removeFromCart(plant),
            icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}

class _CheckoutSection extends StatelessWidget {
  final BuildContext context;
  const _CheckoutSection({required this.context});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 25, 25, 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Amount', style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500)),
              Text(
                '\$${AppState().totalCartPrice.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
              ),
            ],
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () {
              AppState().cart.clear();
              Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderSuccessScreen()));
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text('Checkout Now', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
