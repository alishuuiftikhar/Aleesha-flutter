import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'documentation_screen.dart';
import 'faq_screen.dart';
import 'guidelines_screen.dart';

class ResourceHubScreen extends StatelessWidget {
  const ResourceHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Documentation', 'Step-by-step portal procedures for onboarding, team setup, and reviews.', Icons.description_outlined, const DocumentationScreen()),
      ('FAQ', 'Quick answers to common issues such as account access and deadlines.', Icons.help_outline, const FaqScreen()),
      ('Guidelines', 'Official quality standards and role-based expectations.', Icons.rule_outlined, const GuidelinesScreen()),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Resource Hub')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Central entry point that connects students and faculty to all support materials, workflows, and reference content.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 18),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: ListTile(
                  leading: Icon(item.$3, color: AppColors.primary),
                  title: Text(item.$1, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(item.$2, style: const TextStyle(fontSize: 12.5)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => item.$4)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
