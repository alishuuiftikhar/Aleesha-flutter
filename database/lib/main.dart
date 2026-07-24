import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://jtwbrngtiihkkzhpjecl.supabase.co',
    anonKey: 'sb_publishable_djeRN-zE5IGImgWxdfE7Zg_9r1Ue0-0',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple, scaffoldBackgroundColor: const Color(0xFFF3E5F5)),
      home: const FoodAppHome(),
    );
  }
}

class FoodAppHome extends StatefulWidget {
  const FoodAppHome({super.key});

  @override
  State<FoodAppHome> createState() => _FoodAppHomeState();
}

class _FoodAppHomeState extends State<FoodAppHome> {
  final supabase = Supabase.instance.client;
  final _nameCtrl = TextEditingController(), _phoneCtrl = TextEditingController();
  String _payment = 'Cash on Delivery';
  final Map<String, int> _cart = {};

  final foodMenu = [
    {'name': 'Chicken Pizza', 'price': 1200, 'icon': '🍕'},
    {'name': 'Zinger Burger', 'price': 550, 'icon': '🍔'},
    {'name': 'Chicken Biryani', 'price': 380, 'icon': '🍲'},
    {'name': 'Creamy Pasta', 'price': 750, 'icon': '🍝'},
    {'name': 'Coke', 'price': 100, 'icon': '🥤'},
  ];

  int get _totalBill {
    int total = 0;
    _cart.forEach((k, v) => total += (foodMenu.firstWhere((e) => e['name'] == k)['price'] as int) * v);
    return total;
  }

