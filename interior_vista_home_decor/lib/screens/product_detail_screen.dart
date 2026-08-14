import 'package:flutter/material.dart';
import 'order_success_screen.dart';
import 'package:interior_vista_home_decor/models/app_data.dart';

class ProductDetailScreen extends StatefulWidget {
  final FurnitureItem item;

  const ProductDetailScreen({super.key, required this.item});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String selectedColorHex = '#F06292';
  String _paymentMethod = 'Cash on Delivery';

  void _showOrderDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          title: const Text('Confirm Your Order', style: TextStyle(color: Color(0xFFF06292), fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    filled: true,
                    fillColor: const Color(0xFFFFF1F5),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    filled: true,
                    fillColor: const Color(0xFFFFF1F5),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 25),
                const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF06292))),
                const SizedBox(height: 10),
                _buildPaymentRadio('Cash on Delivery', setDialogState),
                _buildPaymentRadio('Online Payment', setDialogState),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty && _phoneController.text.isNotEmpty) {
                  final order = OrderItem(
                    item: widget.item,
                    userName: _nameController.text,
                    phone: _phoneController.text,
                    date: DateTime.now(),
                    selectedColor: selectedColorHex,
                    paymentMethod: _paymentMethod,
                  );
                  AppData.myOrders.add(order);
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderSuccessScreen()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter all details')));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF06292), 
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Confirm Order'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentRadio(String value, StateSetter setDialogState) {
    return RadioListTile<String>(
      title: Text(value, style: const TextStyle(fontSize: 14)),
      value: value,
      groupValue: _paymentMethod,
      activeColor: const Color(0xFFF06292),
      contentPadding: EdgeInsets.zero,
      onChanged: (val) => setDialogState(() => _paymentMethod = val!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 450,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white70,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFFF06292)),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.item.id,
                child: Image.network(widget.item.imageUrl, fit: BoxFit.cover),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(widget.item.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      ),
                      Text(widget.item.price, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFF06292))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const Icon(Icons.star_half, color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      Text('4.8 (256 Reviews)', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text('Select Finish', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  Row(
                    children: widget.item.colors.map((colorHex) {
                      bool isSelected = selectedColorHex == colorHex;
                      return GestureDetector(
                        onTap: () => setState(() => selectedColorHex = colorHex),
                        child: Container(
                          margin: const EdgeInsets.only(right: 15),
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: isSelected ? const Color(0xFFF06292) : Colors.transparent, width: 2.5),
                          ),
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Color(int.parse(colorHex.replaceFirst('#', '0xFF'))),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),
                  const Text('Product Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(
                    widget.item.description, 
                    style: TextStyle(color: Colors.grey[600], fontSize: 16, height: 1.8),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 65,
                          child: OutlinedButton(
                            onPressed: () {
                              if (!AppData.cart.any((e) => e.id == widget.item.id)) {
                                AppData.cart.add(widget.item);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Added to your cart!'), backgroundColor: Colors.black87),
                                );
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFF06292), width: 1.5),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            ),
                            child: const Text('Add to Cart', style: TextStyle(color: Color(0xFFF06292), fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 65,
                          child: ElevatedButton(
                            onPressed: _showOrderDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF06292),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                              elevation: 8,
                            ),
                            child: const Text('Buy Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
