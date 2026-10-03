import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg = Colors.white;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'arrived':
      case 'received':
      case 'completed':
      case 'collected':
        bg = AppTheme.success;
        icon = Icons.check_circle_outline;
        break;
      case 'expected':
      case 'scheduled':
        bg = AppTheme.warning;
        icon = Icons.schedule;
        break;
      case 'in progress':
      case 'departed':
        bg = AppTheme.secondary;
        icon = Icons.sync_rounded;
        break;
      case 'returned':
      case 'cancelled':
        bg = AppTheme.error;
        icon = Icons.cancel_outlined;
        break;
      default:
        bg = AppTheme.primary;
        icon = Icons.info_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: bg, width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: bg),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: bg,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
