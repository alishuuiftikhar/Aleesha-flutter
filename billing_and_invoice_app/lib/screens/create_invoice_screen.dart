import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/app_models.dart';
import '../services/app_provider.dart';
import '../theme/app_theme.dart';

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({super.key});

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  Customer? selectedCustomer;
  DateTime date = DateTime.now();
  DateTime dueDate = DateTime.now().add(const Duration(days: 7));
  List<InvoiceItem> items = [];
  double taxRate = 10.0;
  double discountAmount = 0.0;
  final notesController = TextEditingController();

  double get subtotal => items.fold(0, (sum, item) => sum + item.total);
  double get taxAmount => subtotal * (taxRate / 100);
  double get total => subtotal + taxAmount - discountAmount;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final currencyFormat = NumberFormat.simpleCurrency();

    return Scaffold(
      appBar: AppBar(title: const Text('Create Invoice')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer Selection
            Text('Customer', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            DropdownButtonFormField<Customer>(
              initialValue: selectedCustomer,
              items: provider.customers.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
              onChanged: (val) => setState(() => selectedCustomer = val),
              decoration: const InputDecoration(hintText: 'Select Customer'),
            ),
            const SizedBox(height: 20),

            // Dates
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Invoice Date'),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(DateFormat.yMMMd().format(date)),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) setState(() => date = picked);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Due Date'),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(DateFormat.yMMMd().format(dueDate)),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: dueDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) setState(() => dueDate = picked);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),

            // Items
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Items', style: Theme.of(context).textTheme.titleMedium),
                TextButton.icon(
                  onPressed: () => _addItemDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Item'),
                ),
              ],
            ),
            if (items.isEmpty)
              const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('No items added')))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final product = provider.products.firstWhere((p) => p.id == item.productId);
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text('${item.quantity} x ${currencyFormat.format(item.unitPrice)}'),
                    trailing: Text(currencyFormat.format(item.total)),
                    onLongPress: () => setState(() => items.removeAt(index)),
                  );
                },
              ),
            const Divider(height: 32),

            // Totals
            _totalRow('Subtotal', currencyFormat.format(subtotal)),
            _totalRow('Tax ($taxRate%)', currencyFormat.format(taxAmount)),
            _totalRow('Discount', currencyFormat.format(discountAmount), isDiscount: true),
            const Divider(),
            _totalRow('Total', currencyFormat.format(total), isBold: true),
            
            const SizedBox(height: 24),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(labelText: 'Notes', hintText: 'Thank you for your business!'),
              maxLines: 3,
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedCustomer == null || items.isEmpty
                    ? null
                    : () => _saveInvoice(context),
                child: const Text('Create & Save Invoice'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _totalRow(String label, String value, {bool isBold = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(
            isDiscount ? '- $value' : value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? AppTheme.primary : (isDiscount ? Colors.red : AppTheme.text),
            ),
          ),
        ],
      ),
    );
  }

  void _addItemDialog(BuildContext context) {
    Product? selectedProduct;
    final qtyController = TextEditingController(text: '1');

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<Product>(
                initialValue: selectedProduct,
                items: context.read<AppProvider>().products.map((p) => DropdownMenuItem(value: p, child: Text(p.name))).toList(),
                onChanged: (val) => setDialogState(() => selectedProduct = val),
                decoration: const InputDecoration(hintText: 'Select Product'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: qtyController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: selectedProduct == null
                  ? null
                  : () {
                      final qty = int.tryParse(qtyController.text) ?? 1;
                      setState(() {
                        items.add(InvoiceItem(
                          id: '',
                          invoiceId: '',
                          productId: selectedProduct!.id,
                          quantity: qty,
                          unitPrice: selectedProduct!.price,
                          total: qty * selectedProduct!.price,
                        ));
                      });
                      Navigator.pop(context);
                    },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveInvoice(BuildContext context) async {
    final invoice = Invoice(
      id: '',
      customerId: selectedCustomer!.id,
      date: date,
      dueDate: dueDate,
      status: 'unpaid',
      subtotal: subtotal,
      tax: taxAmount,
      discount: discountAmount,
      total: total,
      notes: notesController.text,
    );

    final nav = Navigator.of(context);
    final provider = context.read<AppProvider>();
    await provider.createInvoice(invoice, items);
    if (mounted) nav.pop();
  }
}
