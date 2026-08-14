import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSupportItem(Icons.question_answer_outlined, 'FAQ', 'Common questions and answers'),
          _buildSupportItem(Icons.chat_bubble_outline, 'Live Chat', 'Chat with our support team'),
          _buildSupportItem(Icons.email_outlined, 'Email Us', 'support@eventify.com'),
          _buildSupportItem(Icons.phone_outlined, 'Call Us', '+1 800 123 4567'),
          const SizedBox(height: 32),
          const Text(
            'How can we help you?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryText),
          ),
          const SizedBox(height: 16),
          TextField(
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Describe your issue here...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Submit Ticket', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportItem(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
              Text(subtitle, style: const TextStyle(color: AppTheme.secondaryText, fontSize: 12)),
            ],
          ),
          const Spacer(),
          const Icon(Icons.chevron_right, color: AppTheme.secondaryText),
        ],
      ),
    );
  }
}
