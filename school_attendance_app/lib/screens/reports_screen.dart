import 'package:flutter/material.dart';
import 'package:school_attendance_app/database/database_helper.dart';
import 'package:school_attendance_app/models/student.dart';
import 'package:school_attendance_app/theme/app_theme.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<Student> _students = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    setState(() => _isLoading = true);
    final maps = await DatabaseHelper.instance.queryAllStudents();
    setState(() {
      _students = maps.map((e) => Student.fromMap(e)).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance Reports')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _students.length,
              itemBuilder: (context, index) {
                final student = _students[index];
                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: DatabaseHelper.instance.queryStudentAttendance(student.id!),
                  builder: (context, snapshot) {
                    double percentage = 0;
                    int total = 0;
                    int present = 0;

                    if (snapshot.hasData) {
                      total = snapshot.data!.length;
                      present = snapshot.data!.where((a) => a['status'] == 'Present' || a['status'] == 'Late').length;
                      if (total > 0) percentage = (present / total) * 100;
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        onTap: () => _showAttendanceHistory(student, snapshot.data ?? []),
                        title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${student.className} • Roll: ${student.rollNumber}'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${percentage.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: percentage >= 75 ? Colors.green : Colors.red,
                              ),
                            ),
                            Text('$present/$total Days', style: const TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  void _showAttendanceHistory(Student student, List<Map<String, dynamic>> history) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'History: ${student.name}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            Expanded(
              child: history.isEmpty
                  ? const Center(child: Text('No attendance history found'))
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final record = history[index];
                        Color statusColor = Colors.grey;
                        if (record['status'] == 'Present') statusColor = Colors.green;
                        if (record['status'] == 'Absent') statusColor = Colors.red;
                        if (record['status'] == 'Late') statusColor = Colors.orange;

                        return ListTile(
                          leading: Icon(Icons.calendar_today, color: statusColor, size: 20),
                          title: Text(record['subject_name'] ?? 'Subject'),
                          subtitle: Text(record['date']),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: statusColor),
                            ),
                            child: Text(
                              record['status'],
                              style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
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
