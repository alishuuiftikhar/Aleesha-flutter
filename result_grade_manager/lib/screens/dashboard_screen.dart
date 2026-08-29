import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../database/db_helper.dart';
import 'student_list_screen.dart';
import 'subject_list_screen.dart';
import 'results_screen.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DBHelper _dbHelper = DBHelper();
  int _studentCount = 0;
  int _subjectCount = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await _dbHelper.getDashboardStats();
    setState(() {
      _studentCount = stats[0]['students'];
      _subjectCount = stats[0]['subjects'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBg,
      appBar: AppBar(
        title: Text('Academic Dashboard', style: AppTextStyles.heading.copyWith(color: Colors.white, fontSize: 20)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quick Statistics', style: AppTextStyles.subHeading),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildStatCard('Students', _studentCount.toString(), Icons.people, AppColors.primary)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard('Subjects', _subjectCount.toString(), Icons.book, AppColors.accent)),
              ],
            ),
            const SizedBox(height: 24),
            Text('Performance Overview', style: AppTextStyles.subHeading),
            const SizedBox(height: 16),
            Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 85, color: AppColors.primary, width: 20)]),
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 70, color: AppColors.accent, width: 20)]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 92, color: AppColors.secondary, width: 20)]),
                  ],
                  titlesData: const FlTitlesData(show: false),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Manage Data', style: AppTextStyles.subHeading),
            const SizedBox(height: 16),
            _buildMenuTile(
              context,
              'Students Directory',
              'Add, Edit or Remove Students',
              Icons.person_search,
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StudentListScreen())),
            ),
            _buildMenuTile(
              context,
              'Subject Catalog',
              'Manage Academic Subjects',
              Icons.library_books,
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SubjectListScreen())),
            ),
            _buildMenuTile(
              context,
              'Examination Results',
              'View & Analyze Student Grades',
              Icons.analytics,
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ResultsScreen())),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          // Quick add student
          Navigator.push(context, MaterialPageRoute(builder: (context) => const StudentListScreen()));
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(value, style: AppTextStyles.heading.copyWith(fontSize: 28, color: color)),
          Text(title, style: AppTextStyles.label),
        ],
      ),
    );
  }

  Widget _buildMenuTile(BuildContext context, String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Card(
      color: AppColors.cardBg,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.secondaryBg, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title, style: AppTextStyles.subHeading.copyWith(fontSize: 16)),
        subtitle: Text(subtitle, style: AppTextStyles.label),
        trailing: const Icon(Icons.chevron_right, color: AppColors.secondary),
        onTap: onTap,
      ),
    );
  }
}
