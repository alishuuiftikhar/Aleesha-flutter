import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/app_models.dart';
import '../services/app_provider.dart';
import '../theme/app_theme.dart';
import 'create_invoice_screen.dart';
import 'invoice_detail_screen.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  String _filterStatus = 'All';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final currencyFormatter = NumberFormat.simpleCurrency();

    final filteredInvoices = provider.invoices.where((i) {
      if (_filterStatus == 'All') return true;
      return i.status.toLowerCase() == _filterStatus.toLowerCase();
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoices'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Paid', 'Unpaid', 'Overdue'].map((status) {
                  final isSelected = _filterStatus == status;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(status),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) setState(() => _filterStatus = status);
                      },
                      selectedColor: AppTheme.accent,
                      labelStyle: TextStyle(color: isSelected ? Colors.white : AppTheme.text),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: filteredInvoices.length,
              itemBuilder: (context, index) {
                final invoice = filteredInvoices[index];
                final customer = provider.customers.firstWhere(
                  (c) => c.id == invoice.customerId,
                  orElse: () => Customer(id: '', name: 'Unknown', email: '', phone: '', address: ''),
                );

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text("Invoice #${invoice.id.substring(0, 8)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("${customer.name}\n${DateFormat.yMMMd().format(invoice.date)}"),
                    isThreeLine: true,
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(currencyFormatter.format(invoice.total), style: const TextStyle(fontWeight: FontWeight.bold)),
                        _statusBadge(invoice.status),
                      ],
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => InvoiceDetailScreen(invoice: invoice)),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CreateInvoiceScreen()),
        ),
        backgroundColor: AppTheme.accent,
        child: const Icon(Icons.add),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
