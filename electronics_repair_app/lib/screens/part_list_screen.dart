import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/repair_provider.dart';
import '../models/part.dart';
import '../theme/app_theme.dart';

class PartListScreen extends StatelessWidget {
  const PartListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory / Parts'),
      ),
      body: Consumer<RepairProvider>(
        builder: (context, provider, child) {
          if (provider.parts.isEmpty) {
            return const Center(child: Text('No parts in inventory.'));
          }
          return ListView.builder(
            itemCount: provider.parts.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final part = provider.parts[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.settings_input_component, color: AppTheme.accentColor),
                  title: Text(part.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Stock: ${part.stockQuantity}'),
                  trailing: Text('\$${part.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPartDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddPartDialog(BuildContext context) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Part'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Part Name')),
            TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
            TextField(controller: stockController, decoration: const InputDecoration(labelText: 'Stock Quantity'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final price = double.tryParse(priceController.text) ?? 0.0;
              final stock = int.tryParse(stockController.text) ?? 0;
              if (nameController.text.isNotEmpty && price >= 0) {
                final part = Part(
                  name: nameController.text,
                  price: price,
                  stockQuantity: stock,
                );
                Provider.of<RepairProvider>(context, listen: false).addPart(part);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
