import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'login_screen.dart';
import 'course_screen.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final supabase = Supabase.instance.client;
  bool isLoading = true;
  double attendancePercentage = 0.0;
  double averageMarks = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchAnalytics();
  }

  Future<void> _fetchAnalytics() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final attRes = await supabase.from('attendance').select('status').eq('student_id', user.id);
      if (attRes.isNotEmpty) {
        int presentCount = attRes.where((e) => e['status'] == 'Present').length;
        attendancePercentage = (presentCount / attRes.length) * 100;
      }

      final markRes = await supabase.from('marks').select('obtained_marks, total_marks').eq('student_id', user.id);
      if (markRes.isNotEmpty) {
        double totalObt = 0;
        double totalMax = 0;
        for (var m in markRes) {
          totalObt += (m['obtained_marks'] as num).toDouble();
          totalMax += (m['total_marks'] as num).toDouble();
        }
        if (totalMax > 0) {
          averageMarks = (totalObt / totalMax) * 100;
        }
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Portal Pro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await supabase.auth.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Performance Overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                .animate().fadeIn(),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 180,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)]),
                    child: Column(
                      children: [
                        const Text('Attendance', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                        const SizedBox(height: 10),
                        Expanded(
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 0,
                              centerSpaceRadius: 30,
                              sections: [
                                PieChartSectionData(color: const Color(0xFF4682B4), value: attendancePercentage, title: '${attendancePercentage.toStringAsFixed(0)}%', radius: 25, titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                                PieChartSectionData(color: Colors.grey.shade200, value: 100 - attendancePercentage, title: '', radius: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    height: 180,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)]),
                    child: Column(
                      children: [
                        const Text('Overall Marks', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                        const SizedBox(height: 10),
                        Expanded(
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 0,
                              centerSpaceRadius: 30,
                              sections: [
                                PieChartSectionData(color: Colors.green, value: averageMarks, title: '${averageMarks.toStringAsFixed(0)}%', radius: 25, titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                                PieChartSectionData(color: Colors.grey.shade200, value: 100 - averageMarks, title: '', radius: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text('Quick Access', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: const Icon(Icons.book, color: Color(0xFF4682B4), size: 30),
                title: const Text('Browse & Enroll Courses', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Explore subjects and join classes'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CoursesScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}