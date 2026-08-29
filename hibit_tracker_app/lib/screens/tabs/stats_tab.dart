import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/habit_provider.dart';
import '../../theme.dart';

class StatsTab extends StatelessWidget {
  const StatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);
    
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistics',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.text),
            ),
            const SizedBox(height: 25),
            _buildStatCard('Weekly Completion Rate', _buildBarChart(habitProvider)),
            const SizedBox(height: 25),
            _buildStatCard('Habit Categories', _buildPieChart(habitProvider)),
            const SizedBox(height: 25),
            _buildSummaryRow(habitProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, Widget chart) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.secondaryBackground),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 20),
          SizedBox(height: 200, child: chart),
        ],
      ),
    );
  }

  Widget _buildBarChart(HabitProvider provider) {
    // Generate data for the last 7 days
    final now = DateTime.now();
    final data = List.generate(7, (i) {
      final date = now.subtract(Duration(days: 6 - i));
      return provider.getCompletionPercentage(date);
    });

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 1,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (val, meta) {
                const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                int index = val.toInt();
                if (index >= 0 && index < 7) {
                  return Text(days[index], style: const TextStyle(fontSize: 10));
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(7, (i) => BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: data[i],
              color: AppColors.primary,
              width: 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        )),
      ),
    );
  }

  Widget _buildPieChart(HabitProvider provider) {
    if (provider.habits.isEmpty) return const Center(child: Text('No data'));

    final categoryCounts = <String, int>{};
    for (var h in provider.habits) {
      categoryCounts[h.category] = (categoryCounts[h.category] ?? 0) + 1;
    }

    return PieChart(
      PieChartData(
        sections: categoryCounts.entries.map((e) {
          final index = categoryCounts.keys.toList().indexOf(e.key);
          return PieChartSectionData(
            value: e.value.toDouble(),
            title: '${e.key}\n${e.value}',
            color: AppColors.habitColors[index % AppColors.habitColors.length],
            radius: 80,
            titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSummaryRow(HabitProvider provider) {
    int totalHabits = provider.habits.length;
    int activeStreaks = provider.habits.fold(0, (sum, h) => sum + h.currentStreak);
    
    return Row(
      children: [
        Expanded(child: _buildSummaryBox('Total Habits', totalHabits.toString(), Icons.list_alt)),
        const SizedBox(width: 15),
        Expanded(child: _buildSummaryBox('Total Streaks', activeStreaks.toString(), Icons.local_fire_department)),
      ],
    );
  }

  Widget _buildSummaryBox(String title, String val, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: 5),
          Text(val, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
