import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Methods')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildMethodCard('Visa Classic', '**** **** **** 4582', '08/26', Icons.credit_card),
            const SizedBox(height: 16),
            _buildMethodCard('Mastercard Gold', '**** **** **** 1245', '12/25', Icons.credit_card),
            const Spacer(),
            CustomButton(
              text: 'Add New Method',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodCard(String name, String number, String expiry, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
                Text(number, style: const TextStyle(color: AppTheme.secondaryText)),
              ],
            ),
          ),
          Text(expiry, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
        ],
      ),
    );
  }
}
