import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/app_models.dart';
import '../services/app_provider.dart';
import '../theme/app_theme.dart';

class InvoiceDetailScreen extends StatefulWidget {
  final Invoice invoice;

  const InvoiceDetailScreen({super.key, required this.invoice});

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  List<InvoiceItem> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final fetchedItems = await context.read<AppProvider>().getInvoiceItems(widget.invoice.id);
    if (mounted) {
      setState(() {
        items = fetchedItems;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final customer = provider.customers.firstWhere(
      (c) => c.id == widget.invoice.customerId,
      orElse: () => Customer(id: '', name: 'Unknown', email: '', phone: '', address: ''),
    );
    final currencyFormat = NumberFormat.simpleCurrency();

    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice #${widget.invoice.id.substring(0, 8)}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('STATUS', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                              _statusBadge(widget.invoice.status),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(customer.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text(customer.email),
                          Text(customer.phone),
                          const Divider(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('DATE', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                                  Text(DateFormat.yMMMd().format(widget.invoice.date)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('DUE DATE', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                                  Text(DateFormat.yMMMd().format(widget.invoice.dueDate)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text('ITEMS', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  Card(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final product = provider.products.firstWhere(
                          (p) => p.id == item.productId,
                          orElse: () => Product(id: '', name: 'Deleted Product', description: '', price: 0, unit: ''),
                        );
                        return ListTile(
                          title: Text(product.name),
                          subtitle: Text('${item.quantity} x ${currencyFormat.format(item.unitPrice)}'),
                          trailing: Text(currencyFormat.format(item.total), style: const TextStyle(fontWeight: FontWeight.bold)),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Summary
                  Card(
                    color: AppTheme.secondaryBackground.withValues(alpha: 0.3),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _summaryRow('Subtotal', currencyFormat.format(widget.invoice.subtotal)),
                          _summaryRow('Tax', currencyFormat.format(widget.invoice.tax)),
                          _summaryRow('Discount', '- ${currencyFormat.format(widget.invoice.discount)}', isRed: true),
                          const Divider(),
                          _summaryRow('Total', currencyFormat.format(widget.invoice.total), isBold: true),
                        ],
                      ),
                    ),
                  ),

                  if (widget.invoice.notes != null && widget.invoice.notes!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text('NOTES', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Text(widget.invoice.notes!),
                  ],

                  const SizedBox(height: 100), // Space for FAB
                ],
              ),
            ),
      floatingActionButton: widget.invoice.status != 'paid'
          ? FloatingActionButton.extended(
              onPressed: () => _showPaymentDialog(context),
              label: const Text('Record Payment'),
              icon: const Icon(Icons.payment),
              backgroundColor: Colors.green,
            )
          : null,
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false, bool isRed = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isRed ? Colors.red : (isBold ? AppTheme.primary : AppTheme.text),
              fontSize: isBold ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'paid':
        color = Colors.green;
        break;
      case 'overdue':
        color = Colors.red;
        break;
      default:
        color = AppTheme.accent;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Invoice'),
        content: const Text('Are you sure you want to delete this invoice? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              context.read<AppProvider>().deleteInvoice(widget.invoice.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to list
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showPaymentDialog(BuildContext context) {
    final amountController = TextEditingController(text: widget.invoice.total.toString());
    String method = 'Cash';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Record Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Amount Paid'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: method,
              items: ['Cash', 'Bank Transfer', 'Card', 'Cheque'].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
              onChanged: (val) => method = val!,
              decoration: const InputDecoration(labelText: 'Payment Method'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final nav = Navigator.of(context);
              final provider = context.read<AppProvider>();
              final payment = Payment(
                id: '',
                invoiceId: widget.invoice.id,
                date: DateTime.now(),
                amount: double.tryParse(amountController.text) ?? 0.0,
                method: method,
              );
              await provider.addPayment(payment);
              if (mounted) {
                nav.pop();
                nav.pop(); // Refresh parent
              }
            },
            child: const Text('Save Payment'),
          ),
        ],
      ),
    );
  }
}
