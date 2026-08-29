import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ChecklistScreen extends StatelessWidget {
  const ChecklistScreen({super.key});

  final List<Map<String, dynamic>> requirements = const [
    {'title': 'Original CNIC / Passport', 'done': false},
    {'title': 'Learner License (6 weeks old)', 'done': false},
    {'title': 'Medical Fitness Certificate', 'done': false},
    {'title': '2 Passport size photographs', 'done': false},
    {'title': 'Post Office Voucher (Paid)', 'done': false},
    {'title': 'Driving License Form (Form-B)', 'done': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('License Checklist'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(
            color: AppColors.secondary,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Make sure you have these documents ready before visiting the licensing office.',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...requirements.map((req) => Card(
            color: AppColors.cardBackground,
            margin: const EdgeInsets.only(bottom: 12),
            child: CheckboxListTile(
              title: Text(req['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
              value: false,
              onChanged: (val) {},
              activeColor: AppColors.primary,
              checkColor: Colors.white,
            ),
          )).toList(),
          const SizedBox(height: 20),
          const Text(
            'Important Note:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const Text(
            'Verification usually takes 3-5 working days. Ensure all photocopies are attested.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
