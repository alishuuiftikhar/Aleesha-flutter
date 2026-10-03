import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/submission_model.dart';

class SubmissionTile extends StatelessWidget {
  final Submission submission;

  const SubmissionTile({super.key, required this.submission});

  Color get _statusColor {
    switch (submission.status) {
      case 'Approved':
        return AppColors.success;
      case 'Revision Requested':
        return AppColors.warning;
      case 'Under Review':
        return AppColors.accent;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('${submission.type} · v${submission.version}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(submission.status,
                      style: TextStyle(color: _statusColor, fontSize: 11, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.insert_drive_file_outlined, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(submission.fileName, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              'Submitted ${submission.submittedOn.day}/${submission.submittedOn.month}/${submission.submittedOn.year}',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            if (submission.feedback != null) ...[
              const Divider(height: 18),
              Text('Feedback', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 2),
              Text(submission.feedback!, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
            ],
          ],
        ),
      ),
    );
  }
}