  Future<void> placeOrder() async {
    if (_nameCtrl.text.trim().isEmpty || _phoneCtrl.text.trim().isEmpty) {
      _snack('Please enter Name & Phone! ⚠️', Colors.deepPurple);
      return;
    }
    if (_cart.isEmpty) {
      _snack('Cart is empty! Select items. 🛒', Colors.orange);
      return;
    }

    final dt = DateTime.now();
    final dateStr = "${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
    final summary = _cart.entries.map((e) => "${e.key} x${e.value}").join(", ");
    final bill = _totalBill;

    try {
      await supabase.from('orders').insert({
        'item_name': summary,
        'customer_name': _nameCtrl.text.trim(),
        'phone_number': _phoneCtrl.text.trim(),
        'status': 'Pending',
        'total_bill': bill,
        'payment_method': _payment,
        'order_date': dateStr,
      });

      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: const Row(children: [Icon(Icons.check_circle, color: Colors.green, size: 28), SizedBox(width: 8), Text('Order Confirmed! 🎉')]),
            content: SingleChildScrollView(child: Text('👤 Customer: ${_nameCtrl.text}\n📞 Phone: ${_phoneCtrl.text}\n🍔 Items: $summary\n💰 Total Bill: Rs. $bill\n💳 Payment: $_payment\n📅 Date: $dateStr')),
            actions: [ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple), onPressed: () { setState(() => _cart.clear()); Navigator.pop(context); }, child: const Text('OK', style: TextStyle(color: Colors.white)))],
          ),
        );
      }
    } catch (e) {
      _snack('Error: $e', Colors.red);
    }
  }

  Future<void> updateStatus(dynamic id, String newStatus) async {
    try {
      await supabase.from('orders').update({'status': newStatus}).eq('id', id);
      _snack('Status updated to $newStatus ✅', Colors.green);
    } catch (e) {
      _snack('Failed to update status: $e', Colors.red);
    }
  }

  Future<void> deleteOrder(dynamic id) async {
    try {
      await supabase.from('orders').delete().eq('id', id);
      _snack('Order deleted 🗑️', Colors.redAccent);
    } catch (e) {
      _snack('Failed to delete: $e', Colors.red);
    }
  }

  void _snack(String msg, Color bg) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: bg, duration: const Duration(seconds: 2)));
  }

  @override
  Widget build(BuildContext context) {
    const steps = ['Pending', 'Preparing', 'Out for Delivery', 'Delivered'];

    return Scaffold(
      appBar: AppBar(title: const Text('Foodie Express 🛵', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), backgroundColor: Colors.deepPurple),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 3, color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Customer Name', prefixIcon: Icon(Icons.person, color: Colors.deepPurple), border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8))),
                      const SizedBox(height: 8),
                      TextField(controller: _phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone, color: Colors.deepPurple), border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8))),
                      const SizedBox(height: 8),
                      DropdownButton<String>(
                        value: _payment, isExpanded: true,
                        items: ['Cash on Delivery', 'Card Payment', 'JazzCash / EasyPaisa'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                        onChanged: (v) => setState(() => _payment = v!),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text('Menu 🍴', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              const SizedBox(height: 8),
              SizedBox(
                height: 175,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, itemCount: foodMenu.length,
                  itemBuilder: (_, i) {
                    final name = foodMenu[i]['name'] as String;
                    final qty = _cart[name] ?? 0;
                    return Container(
                      width: 125, margin: const EdgeInsets.only(right: 8, bottom: 4), padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.deepPurple.shade100)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(foodMenu[i]['icon'] as String, style: const TextStyle(fontSize: 26)),
                          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text('Rs. ${foodMenu[i]['price']}', style: const TextStyle(color: Colors.grey, fontSize: 10)),
                          FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(padding: EdgeInsets.zero, constraints: const BoxConstraints(), icon: const Icon(Icons.remove_circle_outline, color: Colors.red, size: 22), onPressed: () => setState(() => qty > 1 ? _cart[name] = qty - 1 : _cart.remove(name))),
                                Padding(padding: const EdgeInsets.symmetric(horizontal: 6.0), child: Text('$qty', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                                IconButton(padding: EdgeInsets.zero, constraints: const BoxConstraints(), icon: const Icon(Icons.add_circle_outline, color: Colors.green, size: 22), onPressed: () => setState(() => _cart[name] = qty + 1)),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (_cart.isNotEmpty) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity, height: 44,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                    onPressed: placeOrder,
                    icon: const Icon(Icons.shopping_cart, color: Colors.white, size: 18),
                    label: Text('Place Order (Total: Rs. $_totalBill)', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ),
              ],
              const SizedBox(height: 18),
              const Text('Live Orders Tracking & Admin View 🚚', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              const SizedBox(height: 8),
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: supabase.from('orders').stream(primaryKey: ['id']).order('created_at', ascending: false),
                builder: (_, snap) {
                  if (snap.hasError) return Text('Error: ${snap.error}', style: const TextStyle(color: Colors.red));
                  if (!snap.hasData) return const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator()));

                  final orders = snap.data!;
                  if (orders.isEmpty) return const Text('No orders placed yet. 📋', style: TextStyle(color: Colors.grey));

                  return ListView.builder(
                    shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: orders.length,
                    itemBuilder: (_, i) {
                      final o = orders[i]; final st = o['status'] ?? 'Pending'; final idx = steps.indexOf(st);
                      return Card(
                        color: const Color(0xFFE0F7FA), margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: Text('Order #${orders.length - i} - ${o['item_name']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                                  Chip(materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, label: Text(st.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)), backgroundColor: _color(st)),
                                  IconButton(padding: EdgeInsets.zero, constraints: const BoxConstraints(), icon: const Icon(Icons.delete, color: Colors.red, size: 20), onPressed: () => deleteOrder(o['id'])),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text('👤 Name: ${o['customer_name'] ?? 'N/A'}', style: const TextStyle(fontSize: 11)),
                              Text('📞 Phone: ${o['phone_number'] ?? 'N/A'}', style: const TextStyle(fontSize: 11)),
                              Text('💰 Total Bill: Rs. ${o['total_bill'] ?? '0'}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                              Text('💳 Payment: ${o['payment_method'] ?? 'Cash on Delivery'}', style: const TextStyle(fontSize: 11)),
                              Text('📅 Date: ${o['order_date'] ?? 'N/A'}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                              const Divider(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: steps.map((s) {
                                  bool active = steps.indexOf(s) <= idx;
                                  return Expanded(
                                    child: Column(children: [
                                      Icon(active ? Icons.check_circle : Icons.radio_button_unchecked, color: active ? Colors.deepPurple : Colors.grey, size: 18),
                                      const SizedBox(height: 2),
                                      Text(s, textAlign: TextAlign.center, style: TextStyle(fontSize: 8, color: active ? Colors.deepPurple : Colors.grey[600], fontWeight: active ? FontWeight.bold : FontWeight.normal)),
                                    ]),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 8),
                              const Text('Change Status (Admin Control):', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                              const SizedBox(height: 4),
                              Wrap(
                                spacing: 6, runSpacing: 4, alignment: WrapAlignment.center,
                                children: ['Preparing', 'Out for Delivery', 'Delivered'].map((s) => ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: _color(s), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                  onPressed: () => updateStatus(o['id'], s),
                                  child: Text(s, style: const TextStyle(color: Colors.white, fontSize: 9)),
                                )).toList(),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Color _color(String status) {
    switch (status) {
      case 'Preparing': return Colors.orange;
      case 'Out for Delivery': return Colors.blue;
      case 'Delivered': return Colors.green;
      default: return Colors.redAccent;
    }
  }
}