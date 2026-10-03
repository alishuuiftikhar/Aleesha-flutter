import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class DocumentationScreen extends StatelessWidget {
  const DocumentationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final modules = [
      ('1. Account Onboarding', 'Login using your institutional credentials, verify your profile details, and complete security setup before using portal modules.'),
      ('2. Team and Supervision', 'Create or join a group, define your project scope, and submit supervision requests with a focused project summary.'),
      ('3. Deliverables and Reviews', 'Upload documents in required formats, monitor feedback cycles, and submit revised versions within announced windows.'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Documentation')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Complete Documentation for Students and Faculty',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text(
            'Follow clear and practical documentation to set up your account, manage projects, and submit deliverables on time.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 18),
          for (final m in modules)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.$1, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5)),
                      const SizedBox(height: 6),
                      Text(m.$2, style: const TextStyle(color: AppColors.textSecondary, height: 1.4)),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 8),
          const Text('Key Takeaways', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5)),
          const SizedBox(height: 8),
          const _Bullet('Keep project metadata updated so evaluators see current information.'),
          const _Bullet('Use clear file naming for every submission to avoid confusion.'),
          const _Bullet('Track remarks after each review and resolve them before next deadline.'),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  '),
          Expanded(child: Text(text, style: const TextStyle(color: AppColors.textSecondary))),
        ],
      ),
    );
  }
}
