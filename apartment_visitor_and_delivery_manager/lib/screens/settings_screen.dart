import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../theme/app_theme.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/custom_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<String, dynamic> _stats = {};

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await DatabaseHelper.instance.getDetailedStatistics();
    if (mounted) {
      setState(() {
        _stats = stats;
      });
    }
  }

  Future<void> _resetDatabase() async {
    final confirm = await ConfirmDialog.show(
      context,
      title: 'Reset Database',
      content: 'Are you sure you want to clear all visitors, deliveries, maintenance records, reminders, and notes? This action CANNOT be undone.',
      confirmText: 'Reset All Data',
      confirmColor: AppTheme.error,
    );

    if (confirm == true) {
      await DatabaseHelper.instance.clearAllData();
      _loadStats();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Database reset successfully'), backgroundColor: AppTheme.primary),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Storage'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // App Banner Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primary, AppTheme.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.apartment_rounded, size: 36, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'AptSentry Manager',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Version 1.0.0 (SQLite Direct)',
                        style: TextStyle(fontSize: 13, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text('Storage Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primary)),
          const SizedBox(height: 10),

          CustomCard(
            child: Column(
              children: [
                _buildSummaryRow('Visitors Records', '${_stats['total_visitors'] ?? 0}'),
                const Divider(),
                _buildSummaryRow('Delivery Records', '${_stats['total_deliveries'] ?? 0}'),
                const Divider(),
                _buildSummaryRow('Maintenance Records', '${_stats['total_maintenance'] ?? 0}'),
                const Divider(),
                _buildSummaryRow('Entry Logs History', '${_stats['total_entry_records'] ?? 0}'),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text('Theme Palette', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primary)),
          const SizedBox(height: 10),

          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Current Theme: Premium Slate Blue & Steel Blue', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildColorSwatch(AppTheme.mainBackground, 'Bg'),
                    _buildColorSwatch(AppTheme.secondaryBackground, 'Sec Bg'),
                    _buildColorSwatch(AppTheme.cardBackground, 'Card'),
                    _buildColorSwatch(AppTheme.primary, 'Primary'),
                    _buildColorSwatch(AppTheme.secondary, 'Steel'),
                    _buildColorSwatch(AppTheme.accent, 'Gold'),
                    _buildColorSwatch(AppTheme.highlight, 'Purple'),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text('Data Operations', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primary)),
          const SizedBox(height: 10),

          CustomCard(
            backgroundColor: AppTheme.error.withOpacity(0.08),
            border: Border.all(color: AppTheme.error.withOpacity(0.3)),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.delete_forever, color: AppTheme.error, size: 28),
              title: const Text('Reset All Database Data', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.error)),
              subtitle: const Text('Permanently delete all visitors, deliveries, maintenance, notes, and history.'),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
                onPressed: _resetDatabase,
                child: const Text('Reset'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: AppTheme.textDark)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primary)),
        ],
      ),
    );
  }

  Widget _buildColorSwatch(Color color, String label) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black26),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
      ],
    );
  }
}
