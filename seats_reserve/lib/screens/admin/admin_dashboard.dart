import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:seats_reserve/providers/data_provider.dart';
import 'package:seats_reserve/theme/app_theme.dart';
import 'package:seats_reserve/screens/admin/students_list_screen.dart';
import 'package:seats_reserve/screens/admin/daily_reservations_screen.dart';
import 'package:seats_reserve/screens/admin/daily_report_screen.dart';
import 'package:seats_reserve/screens/announcements_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:seats_reserve/models/announcement.dart';
import 'package:seats_reserve/screens/admin/fine_management_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String _selectedRange = 'today';

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DataProvider>();
    
    final totalSeats = data.settings?.totalSeats ?? 30;
    final reservedCount = data.todayReservations.length;
    final presentCount = data.todayReservations.where((r) => r.status == 'present').length;
    final absentCount = data.todayReservations.where((r) => r.status == 'absent').length;
    final pendingApprovals = data.pendingStudents.length;
    final availableSeats = totalSeats - reservedCount;

    return Scaffold(
      appBar: AppBar(
        title: Text('${data.settings?.houseName ?? 'Admin'} 👋'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => data.fetchInitialData(null, 'admin'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => data.fetchInitialData(null, 'admin'),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Statistics Grid (Super Compact)
              _buildStatsGrid(totalSeats, reservedCount, availableSeats, presentCount, absentCount, pendingApprovals),
              
              const SizedBox(height: 24),
              
              const Text('Quick Actions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              _buildQuickActionsRow(context),

              const SizedBox(height: 24),
              
              // Simple Summary Text
              _buildSummaryCard(reservedCount, presentCount, absentCount),

              const SizedBox(height: 24),
              
              // Analytics Chart
              _buildUsageChart(totalSeats, reservedCount, presentCount),

              const SizedBox(height: 24),

              // Recent Announcements
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Announcements', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnnouncementsScreen())),
                    child: const Text('View All'),
                  ),
                ],
              ),
              _buildAnnouncementList(data.announcements),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid(int total, int res, int avail, int pres, int abs, int pend) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.1,
      children: [
        _statBox('Total', total.toString(), Icons.event_seat, AppTheme.primaryColor),
        _statBox('Reserved', res.toString(), Icons.bookmark, Colors.blue),
        _statBox('Available', avail.toString(), Icons.check_circle, Colors.green),
        _statBox('Present', pres.toString(), Icons.how_to_reg, Colors.teal),
        _statBox('Absent', abs.toString(), Icons.cancel, Colors.red),
        _statBox('Pending', pend.toString(), Icons.person_add, Colors.orange),
      ],
    );
  }

  Widget _statBox(String title, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(fontSize: 9, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildQuickActionsRow(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      spacing: 10,
      runSpacing: 10,
      children: [
        _actionItem(context, 'Students', Icons.people, const StudentsListScreen()),
        _actionItem(context, 'Attendance', Icons.fact_check, const DailyReservationsScreen()),
        _actionItem(context, 'Fines', Icons.account_balance_wallet, const FineManagementScreen()),
        _actionItem(context, 'Announce', Icons.campaign, const AnnouncementsScreen()),
        _actionItem(context, 'Reports', Icons.assessment, const DailyReportScreen()),
      ],
    );
  }

  Widget _actionItem(BuildContext context, String label, IconData icon, Widget screen) {
    return SizedBox(
      width: 75,
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.08), shape: BoxShape.circle),
              child: Icon(icon, color: AppTheme.primaryColor, size: 24),
            ),
            const SizedBox(height: 6),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(int reserved, int present, int absent) {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _summaryPart('Expected', reserved.toString(), Colors.blue),
            _summaryPart('Showed Up', present.toString(), Colors.green),
            _summaryPart('Missed', absent.toString(), Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _summaryPart(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Widget _buildUsageChart(int total, int reserved, int present) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[100]!)),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(color: Colors.green, value: (total - reserved).toDouble(), radius: 8, showTitle: false),
                  PieChartSectionData(color: Colors.orange, value: (reserved - present).toDouble(), radius: 8, showTitle: false),
                  PieChartSectionData(color: Colors.red, value: present.toDouble(), radius: 8, showTitle: false),
                ],
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Seat Usage', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _legendItem(Colors.green, 'Available'),
                _legendItem(Colors.orange, 'Reserved'),
                _legendItem(Colors.red, 'Present'),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildAnnouncementList(List<Announcement> announcements) {
    if (announcements.isEmpty) return const Text('No active announcements', style: TextStyle(fontSize: 12, color: Colors.grey));
    return Column(
      children: announcements.take(2).map((a) => Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          dense: true,
          leading: const Icon(Icons.campaign, color: Colors.orange, size: 20),
          title: Text(a.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          subtitle: Text(a.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11)),
        ),
      )).toList(),
    );
  }
}
