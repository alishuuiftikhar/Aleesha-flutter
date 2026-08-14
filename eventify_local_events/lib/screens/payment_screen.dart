import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event_model.dart';
import '../models/booking_model.dart';
import '../providers/booking_provider.dart';
import '../theme/app_theme.dart';
import 'booking_confirmation_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Event event;
  final TicketType ticketType;
  final int quantity;
  final double totalAmount;

  const PaymentScreen({super.key, required this.event, required this.ticketType, required this.quantity, required this.totalAmount});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = 'card';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Booking Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(widget.event.imageUrl, width: 80, height: 80, fit: BoxFit.cover)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.event.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryText)),
                        Text('${widget.quantity}x ${widget.ticketType.name.toUpperCase()} Ticket', style: const TextStyle(color: AppTheme.secondaryText)),
                        Text('\$${widget.totalAmount.toStringAsFixed(2)}', style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text('Payment Method', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
            const SizedBox(height: 16),
            _buildMethodItem('card', 'Credit / Debit Card', Icons.credit_card),
            _buildMethodItem('jazzcash', 'JazzCash', Icons.account_balance_wallet),
            _buildMethodItem('easypaisa', 'EasyPaisa', Icons.mobile_friendly),
            _buildMethodItem('wallet', 'Eventify Wallet', Icons.wallet),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.blue.withAlpha(13), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.blue.withAlpha(25))),
              child: const Row(
                children: [
                  Icon(Icons.shield_outlined, color: Colors.blue),
                  SizedBox(width: 12),
                  Expanded(child: Text('Your payment is secure and encrypted.', style: TextStyle(color: Colors.blue, fontSize: 12))),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                final booking = Booking(
                  id: 'BK${DateTime.now().millisecondsSinceEpoch}',
                  event: widget.event,
                  bookingDate: DateTime.now(),
                  ticketType: widget.ticketType,
                  quantity: widget.quantity,
                  totalAmount: widget.totalAmount,
                );
                context.read<BookingProvider>().addBooking(booking);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BookingConfirmationScreen(booking: booking)));
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
              child: Text('Pay \$${widget.totalAmount.toStringAsFixed(2)} Now', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodItem(String id, String title, IconData icon) {
    bool isSelected = _selectedMethod == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppTheme.primaryColor : Colors.black.withAlpha(13), width: 2),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppTheme.primaryColor : AppTheme.secondaryText),
            const SizedBox(width: 16),
            Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: AppTheme.primaryText)),
            const Spacer(),
            if (isSelected) const Icon(Icons.check_circle, color: AppTheme.primaryColor) else Container(width: 24, height: 24, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey[300]!))),
          ],
        ),
      ),
    );
  }
}
