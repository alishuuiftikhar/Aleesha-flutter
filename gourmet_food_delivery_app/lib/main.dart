import 'package:flutter/material.dart';

void main() => runApp(const GourmetFoodApp());

class GourmetFoodApp extends StatelessWidget {
  const GourmetFoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gourmet Food Delivery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C5CE7)),
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
      ),
      home: const MainNavScreen(),
    );
  }
}

class CartModel extends ChangeNotifier {
  final List<Map<String, dynamic>> items = [];
  void add(Map<String, dynamic> item) { items.add(item); notifyListeners(); }
  void remove(int index) { items.removeAt(index); notifyListeners(); }
  double get total => items.fold(0, (sum, item) => sum + item['price']);
}
final cart = CartModel();

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});
  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _index = 0;
  final _screens = const [FoodHomeContent(), Center(child: Text('Explore')), Center(child: Text('Orders')), Center(child: Text('Profile'))];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF6C5CE7),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class FoodHomeContent extends StatelessWidget {
  const FoodHomeContent({super.key});

  final List<Map<String, dynamic>> _restaurants = const [
    {
      'name': 'Burger & Co. Deluxe', 'cuisine': 'American • Burgers', 'rating': '4.9', 'time': '15-25 min', 'price': '\$\$',
      'image': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=500&q=80',
    },
    {
      'name': 'Bella Italia Pizzeria', 'cuisine': 'Italian • Pizza', 'rating': '4.8', 'time': '20-30 min', 'price': '\$\$\$',
      'image': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=500&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DELIVER TO', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                    Text('742 Evergreen Terrace', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
                  icon: AnimatedBuilder(
                    animation: cart,
                    builder: (_, __) => Badge(isLabelVisible: cart.items.isNotEmpty, label: Text('${cart.items.length}'), child: const Icon(Icons.shopping_bag_outlined)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search restaurants...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(icon: const Icon(Icons.tune), onPressed: () => _showFilter(context)),
                filled: true, fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Featured Restaurants', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ..._restaurants.map((res) => GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RestaurantDetailScreen(restaurant: res))),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), child: Image.network(res['image']!, height: 140, width: double.infinity, fit: BoxFit.cover)),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(res['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            Text('⭐ ${res['rating']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ]),
                          const SizedBox(height: 4),
                          Text(res['cuisine']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  void _showFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filter Restaurants', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('Price Range: \$ • \$\$ • \$\$\$'),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Apply')),
          ],
        ),
      ),
    );
  }
}

class RestaurantDetailScreen extends StatelessWidget {
  final Map<String, dynamic> restaurant;
  const RestaurantDetailScreen({super.key, required this.restaurant});

  final List<Map<String, dynamic>> menu = const [
    {'name': 'Classic Burger', 'price': 10.99, 'image': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=500&q=80'},
    {'name': 'Cheesy Pizza', 'price': 12.99, 'image': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=500&q=80'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(restaurant['name'])),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: menu.length,
        itemBuilder: (_, i) {
          final item = menu[i];
          return ListTile(
            leading: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(item['image'], width: 50, height: 50, fit: BoxFit.cover)),
            title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('\$${item['price']}'),
            trailing: IconButton(
              icon: const Icon(Icons.add_circle, color: Color(0xFF6C5CE7)),
              onPressed: () {
                cart.add(item);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart!'), duration: Duration(milliseconds: 600)));
              },
            ),
          );
        },
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: AnimatedBuilder(
        animation: cart,
        builder: (_, __) {
          if (cart.items.isEmpty) return const Center(child: Text('Cart is empty'));
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (_, i) => ListTile(
                    title: Text(cart.items[i]['name']),
                    subtitle: Text('\$${cart.items[i]['price']}'),
                    trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => cart.remove(i)),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C5CE7), foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 45)),
                  onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LiveTrackingScreen())),
                  child: Text('Checkout (\$${cart.total.toStringAsFixed(2)})'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class LiveTrackingScreen extends StatelessWidget {
  const LiveTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Tracking')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delivery_dining, size: 80, color: Color(0xFF6C5CE7)),
            SizedBox(height: 16),
            Text('Driver is on the way!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Estimated arrival: 15 mins', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}