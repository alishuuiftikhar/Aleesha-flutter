import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Frequently Asked Questions', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildFaqItem('How do I save a recipe?', 'Tap the heart icon on any recipe image or details screen.'),
            _buildFaqItem('Can I add my own recipes?', 'This feature is coming soon in the Premium version!'),
            _buildFaqItem('Is the app free?', 'Yes, the basic version is completely free for all users.'),
            const SizedBox(height: 40),
            const Text('Contact Us', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Card(
              child: ListTile(
                leading: Icon(Icons.email_outlined, color: Colors.blue),
                title: Text('Email Support'),
                subtitle: Text('support@chefhat.com'),
              ),
            ),
            const Card(
              child: ListTile(
                leading: Icon(Icons.language, color: Colors.blue),
                title: Text('Website'),
                subtitle: Text('www.chefhat.com'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: const TextStyle(fontWeight: FontWeight.bold)),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(answer, style: const TextStyle(color: Colors.black54)),
        ),
      ],
    );
  }
}
