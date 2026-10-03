import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/project_idea_model.dart';

class IdeaCard extends StatelessWidget {
  final ProjectIdea idea;
  final VoidCallback onTap;

  const IdeaCard({super.key, required this.idea, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _Tag(text: idea.domain, color: AppColors.primary),
                  const SizedBox(width: 6),
                  _Tag(text: idea.difficulty, color: AppColors.accent),
                  const Spacer(),
                  _StatusPill(status: idea.status),
                ],
              ),
              const SizedBox(height: 10),
              Text(idea.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(
                idea.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13.5, height: 1.4),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6, runSpacing: 6,
                children: idea.techStack.take(4).map((t) => _Chip(label: t)).toList(),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.person_outline, size: 15, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(idea.supervisorName,
                        style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                        overflow: TextOverflow.ellipsis),
                  ),
                  const Icon(Icons.groups_outlined, size: 15, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text('${idea.teamsAssigned}/${idea.maxTeams}',
                      style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final Color color;
  const _Tag({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String status;
  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final isOpen = status == 'Open';
    final color = isOpen ? AppColors.success : AppColors.danger;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
      child: Text(status, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w700)),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textPrimary)),
    );
  }
}
