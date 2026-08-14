import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:seats_reserve/theme/app_theme.dart';

import 'package:provider/provider.dart';
import 'package:seats_reserve/providers/data_provider.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DataProvider>();
    final total = data.settings?.totalSeats ?? 30;
    final reserved = data.todayReservations.length;
    final present = data.todayReservations.where((r) => r.status == 'present').length;
    final absent = data.todayReservations.where((r) => r.status == 'absent').length;
    final available = total - reserved;

    return Scaffold(
      appBar: AppBar(title: const Text('Reports & Analytics')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Today\'s Seat Utilization',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(color: Colors.green, value: available.toDouble(), title: 'Available', radius: 50, showTitle: false),
                    PieChartSectionData(color: Colors.orange, value: (reserved - present - absent).toDouble(), title: 'Reserved', radius: 50, showTitle: false),
                    PieChartSectionData(color: Colors.red, value: present.toDouble(), title: 'Present', radius: 50, showTitle: false),
                    PieChartSectionData(color: Colors.purple, value: absent.toDouble(), title: 'Absent', radius: 50, showTitle: false),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIndicator(Colors.green, 'Available'),
                _buildIndicator(Colors.orange, 'Reserved'),
                _buildIndicator(Colors.red, 'Present'),
                _buildIndicator(Colors.purple, 'Absent'),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Weekly Attendance Trends',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 3),
                        FlSpot(1, 4),
                        FlSpot(2, 5),
                        FlSpot(3, 8),
                        FlSpot(4, 3),
                        FlSpot(5, 10),
                      ],
                      isCurved: true,
                      color: AppTheme.primaryColor,
                      barWidth: 4,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(Color color, String text) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
