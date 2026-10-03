import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      ('How do I recover my account access?', 'Use the Reset Password option on the login screen, or contact your coordinator if 2FA is enabled.'),
      ('What happens if I miss a submission deadline?', 'Late submissions are flagged automatically; contact your supervisor for a possible revision window.'),
      ('When are evaluation results visible?', 'Evaluator remarks become visible once the internal/external review is finalized and published.'),
      ('Can I change my team after supervisor approval?', 'Team changes after approval require coordinator sign-off — reach out via the Help Desk.'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('FAQ')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: faqs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final f = faqs[index];
          return Card(
            child: ExpansionTile(
              title: Text(f.$1, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(f.$2, style: const TextStyle(color: AppColors.textSecondary)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
