import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../widgets/loading_widget.dart';
import '../services/card_service.dart';
import '../providers/auth_provider.dart';
import 'checkout_screen.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String,dynamic>> cartItems = [];
  bool loading = true;

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadCart();
    });
  }

  Future<void> loadCart() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final String? userId = authProvider.user?.id;

    if (userId == null) {
      if (mounted) setState(() => loading = false);
      return;
    }

    try {
      final data = await CartService.getCartItems(userId);
      if (mounted) {
        setState((){
          cartItems = data;
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => loading = false);
    }
  }

  double getTotal(){
    double total = 0;
    for(var item in cartItems){
      final product = item['products'];
      if(product != null){
        total += (product['price'] ?? 0) * (item['quantity'] ?? 1);
      }
    }
    return total;
  }

  Future<void> removeItem(int id) async{
    await CartService.removeItem(id);
    loadCart();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("My Cart"),
        centerTitle: true,
      ),
      body: loading
          ? const LoadingWidget()
          : cartItems.isEmpty
          ? const Center(child: Text("Cart is Empty"))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                final product = item['products'];

                // Safety Check: If product data is missing
                if (product == null) {
                  return const SizedBox.shrink();
                }

                return Card(
                  child: ListTile(
                    leading: SizedBox(
                      width: 60,
                      child: (product['image'] != null && product['image'].toString().isNotEmpty)
                        ? Image.network(
                            product['image'],
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                            },
                            errorBuilder: (context, error, stack) => const Icon(Icons.broken_image),
                          )
                        : const Icon(Icons.image),
                    ),
                    title: Text(product['name'] ?? "Unknown Product"),
                    subtitle: Text("Quantity: ${item['quantity']}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => removeItem(item['id']),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  "Total: \$${getTotal().toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: cartItems.isEmpty ? null : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CheckoutScreen(
                            total: getTotal(),
                            items: cartItems,
                          ),
                        ),
                      );
                    },
                    child: const Text("Checkout"),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
