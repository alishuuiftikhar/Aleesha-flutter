import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceScreen extends StatefulWidget {
  final int courseId;
  final String courseTitle;

  const AttendanceScreen({super.key, required this.courseId, required this.courseTitle});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final supabase = Supabase.instance.client;
  bool isLoading = true;
  String? userRole;
  List<Map<String, dynamic>> enrolledStudents = [];
  Map<String, String> attendanceStatus = {}; // studentId -> 'Present'/'Absent'
  String selectedDate = DateTime.now().toIso8601String().split('T')[0];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => isLoading = true);
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final userDoc = await supabase.from('users').select('role').eq('id', user.id).single();
      userRole = userDoc['role'];

      if (userRole == 'teacher') {
        final studRes = await supabase
            .from('enrollments')
            .select('student_id, users!inner(full_name)')
            .eq('course_id', widget.courseId);
        enrolledStudents = List<Map<String, dynamic>>.from(studRes);

        for (var s in enrolledStudents) {
          attendanceStatus[s['student_id']] = 'Present';
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _submitAttendance() async {
    try {
      for (var entry in attendanceStatus.entries) {
        await supabase.from('attendance').upsert({
          'course_id': widget.courseId,
          'student_id': entry.key,
          'date': selectedDate,
          'status': entry.value,
        }, onConflict: 'course_id, student_id, date');
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Attendance saved successfully!'), backgroundColor: Colors.green));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Attendance: ${widget.courseTitle}')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userRole == 'teacher'
          ? Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Date: $selectedDate', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: enrolledStudents.length,
              itemBuilder: (context, index) {
                final student = enrolledStudents[index];
                final studentId = student['student_id'];
                final studentName = student['users']['full_name'];
                final status = attendanceStatus[studentId] ?? 'Present';

                return Card(
                  color: const Color(0xFF1E293B),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    title: Text(studentName, style: const TextStyle(color: Colors.white)),
                    trailing: DropdownButton<String>(
                      value: status,
                      dropdownColor: const Color(0xFF1E293B),
                      items: const [
                        DropdownMenuItem(value: 'Present', child: Text('Present', style: TextStyle(color: Colors.green))),
                        DropdownMenuItem(value: 'Absent', child: Text('Absent', style: TextStyle(color: Colors.red))),
                      ],
                      onChanged: (val) {
                        setState(() {
                          attendanceStatus[studentId] = val!;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitAttendance,
                child: const Text('Save Attendance'),
              ),
            ),
          ),
        ],
      )
          : const Center(child: Text('Attendance view for student coming soon.', style: TextStyle(color: Colors.white70))),
    );
  }
}