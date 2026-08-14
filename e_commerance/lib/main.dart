import 'package:flutter/material.dart';

void main() => runApp(const FoodApp());

class FoodApp extends StatelessWidget {
  const FoodApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple, primary: Colors.purple, secondary: Colors.pink),
        scaffoldBackgroundColor: const Color(0xFFFCE4EC), // Beautiful soft pink background
      ),
      home: const HomeScreen(),
    );
  }
}

class Product {
  final String name, image;
  final double basePrice;
  final bool isPizza;
  Product({required this.name, required this.image, required this.basePrice, this.isPizza = false});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Product> products = [
    Product(name: 'Special Chicken Pizza', image: '🍕', basePrice: 12.0, isPizza: true),
    Product(name: 'Cheese Burger', image: '🍔', basePrice: 6.5),
    Product(name: 'Crispy French Fries', image: '🍟', basePrice: 4.0),
    Product(name: 'Club Sandwich', image: '🥪', basePrice: 5.5),
    Product(name: 'Chocolate Lava Cake', image: '🍰', basePrice: 4.5),
  ];

  final Map<int, int> cart = {};
  final Map<int, String> pizzaSizes = {};
  final TextEditingController nameCtrl = TextEditingController();
  String payment = 'Cash on Delivery';

  double getPrice(Product p, int idx) {
    if (!p.isPizza) return p.basePrice;
    String sz = pizzaSizes[idx] ?? 'Medium';
    return sz == 'Small' ? 10.0 : (sz == 'Large' ? 15.0 : 12.0);
  }

  double get total {
    double sum = 0;
    cart.forEach((idx, qty) => sum += qty > 0 ? getPrice(products[idx], idx) * qty : 0);
    return sum;
  }

  void placeOrder() {
    if (nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter your name first!')));
      return;
    }
    if (total == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Your cart is empty!')));
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: const Color(0xFFFFF1F5),
        title: const Icon(Icons.stars, color: Colors.pink, size: 60),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Order Confirmed! 🎉', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.purple)),
            const SizedBox(height: 12),
            Text('Thank you, ${nameCtrl.text}!\nYour order has been received successfully.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Total Bill: \$${total.toStringAsFixed(2)}\nPayment: $payment',
                textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() { cart.clear(); nameCtrl.clear(); });
              Navigator.pop(context);
            },
            child: const Text('OK', style: TextStyle(color: Colors.pink, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aleesha Foodie Express 🌸', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.purple,
        centerTitle: true,
        elevation: 4,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Choose From Our Delicious Menu:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple)),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length,
                itemBuilder: (context, idx) {
                  final p = products[idx];
                  final qty = cart[idx] ?? 0;
                  final size = pizzaSizes[idx] ?? 'Medium';
                  final currentPrice = getPrice(p, idx);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    elevation: 2,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Text(p.image, style: const TextStyle(fontSize: 40)),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple)),
                                Text('\$${currentPrice.toStringAsFixed(2)}', style: const TextStyle(color: Colors.pink, fontWeight: FontWeight.bold, fontSize: 15)),
                                if (p.isPizza) ...[
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      {'s': 'Small', 'p': '\$10'},
                                      {'s': 'Medium', 'p': '\$12'},
                                      {'s': 'Large', 'p': '\$15'}
                                    ].map((opt) {
                                      final isSelected = size == opt['s'];
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 5),
                                        child: ChoiceChip(
                                          label: Text('${opt['s']} (${opt['p']})', style: TextStyle(fontSize: 9, color: isSelected ? Colors.white : Colors.black)),
                                          selected: isSelected,
                                          selectedColor: Colors.pink,
                                          backgroundColor: Colors.pink.withOpacity(0.08),
                                          onSelected: (val) {
                                            if (val) setState(() => pizzaSizes[idx] = opt['s']!);
                                          },
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ]
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(color: Colors.purple.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, color: Colors.purple, size: 18),
                                  onPressed: () { if (qty > 0) setState(() => cart[idx] = qty - 1); },
                                ),
                                Text('$qty', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.add, color: Colors.purple, size: 18),
                                  onPressed: () => setState(() => cart[idx] = qty + 1),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
              const Divider(color: Colors.pinkAccent, thickness: 1),
              const SizedBox(height: 10),
              TextField(
                controller: nameCtrl,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  labelText: 'Enter Your Name',
                  labelStyle: const TextStyle(color: Colors.purple),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  prefixIcon: const Icon(Icons.person, color: Colors.pink),
                ),
              ),
              const SizedBox(height: 15),
              const Text('Select Payment Method:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.purple)),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Card Payment', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      value: 'Card Payment',
                      groupValue: payment,
                      activeColor: Colors.pink,
                      onChanged: (val) => setState(() => payment = val!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Cash on Delivery', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      value: 'Cash on Delivery',
                      groupValue: payment,
                      activeColor: Colors.pink,
                      onChanged: (val) => setState(() => payment = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.pink.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Bill:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple)),
                    Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.pink)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.pinkAccent,
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  onPressed: placeOrder,
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: const Text('Confirm Order ✨', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}