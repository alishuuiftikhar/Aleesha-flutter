import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class GuidelinesScreen extends StatelessWidget {
  const GuidelinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = [
      ('Students', ['Meet every milestone submission window.', 'Respond to supervisor feedback within 3 working days.', 'Maintain accurate project metadata.']),
      ('Supervisors', ['Review supervision requests promptly.', 'Provide constructive, rubric-aligned feedback.', 'Escalate stalled teams to the coordinator.']),
      ('Evaluators', ['Score strictly against the published rubric.', 'Keep remarks professional and actionable.', 'Submit evaluations before the grading deadline.']),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Guidelines')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Official quality standards and role-based expectations for the FYP lifecycle.',
              style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          for (final s in sections)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.$1, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 8),
                      for (final point in s.$2)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('•  '),
                              Expanded(child: Text(point, style: const TextStyle(color: AppColors.textSecondary))),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
