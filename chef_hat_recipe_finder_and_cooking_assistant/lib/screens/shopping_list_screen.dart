import 'package:flutter/material.dart';
import '../services/app_state.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final _appState = AppState();

  void _addItem(String name) {
    if (name.isEmpty) return;
    setState(() {
      _appState.addShoppingItem(name, 'Custom');
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = _appState.shoppingItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: () {
              setState(() {
                _appState.shoppingItems.removeWhere((item) => item['bought']);
              });
            },
          ),
        ],
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text('Your list is empty!', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                    child: Text('Add ingredients directly from any recipe screen.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    setState(() {
                      _appState.removeShoppingItem(index);
                    });
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: CheckboxListTile(
                      title: Text(
                        item['name'],
                        style: TextStyle(
                          decoration: item['bought'] ? TextDecoration.lineThrough : null,
                          color: item['bought'] ? Colors.grey : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(item['category'], style: const TextStyle(fontSize: 12)),
                      value: item['bought'],
                      onChanged: (bool? value) {
                        setState(() {
                          _appState.toggleShoppingItem(index);
                        });
                      },
                      secondary: CircleAvatar(
                        backgroundColor: _getCategoryColor(item['category']),
                        radius: 5,
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Meat': return Colors.red;
      case 'Vegetables': return Colors.green;
      case 'Dairy': return Colors.blue;
      case 'Pantry': return Colors.orange;
      default: return Colors.grey;
    }
  }

  void _showAddDialog() {
    String newItem = '';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Item'),
        content: TextField(
          autofocus: true,
          onChanged: (val) => newItem = val,
          decoration: const InputDecoration(hintText: 'e.g. Eggs'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              _addItem(newItem);
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
