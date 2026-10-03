import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_card.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.instance.getDetailedStatistics();
    if (mounted) {
      setState(() {
        _stats = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics & Statistics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStats,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
          : RefreshIndicator(
              onRefresh: _loadStats,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Overview Metrics',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primary),
                    ),
                    const SizedBox(height: 12),

                    // Metrics Grid Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricTile(
                            'Total Visitors',
                            '${_stats['total_visitors'] ?? 0}',
                            Icons.groups,
                            AppTheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMetricTile(
                            'Visitors (Week)',
                            '${_stats['visitors_this_week'] ?? 0}',
                            Icons.date_range,
                            AppTheme.accent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricTile(
                            'Pending Packages',
                            '${_stats['pending_deliveries'] ?? 0}',
                            Icons.inventory_2,
                            AppTheme.warning,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMetricTile(
                            'Collected Packages',
                            '${_stats['collected_deliveries'] ?? 0}',
                            Icons.check_circle,
                            AppTheme.success,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Progress & Breakdown Section
                    const Text(
                      'Category Breakdown',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primary),
                    ),
                    const SizedBox(height: 12),

                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Visitor Completion Rate', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                          const SizedBox(height: 8),
                          _buildProgressBar(
                            label: 'Completed / Departed Visits',
                            count: _stats['completed_visits'] ?? 0,
                            total: (_stats['total_visitors'] ?? 1) == 0 ? 1 : (_stats['total_visitors'] ?? 1),
                            color: AppTheme.success,
                          ),
                        ],
                      ),
                    ),

                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Delivery Resolution Rate', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                          const SizedBox(height: 8),
                          _buildProgressBar(
                            label: 'Collected Packages',
                            count: _stats['collected_deliveries'] ?? 0,
                            total: (_stats['total_deliveries'] ?? 1) == 0 ? 1 : (_stats['total_deliveries'] ?? 1),
                            color: AppTheme.primary,
                          ),
                        ],
                      ),
                    ),

                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Maintenance Resolution Rate', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                          const SizedBox(height: 8),
                          _buildProgressBar(
                            label: 'Completed Service Visits',
                            count: _stats['completed_maintenance'] ?? 0,
                            total: (_stats['total_maintenance'] ?? 1) == 0 ? 1 : (_stats['total_maintenance'] ?? 1),
                            color: AppTheme.highlight,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Visual Comparison Chart
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Activity Volume Chart', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                          const SizedBox(height: 16),
                          _buildVisualBar('Visitors', _stats['total_visitors'] ?? 0, AppTheme.primary),
                          _buildVisualBar('Deliveries', _stats['total_deliveries'] ?? 0, AppTheme.accent),
                          _buildVisualBar('Maintenance', _stats['total_maintenance'] ?? 0, AppTheme.highlight),
                          _buildVisualBar('Entry Logs', _stats['total_entry_records'] ?? 0, AppTheme.secondary),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildMetricTile(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.secondaryBackground, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar({required String label, required int count, required int total, required Color color}) {
    final double ratio = total > 0 ? (count / total).clamp(0.0, 1.0) : 0.0;
    final int percent = (ratio * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.textMuted)),
            Text('$count / $total ($percent%)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: ratio,
            backgroundColor: AppTheme.secondaryBackground,
            color: color,
            minHeight: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildVisualBar(String label, int value, Color color) {
    final int maxVal = [
      _stats['total_visitors'] ?? 1,
      _stats['total_deliveries'] ?? 1,
      _stats['total_maintenance'] ?? 1,
      _stats['total_entry_records'] ?? 1,
      10
    ].reduce((a, b) => a > b ? a : b);

    final double widthFactor = maxVal > 0 ? (value / maxVal).clamp(0.05, 1.0) : 0.05;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 22,
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryBackground,
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: widthFactor,
                  child: Container(
                    height: 22,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 30,
            child: Text('$value', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark)),
          ),
        ],
      ),
    );
  }
}
