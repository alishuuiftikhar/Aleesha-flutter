import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seats_reserve/providers/data_provider.dart';
import 'package:seats_reserve/theme/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';

class MyAttendanceScreen extends StatelessWidget {
  const MyAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reservations = context.watch<DataProvider>().myAllReservations;
    
    final total = reservations.length;
    final present = reservations.where((r) => r.status == 'present').length;
    final absent = reservations.where((r) => r.status == 'absent').length;
    final cancelled = reservations.where((r) => r.status == 'cancelled').length;
    final attendanceRate = total == 0 ? 0 : (present / total * 100).toInt();

    return Scaffold(
      appBar: AppBar(title: const Text('My Attendance Statistics')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Circular Chart Card
            Card(
              elevation: 0,
              color: AppTheme.primaryColor.withOpacity(0.05),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 180,
                      child: Stack(
                        children: [
                          PieChart(
                            PieChartData(
                              sectionsSpace: 5,
                              centerSpaceRadius: 60,
                              sections: [
                                PieChartSectionData(value: present.toDouble(), color: Colors.green, radius: 15, showTitle: false),
                                PieChartSectionData(value: absent.toDouble(), color: Colors.red, radius: 15, showTitle: false),
                                PieChartSectionData(value: cancelled.toDouble(), color: Colors.grey, radius: 15, showTitle: false),
                                PieChartSectionData(value: (total - present - absent - cancelled).toDouble().abs(), color: AppTheme.primaryColor.withOpacity(0.2), radius: 15, showTitle: false),
                              ],
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('$attendanceRate%', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                                const Text('Attendance', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _indicator(Colors.green, 'Present', present.toString()),
                        _indicator(Colors.red, 'Absent', absent.toString()),
                        _indicator(Colors.grey, 'Cancelled', cancelled.toString()),
                      ],
                    )
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Stats Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.5,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _statCard('Total Bookings', total.toString(), Icons.event_seat, Colors.blue),
                _statCard('Present Days', present.toString(), Icons.check_circle, Colors.green),
                _statCard('Absent Days', absent.toString(), Icons.cancel, Colors.red),
                _statCard('Pending Review', (total - present - absent - cancelled).toString(), Icons.hourglass_empty, Colors.orange),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Attendance Policy Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppTheme.accentColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Maintaining high attendance is mandatory. Absences after reservation lead to automatic fines.',
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _indicator(Color color, String label, String value) {
    return Column(
      children: [
        Row(
          children: [
            Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }
}
