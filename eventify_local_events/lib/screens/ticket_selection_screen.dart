import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../models/booking_model.dart';
import '../theme/app_theme.dart';
import 'payment_screen.dart';

class TicketSelectionScreen extends StatefulWidget {
  final Event event;
  const TicketSelectionScreen({super.key, required this.event});

  @override
  State<TicketSelectionScreen> createState() => _TicketSelectionScreenState();
}

class _TicketSelectionScreenState extends State<TicketSelectionScreen> {
  TicketType _selectedType = TicketType.standard;
  int _quantity = 1;

  double get _ticketPrice {
    switch (_selectedType) {
      case TicketType.vip: return widget.event.price * 2;
      case TicketType.standard: return widget.event.price;
      case TicketType.economy: return widget.event.price * 0.7;
    }
  }

  @override
  Widget build(BuildContext context) {
    double subtotal = _ticketPrice * _quantity;
    double serviceFee = 5.0;
    double total = subtotal + serviceFee;

    return Scaffold(
      appBar: AppBar(title: const Text('Select Tickets')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose Ticket Type', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
            const SizedBox(height: 16),
            _buildTypeCard(TicketType.vip, 'VIP Ticket', 'Premium seating + Backstage pass', widget.event.price * 2),
            _buildTypeCard(TicketType.standard, 'Standard Ticket', 'Regular seating + Welcome drink', widget.event.price),
            _buildTypeCard(TicketType.economy, 'Economy Ticket', 'General admission', widget.event.price * 0.7),
            const SizedBox(height: 32),
            const Text('Select Quantity', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.black.withAlpha(13))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Number of Tickets', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
                  Row(
                    children: [
                      _buildQuantityBtn(Icons.remove, () => setState(() => _quantity > 1 ? _quantity-- : null)),
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text('$_quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryText))),
                      _buildQuantityBtn(Icons.add, () => setState(() => _quantity++)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Text('Booking Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
            const SizedBox(height: 16),
            _buildSummaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
            _buildSummaryRow('Service Fee', '\$${serviceFee.toStringAsFixed(2)}'),
            const Divider(height: 32),
            _buildSummaryRow('Total Amount', '\$${total.toStringAsFixed(2)}', isTotal: true),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentScreen(
                event: widget.event,
                ticketType: _selectedType,
                quantity: _quantity,
                totalAmount: total,
              ))),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
              child: const Text('Continue to Payment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeCard(TicketType type, String title, String subtitle, double price) {
    bool isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor.withAlpha(13) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppTheme.primaryColor : Colors.black.withAlpha(13), width: 2),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.primaryText)),
                  Text(subtitle, style: const TextStyle(color: AppTheme.secondaryText, fontSize: 12)),
                ],
              ),
            ),
            Text('\$${price.toStringAsFixed(2)}', style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppTheme.primaryColor.withAlpha(25), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: AppTheme.primaryColor, size: 20),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: isTotal ? 18 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, color: AppTheme.primaryText)),
        Text(value, style: TextStyle(fontSize: isTotal ? 24 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.bold, color: isTotal ? AppTheme.primaryColor : AppTheme.primaryText)),
      ],
    );
  }
}
